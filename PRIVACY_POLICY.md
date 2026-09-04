# Privacy Policy

**Pure Pantry AI**
**Operated by:** Pure Hunger Labs
**Effective Date:** August 22, 2026
**Contact:** support@purehungerlabs.com

---

## 1. Information We Collect

### Information You Provide

When you use Pure Pantry AI, you may provide:

- **Pantry & food data:** Items, quantities, expiration dates, storage locations, categories
- **Recipes:** Ingredients, instructions, photos, tags, ratings
- **Shopping lists:** Items, quantities, stores, purchase history, budget data
- **Meal plans:** Planned meals, schedules, preferences
- **Family profiles:** Household size, children's ages, dietary preferences and restrictions
- **Account information:** If you sign in with Google or Apple, we receive your name and email address. Sign-in is optional.

### Information Collected Automatically

- **Analytics:** Firebase Analytics collects usage events (e.g., features used, screens viewed) in aggregate
- **Device information:** Device type, operating system version, app version

### Camera & Microphone

- **Camera:** Used for barcode scanning and recipe photos. Images are processed on-device or stored locally unless you explicitly share them.
- **Microphone:** Used for voice input in the cooking assistant. Audio is processed on-device for speech-to-text; transcribed text may be sent to cloud functions for AI processing.

---

## 2. How We Use Your Information

We use the information we collect to:

- Provide core app functionality: pantry tracking, recipe management, meal planning, and shopping lists
- Generate AI-powered meal plans and cooking assistance via cloud functions
- Look up product information via barcode scanning (Open Food Facts, UPC Item Database)
- Send push notifications you enable (expiry alerts, sharing events, reorder reminders, thaw reminders)
- Manage your subscription status
- Improve app stability and performance through analytics

---

## 3. Data Storage

### Local-First Architecture

Pure Pantry AI stores your data primarily on your device in a local SQLite database. Your data remains on your device unless you choose to use cloud features.

### Cloud Storage

If you sign in and use sharing features (e.g., family pantry sharing), your shared data is stored in Firebase Firestore (operated by Google). Only data relevant to shared pantries is synced to the cloud.

### Data Retention

Local data persists until you delete it or uninstall the app. Cloud data is retained until you request deletion or delete your account.

---

## 4. Third-Party Services

We use the following third-party services:

| Service | Purpose |
|---------|---------|
| **Firebase (Google)** | Authentication, Firestore database, Analytics, Cloud Functions, Push Notifications, Remote Config, App Check |
| **AWS Bedrock** | AI meal planning and cooking assistant (accessed via Firebase Cloud Functions; no direct user PII is sent — only recipe/pantry context needed for generation) |
| **Open Food Facts API** | Product nutrition and ingredient data lookup |
| **UPC Item Database** | Barcode-to-product lookup |
| **Apple App Store / Google Play** | Subscription and in-app purchase processing |

Each third-party service is governed by its own privacy policy. We encourage you to review them:

- [Firebase Privacy](https://firebase.google.com/support/privacy)
- [AWS Privacy](https://aws.amazon.com/privacy/)
- [Open Food Facts Privacy](https://world.openfoodfacts.org/privacy)

---

## 5. Data Sharing

We do **not** sell your data to third parties.

We do **not** share your data for advertising purposes.

Data is shared only in these circumstances:

- **User-initiated sharing:** When you invite family members to a shared pantry via invite codes, shared pantry data is accessible to invited members.
- **Third-party service providers:** As listed above, strictly for app functionality.
- **Legal requirements:** If required by law, regulation, or legal process.

---

## 6. Children's Privacy

Pure Pantry AI is not directed at children under 13. We do not knowingly collect personal information from children under 13. Family profiles may include children's ages for meal planning purposes, but this data is stored locally and controlled by the parent/guardian.

If you believe a child under 13 has provided personal information to us, please contact us at support@purehungerlabs.com.

---

## 7. Your Rights

### All Users

- **Delete local data:** You can delete any or all local data at any time through the app settings.
- **Delete cloud data:** If you use cloud/sharing features, you can request deletion of your cloud data by emailing support@purehungerlabs.com.
- **Delete account:** You can delete your account through the app or by contacting us.

### California Residents (CCPA)

If you are a California resident, you have the right to:

- Know what personal information we collect, use, and disclose
- Request deletion of your personal information
- Opt out of the sale of personal information (we do not sell personal information)
- Non-discrimination for exercising your privacy rights

To exercise these rights, contact us at support@purehungerlabs.com.

---

## 8. Security

We protect your data through:

- **HTTPS encryption** for all network communications
- **Firebase App Check** to verify authentic app instances
- **Device encryption** provided by your operating system for local data
- **Access controls** on cloud infrastructure

No method of transmission or storage is 100% secure. We cannot guarantee absolute security but take reasonable measures to protect your information.

---

## 9. Changes to This Policy

We may update this Privacy Policy from time to time. Changes will be reflected by an updated effective date. Continued use of the app after changes constitutes acceptance of the updated policy.

We encourage you to review this policy periodically.

---

## 10. Contact Us

If you have questions about this Privacy Policy, contact us at:

**Pure Hunger Labs**
Email: support@purehungerlabs.com
