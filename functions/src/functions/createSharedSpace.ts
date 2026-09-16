import {onCall, HttpsError} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {getFirestore, CollectionReference} from "firebase-admin/firestore";
import {isEntitled} from "../services/entitlementService";
import {
  COLLECTIONS,
  buildSharedSpaceDoc,
  generateInviteCode,
  isSharedSpaceKind,
  optionalName,
  sanitizeName,
} from "../services/sharedSpaces";

if (getApps().length === 0) initializeApp();

/** Document ids the client may propose, matching Firestore's own ids. */
const ID_PATTERN = /^[A-Za-z0-9_-]{1,64}$/;

/** Picks an invite code no live document is using. */
async function reserveInviteCode(
  collection: CollectionReference
): Promise<string> {
  for (let attempt = 0; attempt < 10; attempt++) {
    const code = generateInviteCode();
    const existing = await collection
      .where("inviteCode", "==", code)
      .limit(1)
      .get();
    if (existing.empty) return code;
  }
  throw new HttpsError(
    "resource-exhausted",
    "Could not generate an invite code. Please try again."
  );
}

/**
 * Creates a shared pantry or shopping list for a Premium account.
 *
 * This is the authoritative Premium check for sharing: the app's own check is
 * a paywall prompt, which a modified build can skip. See `sharedSpaces.ts` for
 * why the Firestore rules can't enforce it instead.
 */
export const createSharedSpace = onCall(
  // The instance cap matches the other purepantry functions, so a burst of
  // calls can't run up the bill.
  {enforceAppCheck: true, maxInstances: 20},
  async (request): Promise<{id: string; inviteCode: string}> => {
    // Auth check (skipped in emulator when no Auth emulator is running)
    const isEmulator = process.env.FUNCTIONS_EMULATOR === "true";
    if (!isEmulator && !request.auth) {
      throw new HttpsError("permission-denied", "Authentication required.");
    }
    const uid = request.auth?.uid ?? "emulator-test-user";

    const data = (request.data ?? {}) as Record<string, unknown>;
    if (!isSharedSpaceKind(data.kind)) {
      throw new HttpsError("invalid-argument", "Unknown share type.");
    }
    const kind = data.kind;

    if (!(await isEntitled(uid))) {
      throw new HttpsError(
        "permission-denied",
        "Sharing is a Premium feature. Subscribe to share with your family."
      );
    }

    const db = getFirestore();
    const collection = db.collection(COLLECTIONS[kind]);

    // The client may name the document, so it can link its local copy before
    // the first snapshot arrives. `create` below fails if it already exists.
    const proposedId = data.id;
    const id =
      typeof proposedId === "string" && ID_PATTERN.test(proposedId) ?
        proposedId :
        collection.doc().id;

    const inviteCode = await reserveInviteCode(collection);
    const doc = buildSharedSpaceDoc({
      kind,
      uid,
      displayName: sanitizeName(data.displayName, "Me"),
      name: sanitizeName(
        data.name,
        kind === "pantry" ? "Family Pantry" : "Shopping List"
      ),
      storeName: optionalName(data.storeName),
      inviteCode,
      now: new Date(),
    });

    try {
      await collection.doc(id).create(doc);
    } catch (err: any) {
      if (err?.code === 6 /* ALREADY_EXISTS */) {
        throw new HttpsError(
          "already-exists",
          "That shared space already exists."
        );
      }
      throw err;
    }

    console.log(`[createSharedSpace] uid=${uid} kind=${kind} id=${id}`);
    return {id, inviteCode};
  }
);
