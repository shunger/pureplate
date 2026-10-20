import assert from "node:assert/strict";
import {beforeEach, describe, it} from "node:test";
import {getFirestore} from "firebase-admin/firestore";
import {
  joinByInviteCode,
  lookupInviteCode,
} from "../lib/functions/inviteCodeRedemption.js";
import {MAX_FAILED_ATTEMPTS} from "../lib/services/inviteCodes.js";

// Runs against the Firestore emulator (see `npm run test:invites`).

const DAY = 86_400_000;

const call = (fn, uid, data) => fn.run({auth: {uid, token: {}}, data});

async function rejects(promise, code) {
  await assert.rejects(promise, (err) => {
    assert.equal(err.code, code);
    return true;
  });
}

function db() {
  return getFirestore();
}

async function seedList(id, overrides = {}) {
  await db().collection("sharedLists").doc(id).set({
    name: "Groceries",
    storeName: "Costco",
    ownerUid: "owner",
    inviteCode: "ABC234",
    inviteCodeExpiresAt: new Date(Date.now() + 7 * DAY),
    collaborators: {owner: {role: "owner", displayName: "Me"}},
    createdAt: new Date(),
    updatedAt: new Date(),
    ...overrides,
  });
}

beforeEach(async () => {
  assert.ok(process.env.FIRESTORE_EMULATOR_HOST, "run inside the Firestore emulator");
  const collections = await db().listCollections();
  await Promise.all(collections.map((c) => db().recursiveDelete(c)));
});

describe("lookupInviteCode", () => {
  it("previews a list without joining it", async () => {
    await seedList("L1");
    const summary = await call(lookupInviteCode, "guest", {kind: "list", code: " abc234 "});
    assert.equal(summary.id, "L1");
    assert.equal(summary.name, "Groceries");
    assert.deepEqual(Object.keys(summary.collaborators), ["owner"]);
    const doc = await db().doc("sharedLists/L1").get();
    assert.ok(!("guest" in doc.get("collaborators")));
  });

  it("refuses unknown, malformed and expired codes", async () => {
    await seedList("L1", {inviteCodeExpiresAt: new Date(Date.now() - 1)});
    await rejects(call(lookupInviteCode, "guest", {kind: "list", code: "ZZZ999"}), "invalid-argument");
    await rejects(call(lookupInviteCode, "guest", {kind: "list", code: "short"}), "invalid-argument");
    await rejects(call(lookupInviteCode, "guest", {kind: "list", code: "ABC234"}), "failed-precondition");
  });

  it("never answers not-found, which the apps treat as not deployed", async () => {
    await rejects(call(lookupInviteCode, "guest", {kind: "pantry", code: "ZZZ999"}), "invalid-argument");
  });

  it("pauses an account after too many wrong codes, but not others", async () => {
    await seedList("L1");
    for (let i = 0; i < MAX_FAILED_ATTEMPTS; i++) {
      await rejects(call(lookupInviteCode, "guesser", {kind: "list", code: "ZZZ999"}), "invalid-argument");
    }
    // Even the right code is refused while paused.
    await rejects(call(lookupInviteCode, "guesser", {kind: "list", code: "ABC234"}), "resource-exhausted");
    await rejects(call(joinByInviteCode, "guesser", {kind: "list", code: "ABC234"}), "resource-exhausted");
    const summary = await call(lookupInviteCode, "someone-else", {kind: "list", code: "ABC234"});
    assert.equal(summary.id, "L1");
  });

  it("doesn't count successful lookups", async () => {
    await seedList("L1");
    for (let i = 0; i < MAX_FAILED_ATTEMPTS + 2; i++) {
      await call(lookupInviteCode, "guest", {kind: "list", code: "ABC234"});
    }
    assert.ok(!(await db().doc("inviteAttempts/guest").get()).exists);
  });
});

describe("joinByInviteCode", () => {
  it("adds the caller as an editor, as the apps do", async () => {
    await seedList("L1");
    const summary = await call(joinByInviteCode, "guest", {
      kind: "list", code: "ABC234", displayName: "Pat",
    });
    assert.deepEqual(summary.collaborators.guest, {role: "editor", displayName: "Pat"});
    const doc = await db().doc("sharedLists/L1").get();
    assert.deepEqual(doc.get("collaborators.guest"), {role: "editor", displayName: "Pat"});
    assert.ok(doc.get("updatedAt").toMillis() > 0);
  });

  it("keeps an existing member's role", async () => {
    await seedList("L1");
    const summary = await call(joinByInviteCode, "owner", {kind: "list", code: "ABC234"});
    assert.equal(summary.collaborators.owner.role, "owner");
    const doc = await db().doc("sharedLists/L1").get();
    assert.equal(doc.get("collaborators.owner.role"), "owner");
  });

  it("records the app on pantry members, and only known apps", async () => {
    await db().collection("sharedPantries").doc("P1").set({
      name: "Home",
      ownerUid: "owner",
      inviteCode: "PAN234",
      inviteCodeExpiresAt: null,
      collaborators: {owner: {role: "owner", displayName: "Me"}},
    });
    await call(joinByInviteCode, "a", {kind: "pantry", code: "PAN234", sourceApp: "scanner"});
    await call(joinByInviteCode, "b", {kind: "pantry", code: "PAN234", sourceApp: "evil"});
    const doc = await db().doc("sharedPantries/P1").get();
    assert.deepEqual(doc.get("collaborators.a"), {role: "editor", displayName: "User", sourceApp: "scanner"});
    assert.deepEqual(doc.get("collaborators.b"), {role: "editor", displayName: "User"});
  });

  it("caps display names", async () => {
    await seedList("L1");
    await call(joinByInviteCode, "guest", {kind: "list", code: "ABC234", displayName: "x".repeat(500)});
    const doc = await db().doc("sharedLists/L1").get();
    assert.equal(doc.get("collaborators.guest.displayName").length, 100);
  });

  it("refuses expired codes and doesn't join", async () => {
    await seedList("L1", {inviteCodeExpiresAt: new Date(Date.now() - 1)});
    await rejects(call(joinByInviteCode, "guest", {kind: "list", code: "ABC234"}), "failed-precondition");
    const doc = await db().doc("sharedLists/L1").get();
    assert.ok(!("guest" in doc.get("collaborators")));
  });

  it("requires a signed-in caller", async () => {
    await seedList("L1");
    await rejects(joinByInviteCode.run({data: {kind: "list", code: "ABC234"}}), "permission-denied");
  });

  it("rejects unknown share types", async () => {
    await rejects(call(joinByInviteCode, "guest", {kind: "recipes", code: "ABC234"}), "invalid-argument");
  });
});
