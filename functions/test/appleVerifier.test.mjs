import assert from "node:assert/strict";
import {describe, it} from "node:test";
import {
  claimedEnvironment,
  toVerifiedSubscription,
  verifyAppleTransaction,
} from "../lib/services/appleVerifier.js";

const now = Date.parse("2026-10-17T12:00:00Z");
const tx = {
  productId: "ppmonthly02",
  originalTransactionId: "2000000123",
  expiresDate: now + 86_400_000,
  environment: "Sandbox",
};

function jws(payload) {
  const part = (o) => Buffer.from(JSON.stringify(o)).toString("base64url");
  return `${part({alg: "ES256"})}.${part(payload)}.c2ln`;
}

describe("toVerifiedSubscription", () => {
  it("accepts an active Pure Pantry subscription", () => {
    assert.deepEqual(toVerifiedSubscription(tx, undefined, now), {
      valid: true,
      productId: "ppmonthly02",
      expiresAt: new Date(tx.expiresDate).toISOString(),
      originalTransactionId: "2000000123",
      environment: "sandbox",
      autoRenewing: true,
    });
  });

  it("rejects expired, revoked, foreign, and expiry-less transactions", () => {
    const expired = toVerifiedSubscription({...tx, expiresDate: now - 1}, undefined, now);
    assert.equal(expired.valid, false);
    assert.equal(expired.autoRenewing, false);
    assert.equal(expired.originalTransactionId, "2000000123");

    const revoked = toVerifiedSubscription({...tx, revocationDate: now - 5}, undefined, now);
    assert.equal(revoked.valid, false);
    assert.equal(revoked.reason, "revoked");

    assert.equal(toVerifiedSubscription({...tx, productId: "other"}, undefined, now).reason,
      "no_matching_product");
    assert.equal(toVerifiedSubscription({...tx, expiresDate: undefined}, undefined, now).reason,
      "no_expiry");
  });

  it("takes auto-renew from renewal info when Apple sends it", () => {
    assert.equal(toVerifiedSubscription(tx, {autoRenewStatus: 0}, now).autoRenewing, false);
    assert.equal(toVerifiedSubscription(tx, {autoRenewStatus: 1}, now).autoRenewing, true);
    assert.equal(
      toVerifiedSubscription({...tx, environment: "Production"}, undefined, now).environment,
      "production"
    );
  });

  it("keeps Premium through a billing grace period", () => {
    const lapsed = {...tx, expiresDate: now - 86_400_000};
    const graceEnd = now + 15 * 86_400_000;
    const inGrace = toVerifiedSubscription(
      lapsed, {autoRenewStatus: 1, gracePeriodExpiresDate: graceEnd}, now);
    assert.equal(inGrace.valid, true);
    assert.equal(inGrace.expiresAt, new Date(graceEnd).toISOString());

    const graceOver = toVerifiedSubscription(
      lapsed, {autoRenewStatus: 1, gracePeriodExpiresDate: now - 1}, now);
    assert.equal(graceOver.valid, false);

    const revokedInGrace = toVerifiedSubscription(
      {...lapsed, revocationDate: now - 5}, {gracePeriodExpiresDate: graceEnd}, now);
    assert.equal(revokedInGrace.valid, false);
  });
});

describe("claimedEnvironment", () => {
  it("reads Sandbox and Production and refuses local test signing", () => {
    assert.equal(claimedEnvironment(jws({environment: "Sandbox"}), "transaction"), "Sandbox");
    assert.equal(
      claimedEnvironment(jws({data: {environment: "Production"}}), "notification"),
      "Production"
    );
    assert.throws(() => claimedEnvironment(jws({environment: "Xcode"}), "transaction"));
    assert.throws(() => claimedEnvironment("not-a-jws", "transaction"));
  });
});

describe("verifyAppleTransaction", () => {
  it("rejects a transaction Apple did not sign", async () => {
    const forged = await verifyAppleTransaction(jws({...tx, bundleId: "com.purehungerlabs.purepantry"}));
    assert.equal(forged.valid, false);
    assert.match(forged.reason, /^apple_jws_/);
  });

  it("rejects an old-style receipt", async () => {
    const result = await verifyAppleTransaction("MIIT2gYJKoZIhvcNAQcCoIITyzCCE8cCAQExCzAJ");
    assert.equal(result.valid, false);
  });
});
