import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/database_providers.dart';

// Re-export existing providers for convenience in settings screens.
// userPreferencesProvider and familyProfileProvider are already defined
// in database_providers.dart and can be used directly.

/// App version info (static for now).
final appVersionProvider = Provider<String>((ref) => '1.0.0');

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
