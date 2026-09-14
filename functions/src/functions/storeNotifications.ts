import {onRequest} from "firebase-functions/v2/https";
import {onMessagePublished} from "firebase-functions/v2/pubsub";
import {initializeApp, getApps} from "firebase-admin/app";
import {verifyAppleReceipt, appleSharedSecret} from "../services/appleVerifier";
import {verifyGooglePurchase} from "../services/googleVerifier";
import {
  applyToLinkedAccounts,
  lookupSubscription,
} from "../services/entitlementService";

if (getApps().length === 0) initializeApp();

/**
 * Pub/Sub topic wired to Play Console → Monetization setup → Real-time
 * developer notifications. Must match the topic name configured there.
 */
const PLAY_RTDN_TOPIC = "play-store-notifications";

/**
 * Decodes the payload segment of a JWS **without** verifying its signature.
 *
 * That is safe here only because nothing in the payload is trusted: it is used
 * solely to learn *which* subscription changed, after which the state is
 * re-fetched from the store. A forged notification can therefore do no more
 * than make us re-confirm the truth for a subscription we already know about.
 */
function decodeJwsPayload<T>(jws: string): T {
  const parts = jws.split(".");
  if (parts.length !== 3) {
    throw new Error("Malformed JWS");
  }
  return JSON.parse(
    Buffer.from(parts[1], "base64url").toString("utf8")
  ) as T;
}

interface AppleNotificationPayload {
  notificationType?: string;
  subtype?: string;
  data?: {
    signedTransactionInfo?: string;
  };
}

interface AppleTransactionInfo {
  originalTransactionId?: string;
  productId?: string;
}

/**
 * App Store Server Notifications V2 endpoint.
 *
 * Set the URL in App Store Connect → App Information → App Store Server
 * Notifications (both production and sandbox).
 */
export const appleSubscriptionNotifications = onRequest(
  {secrets: [appleSharedSecret]},
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).send("Method not allowed");
      return;
    }

    try {
      const signedPayload = req.body?.signedPayload as string | undefined;
      if (!signedPayload) {
        res.status(400).send("Missing signedPayload");
        return;
      }

      const payload = decodeJwsPayload<AppleNotificationPayload>(signedPayload);
      const signedTx = payload.data?.signedTransactionInfo;
      if (!signedTx) {
        console.warn(
          `[appleNotifications] ${payload.notificationType} carried no transaction`
        );
        res.status(200).send("OK");
        return;
      }

      const tx = decodeJwsPayload<AppleTransactionInfo>(signedTx);
      const originalTransactionId = tx.originalTransactionId;
      if (!originalTransactionId) {
        res.status(200).send("OK");
        return;
      }

      const link = await lookupSubscription("apple", originalTransactionId);
      if (!link?.receipt) {
        // Either a subscription bought before this indexing existed, or one
        // that never completed verifyReceipt. Nothing to re-verify against;
        // the client's own launch sync will repair it on next open.
        console.warn(
          `[appleNotifications] no indexed receipt for ${originalTransactionId}`
        );
        res.status(200).send("OK");
        return;
      }

      // Re-verify from Apple rather than trusting the notification body, then
      // update every account the subscription is linked to.
      const verified = await verifyAppleReceipt(link.receipt);
      await applyToLinkedAccounts(link.uids, "apple", verified);

      console.log(
        `[appleNotifications] ${payload.notificationType}/${payload.subtype ?? "-"} ` +
          `accounts=${link.uids.length} valid=${verified.valid} expires=${verified.expiresAt}`
      );

      res.status(200).send("OK");
    } catch (err: any) {
      console.error("[appleNotifications] failed:", err?.message ?? err);
      // 500 tells Apple to retry, which is what we want for a transient fault.
      res.status(500).send("Error");
    }
  }
);

interface PlayNotification {
  subscriptionNotification?: {
    notificationType?: number;
    purchaseToken?: string;
    subscriptionId?: string;
  };
}

/**
 * Google Play Real-time Developer Notifications.
 *
 * As with Apple, the message is only a trigger: the authoritative state is
 * re-read from the Play Developer API.
 */
export const googleSubscriptionNotifications = onMessagePublished(
  {topic: PLAY_RTDN_TOPIC},
  async (event) => {
    const notification = event.data.message.json as PlayNotification | undefined;
    const purchaseToken = notification?.subscriptionNotification?.purchaseToken;

    if (!purchaseToken) {
      // Test publishes and voided-purchase notifications land here too.
      return;
    }

    const link = await lookupSubscription("google", purchaseToken);
    if (!link) {
      console.warn("[playNotifications] purchase token not indexed to any user");
      return;
    }

    const verified = await verifyGooglePurchase(purchaseToken);
    await applyToLinkedAccounts(link.uids, "google", verified);

    console.log(
      `[playNotifications] type=${notification?.subscriptionNotification?.notificationType} ` +
        `accounts=${link.uids.length} valid=${verified.valid} expires=${verified.expiresAt}`
    );
  }
);
