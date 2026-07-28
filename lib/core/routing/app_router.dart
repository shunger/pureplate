import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'route_names.dart';
import 'navigation_shell.dart';

// Feature screen imports.
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/pantry/presentation/screens/pantry_screen.dart';
import '../../features/pantry/presentation/screens/pantry_item_detail_screen.dart';
import '../../features/pantry/presentation/widgets/add_pantry_item_sheet.dart';
import '../../features/meal_plan/presentation/screens/planner_screen.dart';
import '../../features/meal_plan/presentation/screens/plan_generation_screen.dart';
import '../../features/meal_plan/presentation/screens/chat_planning_screen.dart';
import '../../features/meal_plan/presentation/screens/inventory_suggestions_screen.dart';
import '../../features/shopping_list/presentation/screens/shopping_lists_screen.dart';
import '../../features/shopping_list/presentation/screens/shopping_list_detail_screen.dart';
import '../../features/scanner/presentation/screens/scanner_screen.dart';
import '../../features/recipes/presentation/screens/recipe_browser_screen.dart';
import '../../features/recipes/presentation/screens/recipe_detail_screen.dart';
import '../../features/recipes/presentation/screens/cooking_mode_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/settings/presentation/screens/profile_edit_screen.dart';
import '../../features/premium/presentation/screens/premium_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_welcome_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_family_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_dietary_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_cooking_screen.dart';
import '../../features/sharing/presentation/screens/collaborators_screen.dart';
import '../../features/sharing/presentation/screens/activity_feed_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding flow (no bottom nav)
      GoRoute(
        path: Routes.onboardingWelcome,
        builder: (context, state) => const OnboardingWelcomeScreen(),
      ),
      GoRoute(
        path: Routes.onboardingFamily,
        builder: (context, state) => const OnboardingFamilyScreen(),
      ),
      GoRoute(
        path: Routes.onboardingDietary,
        builder: (context, state) => const OnboardingDietaryScreen(),
      ),
      GoRoute(
        path: Routes.onboardingCooking,
        builder: (context, state) => const OnboardingCookingScreen(),
      ),

      // Main app shell with bottom navigation
      ShellRoute(
        builder: (context, state, child) =>
            NavigationShell(state: state, child: child),
        routes: [
          GoRoute(
            path: Routes.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
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
                builder: (context, state) => PantryItemDetailScreen(
                    itemId: state.pathParameters['id']!),
              ),
              GoRoute(
                path: 'add',
                builder: (context, state) => Scaffold(
                  backgroundColor: const Color(0xFFFFF8F0),
                  appBar: AppBar(title: const Text('Add to Pantry')),
                  body: const AddPantryItemSheet(),
                ),
              ),
            ],
          ),
          GoRoute(
            path: Routes.planner,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PlannerScreen(),
            ),
          ),
          GoRoute(
            path: Routes.chatTab,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ChatPlanningScreen(),
            ),
          ),
          GoRoute(
            path: Routes.lists,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ShoppingListsScreen(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => ShoppingListDetailScreen(
                    listId: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: Routes.scanner,
            builder: (context, state) => const ScannerScreen(),
          ),
        ],
      ),

      // Full-screen routes (no bottom nav)
      GoRoute(
        path: Routes.recipes,
        builder: (context, state) => const RecipeBrowserScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) =>
                RecipeDetailScreen(recipeId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: Routes.cookingMode,
        builder: (context, state) =>
            CookingModeScreen(recipeId: state.pathParameters['recipeId']!),
      ),
      GoRoute(
        path: Routes.planGeneration,
        builder: (context, state) => const PlanGenerationScreen(),
      ),
      GoRoute(
        path: Routes.chat,
        builder: (context, state) => ChatPlanningScreen(
          mode: state.uri.queryParameters['mode'],
          prefsParam: state.uri.queryParameters['prefs'],
        ),
      ),
      GoRoute(
        path: Routes.inventorySuggestions,
        builder: (context, state) => const InventorySuggestionsScreen(),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.profileEdit,
        builder: (context, state) => const ProfileEditScreen(),
      ),
      GoRoute(
        path: Routes.premium,
        builder: (context, state) => const PremiumScreen(),
      ),
      GoRoute(
        path: Routes.collaborators,
        builder: (context, state) => CollaboratorsScreen(
            firestoreId: state.pathParameters['firestoreId']!),
      ),
      GoRoute(
        path: Routes.activityFeed,
        builder: (context, state) => const ActivityFeedScreen(),
      ),
    ],
  );
});
