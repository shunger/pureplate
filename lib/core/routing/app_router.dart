import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'route_names.dart';
import 'navigation_shell.dart';

// Feature screen imports — uncomment as screens are implemented.
// import '../../features/splash/presentation/splash_screen.dart';
// import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/pantry/presentation/screens/pantry_screen.dart';
// import '../../features/meal_plan/presentation/screens/planner_screen.dart';
// import '../../features/shopping_list/presentation/screens/shopping_list_screen.dart';
// import '../../features/scanner/presentation/screens/scanner_screen.dart';
// import '../../features/recipes/presentation/screens/recipe_detail_screen.dart';
// import '../../features/cooking/presentation/screens/cooking_mode_screen.dart';
// import '../../features/settings/presentation/screens/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.home,
    debugLogDiagnostics: true,
    routes: [
      // Splash
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const _Placeholder('Splash'),
      ),

      // Onboarding flow (no bottom nav)
      GoRoute(
        path: Routes.onboardingWelcome,
        builder: (context, state) => const _Placeholder('Welcome'),
      ),
      GoRoute(
        path: Routes.onboardingFamily,
        builder: (context, state) => const _Placeholder('Family Setup'),
      ),
      GoRoute(
        path: Routes.onboardingDietary,
        builder: (context, state) => const _Placeholder('Dietary Prefs'),
      ),
      GoRoute(
        path: Routes.onboardingCooking,
        builder: (context, state) => const _Placeholder('Cooking Style'),
      ),

      // Main app shell with bottom navigation
      ShellRoute(
        builder: (context, state, child) =>
            NavigationShell(state: state, child: child),
        routes: [
          GoRoute(
            path: Routes.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _Placeholder('Home Dashboard'),
            ),
          ),
          GoRoute(
            path: Routes.pantry,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PantryScreen(),
            ),
            routes: [
              GoRoute(
                path: 'item/:id',
                builder: (context, state) => _Placeholder(
                    'Pantry Item ${state.pathParameters['id']}'),
              ),
              GoRoute(
                path: 'add',
                builder: (context, state) =>
                    const _Placeholder('Add Pantry Item'),
              ),
            ],
          ),
          GoRoute(
            path: Routes.planner,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _Placeholder('Meal Planner'),
            ),
          ),
          GoRoute(
            path: Routes.lists,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _Placeholder('Shopping Lists'),
            ),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => _Placeholder(
                    'List ${state.pathParameters['id']}'),
              ),
            ],
          ),
        ],
      ),

      // Full-screen routes (no bottom nav)
      GoRoute(
        path: Routes.scanner,
        builder: (context, state) => const _Placeholder('Barcode Scanner'),
      ),
      GoRoute(
        path: Routes.recipes,
        builder: (context, state) => const _Placeholder('Recipe Browser'),
      ),
      GoRoute(
        path: Routes.recipeDetail,
        builder: (context, state) =>
            _Placeholder('Recipe ${state.pathParameters['id']}'),
      ),
      GoRoute(
        path: Routes.cookingMode,
        builder: (context, state) =>
            _Placeholder('Cooking ${state.pathParameters['recipeId']}'),
      ),
      GoRoute(
        path: Routes.planGeneration,
        builder: (context, state) =>
            const _Placeholder('Generate Plan'),
      ),
      GoRoute(
        path: Routes.chat,
        builder: (context, state) => const _Placeholder('Chat Planning'),
      ),
      GoRoute(
        path: Routes.inventorySuggestions,
        builder: (context, state) =>
            const _Placeholder('Inventory Suggestions'),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const _Placeholder('Settings'),
      ),
      GoRoute(
        path: Routes.profileEdit,
        builder: (context, state) => const _Placeholder('Edit Profile'),
      ),
      GoRoute(
        path: Routes.premium,
        builder: (context, state) => const _Placeholder('Premium'),
      ),
    ],
  );
});

/// Temporary placeholder widget — replace with real screens as they're ported.
class _Placeholder extends StatelessWidget {
  final String label;
  const _Placeholder(this.label);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(
        child: Text(label, style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
