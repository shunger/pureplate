import {onCall, HttpsError} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {verifyAppleReceipt, appleSharedSecret} from "../services/appleVerifier";
import {verifyGooglePurchase} from "../services/googleVerifier";
import {
  applyEntitlement,
  linkSubscription,
  revokeIfFromSubscription,
} from "../services/entitlementService";
import {isEntitlementActive} from "../services/subscriptionLinks";
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

    // Never replaces Premium from another subscription that's still active,
    // e.g. when Restore re-delivers an old, lapsed purchase.
    const {doc: entitlement} =
      await applyEntitlement(uid, data.source, verified);

    // Link the subscription so renewal notifications reach every account using
    // it (one per device, say). Accounts dropped past the cap lose the
    // Premium they had from this subscription.
    const subscriptionId = verified.originalTransactionId;
    if (subscriptionId) {
      const dropped = await linkSubscription({
        uid,
        source: data.source,
        id: subscriptionId,
        receipt: data.source === "apple" ? data.receipt : undefined,
      });
      for (const droppedUid of dropped) {
        await revokeIfFromSubscription(droppedUid, data.source, subscriptionId);
      }
      if (dropped.length > 0) {
        console.log(
          `[verifyReceipt] linked uid=${uid}; unlinked ${dropped.length} ` +
            "least recently used account(s)"
        );
      }
    }

    // Report the entitlement actually in effect, which can come from a
    // different subscription than the receipt just checked.
    return {
      valid: isEntitlementActive(entitlement, Date.now()),
      expiresAt:
        entitlement.expiresAt != null ?
          new Date(entitlement.expiresAt).toISOString() :
          null,
      productId: entitlement.productId,
      autoRenewing: entitlement.autoRenewing,
      environment: entitlement.environment as VerifyReceiptResponse["environment"],
    };
  }
);
