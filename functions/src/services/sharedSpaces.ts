import {randomInt} from "crypto";

/**
 * Shared pantries and shopping lists created by Pure Pantry.
 *
 * Sharing is a Premium feature, but the Firestore rules can't enforce that:
 * the same collections are written directly by Smart Shopping Scanner, where
 * sharing is free, and the rules can't tell the two apps apart. So Pure Pantry
 * creates shared spaces through `createSharedSpace`, which checks the
 * server-owned entitlement. Direct creates stay open for the scanner until it
 * has a minimum-version check (see RELEASE_MIGRATION_PLAN.md §6).
 *
 * The document shape below must stay byte-compatible with what both apps
 * write today, since shipped scanner builds read these documents.
 */

/** Ambiguous characters (I, O, 0, 1) are left out, as in both apps. */
export const INVITE_CODE_ALPHABET = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
export const INVITE_CODE_LENGTH = 6;
export const INVITE_CODE_TTL_DAYS = 7;
export const MAX_NAME_CHARS = 100;

export type SharedSpaceKind = "pantry" | "list";

export const COLLECTIONS: Record<SharedSpaceKind, string> = {
  pantry: "sharedPantries",
  list: "sharedLists",
};

export function isSharedSpaceKind(value: unknown): value is SharedSpaceKind {
  return value === "pantry" || value === "list";
}

/**
 * A six-character invite code. [random] is injectable for tests; it defaults
 * to Node's CSPRNG, matching the apps' `Random.secure()`.
 */
export function generateInviteCode(
  random: (max: number) => number = (max) => randomInt(max)
): string {
  let code = "";
  for (let i = 0; i < INVITE_CODE_LENGTH; i++) {
    code += INVITE_CODE_ALPHABET[random(INVITE_CODE_ALPHABET.length)];
  }
  return code;
}

/** Trims and caps a user-supplied name, falling back when it's empty. */
export function sanitizeName(value: unknown, fallback: string): string {
  const text = typeof value === "string" ? value.trim() : "";
  return (text || fallback).slice(0, MAX_NAME_CHARS);
}

/** Trims and caps an optional name; empty becomes undefined. */
export function optionalName(value: unknown): string | undefined {
  const text = typeof value === "string" ? value.trim() : "";
  return text ? text.slice(0, MAX_NAME_CHARS) : undefined;
}

export interface SharedSpaceInput {
  kind: SharedSpaceKind;
  uid: string;
  displayName: string;
  name: string;
  storeName?: string;
  inviteCode: string;
  now: Date;
}

/**
 * The document written for a new shared space: the creator is the only
 * member, as owner, which is also what the Firestore rules require of a
 * client-created one.
 */
export function buildSharedSpaceDoc(
  input: SharedSpaceInput
): Record<string, unknown> {
  const {kind, uid, displayName, name, storeName, inviteCode, now} = input;
  const expiresAt = new Date(
    now.getTime() + INVITE_CODE_TTL_DAYS * 24 * 60 * 60 * 1000
  );

  const doc: Record<string, unknown> = {
    name,
    ownerUid: uid,
    inviteCode,
    inviteCodeExpiresAt: expiresAt,
    collaborators: {
      [uid]: {role: "owner", displayName},
    },
    createdAt: now,
    updatedAt: now,
  };

  if (kind === "list") {
    // Lists carry these two extras in both apps; pantries don't.
    doc.storeName = storeName ?? null;
    doc.inviteCodeCreatedAt = now;
  }

  return doc;
}
