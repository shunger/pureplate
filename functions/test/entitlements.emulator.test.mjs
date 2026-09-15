import assert from "node:assert/strict";
import {after, before, beforeEach, describe, it} from "node:test";
import {deleteApp, initializeApp} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";
import {
  applyEntitlement,
  linkSubscription,
  lookupSubscription,
  revokeIfFromSubscription,
} from "../lib/services/entitlementService.js";
import {MAX_LINKED_ACCOUNTS} from "../lib/services/subscriptionLinks.js";

// Runs against the Firestore emulator (see `npm run test:entitlements`).

let app;
let db;

const DAY = 86_400_000;

const verified = (overrides = {}) => ({
  valid: true,
  productId: "ppannual02",
  expiresAt: new Date(Date.now() + 30 * DAY).toISOString(),
  originalTransactionId: "sub-A",
  environment: "production",
  autoRenewing: true,
  ...overrides,
});

async function entitlementOf(uid) {
  return (await db.doc(`users/${uid}/entitlement/current`).get()).data();
}

before(() => {
  assert.ok(process.env.FIRESTORE_EMULATOR_HOST, "run inside the Firestore emulator");
  app = initializeApp({projectId: "pure-pantry-entitlement-test"});
  db = getFirestore();
});

after(async () => {
  await deleteApp(app);
});

beforeEach(async () => {
  const collections = await db.listCollections();
  await Promise.all(collections.map((c) => db.recursiveDelete(c)));
});

describe("linkSubscription", () => {
  it("links several accounts and notifies all of them", async () => {
    await linkSubscription({uid: "iphone", source: "apple", id: "sub-A", receipt: "r1"});
    await linkSubscription({uid: "ipad", source: "apple", id: "sub-A"});

    const link = await lookupSubscription("apple", "sub-A");
    assert.deepEqual(link.uids, ["ipad", "iphone"]);
    assert.equal(link.receipt, "r1");
  });

  it("drops the oldest account past the cap and revokes only its shared Premium",
      async () => {
        const uids = Array.from({length: MAX_LINKED_ACCOUNTS}, (_, i) => `u${i}`);
        for (const uid of uids) {
          await applyEntitlement(uid, "apple", verified());
          await linkSubscription({uid, source: "apple", id: "sub-A"});
          await new Promise((r) => setTimeout(r, 2));
        }

        const dropped = await linkSubscription({uid: "newcomer", source: "apple", id: "sub-A"});
        assert.deepEqual(dropped, ["u0"]);
        for (const uid of dropped) {
          await revokeIfFromSubscription(uid, "apple", "sub-A");
        }

        assert.equal((await entitlementOf("u0")).isPremium, false);
        assert.equal((await entitlementOf("u1")).isPremium, true);
        const link = await lookupSubscription("apple", "sub-A");
        assert.equal(link.uids.length, MAX_LINKED_ACCOUNTS);
        assert.ok(!link.uids.includes("u0"));
      });

  it("revoking leaves Premium from a different subscription alone", async () => {
    await applyEntitlement("buyer", "apple", verified({originalTransactionId: "own-sub"}));

    const revoked = await revokeIfFromSubscription("buyer", "apple", "sub-A");

    assert.equal(revoked, false);
    assert.equal((await entitlementOf("buyer")).isPremium, true);
  });

  it("reads and migrates a single-account link from before this change", async () => {
    const snap = await db.collection("subscriptionIndex").get();
    assert.equal(snap.size, 0);
    await linkSubscription({uid: "legacy", source: "google", id: "token-1"});
    const [doc] = (await db.collection("subscriptionIndex").get()).docs;
    await doc.ref.set({uid: "legacy", source: "google", updatedAt: 1});

    assert.deepEqual((await lookupSubscription("google", "token-1")).uids, ["legacy"]);

    await linkSubscription({uid: "second", source: "google", id: "token-1"});
    const migrated = (await doc.ref.get()).data();
    assert.deepEqual(Object.keys(migrated.accounts).sort(), ["legacy", "second"]);
    // Still readable by the previous function version, in case of rollback.
    assert.equal(migrated.uid, "second");
  });
});

describe("applyEntitlement", () => {
  it("keeps active Premium when Restore re-delivers an old, expired subscription",
      async () => {
        await applyEntitlement("user", "google", verified({originalTransactionId: "current"}));

        const result = await applyEntitlement(
          "user",
          "google",
          verified({originalTransactionId: "old", valid: false})
        );

        assert.equal(result.applied, false);
        assert.equal(result.doc.isPremium, true);
        assert.equal((await entitlementOf("user")).originalTransactionId, "current");
      });

  it("applies a cancellation of the subscription in effect", async () => {
    await applyEntitlement("user", "apple", verified());

    const result = await applyEntitlement("user", "apple", verified({valid: false}));

    assert.equal(result.applied, true);
    assert.equal((await entitlementOf("user")).isPremium, false);
  });
});
