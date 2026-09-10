# Premium: configuration required before this works

The code is in place. None of it grants premium until the secrets and store
configuration below exist — receipt verification cannot succeed without
credentials, and the client deliberately no longer grants access when
verification fails.

---

## 1. Secrets

Both are read via `defineSecret` and must live in Secret Manager. Never commit
them.

### `APPLE_SHARED_SECRET`
App Store Connect → your app → App Information → **App-Specific Shared Secret**.

```bash
firebase functions:secrets:set APPLE_SHARED_SECRET
```

### Google Play — no secret required

There is deliberately **no** `GOOGLE_PLAY_SERVICE_ACCOUNT` secret. The
organization policy `iam.disableServiceAccountKeyCreation` forbids downloading
service-account JSON keys in this project, so `googleVerifier.ts` authenticates
with Application Default Credentials — the function's own runtime identity —
instead. A key is only needed to impersonate an account from *outside* GCP,
which these functions are not.

Two one-time steps replace the secret:

1. Enable the Play Developer API in the project:
   <https://console.cloud.google.com/apis/library/androidpublisher.googleapis.com?project=pure-pantry-ai>
2. Play Console → Users and permissions → invite the functions' runtime service
   account and grant **View financial data, orders, and cancellation survey
   responses**:

   ```
   382740832833-compute@developer.gserviceaccount.com
   ```

   (Confirm the address in Cloud Console → Cloud Run → any function → Security
   if the runtime service account is ever overridden.)

Permissions can take up to 24 hours to propagate on Google's side; until then
`subscriptionsv2.get` returns 401 and the client keeps the receipt queued for
retry, which is the intended behaviour.

---

## 2. Store products

Create both subscriptions with these exact product IDs — they are asserted
server-side in `functions/src/constants/products.ts` and a receipt for anything
else is rejected.

| Field | Monthly | Annual |
|---|---|---|
| Product ID | `ppmonthly02` | `ppannual02` |
| Reference name | Premium Monthly | Premium Annual |
| **Display name** | **Premium Monthly** | **Premium Annual** |
| Duration | 1 month | 1 year |
| Price (USD) | **$4.99** | **$39.99** |

Annual works out to $3.33/month — a 33% saving worth calling out on the paywall.

Chosen over a steeper annual discount deliberately. Break-even is 8.0 months
($39.99 / $4.99): a monthly subscriber has to stay past eight months to be worth
more than an annual one, which is beyond typical consumer-subscription
retention, so the annual plan still wins on lifetime value without discounting
harder than the decision requires. The monthly price is also the anchor that
makes annual read as a bargain — cutting it to narrow the gap would weaken the
annual pitch and shift mix toward the plan that churns more.

Both products go in **one subscription group** ("Pure Pantry Premium"). Same
group is what lets a subscriber switch plans and prevents holding both at once.

The display name is not cosmetic: the paywall renders
`'${product.title} — ${product.price}'` (`premium_screen.dart:290`), so these
names are what produce "Premium Monthly — $4.99" on the purchase button. That
string is how the paywall satisfies the stores' requirement to state the
subscription period, so do not shorten them to "Premium".

### Free trial: server-side only — configure no introductory offer

**Do not create an introductory offer in App Store Connect or Play Console.**

The 14-day trial is entirely server-side (`rateLimiter.ts:22`, `TRIAL_MS`) and
independent of StoreKit / Play Billing. It keys off `firstUsedAt` in the user's
quota doc, so it starts on first AI use rather than at signup, survives the
weekly counter reset, and grants genuinely uncapped access
(`unlimited = premium || inTrial`, `rateLimiter.ts:74`). `quota_hint.dart:37-44`
renders the countdown to the user.

Rationale: users reach the paywall having already had 14 uncapped days with no
card on file, so a store trial would mostly defer revenue and hand a second free
window to users who already declined. Published trial-conversion benchmarks
compare against a hard paywall, which is not this app's shape.

An introductory offer can be added later as pure store configuration — no code,
no redeploy, no app update — so this is reversible once real conversion data
exists. Removing one after launch is not.

Known and accepted: the trial is per Firebase account, so signing in with a
different account resets it.

---

## 3. Renewal notifications

Without these, a cancellation is only noticed when the stored expiry passes.
With them, it lands within seconds.

### Apple — App Store Server Notifications V2
App Store Connect → App Information → App Store Server Notifications. Set both
the **production** and **sandbox** URLs to the deployed function:

```
https://<region>-<project>.cloudfunctions.net/appleSubscriptionNotifications
```

Version must be **V2**. V1 payloads will be ignored.

### Google — Real-time Developer Notifications
Play Console → Monetization setup → Real-time developer notifications. Create
the Pub/Sub topic named exactly:

```
play-store-notifications
```

This name is hardcoded as `PLAY_RTDN_TOPIC` in
`functions/src/functions/storeNotifications.ts`; change both together if you
rename it. Grant `google-play-developer-notifications@system.gserviceaccount.com`
the Pub/Sub Publisher role on the topic.

---

## 4. Legal pages must be publicly reachable ✅ hosted

`lib/core/constants/app_links.dart` points at:

- <https://purehungerlabs.com/purepantry/TERMS_OF_USE.html>
- <https://purehungerlabs.com/purepantry/PRIVACY_POLICY.html>

Both return 200 and serve the Pure Pantry AI pages. Source text lives in
`TERMS_OF_USE.md` / `PRIVACY_POLICY.md`; the rendered `.html` files next to them
are what gets uploaded. **Re-upload after editing either markdown file** — the
hosted copies do not regenerate themselves, and App Review compares the served
policy against the App Privacy answers.

---

## 5. Deploy

```bash
firebase deploy --only firestore:rules        # do this first — it closes the hole
firebase deploy --only functions
```

Deploy rules **before** functions. The rules change makes
`users/{uid}/quota/weekly` server-write-only, which the new
`checkRateLimit` already assumes.

### Existing users

Quota documents written while the collection was client-writable may still
carry `isPremium: true` — either self-granted or from the old debug toggle.
That field is no longer read by anything, so no cleanup is required for
correctness. To tidy it up anyway:

```bash
# Optional: strip the dead field from existing quota docs.
# Entitlement now lives in users/{uid}/entitlement/current.
```

Nobody is grandfathered into premium by this change: entitlement starts empty
and is granted only by a verified receipt. Anyone who genuinely subscribed
before this deploy gets it back through **Restore Purchases**, which re-verifies
and writes the entitlement doc.

---

## 6. Verify

```bash
cd functions && npm run test:rules   # 9 tests, needs the Firestore emulator
cd functions && npm run build && npm run lint
flutter test
```

Then, in the store sandboxes, walk each of:

- purchase → premium unlocks
- cancel → premium survives to period end, then lapses
- renew → expiry moves forward without user action
- refund → premium revoked
- reinstall → Restore Purchases brings premium back
- second device, same account → premium present without restoring

The one path that cannot be exercised in a sandbox is a backend outage during
verification. To test it, point `verifyReceipt` at a bad `APPLE_SHARED_SECRET`
in a test project: the purchase should report "we're confirming it with the
store", grant nothing, and unlock on the next launch once the secret is fixed.
