import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/user_preferences_table.dart';

part 'preferences_dao.g.dart';

@DriftAccessor(tables: [UserPreferencesTable])
class PreferencesDao extends DatabaseAccessor<AppDatabase>
    with _$PreferencesDaoMixin {
  PreferencesDao(super.db);

  /// Get preferences, creating default row if missing.
  Future<UserPreferencesTableData> getPreferences() async {
    final existing =
        await (select(userPreferencesTable)..where((p) => p.id.equals(1)))
            .getSingleOrNull();
    if (existing != null) return existing;

    await into(userPreferencesTable)
        .insert(UserPreferencesTableCompanion.insert());
    return (select(userPreferencesTable)..where((p) => p.id.equals(1)))
        .getSingle();
  }

  Stream<UserPreferencesTableData> watchPreferences() =>
      (select(userPreferencesTable)..where((p) => p.id.equals(1)))
          .watchSingle();

  Future<void> updatePreferences(UserPreferencesTableCompanion prefs) =>
      (update(userPreferencesTable)..where((p) => p.id.equals(1)))
          .write(prefs);

  // ── Convenience setters ─────────────────────────────────

  Future<void> setOnboardingCompleted(bool completed) =>
      updatePreferences(
          UserPreferencesTableCompanion(onboardingCompleted: Value(completed)));

  Future<void> setCurrency(String currency) =>
      updatePreferences(
          UserPreferencesTableCompanion(preferredCurrency: Value(currency)));

  Future<void> setTheme(String theme) =>
      updatePreferences(UserPreferencesTableCompanion(theme: Value(theme)));

  Future<void> setLanguage(String language) =>
      updatePreferences(
          UserPreferencesTableCompanion(language: Value(language)));

  Future<void> setSyncEnabled(bool enabled) =>
      updatePreferences(
          UserPreferencesTableCompanion(syncEnabled: Value(enabled)));

  Future<void> setSelectedListId(String? listId) =>
      updatePreferences(
          UserPreferencesTableCompanion(selectedListId: Value(listId)));

  Future<void> setDietaryRestrictions(String json) =>
      updatePreferences(
          UserPreferencesTableCompanion(dietaryRestrictionsJson: Value(json)));

  Future<void> setAllergenAlerts(String json) =>
      updatePreferences(
          UserPreferencesTableCompanion(allergenAlertsJson: Value(json)));

  Future<void> setScanSound(bool enabled) =>
      updatePreferences(
          UserPreferencesTableCompanion(scanSound: Value(enabled)));

  Future<void> setHapticFeedback(bool enabled) =>
      updatePreferences(
          UserPreferencesTableCompanion(hapticFeedback: Value(enabled)));

  // ── Notification toggles ────────────────────────────────

  Future<void> setNotifySharingEvents(bool enabled) =>
      updatePreferences(
          UserPreferencesTableCompanion(notifySharingEvents: Value(enabled)));

  Future<void> setNotifyExpiryAlerts(bool enabled) =>
      updatePreferences(
          UserPreferencesTableCompanion(notifyExpiryAlerts: Value(enabled)));

  Future<void> setNotifyReorderAlerts(bool enabled) =>
      updatePreferences(
          UserPreferencesTableCompanion(notifyReorderAlerts: Value(enabled)));

  // ── Premium / plan quota ────────────────────────────────

  Future<void> setPremium(bool isPremium) =>
      updatePreferences(
          UserPreferencesTableCompanion(isPremium: Value(isPremium)));

  Future<void> setSubscription({
    required String? subscriptionId,
    required String? plan,
    required DateTime? expiresAt,
  }) =>
      updatePreferences(UserPreferencesTableCompanion(
        isPremium: Value(expiresAt != null && expiresAt.isAfter(DateTime.now())),
        subscriptionId: Value(subscriptionId),
        subscriptionPlan: Value(plan),
        subscriptionExpiresAt: Value(expiresAt),
      ));

  Future<void> incrementWeeklyPlanCount() async {
    final prefs = await getPreferences();
    final now = DateTime.now();

    // Reset counter if past the reset date.
    if (prefs.weeklyPlanResetDate != null &&
        now.isAfter(prefs.weeklyPlanResetDate!)) {
      await updatePreferences(UserPreferencesTableCompanion(
        weeklyPlanCount: const Value(1),
        weeklyPlanResetDate:
            Value(now.add(const Duration(days: 7))),
      ));
    } else {
      await updatePreferences(UserPreferencesTableCompanion(
        weeklyPlanCount: Value(prefs.weeklyPlanCount + 1),
        weeklyPlanResetDate: prefs.weeklyPlanResetDate == null
            ? Value(now.add(const Duration(days: 7)))
            : const Value.absent(),
      ));
    }
  }

  Future<void> setVoicePersona(String? persona) =>
      updatePreferences(
          UserPreferencesTableCompanion(voicePersona: Value(persona)));

  Future<void> setSharedListId(String? listId) =>
      updatePreferences(
          UserPreferencesTableCompanion(sharedListId: Value(listId)));

  Future<void> setSharedPantryId(String? pantryId) =>
      updatePreferences(
          UserPreferencesTableCompanion(sharedPantryId: Value(pantryId)));

  /// Dismiss a UI hint.
  Future<void> dismissHint(String hintKey) async {
    final prefs = await getPreferences();
    final current = prefs.dismissedHintsJson;
    if (!current.contains(hintKey)) {
      final updated = current == '[]'
          ? '["$hintKey"]'
          : '${current.substring(0, current.length - 1)},"$hintKey"]';
      await updatePreferences(
          UserPreferencesTableCompanion(dismissedHintsJson: Value(updated)));
    }
  }
}
