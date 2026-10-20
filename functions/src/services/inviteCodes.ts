import {INVITE_CODE_ALPHABET, INVITE_CODE_LENGTH} from "./sharedSpaces";

/**
 * Invite-code redemption, shared by `lookupInviteCode` and `joinByInviteCode`.
 *
 * Codes are six characters from a 32-character alphabet (about a billion
 * combinations), so guessing is limited per account: failed lookups and joins
 * are counted, and an account that keeps guessing wrong is paused. Successful
 * redemptions never count, so people joining normally are unaffected.
 *
 * Direct joins through Firestore stay open until shipped scanner builds have
 * moved to these functions (see RELEASE_MIGRATION_PLAN.md §6); until then the
 * limit only applies to apps that call them.
 */

export const MAX_FAILED_ATTEMPTS = 10;
export const ATTEMPT_WINDOW_MS = 60 * 60 * 1000;

const CODE_PATTERN = new RegExp(
  `^[${INVITE_CODE_ALPHABET}]{${INVITE_CODE_LENGTH}}$`
);

/** Uppercases and trims what the user typed, as both apps do. */
export function normalizeInviteCode(value: unknown): string {
  return typeof value === "string" ? value.trim().toUpperCase() : "";
}

/** Whether a normalized code could have been issued by either app. */
export function isWellFormedInviteCode(code: string): boolean {
  return CODE_PATTERN.test(code);
}

export interface AttemptState {
  windowStart: number;
  failures: number;
}

/** The attempt window in effect at [now]; an elapsed window starts over. */
export function currentWindow(
  state: AttemptState | undefined,
  now: number
): AttemptState {
  if (!state || now - state.windowStart >= ATTEMPT_WINDOW_MS) {
    return {windowStart: now, failures: 0};
  }
  return state;
}

/** Whether the account has used up its failed attempts for this window. */
export function isLockedOut(
  state: AttemptState | undefined,
  now: number
): boolean {
  return currentWindow(state, now).failures >= MAX_FAILED_ATTEMPTS;
}

/** The state after one more failed attempt at [now]. */
export function recordFailure(
  state: AttemptState | undefined,
  now: number
): AttemptState {
  const window = currentWindow(state, now);
  return {windowStart: window.windowStart, failures: window.failures + 1};
}

/** Milliseconds since the epoch for a Firestore Timestamp, Date or number. */
export function toMillis(value: unknown): number | null {
  if (value == null) return null;
  if (typeof value === "number") return value;
  if (value instanceof Date) return value.getTime();
  const maybe = value as {toMillis?: () => number};
  return typeof maybe.toMillis === "function" ? maybe.toMillis() : null;
}

/** Whether a code with this expiry can still be redeemed at [now]. */
export function isExpired(expiresAt: unknown, now: number): boolean {
  const millis = toMillis(expiresAt);
  return millis != null && millis <= now;
}

export interface MemberEntry {
  role: string;
  displayName?: string;
}

/**
 * What a non-member may see of a shared space before joining: enough for the
 * join preview, and the same fields the apps read from the document today.
 */
export interface SharedSpaceSummary {
  id: string;
  name: string;
  storeName: string | null;
  ownerUid: string;
  collaborators: Record<string, MemberEntry>;
  inviteCodeExpiresAt: number | null;
  createdAt: number | null;
  updatedAt: number | null;
}

export function summarize(
  id: string,
  data: Record<string, unknown>
): SharedSpaceSummary {
  const collaborators: Record<string, MemberEntry> = {};
  const raw = data.collaborators;
  if (raw && typeof raw === "object") {
    for (const [uid, entry] of Object.entries(raw as Record<string, unknown>)) {
      if (!entry || typeof entry !== "object") continue;
      const {role, displayName} = entry as Record<string, unknown>;
      collaborators[uid] = {
        role: typeof role === "string" ? role : "editor",
        ...(typeof displayName === "string" ? {displayName} : {}),
      };
    }
  }
  return {
    id,
    name: typeof data.name === "string" ? data.name : "",
    storeName: typeof data.storeName === "string" ? data.storeName : null,
    ownerUid: typeof data.ownerUid === "string" ? data.ownerUid : "",
    collaborators,
    inviteCodeExpiresAt: toMillis(data.inviteCodeExpiresAt),
    createdAt: toMillis(data.createdAt),
    updatedAt: toMillis(data.updatedAt),
  };
}
