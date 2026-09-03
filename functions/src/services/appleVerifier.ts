import {defineSecret} from "firebase-functions/params";
import {isPremiumProductId} from "../constants/products";
import {VerifiedSubscription} from "../types";

/**
 * App-Specific Shared Secret from App Store Connect
 * (App Information → App-Specific Shared Secret).
 */
export const appleSharedSecret = defineSecret("APPLE_SHARED_SECRET");

const PROD_URL = "https://buy.itunes.apple.com/verifyReceipt";
const SANDBOX_URL = "https://sandbox.itunes.apple.com/verifyReceipt";

/** A sandbox receipt was sent to the production host. */
const STATUS_SANDBOX_ON_PROD = 21007;
/** A production receipt was sent to the sandbox host. */
const STATUS_PROD_ON_SANDBOX = 21008;

interface LatestReceiptInfo {
  product_id?: string;
  expires_date_ms?: string;
  original_transaction_id?: string;
}

interface PendingRenewalInfo {
  original_transaction_id?: string;
  auto_renew_status?: string;
}

interface AppleVerifyResponse {
  status: number;
  environment?: string;
  latest_receipt_info?: LatestReceiptInfo[];
  pending_renewal_info?: PendingRenewalInfo[];
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

function expiryMs(entry: LatestReceiptInfo): number {
  const raw = entry.expires_date_ms;
  if (!raw) return 0;
  const parsed = Number(raw);
  return Number.isFinite(parsed) ? parsed : 0;
}

async function post(
  url: string,
  receipt: string
): Promise<AppleVerifyResponse> {
  const res = await fetch(url, {
    method: "POST",
    headers: {"Content-Type": "application/json"},
    body: JSON.stringify({
      "receipt-data": receipt,
      "password": appleSharedSecret.value(),
      "exclude-old-transactions": true,
    }),
  });

  if (!res.ok) {
    // Network/5xx — the caller turns this into a retryable error rather than
    // telling a paying user their receipt was rejected.
    throw new Error(`Apple verifyReceipt HTTP ${res.status}`);
  }

  return (await res.json()) as AppleVerifyResponse;
}

/**
 * Verifies a StoreKit 1 app receipt with Apple and reduces it to the
 * subscription we care about.
 *
 * Note: this uses the /verifyReceipt endpoint rather than the newer App Store
 * Server API. `in_app_purchase` 3.2.0 runs StoreKit 1 by default, so the client
 * hands us a base64 app receipt, which is what this endpoint consumes; the
 * Server API's transaction endpoints need a StoreKit 2 transaction ID. If the
 * client later opts into StoreKit 2 via `enableStoreKit2()`, swap this for
 * GET /inApps/v1/subscriptions/{transactionId}.
 */
export async function verifyAppleReceipt(
  receipt: string
): Promise<VerifiedSubscription> {
  let body = await post(PROD_URL, receipt);

  // TestFlight and App Review purchases come back as sandbox receipts even in
  // a production build, so retry against the host Apple points us at.
  if (body.status === STATUS_SANDBOX_ON_PROD) {
    body = await post(SANDBOX_URL, receipt);
  } else if (body.status === STATUS_PROD_ON_SANDBOX) {
    body = await post(PROD_URL, receipt);
  }

  if (body.status !== 0) {
    return invalid(`apple_status_${body.status}`);
  }

  const entries = (body.latest_receipt_info ?? []).filter((e) =>
    isPremiumProductId(e.product_id)
  );
  if (entries.length === 0) {
    return invalid("no_matching_product");
  }

  // Latest expiry wins, which is also correct across a monthly→annual upgrade.
  const latest = entries.reduce((best, e) =>
    expiryMs(e) > expiryMs(best) ? e : best
  );

  const expiresMs = expiryMs(latest);
  if (expiresMs <= 0) {
    return invalid("no_expiry");
  }

  const originalTransactionId = latest.original_transaction_id ?? null;
  const autoRenewing = (body.pending_renewal_info ?? []).some(
    (r) =>
      r.original_transaction_id === originalTransactionId &&
      r.auto_renew_status === "1"
  );

  return {
    valid: expiresMs > Date.now(),
    productId: latest.product_id ?? null,
    expiresAt: new Date(expiresMs).toISOString(),
    originalTransactionId,
    environment: body.environment === "Sandbox" ? "sandbox" : "production",
    autoRenewing,
  };
}
