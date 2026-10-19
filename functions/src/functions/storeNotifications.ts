import {onRequest} from "firebase-functions/v2/https";
import {onMessagePublished} from "firebase-functions/v2/pubsub";
import {initializeApp, getApps} from "firebase-admin/app";
import {verifyAppleNotification} from "../services/appleVerifier";
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
 * App Store Server Notifications V2 endpoint.
 *
 * Set the URL in App Store Connect → App Information → App Store Server
 * Notifications (both production and sandbox).
 */
export const appleSubscriptionNotifications = onRequest(
  // The cap matches what the live function already runs with; pinned in the
  // source so a deploy can't silently drop it.
  {maxInstances: 20},
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

      // Apple signs the notification and the transaction inside it, so once
      // verified the subscription state can be applied as-is.
      const notification = await verifyAppleNotification(signedPayload);
      if (!notification) {
        // Not signed by Apple for this app. 200 so nothing retries it.
        res.status(200).send("OK");
        return;
      }

      const verified = notification.subscription;
      const originalTransactionId = verified?.originalTransactionId;
      if (!verified || !originalTransactionId) {
        console.warn(
          `[appleNotifications] ${notification.notificationType} carried no subscription`
        );
        res.status(200).send("OK");
        return;
      }

      const link = await lookupSubscription("apple", originalTransactionId);
      if (!link || link.uids.length === 0) {
        // A subscription that never completed verifyReceipt. The client's
        // stored retry or Restore Purchases links it.
        console.warn(
          `[appleNotifications] no linked account for ${originalTransactionId}`
        );
        res.status(200).send("OK");
        return;
      }

      await applyToLinkedAccounts(link.uids, "apple", verified);

      console.log(
        `[appleNotifications] ${notification.notificationType}/${notification.subtype ?? "-"} ` +
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
  // maxInstances was set outside the source until 2026-09-16, when a deploy
  // dropped it. Pinned here so it survives every deploy.
  {topic: PLAY_RTDN_TOPIC, maxInstances: 20},
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
