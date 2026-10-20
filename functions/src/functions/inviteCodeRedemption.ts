import {onCall, HttpsError, CallableRequest} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {
  getFirestore,
  FieldValue,
  QueryDocumentSnapshot,
} from "firebase-admin/firestore";
import {COLLECTIONS, isSharedSpaceKind, sanitizeName} from "../services/sharedSpaces";
import {
  ATTEMPT_WINDOW_MS,
  AttemptState,
  SharedSpaceSummary,
  isExpired,
  isLockedOut,
  isWellFormedInviteCode,
  normalizeInviteCode,
  recordFailure,
  summarize,
} from "../services/inviteCodes";

if (getApps().length === 0) initializeApp();

/** Server-only; no Firestore rule matches it, so clients can't read it. */
const ATTEMPTS_COLLECTION = "inviteAttempts";

/** App labels both apps write on pantry members. */
const SOURCE_APPS = new Set(["scanner", "pantry"]);

// App Check isn't enforced: shipped scanner builds don't send tokens yet.
// The instance cap matches the other purepantry functions.
const OPTIONS = {enforceAppCheck: false, maxInstances: 20};

function requireUid(request: CallableRequest): string {
  const isEmulator = process.env.FUNCTIONS_EMULATOR === "true";
  if (!isEmulator && !request.auth) {
    throw new HttpsError("permission-denied", "Authentication required.");
  }
  return request.auth?.uid ?? "emulator-test-user";
}

function attemptsRef(uid: string) {
  return getFirestore().collection(ATTEMPTS_COLLECTION).doc(uid);
}

async function throwIfLockedOut(uid: string, now: number): Promise<void> {
  const snap = await attemptsRef(uid).get();
  if (isLockedOut(snap.data() as AttemptState | undefined, now)) {
    throw new HttpsError(
      "resource-exhausted",
      "Too many incorrect invite codes. Please try again in an hour."
    );
  }
}

/**
 * Counts a failed redemption and throws [error]. Business outcomes never use
 * `not-found`: the apps read that code as "function not deployed" and fall
 * back to joining directly.
 */
async function fail(uid: string, now: number, error: HttpsError): Promise<never> {
  const ref = attemptsRef(uid);
  await getFirestore().runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    const next = recordFailure(snap.data() as AttemptState | undefined, now);
    // expireAt lets a Firestore TTL policy clean these up.
    tx.set(ref, {...next, expireAt: new Date(next.windowStart + ATTEMPT_WINDOW_MS)});
  });
  throw error;
}

interface Redemption {
  uid: string;
  kind: "pantry" | "list";
  doc: QueryDocumentSnapshot;
  now: number;
}

/** Validates the request and finds the shared space its code belongs to. */
async function redeem(request: CallableRequest): Promise<Redemption> {
  const uid = requireUid(request);
  const now = Date.now();
  const data = (request.data ?? {}) as Record<string, unknown>;
  if (!isSharedSpaceKind(data.kind)) {
    throw new HttpsError("invalid-argument", "Unknown share type.");
  }
  const kind = data.kind;

  await throwIfLockedOut(uid, now);

  const code = normalizeInviteCode(data.code);
  const invalid = new HttpsError("invalid-argument", "Invalid invite code.");
  if (!isWellFormedInviteCode(code)) return fail(uid, now, invalid);

  const query = await getFirestore()
    .collection(COLLECTIONS[kind])
    .where("inviteCode", "==", code)
    .limit(1)
    .get();
  if (query.empty) return fail(uid, now, invalid);

  const doc = query.docs[0];
  if (isExpired(doc.get("inviteCodeExpiresAt"), now)) {
    return fail(
      uid,
      now,
      new HttpsError("failed-precondition", "This invite code has expired.")
    );
  }
  return {uid, kind, doc, now};
}

/** Previews the shared pantry or list an invite code belongs to. */
export const lookupInviteCode = onCall(
  OPTIONS,
  async (request): Promise<SharedSpaceSummary> => {
    const {doc} = await redeem(request);
    return summarize(doc.id, doc.data());
  }
);

/**
 * Joins the shared pantry or list an invite code belongs to, as an editor.
 * Someone who is already a member keeps their role; joining again is a no-op.
 */
export const joinByInviteCode = onCall(
  OPTIONS,
  async (request): Promise<SharedSpaceSummary> => {
    const {uid, kind, doc, now} = await redeem(request);
    const data = (request.data ?? {}) as Record<string, unknown>;

    const entry: Record<string, string> = {
      role: "editor",
      displayName: sanitizeName(data.displayName, "User"),
    };
    if (
      kind === "pantry" &&
      typeof data.sourceApp === "string" &&
      SOURCE_APPS.has(data.sourceApp)
    ) {
      entry.sourceApp = data.sourceApp;
    }

    const joined = await getFirestore().runTransaction(async (tx) => {
      const snap = await tx.get(doc.ref);
      const current = snap.data();
      // The code may have been changed or revoked since the lookup.
      if (
        !current ||
        current.inviteCode !== doc.get("inviteCode") ||
        isExpired(current.inviteCodeExpiresAt, now)
      ) {
        return null;
      }
      const members = (current.collaborators ?? {}) as Record<string, unknown>;
      if (uid in members) return summarize(snap.id, current);

      tx.update(doc.ref, {
        [`collaborators.${uid}`]: entry,
        updatedAt: FieldValue.serverTimestamp(),
      });
      return summarize(snap.id, {
        ...current,
        collaborators: {...members, [uid]: entry},
        updatedAt: new Date(now),
      });
    });

    if (!joined) {
      throw new HttpsError(
        "failed-precondition",
        "This invite code is no longer valid."
      );
    }
    console.log(`[joinByInviteCode] uid=${uid} kind=${kind} id=${doc.id}`);
    return joined;
  }
);
