import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../../core/services/bundled_recipe_service.dart';
import '../../../../core/services/migration_service.dart';
import '../../../pantry/data/datasources/pantry_sync_orchestrator.dart';
import '../../../shopping_list/data/datasources/shopping_list_sync_orchestrator.dart';

/// Splash screen — app logo, brief fade-in animation, then navigate to
/// Home (if onboarding completed) or Onboarding Welcome.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  bool _reduceMotionChecked = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    // Animation is started in didChangeDependencies after reduce-motion check.
    _navigateAfterDelay();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_reduceMotionChecked) {
      _reduceMotionChecked = true;
      final reduceMotion = MediaQuery.of(context).disableAnimations;
      if (reduceMotion) {
        // Skip fade-in; show content immediately.
        _controller.value = 1.0;
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    try {
      // Run data migration from legacy Scanner app (one-time, local SQLite to SQLite).
      final db = ref.read(appDatabaseProvider);
      final migrationService = MigrationService(db);
      final status = await migrationService.checkMigrationStatus();

      if (status.scannerMigrationNeeded) {
        await migrationService.migrateFromScanner();
      }

      // Seed bundled recipes on first launch.
      final recipeDao = ref.read(recipeDaoProvider);
      await BundledRecipeService(recipeDao).loadIfNeeded();

      // Eagerly read the sync orchestrators so their auth listeners start
      // observing — sync begins automatically when authenticated, and lists
      // shared with this user appear without them sharing one first.
      ref.read(pantrySyncOrchestratorProvider);
      ref.read(shoppingListSyncOrchestratorProvider);

      if (!mounted) return;

      final prefsDao = ref.read(preferencesDaoProvider);
      final prefs = await prefsDao.getPreferences();

      if (!mounted) return;

      if (prefs.onboardingCompleted) {
        context.go(Routes.home);
      } else {
        context.go(Routes.onboardingWelcome);
      }
    } catch (_) {
      // If DB fails, go to home anyway
      if (mounted) context.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.coral, AppColors.coralDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.coral.withValues(alpha: 0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.restaurant_menu,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Pure Pantry AI',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
