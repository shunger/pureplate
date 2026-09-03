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

### `GOOGLE_PLAY_SERVICE_ACCOUNT`
The **entire service-account JSON key**, as one secret value.

1. Google Cloud console → create a service account.
2. Play Console → Users and permissions → invite that service account, grant
   **View financial data, orders, and cancellation survey responses**.
3. Download the JSON key, then:

```bash
firebase functions:secrets:set GOOGLE_PLAY_SERVICE_ACCOUNT < service-account.json
```

Permissions can take up to 24 hours to propagate on Google's side; until then
`subscriptionsv2.get` returns 401 and the client keeps the receipt queued for
retry, which is the intended behaviour.

---

## 2. Store products

Create both subscriptions with these exact product IDs — they are asserted
server-side in `functions/src/constants/products.ts` and a receipt for anything
else is rejected:

- `premium_monthly`
- `premium_annual`

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

## 4. Legal pages must be publicly reachable

`lib/core/constants/app_links.dart` points at:

- `https://purehungerlabs.com/terms`
- `https://purehungerlabs.com/privacy`

**Neither is hosted yet.** The source text is in `TERMS_OF_USE.md` and
`PRIVACY_POLICY.md`. Both App Review and Play review open these links from the
paywall; publish the pages, or change the constants to wherever they land.

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
