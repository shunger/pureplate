import {onCall, HttpsError} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {VerifyReceiptRequest, VerifyReceiptResponse} from "../types";

if (getApps().length === 0) initializeApp();

export const verifyReceipt = onCall(
  {
    enforceAppCheck: true,
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

    // TODO: Implement actual receipt verification with Apple/Google credentials.
    // For now, return invalid — the client handles this gracefully with
    // optimistic grant (see purchase_service.dart:139-143).
    const uid = request.auth?.uid ?? "emulator-test-user";
    console.log(
      `[verifyReceipt] Stub called for ${data.source} product=${data.productId} uid=${uid}`
    );

    return {
      valid: false,
      expiresAt: null,
    };
  }
);
