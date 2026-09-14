import {readFileSync} from "node:fs";
import {after, before, describe, it} from "node:test";
import {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
} from "@firebase/rules-unit-testing";
import {
  arrayUnion,
  collection,
  deleteDoc,
  deleteField,
  doc,
  getDoc,
  getDocs,
  limit,
  query,
  serverTimestamp,
  setDoc,
  Timestamp,
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

// ── Smart Shopping Scanner / Pure Pantry sharing ─────────────────
// Payloads below mirror what the apps actually write — including shipped
// scanner builds, which can't be updated. A rules change that fails a
// "lets"/"allows" test breaks live users; do not deploy it.

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

function activity(actorUid, extra = {}) {
  return {
    type: "itemAdded",
    actorUid,
    actorDisplayName: "Member",
    timestamp: serverTimestamp(),
    ...extra,
  };
}

for (const col of ["sharedLists", "sharedPantries"]) {
  describe(`${col}: flows the apps use`, () => {
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
          storeName: null,
          ownerUid: STRANGER,
          inviteCode: "MINE01",
          inviteCodeCreatedAt: serverTimestamp(),
          inviteCodeExpiresAt: null,
          collaborators: {
            [STRANGER]: {role: "owner", displayName: "Me", sourceApp: "scanner"},
          },
          createdAt: serverTimestamp(),
          updatedAt: serverTimestamp(),
        })
      );
    });

    it("lets a non-member join by adding themselves", async () => {
      await seed(`${col}/join`, sharedDoc("JOIN01"));

      const db = testEnv.authenticatedContext(STRANGER).firestore();
      await assertSucceeds(
        updateDoc(doc(db, `${col}/join`), {
          [`collaborators.${STRANGER}`]: {role: "editor", displayName: "New"},
          updatedAt: serverTimestamp(),
        })
      );
    });

    it("lets a scanner pantry join record its source app", async () => {
      await seed(`${col}/join-source`, sharedDoc("JOIN02"));

      const db = testEnv.authenticatedContext(STRANGER).firestore();
      await assertSucceeds(
        updateDoc(doc(db, `${col}/join-source`), {
          [`collaborators.${STRANGER}`]: {
            role: "editor",
            displayName: "New",
            sourceApp: "scanner",
          },
          updatedAt: serverTimestamp(),
        })
      );
    });

    it("lets an existing member re-join with the invite code", async () => {
      await seed(`${col}/rejoin`, sharedDoc("JOIN03"));

      const db = testEnv.authenticatedContext(MEMBER).firestore();
      await assertSucceeds(
        updateDoc(doc(db, `${col}/rejoin`), {
          [`collaborators.${MEMBER}`]: {role: "editor", displayName: "Renamed"},
          updatedAt: serverTimestamp(),
        })
      );
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

    it("lets members regenerate and revoke the invite code", async () => {
      await seed(`${col}/invite`, sharedDoc("CODE01"));

      const db = testEnv.authenticatedContext(MEMBER).firestore();
      await assertSucceeds(
        updateDoc(doc(db, `${col}/invite`), {
          inviteCode: "CODE02",
          inviteCodeCreatedAt: serverTimestamp(),
          inviteCodeExpiresAt: Timestamp.fromMillis(Date.now() + 604800000),
          updatedAt: serverTimestamp(),
        })
      );
      await assertSucceeds(
        updateDoc(doc(db, `${col}/invite`), {
          inviteCode: deleteField(),
          inviteCodeCreatedAt: deleteField(),
          inviteCodeExpiresAt: deleteField(),
          updatedAt: serverTimestamp(),
        })
      );
    });

    it("lets members bump updatedAt", async () => {
      await seed(`${col}/touch`, sharedDoc("TOUCH1"));

      const db = testEnv.authenticatedContext(MEMBER).firestore();
      await assertSucceeds(
        updateDoc(doc(db, `${col}/touch`), {updatedAt: serverTimestamp()})
      );
    });

    it("lets the owner remove a member and a member leave", async () => {
      await seed(`${col}/members`, {
        ...sharedDoc("MEMB01"),
        collaborators: {
          [OWNER]: {role: "owner", displayName: "Owner"},
          [MEMBER]: {role: "editor", displayName: "Member"},
          [STRANGER]: {role: "editor", displayName: "Other"},
        },
      });

      const owner = testEnv.authenticatedContext(OWNER).firestore();
      await assertSucceeds(
        updateDoc(doc(owner, `${col}/members`), {
          [`collaborators.${STRANGER}`]: deleteField(),
          updatedAt: serverTimestamp(),
        })
      );

      const member = testEnv.authenticatedContext(MEMBER).firestore();
      await assertSucceeds(
        updateDoc(doc(member, `${col}/members`), {
          [`collaborators.${MEMBER}`]: deleteField(),
          updatedAt: serverTimestamp(),
        })
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

    it("lets collaborators log activity as themselves, but not rewrite it",
        async () => {
          await seed(`${col}/activity`, sharedDoc("ACTV01"));

          const member = testEnv.authenticatedContext(MEMBER).firestore();
          await assertSucceeds(
            setDoc(doc(member, `${col}/activity/activity/a1`), activity(MEMBER))
          );
          await assertSucceeds(
            setDoc(
              doc(member, `${col}/activity/activity/a2`),
              activity(MEMBER, {
                type: "statusChanged",
                itemName: "Milk",
                details: {status: "opened"},
              })
            )
          );
          await assertFails(
            updateDoc(doc(member, `${col}/activity/activity/a1`), {type: "itemRemoved"})
          );

          const stranger = testEnv.authenticatedContext(STRANGER).firestore();
          await assertFails(
            setDoc(doc(stranger, `${col}/activity/activity/a3`), activity(STRANGER))
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

  describe(`${col}: attacks the rules must stop`, () => {
    it("refuses creating a doc owned by someone else", async () => {
      const db = testEnv.authenticatedContext(STRANGER).firestore();
      await assertFails(setDoc(doc(db, `${col}/forged`), sharedDoc("FORGE1")));
    });

    it("refuses creating a doc with other members pre-added", async () => {
      const db = testEnv.authenticatedContext(STRANGER).firestore();
      await assertFails(
        setDoc(doc(db, `${col}/stuffed`), {
          name: "Mine",
          ownerUid: STRANGER,
          collaborators: {
            [STRANGER]: {role: "owner", displayName: "Me"},
            [OWNER]: {role: "editor", displayName: "Victim"},
          },
        })
      );
    });

    it("refuses a non-member edit that doesn't add themselves", async () => {
      await seed(`${col}/rename`, sharedDoc("RENAM1"));

      const db = testEnv.authenticatedContext(STRANGER).firestore();
      await assertFails(updateDoc(doc(db, `${col}/rename`), {name: "Hijacked"}));
    });

    it("refuses a stranger taking over while joining", async () => {
      await seed(`${col}/takeover`, sharedDoc("TAKE01"));

      const db = testEnv.authenticatedContext(STRANGER).firestore();
      await assertFails(
        updateDoc(doc(db, `${col}/takeover`), {
          ownerUid: STRANGER,
          collaborators: {[STRANGER]: {role: "owner", displayName: "Thief"}},
        })
      );
      await assertFails(
        updateDoc(doc(db, `${col}/takeover`), {
          [`collaborators.${STRANGER}`]: {role: "owner", displayName: "Thief"},
        })
      );
      await assertFails(
        updateDoc(doc(db, `${col}/takeover`), {
          [`collaborators.${STRANGER}`]: {role: "editor", displayName: "x"},
          name: "Hijacked",
        })
      );
      await assertFails(
        updateDoc(doc(db, `${col}/takeover`), {
          [`collaborators.${STRANGER}`]: {role: "editor", displayName: "x".repeat(101)},
        })
      );
    });

    it("refuses a member making themselves owner", async () => {
      await seed(`${col}/promote`, sharedDoc("PROM01"));

      const db = testEnv.authenticatedContext(MEMBER).firestore();
      await assertFails(updateDoc(doc(db, `${col}/promote`), {ownerUid: MEMBER}));
      await assertFails(
        updateDoc(doc(db, `${col}/promote`), {
          [`collaborators.${MEMBER}`]: {role: "owner", displayName: "Member"},
        })
      );
    });

    it("refuses a member removing someone else, or anyone removing the owner",
        async () => {
          await seed(`${col}/evict`, {
            ...sharedDoc("EVIC01"),
            collaborators: {
              [OWNER]: {role: "owner", displayName: "Owner"},
              [MEMBER]: {role: "editor", displayName: "Member"},
              [STRANGER]: {role: "editor", displayName: "Other"},
            },
          });

          const member = testEnv.authenticatedContext(MEMBER).firestore();
          await assertFails(
            updateDoc(doc(member, `${col}/evict`), {
              [`collaborators.${STRANGER}`]: deleteField(),
            })
          );
          await assertFails(
            updateDoc(doc(member, `${col}/evict`), {
              [`collaborators.${OWNER}`]: deleteField(),
            })
          );

          const owner = testEnv.authenticatedContext(OWNER).firestore();
          await assertFails(
            updateDoc(doc(owner, `${col}/evict`), {
              [`collaborators.${OWNER}`]: deleteField(),
            })
          );
        });

    it("refuses a member renaming the list or pantry", async () => {
      await seed(`${col}/member-rename`, sharedDoc("MREN01"));

      const db = testEnv.authenticatedContext(MEMBER).firestore();
      await assertFails(
        updateDoc(doc(db, `${col}/member-rename`), {name: "Hijacked"})
      );
    });

    it("refuses activity impersonating another user or off-script", async () => {
      await seed(`${col}/spoof`, sharedDoc("SPOF01"));

      const db = testEnv.authenticatedContext(MEMBER).firestore();
      const path = (id) => doc(db, `${col}/spoof/activity/${id}`);
      await assertFails(setDoc(path("s1"), activity(OWNER)));
      await assertFails(setDoc(path("s2"), activity(MEMBER, {type: "securityAlert"})));
      await assertFails(
        setDoc(path("s3"), activity(MEMBER, {actorDisplayName: "x".repeat(101)}))
      );
      await assertFails(
        setDoc(path("s4"), activity(MEMBER, {itemName: "x".repeat(201)}))
      );
      await assertFails(setDoc(path("s5"), activity(MEMBER, {link: "https://evil"})));
      await assertFails(
        setDoc(path("s6"), activity(MEMBER, {timestamp: Timestamp.fromMillis(0)}))
      );
    });
  });
}

describe("communityProducts", () => {
  it("lets a user submit a product the way the scanner does", async () => {
    const db = testEnv.authenticatedContext(UID).firestore();
    await assertSucceeds(
      setDoc(doc(db, "communityProducts/0001"), {
        name: "Oat Milk",
        brand: "Oatly",
        category: "dairy",
        contributedBy: UID,
        contributedAt: Timestamp.now(),
        confirmationCount: 0,
        confirmedBy: [],
        flagCount: 0,
        flaggedBy: [],
        offSubmitted: false,
      })
    );
  });

  it("lets a user submit a product the way Pure Pantry does", async () => {
    const db = testEnv.authenticatedContext(UID).firestore();
    await assertSucceeds(
      setDoc(doc(db, "communityProducts/0005"), {
        name: "Oat Milk",
        contributedBy: UID,
        contributedAt: serverTimestamp(),
        confirmationCount: 0,
        confirmedBy: [],
        flagCount: 0,
        flaggedBy: [],
        offSubmitted: false,
      })
    );
  });

  it("refuses a submission attributed to someone else or with fake votes",
      async () => {
        const db = testEnv.authenticatedContext(UID).firestore();
        const product = {
          name: "Oat Milk",
          contributedBy: UID,
          contributedAt: serverTimestamp(),
          confirmationCount: 0,
          confirmedBy: [],
          flagCount: 0,
          flaggedBy: [],
          offSubmitted: false,
        };
        await assertFails(
          setDoc(doc(db, "communityProducts/0002"), {...product, contributedBy: OTHER_UID})
        );
        await assertFails(
          setDoc(doc(db, "communityProducts/0002"), {...product, confirmationCount: 999})
        );
        await assertFails(
          setDoc(doc(db, "communityProducts/0002"), {...product, extra: "field"})
        );
      });

  it("lets other users confirm and flag the way the apps do", async () => {
    await seed("communityProducts/0003", {
      name: "Oat Milk",
      contributedBy: OTHER_UID,
      confirmationCount: 1,
      confirmedBy: ["someone"],
      flagCount: 0,
      flaggedBy: [],
    });

    const db = testEnv.authenticatedContext(UID).firestore();
    await assertSucceeds(getDoc(doc(db, "communityProducts/0003")));
    await assertSucceeds(
      updateDoc(doc(db, "communityProducts/0003"), {
        confirmationCount: 2,
        confirmedBy: arrayUnion(UID),
      })
    );
    await assertSucceeds(
      updateDoc(doc(db, "communityProducts/0003"), {
        flagCount: 1,
        flaggedBy: arrayUnion(UID),
      })
    );
    await assertFails(deleteDoc(doc(db, "communityProducts/0003")));
  });

  it("refuses vandalism and vote stuffing", async () => {
    await seed("communityProducts/0006", {
      name: "Oat Milk",
      contributedBy: OTHER_UID,
      confirmationCount: 0,
      confirmedBy: [],
      flagCount: 0,
      flaggedBy: [],
    });

    const db = testEnv.authenticatedContext(UID).firestore();
    const ref = doc(db, "communityProducts/0006");
    await assertFails(updateDoc(ref, {name: "Poison"}));
    await assertFails(
      updateDoc(ref, {confirmationCount: 999, confirmedBy: arrayUnion(UID)})
    );
    await assertFails(
      updateDoc(ref, {confirmationCount: 2, confirmedBy: ["x", UID]})
    );
    await assertSucceeds(
      updateDoc(ref, {confirmationCount: 1, confirmedBy: arrayUnion(UID)})
    );
    await assertFails(
      updateDoc(ref, {confirmationCount: 2, confirmedBy: arrayUnion(UID)})
    );

    const contributor = testEnv.authenticatedContext(OTHER_UID).firestore();
    await assertFails(
      updateDoc(doc(contributor, "communityProducts/0006"), {
        confirmationCount: 2,
        confirmedBy: arrayUnion(OTHER_UID),
      })
    );
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
