import {onCall, HttpsError} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {verifyAppleReceipt, appleSharedSecret} from "../services/appleVerifier";
import {verifyGooglePurchase} from "../services/googleVerifier";
import {
  writeEntitlement,
  linkSubscription,
} from "../services/entitlementService";
import {isPremiumProductId} from "../constants/products";
import {VerifyReceiptRequest, VerifyReceiptResponse} from "../types";

if (getApps().length === 0) initializeApp();

export const verifyReceipt = onCall(
  {
    enforceAppCheck: true,
    secrets: [appleSharedSecret],
  },
  async (request): Promise<VerifyReceiptResponse> => {
    // Auth check (skipped in emulator when no Auth emulator is running)
    const isEmulator = process.env.FUNCTIONS_EMULATOR === "true";
    if (!isEmulator && !request.auth) {
      throw new HttpsError("permission-denied", "Authentication required.");
    }

    const data = request.data as VerifyReceiptRequest;
    if (!data.receipt || !data.source || !data.productId) {
      throw new HttpsError(
        "invalid-argument",
        "Missing required fields: receipt, source, productId"
      );
    }

    if (data.source !== "apple" && data.source !== "google") {
      throw new HttpsError("invalid-argument", "Unknown purchase source.");
    }

    // The client-supplied productId is only a hint; what actually counts is the
    // product the store reports back below.
    if (!isPremiumProductId(data.productId)) {
      throw new HttpsError("invalid-argument", "Unknown product.");
    }

    const uid = request.auth?.uid ?? "emulator-test-user";

    let verified;
    try {
      verified =
        data.source === "apple" ?
          await verifyAppleReceipt(data.receipt) :
          await verifyGooglePurchase(data.receipt);
    } catch (err: any) {
      // Could not reach the store, or it errored. This is NOT a rejection —
      // returning valid:false here would tell a paying user their purchase
      // failed. Signal retryable instead; the client re-submits on next launch.
      console.error(
        `[verifyReceipt] ${data.source} lookup failed for uid=${uid}:`,
        err?.message ?? err
      );
      throw new HttpsError(
        "unavailable",
        "Could not reach the store to confirm your purchase. " +
          "We'll finish this automatically — your purchase is safe."
      );
    }

    console.log(
      `[verifyReceipt] uid=${uid} source=${data.source} ` +
        `valid=${verified.valid} product=${verified.productId} ` +
        `expires=${verified.expiresAt} reason=${verified.reason ?? "-"}`
    );

    await writeEntitlement(uid, data.source, verified);

    // Index the subscription so renewal notifications can find this account.
    if (verified.originalTransactionId) {
      await linkSubscription({
        uid,
        source: data.source,
        id: verified.originalTransactionId,
        receipt: data.source === "apple" ? data.receipt : undefined,
      });
    }

    return {
      valid: verified.valid,
      expiresAt: verified.expiresAt,
      productId: verified.productId,
      autoRenewing: verified.autoRenewing,
      environment: verified.environment,
    };
  }
);
