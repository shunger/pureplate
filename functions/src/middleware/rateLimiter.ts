import {HttpsError} from "firebase-functions/v2/https";
import {getFirestore, FieldValue} from "firebase-admin/firestore";

interface QuotaDoc {
  planCount: number;
  chatCount: number;
  weekStart: number;
  isPremium?: boolean;
}

const FREE_PLAN_LIMIT = 2;
const FREE_CHAT_LIMIT = 10;
const WEEK_MS = 7 * 24 * 60 * 60 * 1000;

/**
 * Checks and increments weekly usage quota for the given user.
 * Premium users bypass limits. Resets automatically each week.
 *
 * @param uid - Firebase Auth UID
 * @param feature - "plan" or "chat"
 */
export async function checkRateLimit(
  uid: string,
  feature: "plan" | "chat"
): Promise<void> {
  const db = getFirestore();
  const docRef = db.doc(`users/${uid}/quota/weekly`);

  const now = Date.now();

  await db.runTransaction(async (tx) => {
    const snap = await tx.get(docRef);
    let data = snap.data() as QuotaDoc | undefined;

    // If no doc or week has elapsed, reset
    if (!data || now - data.weekStart >= WEEK_MS) {
      data = {
        planCount: 0,
        chatCount: 0,
        weekStart: now,
      };
      tx.set(docRef, data);
    }

    // Premium users bypass limits
    if (data.isPremium) return;

    const count = feature === "plan" ? data.planCount : data.chatCount;
    const limit = feature === "plan" ? FREE_PLAN_LIMIT : FREE_CHAT_LIMIT;

    if (count >= limit) {
      throw new HttpsError(
        "resource-exhausted",
        `You've reached your weekly limit of ${limit} ${feature === "plan" ? "meal plans" : "chat messages"}. Upgrade to Premium for unlimited access.`
      );
    }

    // Increment the counter
    const field = feature === "plan" ? "planCount" : "chatCount";
    tx.update(docRef, {[field]: FieldValue.increment(1)});
  });
}
