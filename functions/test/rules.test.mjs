import {readFileSync} from "node:fs";
import {after, before, describe, it} from "node:test";
import {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
} from "@firebase/rules-unit-testing";
import {
  collection,
  deleteDoc,
  doc,
  getDoc,
  getDocs,
  limit,
  query,
  setDoc,
  updateDoc,
  where,
} from "firebase/firestore";

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

// ── Smart Shopping Scanner paths ─────────────────────────────────
// The published scanner app relies on these exact behaviours, including
// builds that can no longer be updated. A rules change that fails any test
// below breaks live scanner users — do not deploy it.

const OWNER = "owner-uid";
const MEMBER = "member-uid";
const STRANGER = "stranger-uid";

function sharedDoc(inviteCode) {
  return {
    name: "Household",
    ownerUid: OWNER,
    inviteCode,
    collaborators: {
      [OWNER]: {role: "owner", displayName: "Owner"},
      [MEMBER]: {role: "editor", displayName: "Member"},
    },
  };
}

for (const col of ["sharedLists", "sharedPantries"]) {
  describe(`${col} (scanner)`, () => {
    it("lets any signed-in user look a doc up by invite code", async () => {
      await seed(`${col}/lookup`, sharedDoc("LOOK01"));

      const db = testEnv.authenticatedContext(STRANGER).firestore();
      await assertSucceeds(
        getDocs(
          query(collection(db, col), where("inviteCode", "==", "LOOK01"), limit(1))
        )
      );
    });

    it("denies signed-out reads", async () => {
      await seed(`${col}/signed-out`, sharedDoc("OUT001"));

      const db = testEnv.unauthenticatedContext().firestore();
      await assertFails(getDoc(doc(db, `${col}/signed-out`)));
    });

    it("lets a user create a doc they own", async () => {
      const db = testEnv.authenticatedContext(STRANGER).firestore();
      await assertSucceeds(
        setDoc(doc(db, `${col}/created`), {
          name: "Mine",
          ownerUid: STRANGER,
          inviteCode: "MINE01",
          collaborators: {[STRANGER]: {role: "owner", displayName: "Me"}},
        })
      );
    });

    it("refuses creating a doc owned by someone else", async () => {
      const db = testEnv.authenticatedContext(STRANGER).firestore();
      await assertFails(setDoc(doc(db, `${col}/forged`), sharedDoc("FORGE1")));
    });

    it("lets a non-member join by adding themselves", async () => {
      await seed(`${col}/join`, sharedDoc("JOIN01"));

      const db = testEnv.authenticatedContext(STRANGER).firestore();
      await assertSucceeds(
        updateDoc(doc(db, `${col}/join`), {
          [`collaborators.${STRANGER}`]: {role: "editor", displayName: "New"},
          updatedAt: Date.now(),
        })
      );
    });

    it("refuses a non-member edit that doesn't add themselves", async () => {
      await seed(`${col}/rename`, sharedDoc("RENAM1"));

      const db = testEnv.authenticatedContext(STRANGER).firestore();
      await assertFails(updateDoc(doc(db, `${col}/rename`), {name: "Hijacked"}));
    });

    it("lets a member find their docs by collaborator role", async () => {
      await seed(`${col}/mine`, sharedDoc("ROLE01"));

      const db = testEnv.authenticatedContext(MEMBER).firestore();
      await assertSucceeds(
        getDocs(
          query(
            collection(db, col),
            where(`collaborators.${MEMBER}.role`, "in", ["owner", "editor", "viewer"])
          )
        )
      );
    });

    it("lets collaborators read, add and remove items", async () => {
      await seed(`${col}/items-member`, sharedDoc("ITEM01"));
      await seed(`${col}/items-member/items/milk`, {name: "Milk", quantity: 1});

      const db = testEnv.authenticatedContext(MEMBER).firestore();
      await assertSucceeds(getDoc(doc(db, `${col}/items-member/items/milk`)));
      await assertSucceeds(
        setDoc(doc(db, `${col}/items-member/items/eggs`), {name: "Eggs", quantity: 12})
      );
      await assertSucceeds(deleteDoc(doc(db, `${col}/items-member/items/milk`)));
    });

    it("hides items from non-collaborators", async () => {
      await seed(`${col}/items-stranger`, sharedDoc("ITEM02"));
      await seed(`${col}/items-stranger/items/milk`, {name: "Milk", quantity: 1});

      const db = testEnv.authenticatedContext(STRANGER).firestore();
      await assertFails(getDoc(doc(db, `${col}/items-stranger/items/milk`)));
      await assertFails(
        setDoc(doc(db, `${col}/items-stranger/items/eggs`), {name: "Eggs"})
      );
    });

    it("lets collaborators append activity but not rewrite it", async () => {
      await seed(`${col}/activity`, sharedDoc("ACTV01"));

      const member = testEnv.authenticatedContext(MEMBER).firestore();
      await assertSucceeds(
        setDoc(doc(member, `${col}/activity/activity/a1`), {
          type: "itemAdded",
          actorUid: MEMBER,
        })
      );
      await assertFails(
        updateDoc(doc(member, `${col}/activity/activity/a1`), {type: "edited"})
      );

      const stranger = testEnv.authenticatedContext(STRANGER).firestore();
      await assertFails(
        setDoc(doc(stranger, `${col}/activity/activity/a2`), {type: "itemAdded"})
      );
    });

    it("only lets the owner delete", async () => {
      await seed(`${col}/delete`, sharedDoc("DELE01"));

      const member = testEnv.authenticatedContext(MEMBER).firestore();
      await assertFails(deleteDoc(doc(member, `${col}/delete`)));

      const owner = testEnv.authenticatedContext(OWNER).firestore();
      await assertSucceeds(deleteDoc(doc(owner, `${col}/delete`)));
    });
  });
}

describe("communityProducts (scanner)", () => {
  it("lets a user submit a product as themselves", async () => {
    const db = testEnv.authenticatedContext(UID).firestore();
    await assertSucceeds(
      setDoc(doc(db, "communityProducts/0001"), {
        name: "Oat Milk",
        contributedBy: UID,
      })
    );
  });

  it("refuses a submission attributed to someone else", async () => {
    const db = testEnv.authenticatedContext(UID).firestore();
    await assertFails(
      setDoc(doc(db, "communityProducts/0002"), {
        name: "Oat Milk",
        contributedBy: OTHER_UID,
      })
    );
  });

  it("lets signed-in users confirm but never delete", async () => {
    await seed("communityProducts/0003", {
      name: "Oat Milk",
      contributedBy: OTHER_UID,
      confirmationCount: 0,
    });

    const db = testEnv.authenticatedContext(UID).firestore();
    await assertSucceeds(getDoc(doc(db, "communityProducts/0003")));
    await assertSucceeds(
      updateDoc(doc(db, "communityProducts/0003"), {confirmationCount: 1})
    );
    await assertFails(deleteDoc(doc(db, "communityProducts/0003")));
  });

  it("denies signed-out reads", async () => {
    await seed("communityProducts/0004", {name: "Oat Milk", contributedBy: UID});

    const db = testEnv.unauthenticatedContext().firestore();
    await assertFails(getDoc(doc(db, "communityProducts/0004")));
  });
});

describe("user documents (scanner FCM tokens)", () => {
  it("lets a user write their own document", async () => {
    const db = testEnv.authenticatedContext(UID).firestore();
    await assertSucceeds(setDoc(doc(db, `users/${UID}`), {fcmToken: "token"}));
  });

  it("hides one user's document from another", async () => {
    await seed(`users/${UID}`, {fcmToken: "token"});

    const db = testEnv.authenticatedContext(OTHER_UID).firestore();
    await assertFails(getDoc(doc(db, `users/${UID}`)));
    await assertFails(setDoc(doc(db, `users/${UID}`), {fcmToken: "stolen"}));
  });
});
