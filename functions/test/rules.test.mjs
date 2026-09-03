import {readFileSync} from "node:fs";
import {after, before, describe, it} from "node:test";
import {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
} from "@firebase/rules-unit-testing";
import {doc, getDoc, setDoc} from "firebase/firestore";

const UID = "user-a";
const OTHER_UID = "user-b";

let testEnv;

before(async () => {
  testEnv = await initializeTestEnvironment({
    projectId: "pure-pantry-rules-test",
    firestore: {
      rules: readFileSync(
        new URL("../../firestore.rules", import.meta.url),
        "utf8"
      ),
      host: "127.0.0.1",
      port: 8080,
    },
  });
});

after(async () => {
  await testEnv?.cleanup();
});

async function seed(path, data) {
  await testEnv.withSecurityRulesDisabled(async (ctx) => {
    await setDoc(doc(ctx.firestore(), path), data);
  });
}

describe("quota documents", () => {
  it("lets the owner read their own usage", async () => {
    await seed(`users/${UID}/quota/weekly`, {
      planCount: 1,
      chatCount: 0,
      weekStart: Date.now(),
    });

    const db = testEnv.authenticatedContext(UID).firestore();
    await assertSucceeds(getDoc(doc(db, `users/${UID}/quota/weekly`)));
  });

  it("refuses a client write — this is the self-granted premium hole", async () => {
    const db = testEnv.authenticatedContext(UID).firestore();
    await assertFails(
      setDoc(doc(db, `users/${UID}/quota/weekly`), {isPremium: true})
    );
  });

  it("refuses a client reset of the weekly counters", async () => {
    await seed(`users/${UID}/quota/weekly`, {
      planCount: 99,
      chatCount: 99,
      weekStart: Date.now(),
    });

    const db = testEnv.authenticatedContext(UID).firestore();
    await assertFails(
      setDoc(
        doc(db, `users/${UID}/quota/weekly`),
        {planCount: 0, chatCount: 0},
        {merge: true}
      )
    );
  });

  it("hides one user's usage from another", async () => {
    const db = testEnv.authenticatedContext(OTHER_UID).firestore();
    await assertFails(getDoc(doc(db, `users/${UID}/quota/weekly`)));
  });
});

describe("entitlement documents", () => {
  it("lets the owner read their own entitlement", async () => {
    await seed(`users/${UID}/entitlement/current`, {
      isPremium: true,
      expiresAt: Date.now() + 86400000,
    });

    const db = testEnv.authenticatedContext(UID).firestore();
    await assertSucceeds(getDoc(doc(db, `users/${UID}/entitlement/current`)));
  });

  it("refuses a client grant of premium", async () => {
    const db = testEnv.authenticatedContext(UID).firestore();
    await assertFails(
      setDoc(doc(db, `users/${UID}/entitlement/current`), {
        isPremium: true,
        expiresAt: Date.now() + 31536000000,
      })
    );
  });

  it("hides one user's entitlement from another", async () => {
    const db = testEnv.authenticatedContext(OTHER_UID).firestore();
    await assertFails(getDoc(doc(db, `users/${UID}/entitlement/current`)));
  });
});

describe("subscription index", () => {
  it("is invisible to clients in both directions", async () => {
    await seed("subscriptionIndex/abc123", {uid: UID, source: "apple"});

    const db = testEnv.authenticatedContext(UID).firestore();
    await assertFails(getDoc(doc(db, "subscriptionIndex/abc123")));
    await assertFails(setDoc(doc(db, "subscriptionIndex/abc123"), {uid: UID}));
  });
});

describe("unauthenticated access", () => {
  it("is denied everywhere", async () => {
    const db = testEnv.unauthenticatedContext().firestore();
    await assertFails(getDoc(doc(db, `users/${UID}/quota/weekly`)));
    await assertFails(getDoc(doc(db, `users/${UID}/entitlement/current`)));
  });
});
