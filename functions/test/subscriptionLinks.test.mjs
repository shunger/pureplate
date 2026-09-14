import assert from "node:assert/strict";
import {describe, it} from "node:test";
import {
  MAX_LINKED_ACCOUNTS,
  isEntitlementActive,
  linkAccount,
  linkedUids,
  readLinkedAccounts,
  shouldApplyEntitlement,
} from "../lib/services/subscriptionLinks.js";

const NOW = 1_800_000_000_000;

const verified = (overrides = {}) => ({
  valid: true,
  productId: "ppannual02",
  expiresAt: new Date(NOW + 86_400_000).toISOString(),
  originalTransactionId: "sub-A",
  environment: "production",
  autoRenewing: true,
  ...overrides,
});

const entitlement = (overrides = {}) => ({
  isPremium: true,
  productId: "ppannual02",
  expiresAt: NOW + 86_400_000,
  source: "apple",
  originalTransactionId: "sub-A",
  environment: "production",
  autoRenewing: true,
  updatedAt: NOW,
  ...overrides,
});

describe("readLinkedAccounts", () => {
  it("reads the accounts map", () => {
    assert.deepEqual(readLinkedAccounts({accounts: {a: 1, b: 2}}), {a: 1, b: 2});
  });

  it("migrates the single uid older documents hold", () => {
    assert.deepEqual(readLinkedAccounts({uid: "legacy", updatedAt: 5}), {legacy: 5});
    assert.deepEqual(readLinkedAccounts({uid: "legacy"}), {legacy: 0});
  });

  it("keeps a newer link time over the legacy field", () => {
    assert.deepEqual(
      readLinkedAccounts({uid: "a", updatedAt: 1, accounts: {a: 9}}),
      {a: 9}
    );
  });

  it("ignores missing or malformed data", () => {
    assert.deepEqual(readLinkedAccounts(undefined), {});
    assert.deepEqual(readLinkedAccounts({accounts: {a: "soon"}, uid: 42}), {});
  });
});

describe("linkAccount", () => {
  it("adds an account without dropping anyone under the cap", () => {
    const result = linkAccount({a: 1}, "b", NOW);
    assert.deepEqual(result.accounts, {a: 1, b: NOW});
    assert.deepEqual(result.dropped, []);
  });

  it("refreshes an account that's already linked", () => {
    const result = linkAccount({a: 1, b: 2}, "a", NOW);
    assert.deepEqual(result.accounts, {a: NOW, b: 2});
    assert.deepEqual(result.dropped, []);
  });

  it("drops the least recently linked account past the cap", () => {
    const full = Object.fromEntries(
      Array.from({length: MAX_LINKED_ACCOUNTS}, (_, i) => [`u${i}`, i + 1])
    );
    const result = linkAccount(full, "newcomer", NOW);
    assert.equal(Object.keys(result.accounts).length, MAX_LINKED_ACCOUNTS);
    assert.deepEqual(result.dropped, ["u0"]);
    assert.equal(result.accounts.newcomer, NOW);
  });

  it("never drops the account being linked", () => {
    const result = linkAccount({a: 1, b: 2, c: 3}, "a", NOW, 1);
    assert.deepEqual(Object.keys(result.accounts), ["a"]);
    assert.deepEqual(result.dropped.sort(), ["b", "c"]);
  });
});

describe("linkedUids", () => {
  it("lists the most recently linked account first", () => {
    assert.deepEqual(linkedUids({old: 1, newest: 3, middle: 2}), ["newest", "middle", "old"]);
  });
});

describe("shouldApplyEntitlement", () => {
  it("applies to an account with no entitlement yet", () => {
    assert.equal(shouldApplyEntitlement(undefined, verified({valid: false}), NOW), true);
  });

  it("applies any news about the subscription already in effect", () => {
    assert.equal(
      shouldApplyEntitlement(entitlement(), verified({valid: false}), NOW),
      true
    );
  });

  it("never lets another subscription take away active Premium", () => {
    const other = verified({originalTransactionId: "sub-B", valid: false});
    assert.equal(shouldApplyEntitlement(entitlement(), other, NOW), false);
    const otherValid = verified({originalTransactionId: "sub-B"});
    assert.equal(shouldApplyEntitlement(entitlement(), otherValid, NOW), false);
  });

  it("lets a valid subscription replace a lapsed one", () => {
    const lapsed = entitlement({expiresAt: NOW - 1});
    assert.equal(
      shouldApplyEntitlement(lapsed, verified({originalTransactionId: "sub-B"}), NOW),
      true
    );
    assert.equal(
      shouldApplyEntitlement(
        lapsed,
        verified({originalTransactionId: "sub-B", valid: false}),
        NOW
      ),
      false
    );
  });
});

describe("isEntitlementActive", () => {
  it("requires Premium and an unexpired (or open-ended) period", () => {
    assert.equal(isEntitlementActive(entitlement(), NOW), true);
    assert.equal(isEntitlementActive(entitlement({expiresAt: null}), NOW), true);
    assert.equal(isEntitlementActive(entitlement({expiresAt: NOW}), NOW), false);
    assert.equal(isEntitlementActive(entitlement({isPremium: false}), NOW), false);
    assert.equal(isEntitlementActive(undefined, NOW), false);
  });
});
