import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/database_providers.dart';

// Re-export existing providers for convenience in settings screens.
// userPreferencesProvider and familyProfileProvider are already defined
// in database_providers.dart and can be used directly.

/// App version info (static for now).
final appVersionProvider = Provider<String>((ref) => '1.0.0');

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
