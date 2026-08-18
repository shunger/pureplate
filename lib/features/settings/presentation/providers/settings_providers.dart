import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/providers/database_providers.dart';
import '../../../../core/services/thaw_reminder_service.dart';

// Re-export existing providers for convenience in settings screens.
// userPreferencesProvider and familyProfileProvider are already defined
// in database_providers.dart and can be used directly.

/// App version info (static for now).
final appVersionProvider = Provider<String>((ref) => '1.1.0');

/// Derives [ThemeMode] from the stored theme preference string.
final themeModeProvider = Provider<ThemeMode>((ref) {
  final prefsAsync = ref.watch(userPreferencesProvider);
  return prefsAsync.when(
    data: (prefs) {
      switch (prefs.theme) {
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        default:
          return ThemeMode.system;
      }
    },
    loading: () => ThemeMode.system,
    error: (_, __) => ThemeMode.system,
  );
});

/// Whether the user has completed onboarding.
final onboardingCompletedProvider = Provider<AsyncValue<bool>>((ref) {
  final prefsAsync = ref.watch(userPreferencesProvider);
  return prefsAsync.whenData((prefs) => prefs.onboardingCompleted);
});

/// Whether the user is a premium subscriber.
final isPremiumProvider = Provider<AsyncValue<bool>>((ref) {
  final prefsAsync = ref.watch(userPreferencesProvider);
  return prefsAsync.whenData((prefs) => prefs.isPremium);
});

/// Thaw reminder preferences loaded from SharedPreferences.
class ThawReminderPrefs {
  final bool nightBeforeEnabled;
  final TimeOfDay nightBeforeTime;
  final bool morningOfEnabled;
  final TimeOfDay morningOfTime;

  const ThawReminderPrefs({
    this.nightBeforeEnabled = true,
    this.nightBeforeTime = const TimeOfDay(hour: 20, minute: 0),
    this.morningOfEnabled = true,
    this.morningOfTime = const TimeOfDay(hour: 7, minute: 0),
  });
}

final thawReminderPrefsProvider = FutureProvider<ThawReminderPrefs>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return ThawReminderPrefs(
    nightBeforeEnabled:
        prefs.getBool(ThawReminderService.keyNightBeforeEnabled) ?? true,
    nightBeforeTime: TimeOfDay(
      hour: prefs.getInt(ThawReminderService.keyNightBeforeHour) ??
          ThawReminderService.defaultNightBeforeHour,
      minute: prefs.getInt(ThawReminderService.keyNightBeforeMinute) ??
          ThawReminderService.defaultNightBeforeMinute,
    ),
    morningOfEnabled:
        prefs.getBool(ThawReminderService.keyMorningOfEnabled) ?? true,
    morningOfTime: TimeOfDay(
      hour: prefs.getInt(ThawReminderService.keyMorningOfHour) ??
          ThawReminderService.defaultMorningOfHour,
      minute: prefs.getInt(ThawReminderService.keyMorningOfMinute) ??
          ThawReminderService.defaultMorningOfMinute,
    ),
  );
});
