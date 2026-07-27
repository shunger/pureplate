import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/providers/database_providers.dart';
import 'features/settings/presentation/providers/settings_providers.dart';

class PurePantryApp extends ConsumerWidget {
  const PurePantryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    // Fire-and-forget: schedule thaw reminders on startup.
    ref.watch(thawReminderInitProvider);

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
