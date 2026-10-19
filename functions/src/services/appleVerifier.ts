import {readFileSync} from "node:fs";
import {join} from "node:path";
import {
  AutoRenewStatus,
  Environment,
  JWSRenewalInfoDecodedPayload,
  JWSTransactionDecodedPayload,
  ResponseBodyV2DecodedPayload,
  SignedDataVerifier,
  VerificationException,
  VerificationStatus,
} from "@apple/app-store-server-library";
import {APPLE_APP_ID, IOS_BUNDLE_ID, isPremiumProductId} from "../constants/products";
import {VerifiedSubscription} from "../types";

/**
 * Verifies StoreKit 2 signed data (JWS) from the app and from App Store Server
 * Notifications V2.
 *
 * `in_app_purchase` runs StoreKit 2, which hands the app a JWS-signed
 * transaction rather than an app receipt. Apple signs it with a certificate
 * chain ending in Apple Root CA - G3, so it is verified locally against the
 * roots in functions/certs — no App Store Connect API key is needed.
 */

const ROOT_CERTS = ["AppleRootCA-G3.cer", "AppleRootCA-G2.cer"].map((name) =>
  readFileSync(join(__dirname, "../../certs", name))
);

const verifiers = new Map<Environment, SignedDataVerifier>();

/** Thrown when Apple could not be reached to finish a check; worth retrying. */
export class AppleVerificationUnavailable extends Error {}

function verifierFor(environment: Environment): SignedDataVerifier {
  if (environment === Environment.PRODUCTION && APPLE_APP_ID == null) {
    // Fail as retryable rather than rejecting a real purchase: once the ID is
    // set and deployed, the client's stored retry completes it.
    throw new AppleVerificationUnavailable(
      "APPLE_APP_ID is not set; cannot verify Production transactions"
    );
  }
  let verifier = verifiers.get(environment);
  if (!verifier) {
    verifier = new SignedDataVerifier(
      ROOT_CERTS,
      // OCSP revocation checks on the signing certificates.
      true,
      environment,
      IOS_BUNDLE_ID,
      APPLE_APP_ID ?? undefined
    );
    verifiers.set(environment, verifier);
  }
  return verifier;
}

/**
 * Reads which environment a JWS claims to come from, so it can be checked by
 * the verifier for that environment. Nothing else from the unverified payload
 * is used; the verifier rejects a mismatched claim.
 */
export function claimedEnvironment(jws: string, path: "transaction" | "notification"): Environment {
  const parts = jws.split(".");
  if (parts.length !== 3) throw new VerificationException(VerificationStatus.VERIFICATION_FAILURE);
  let payload: any;
  try {
    payload = JSON.parse(Buffer.from(parts[1], "base64url").toString("utf8"));
  } catch {
    throw new VerificationException(VerificationStatus.VERIFICATION_FAILURE);
  }
  const env = path === "notification" ? payload?.data?.environment : payload?.environment;
  if (env === Environment.PRODUCTION) return Environment.PRODUCTION;
  if (env === Environment.SANDBOX) return Environment.SANDBOX;
  // Xcode / LocalTesting transactions are signed by a local key and are never
  // honored by the server.
  throw new VerificationException(VerificationStatus.INVALID_ENVIRONMENT);
}

function invalid(reason: string): VerifiedSubscription {
  return {
    valid: false,
    productId: null,
    expiresAt: null,
    originalTransactionId: null,
    environment: null,
    autoRenewing: false,
    reason,
  };
}

/**
 * Reduces a verified transaction (and renewal info, when Apple sent it) to the
 * subscription state we store. Pure, so it is unit-tested directly.
 *
 * Without renewal info (a purchase or restore from the app) auto-renew is
 * assumed while the subscription is active; the next renewal-status
 * notification corrects it.
 */
export function toVerifiedSubscription(
  tx: JWSTransactionDecodedPayload,
  renewal: JWSRenewalInfoDecodedPayload | undefined,
  now: number
): VerifiedSubscription {
  if (!isPremiumProductId(tx.productId)) return invalid("no_matching_product");
  if (!tx.expiresDate) return invalid("no_expiry");

  const revoked = tx.revocationDate != null;
  const active = !revoked && tx.expiresDate > now;
  const autoRenewing = renewal ?
    renewal.autoRenewStatus === AutoRenewStatus.ON :
    active;

  return {
    valid: active,
    productId: tx.productId,
    expiresAt: new Date(tx.expiresDate).toISOString(),
    originalTransactionId: tx.originalTransactionId ?? null,
    environment: tx.environment === Environment.SANDBOX ? "sandbox" : "production",
    autoRenewing: active && autoRenewing,
    ...(revoked ? {reason: "revoked"} : {}),
  };
}

/** Runs a verification, turning Apple's verdicts into invalid or retryable. */
async function verified<T>(run: () => Promise<T>): Promise<T | string> {
  try {
    return await run();
  } catch (err) {
    if (err instanceof VerificationException) {
      if (err.status === VerificationStatus.RETRYABLE_VERIFICATION_FAILURE) {
        throw new AppleVerificationUnavailable("Apple certificate check unreachable");
      }
      return `apple_jws_${VerificationStatus[err.status]?.toLowerCase() ?? err.status}`;
    }
    throw err;
  }
}

/**
 * Verifies a StoreKit 2 signed transaction sent by the app after a purchase
 * or restore.
 *
 * Throws [AppleVerificationUnavailable] for transient failures; returns
 * `valid: false` with a reason for anything Apple did not sign or that is not
 * an active Pure Pantry subscription.
 */
export async function verifyAppleTransaction(
  signedTransaction: string
): Promise<VerifiedSubscription> {
  const result = await verified(() => {
    const verifier = verifierFor(claimedEnvironment(signedTransaction, "transaction"));
    return verifier.verifyAndDecodeTransaction(signedTransaction);
  });
  if (typeof result === "string") return invalid(result);
  return toVerifiedSubscription(result, undefined, Date.now());
}

export interface AppleNotification {
  notificationType: string;
  subtype: string | null;
  /** Null when the notification carried no subscription transaction. */
  subscription: VerifiedSubscription | null;
}

/**
 * Verifies an App Store Server Notification V2 `signedPayload` and the
 * transaction and renewal info inside it. Returns null when it is not
 * genuinely from Apple for this app.
 */
export async function verifyAppleNotification(
  signedPayload: string
): Promise<AppleNotification | null> {
  const outcome = await verified(async () => {
    const verifier = verifierFor(claimedEnvironment(signedPayload, "notification"));
    const payload: ResponseBodyV2DecodedPayload =
      await verifier.verifyAndDecodeNotification(signedPayload);
    const signedTx = payload.data?.signedTransactionInfo;
    const signedRenewal = payload.data?.signedRenewalInfo;
    const tx = signedTx ? await verifier.verifyAndDecodeTransaction(signedTx) : undefined;
    const renewal = signedRenewal ?
      await verifier.verifyAndDecodeRenewalInfo(signedRenewal) :
      undefined;
    return {payload, tx, renewal};
  });
  if (typeof outcome === "string") {
    console.warn(`[appleVerifier] rejected notification: ${outcome}`);
    return null;
  }

  const {payload, tx, renewal} = outcome;
  return {
    notificationType: String(payload.notificationType ?? "UNKNOWN"),
    subtype: payload.subtype != null ? String(payload.subtype) : null,
    subscription: tx ? toVerifiedSubscription(tx, renewal, Date.now()) : null,
  };
}
