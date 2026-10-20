import {test} from "node:test";
import assert from "node:assert/strict";

import {
  ATTEMPT_WINDOW_MS,
  MAX_FAILED_ATTEMPTS,
  currentWindow,
  isExpired,
  isLockedOut,
  isWellFormedInviteCode,
  normalizeInviteCode,
  recordFailure,
  summarize,
  toMillis,
} from "../lib/services/inviteCodes.js";

const NOW = Date.parse("2026-10-20T12:00:00.000Z");

test("codes are normalized the way both apps do", () => {
  assert.equal(normalizeInviteCode("  abc234 "), "ABC234");
  assert.equal(normalizeInviteCode(123456), "");
  assert.equal(normalizeInviteCode(undefined), "");
});

test("only codes the apps could issue are well formed", () => {
  assert.ok(isWellFormedInviteCode("ABC234"));
  for (const code of ["", "ABC23", "ABC2345", "ABCD10", "ABCDEI", "abc234"]) {
    assert.ok(!isWellFormedInviteCode(code), code);
  }
});

test("an account is locked out after the maximum failures", () => {
  let state;
  for (let i = 0; i < MAX_FAILED_ATTEMPTS; i++) {
    assert.ok(!isLockedOut(state, NOW));
    state = recordFailure(state, NOW);
  }
  assert.ok(isLockedOut(state, NOW));
});

test("failures expire with their window", () => {
  const state = {windowStart: NOW, failures: MAX_FAILED_ATTEMPTS};
  assert.ok(isLockedOut(state, NOW + ATTEMPT_WINDOW_MS - 1));
  assert.ok(!isLockedOut(state, NOW + ATTEMPT_WINDOW_MS));
  assert.deepEqual(currentWindow(state, NOW + ATTEMPT_WINDOW_MS), {
    windowStart: NOW + ATTEMPT_WINDOW_MS,
    failures: 0,
  });
  assert.deepEqual(recordFailure(state, NOW + ATTEMPT_WINDOW_MS), {
    windowStart: NOW + ATTEMPT_WINDOW_MS,
    failures: 1,
  });
});

test("codes without an expiry never expire", () => {
  assert.ok(!isExpired(null, NOW));
  assert.ok(!isExpired(undefined, NOW));
  assert.ok(!isExpired(new Date(NOW + 1), NOW));
  assert.ok(isExpired(new Date(NOW), NOW));
  assert.ok(isExpired({toMillis: () => NOW - 1}, NOW));
});

test("timestamps of every stored kind convert to millis", () => {
  assert.equal(toMillis(NOW), NOW);
  assert.equal(toMillis(new Date(NOW)), NOW);
  assert.equal(toMillis({toMillis: () => NOW}), NOW);
  assert.equal(toMillis("2026-10-20"), null);
  assert.equal(toMillis(null), null);
});

test("summaries keep only what the join preview needs", () => {
  const summary = summarize("abc", {
    name: "Groceries",
    storeName: "Costco",
    ownerUid: "owner",
    inviteCode: "ABC234",
    collaborators: {
      owner: {role: "owner", displayName: "Sam", sourceApp: "scanner"},
      broken: "x",
      noName: {role: "editor"},
    },
    inviteCodeExpiresAt: new Date(NOW),
    createdAt: {toMillis: () => NOW - 5},
  });
  assert.deepEqual(summary, {
    id: "abc",
    name: "Groceries",
    storeName: "Costco",
    ownerUid: "owner",
    collaborators: {
      owner: {role: "owner", displayName: "Sam"},
      noName: {role: "editor"},
    },
    inviteCodeExpiresAt: NOW,
    createdAt: NOW - 5,
    updatedAt: null,
  });
  assert.ok(!("inviteCode" in summary));
});
