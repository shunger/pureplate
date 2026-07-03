import 'package:drift/drift.dart';

/// UserPreferences — merged singleton from both apps.
/// Scanner: currency, scanning, notifications, sharing prefs.
/// Meal Planner: onboarding, premium, voice, plan quota.
class UserPreferencesTable extends Table {
  // Singleton — always ID 1.
  IntColumn get id => integer().withDefault(const Constant(1))();

  // ── From SmartShoppingScanner ──────────────────────────
  TextColumn get preferredCurrency => text().withDefault(const Constant('USD'))();
  TextColumn get dietaryRestrictionsJson => text().withDefault(const Constant('[]'))();
  TextColumn get allergenAlertsJson => text().withDefault(const Constant('[]'))();
  BoolColumn get autoAddToList => boolean().withDefault(const Constant(false))();
  IntColumn get defaultQuantity => integer().withDefault(const Constant(1))();

  // Scanner behavior.
  BoolColumn get scanSound => boolean().withDefault(const Constant(true))();
  IntColumn get scanSoundId => integer().withDefault(const Constant(1108))();
  BoolColumn get hapticFeedback => boolean().withDefault(const Constant(true))();

  // Selected shopping list.
  TextColumn get selectedListId => text().nullable()();
  TextColumn get dismissedHintsJson => text().withDefault(const Constant('[]'))();

  // Sync.
  BoolColumn get syncEnabled => boolean().withDefault(const Constant(false))();

  // ── From MealPlannerAI ─────────────────────────────────
  BoolColumn get onboardingCompleted => boolean().withDefault(const Constant(false))();

  // Plan quota (free tier).
  IntColumn get weeklyPlanCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get weeklyPlanResetDate => dateTime().nullable()();

  // Premium subscription.
  BoolColumn get isPremium => boolean().withDefault(const Constant(false))();
  TextColumn get subscriptionId => text().nullable()();
  TextColumn get subscriptionPlan => text().nullable()();
  DateTimeColumn get subscriptionExpiresAt => dateTime().nullable()();

  // Cooking mode.
  TextColumn get voicePersona => text().nullable()();

  // Default meal type: 'dinner', 'breakfast', 'lunch'.
  TextColumn get mealType => text().withDefault(const Constant('dinner'))();

  // Cross-app sharing IDs.
  TextColumn get sharedListId => text().nullable()();
  TextColumn get sharedPantryId => text().nullable()();

  // ── Shared fields ──────────────────────────────────────
  BoolColumn get enableNotifications => boolean().withDefault(const Constant(true))();
  BoolColumn get notifySharingEvents => boolean().withDefault(const Constant(true))();
  BoolColumn get notifyExpiryAlerts => boolean().withDefault(const Constant(true))();
  BoolColumn get notifyReorderAlerts => boolean().withDefault(const Constant(true))();
  TextColumn get theme => text().withDefault(const Constant('system'))();
  TextColumn get language => text().withDefault(const Constant('en'))();

  @override
  Set<Column> get primaryKey => {id};
}
