import {test} from "node:test";
import assert from "node:assert/strict";

import {
  COLLECTIONS,
  INVITE_CODE_ALPHABET,
  INVITE_CODE_LENGTH,
  MAX_NAME_CHARS,
  buildSharedSpaceDoc,
  generateInviteCode,
  isSharedSpaceKind,
  optionalName,
  sanitizeName,
} from "../lib/services/sharedSpaces.js";

const NOW = new Date("2026-09-16T12:00:00.000Z");

test("invite codes use the apps' alphabet and length", () => {
  for (let i = 0; i < 200; i++) {
    const code = generateInviteCode();
    assert.equal(code.length, INVITE_CODE_LENGTH);
    for (const char of code) {
      assert.ok(
        INVITE_CODE_ALPHABET.includes(char),
        `unexpected character ${char}`
      );
    }
  }
});

test("invite codes exclude characters users confuse", () => {
  for (const char of ["I", "O", "0", "1"]) {
    assert.ok(!INVITE_CODE_ALPHABET.includes(char));
  }
});

test("invite code generation draws from the whole alphabet", () => {
  const draws = [];
  const code = generateInviteCode((max) => {
    draws.push(max);
    return draws.length - 1;
  });
  assert.deepEqual(draws, Array(INVITE_CODE_LENGTH).fill(32));
  assert.equal(code, INVITE_CODE_ALPHABET.slice(0, INVITE_CODE_LENGTH));
});

test("names are trimmed, capped and defaulted", () => {
  assert.equal(sanitizeName("  Home  ", "Family Pantry"), "Home");
  assert.equal(sanitizeName("   ", "Family Pantry"), "Family Pantry");
  assert.equal(sanitizeName(undefined, "Family Pantry"), "Family Pantry");
  assert.equal(sanitizeName(42, "Family Pantry"), "Family Pantry");
  assert.equal(sanitizeName("x".repeat(500), "n").length, MAX_NAME_CHARS);
});

test("optional names drop empties", () => {
  assert.equal(optionalName(" Trader Joe's "), "Trader Joe's");
  assert.equal(optionalName("  "), undefined);
  assert.equal(optionalName(null), undefined);
  assert.equal(optionalName("y".repeat(500)).length, MAX_NAME_CHARS);
});

test("kinds map to the shared collections", () => {
  assert.equal(COLLECTIONS.pantry, "sharedPantries");
  assert.equal(COLLECTIONS.list, "sharedLists");
  assert.ok(isSharedSpaceKind("pantry"));
  assert.ok(isSharedSpaceKind("list"));
  assert.ok(!isSharedSpaceKind("pantries"));
  assert.ok(!isSharedSpaceKind(undefined));
});

test("a new pantry has the creator as its only member, as owner", () => {
  const doc = buildSharedSpaceDoc({
    kind: "pantry",
    uid: "u1",
    displayName: "Sam",
    name: "Family Pantry",
    inviteCode: "ABC234",
    now: NOW,
  });

  assert.equal(doc.name, "Family Pantry");
  assert.equal(doc.ownerUid, "u1");
  assert.equal(doc.inviteCode, "ABC234");
  assert.deepEqual(doc.collaborators, {
    u1: {role: "owner", displayName: "Sam"},
  });
  assert.deepEqual(doc.createdAt, NOW);
  assert.deepEqual(doc.updatedAt, NOW);
  // Pantries carry neither of the list-only fields.
  assert.ok(!("storeName" in doc));
  assert.ok(!("inviteCodeCreatedAt" in doc));
});

test("invite codes expire in seven days", () => {
  const doc = buildSharedSpaceDoc({
    kind: "pantry",
    uid: "u1",
    displayName: "Sam",
    name: "Family Pantry",
    inviteCode: "ABC234",
    now: NOW,
  });

  assert.equal(
    doc.inviteCodeExpiresAt.getTime() - NOW.getTime(),
    7 * 24 * 60 * 60 * 1000
  );
});

test("a new list carries storeName and inviteCodeCreatedAt", () => {
  const doc = buildSharedSpaceDoc({
    kind: "list",
    uid: "u2",
    displayName: "Alex",
    name: "Weekly Shop",
    storeName: "Trader Joe's",
    inviteCode: "XYZ789",
    now: NOW,
  });

  assert.equal(doc.storeName, "Trader Joe's");
  assert.deepEqual(doc.inviteCodeCreatedAt, NOW);
  assert.deepEqual(doc.collaborators, {
    u2: {role: "owner", displayName: "Alex"},
  });
});

test("a list without a store stores null, not undefined", () => {
  const doc = buildSharedSpaceDoc({
    kind: "list",
    uid: "u2",
    displayName: "Alex",
    name: "Weekly Shop",
    inviteCode: "XYZ789",
    now: NOW,
  });

  // Firestore rejects undefined; the apps write null for a missing store.
  assert.equal(doc.storeName, null);
});
