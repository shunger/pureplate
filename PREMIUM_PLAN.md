# Premium Completion Plan

Status as of 2026-08-31. Derived from an audit of `lib/features/premium/`,
`functions/src/`, `firestore.rules`, and every `isPremium` call site.

> ## Implementation status — updated 2026-09-01
>
> **Phases 0-3 are implemented.** Phase 4 (Spending Insights) is deferred by
> decision; the paywall no longer advertises it.
>
> Verified: `flutter test` (273 passing), `npm run build` + `npm run lint` in
> `functions/`, and `npm run test:rules` (9 Firestore rules tests against the
> emulator, covering the two security holes below).
>
> **This does not work until configured** — see `PREMIUM_SETUP.md` for the two
> required secrets, store product IDs, notification endpoints, and the legal
> pages that still need hosting.
>
> Decisions taken: DIY verification in Cloud Functions (not RevenueCat); paywall
> copy corrected rather than gating the chat tab; Spending Insights removed from
> the paywall rather than built.
>
> One deviation from 1.2 as written: Apple verification uses the `/verifyReceipt`
> endpoint, not the App Store Server API. `in_app_purchase` 3.2.0 runs StoreKit 1
> by default, so the client produces a base64 app receipt, which is what that
> endpoint consumes; the Server API's transaction endpoints need a StoreKit 2
> transaction ID the client never produces. The migration path is documented in
> `functions/src/services/appleVerifier.ts`.

**Headline:** premium is currently unsellable and simultaneously unprotected.
`verifyReceipt` is a stub that always fails, so no real purchase grants
entitlement; meanwhile a long-press in Settings and a permissive Firestore rule
both hand out unlimited access for free.

---

## Phase 0 — Close the giveaways ✅ done

These are live in production today. Neither requires design decisions.

### 0.1 Lock the quota document to server-only writes ✅
`firestore.rules:7-9` currently reads:

```
match /users/{uid}/quota/{doc} {
  allow read, write: if request.auth != null && request.auth.uid == uid;
}
```

Any signed-in user can write `isPremium: true` to their own quota doc, or reset
`planCount` / `weekStart`, and bypass all AI metering from the client.
`checkRateLimit` runs through the Admin SDK, which ignores rules, so writes can
be revoked with no backend change.

- Change to `allow read: if <owner>; allow write: if false;`
- Verify `functions/src/middleware/rateLimiter.ts` still passes against the
  emulator (it uses `getFirestore()` from `firebase-admin`, so it will).

### 0.2 Remove the debug premium toggle ✅
`lib/features/settings/presentation/screens/settings_screen.dart:186` — a
long-press on the "About" `_SectionHeader` flips `setPremium()` and writes
`isPremium` into the quota doc. It is not `kDebugMode`-guarded and ships in
release builds.

- Wrap the `GestureDetector` in `if (kDebugMode)`, or delete it and drive test
  entitlement from the emulator instead.
- Its quota-doc write dies with 0.1 anyway; keep the local-DB half for debug
  builds only.

---

## Phase 1 — Make premium purchasable ✅ done

### 1.1 Decide the verification strategy ✅ resolved: DIY in Cloud Functions
Two viable routes:

- **RevenueCat** (`purchases_flutter`): replaces `PurchaseService`, receipt
  verification, renewal webhooks, and cross-device entitlement in one
  dependency. Fastest path; adds a vendor and a revenue share above the free
  tier.
- **DIY in Cloud Functions**: App Store Server API (JWT-signed, `googleapis` or
  `app-store-server-api` npm) + Google Play Developer API
  (`androidpublisher.purchases.subscriptionsv2.get`, service-account auth).
  No vendor, but you own renewals, grace periods, refunds, and notification
  plumbing.

The rest of this plan is written for the DIY route; under RevenueCat, steps
1.2-1.4 and 1.6 collapse into SDK configuration and their listener.

### 1.2 Implement `verifyReceipt` ✅
`functions/src/functions/verifyReceipt.ts:27` — replace the stub.

- Apple: POST the `serverVerificationData` to the App Store Server API, read
  `expiresDate` and `productId` off the latest transaction.
- Google: `androidpublisher` lookup with `productId` + purchase token, read
  `lineItems[].expiryTime`.
- Validate that the returned `productId` is in `{premium_monthly,
  premium_annual}` — do not trust the client-supplied `productId` alone.
- Store credentials in Secret Manager (`defineSecret`), never in the repo.
- Return the existing `VerifyReceiptResponse` shape
  (`functions/src/types/index.ts:125`): `{valid, expiresAt}`.

### 1.3 Make the server the source of truth for entitlement ✅
Add `users/{uid}/entitlement/current`, written only by Cloud Functions:

```
{ isPremium, productId, expiresAt, source, originalTransactionId, updatedAt }
```

- `verifyReceipt` writes it on every successful verification.
- Rules: `allow read: if <owner>; allow write: if false;`
- Point `checkRateLimit` at this doc instead of the `isPremium` field on the
  quota doc (`rateLimiter.ts:57`), or mirror the flag into the quota doc from
  the function. Reading `entitlement/current` is cleaner — one writer, one
  meaning.

This is what fixes the second half of the current bug: even when the client
grants premium locally, the backend keeps throttling paying users to
2 plans / 10 chats per week once the 14-day trial lapses.

### 1.4 Fix the client purchase flow ✅
`lib/features/premium/data/services/purchase_service.dart:100-145`

- Delete the optimistic grant in the `catch` block (line ~139). Today any
  network blip during verification silently awards permanent free premium.
  Replace with a retryable pending state that re-verifies on next launch.
- Keep `valid: false` mapping to `PurchaseError`, but distinguish "verification
  failed, will retry" from "receipt rejected."
- Persist the pending receipt (local table or `SharedPreferences`) so a failed
  verification is retried rather than lost with the user's money.
- Note the stale comment at `verifyReceipt.ts:29-31` claims the client handles
  `valid: false` with an optimistic grant. It does not — the optimistic path is
  the `catch` block, and a returned `false` never throws. Remove the comment
  with the stub.

### 1.5 Re-validate entitlement on launch ✅
`subscriptionExpiresAt` (`user_preferences_table.dart:40`) is written by
`setSubscription` and never read again. Premium therefore never lapses after
cancellation and never renews.

- Add an entitlement sync on app start and on resume: read
  `users/{uid}/entitlement/current`, write through to `PreferencesDao`.
- Treat the local Drift row as a cache, not the record.
- Add an `isPremiumProvider` fallback that expires locally when
  `subscriptionExpiresAt` is in the past and the server is unreachable.

### 1.6 Handle renewals and cancellations ✅
- Apple: App Store Server Notifications V2 → HTTPS function → update
  `entitlement/current`.
- Google: Real-time Developer Notifications → Pub/Sub → same handler.
- Cover `DID_RENEW`, `EXPIRED`, `GRACE_PERIOD`, `REFUND`, `REVOKE`.

### 1.7 Cross-device restore ✅
With 1.3 and 1.5 in place, entitlement follows the Firebase account, so a
reinstall restores from Firestore without touching the store. Keep the
"Restore Purchases" button as the fallback for users who bought while signed
out.

---

## Phase 2 — Close the gating gaps ✅ done

### 2.1 Gate shopping-list sharing ✅
`lib/features/shopping_list/presentation/screens/shopping_list_detail_screen.dart:232`
— `_shareList` checks sign-in only. Pantry sharing gates correctly at
`lib/features/pantry/presentation/screens/pantry_screen.dart:214`; mirror that
premium-then-sign-in order so the same advertised benefit isn't free through
one door and paid through the other.

### 2.2 Resolve the AI chat contradiction ✅ resolved: paywall copy corrected
The paywall lists "AI Chat Planning" as PRO (`premium_screen.dart:86-90`), but
`/chat` is a main tab with no client gate — free users get 10 messages/week
from the server limiter.

Pick one:
- **Gate the tab** (consistent with the paywall, costs free-tier engagement), or
- **Rewrite the paywall row** to "Unlimited AI Chat — Free: 10/week", matching
  how the meal-plan row already reads.

Recommend the second: the metered free tier is working as designed, and the
copy is what's wrong.

### 2.3 Surface quota before the wall, not after ✅
`weeklyPlanCount` and `incrementWeeklyPlanCount()`
(`preferences_dao.dart:106`) are dead — nothing calls them. Users discover the
2/week limit only as an error after they've waited for a plan
(`ai_plan_repository.dart:198`).

- Have `generatePlan` / `chatWithChef` return remaining quota in their
  response, and show "1 of 2 free plans left" on the planner screen.
- Then delete the local counter, which can only drift from the server's.

### 2.4 Build the manage-subscription screen ✅
`Routes.subscriptionManage = '/premium/manage'` (`route_names.dart:60`) is
declared and registered nowhere.

- Show plan, renewal date, and a deep link to the platform's management UI
  (`https://apps.apple.com/account/subscriptions`,
  `https://play.google.com/store/account/subscriptions`).
- Route the premium ListTile in Settings here when `isPremium` is true.

---

## Phase 3 — App Review blockers ✅ done (legal pages still need hosting)

`premium_screen.dart` shows only `product.title — product.price` and a Restore
button. Both stores reject paywalls missing:

- Subscription length and price per period, stated in text.
- Auto-renew disclosure.
- Links to `TERMS_OF_USE.md` and `PRIVACY_POLICY.md` (already in the repo,
  unlinked from the app).
- A visible Restore Purchases control — present, keep it.

Also drop or amend the "Spending Insights" row (`premium_screen.dart:104`)
before submission; advertising a feature that does not exist is a rejection
risk in its own right.

---

## Phase 4 — Spending Insights ⏸ deferred by decision

`lib/core/database/tables/budgets_table.dart` and
`lib/core/database/daos/budget_dao.dart` exist and are registered in
`AppDatabase` (`app_database.dart:103`) with zero call sites — no provider, no
screen, no route. There is no insights feature, only its storage.

Scope, if built:
- Capture spend at pantry-item entry and at shopping-list checkout.
- `lib/features/insights/` — monthly spend, category breakdown, budget vs
  actual against `budgets_table`.
- Route + gate behind `isPremiumProvider`, tab or Settings entry.

Until then, remove the row from the paywall (Phase 3). Shipping the claim
without the feature is worse than shipping a shorter list.

---

## Suggested order

1. Phase 0 — one PR, no decisions, stops the bleeding.
2. Phase 1.1 decision, then 1.2-1.5 — this is what makes revenue possible.
3. Phase 2.1 and 2.2 — small, and they make the paywall honest.
4. Phase 3 — required before the next store submission.
5. Phase 1.6, 2.3, 2.4 — hardening.
6. Phase 4 — its own project.

## Testing

- Emulator: entitlement doc states (active, expired, grace, refunded) against
  `checkRateLimit` and `isPremiumProvider`.
- Rules tests for 0.1 and 1.3 — assert client writes to quota and entitlement
  are rejected.
- Store sandbox: purchase, cancel, renew, refund, reinstall-and-restore on both
  platforms.
- Extend `test/core/database/daos/preferences_dao_test.dart` to cover the
  entitlement-sync write-through from 1.5.

## Open decisions — all resolved 2026-09-01

1. ~~RevenueCat vs. DIY receipt verification (1.1)~~ → DIY in Cloud Functions.
2. ~~Is AI chat premium-gated or metered-free (2.2)?~~ → metered-free; the
   paywall copy was corrected to match.
3. ~~Does Spending Insights get built, or removed from the paywall (4)?~~ →
   removed from the paywall; `budgets_table` and `BudgetDao` remain in place for
   whenever the feature is built.

## Remaining before launch

Not code — see `PREMIUM_SETUP.md`:

1. Set `APPLE_SHARED_SECRET` and `GOOGLE_PLAY_SERVICE_ACCOUNT`.
2. Create `premium_monthly` and `premium_annual` in both stores.
3. Point App Store Server Notifications V2 and Play RTDN at the new endpoints.
4. Host the Terms and Privacy pages the paywall links to.
5. Deploy `firestore:rules` **before** `functions`.
6. Walk the sandbox matrix in `PREMIUM_SETUP.md` §6.
