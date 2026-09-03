import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/providers/database_providers.dart';
import 'features/premium/presentation/providers/purchase_providers.dart';
import 'features/settings/presentation/providers/settings_providers.dart';

class PurePantryApp extends ConsumerWidget {
  const PurePantryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    // Fire-and-forget: schedule thaw reminders on startup.
    ref.watch(thawReminderInitProvider);

    // Keeps premium in step with the server-owned entitlement doc, and retries
    // any purchase a previous session could not get verified.
    ref.watch(entitlementSyncProvider);

    return MaterialApp.router(
      title: 'Pure Pantry AI',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
