import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

// ── Database singleton ────────────────────────────────────
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// ── DAO providers ─────────────────────────────────────────
final productDaoProvider = Provider((ref) => ref.watch(appDatabaseProvider).productDao);
final pantryDaoProvider = Provider((ref) => ref.watch(appDatabaseProvider).pantryDao);
final shoppingListDaoProvider = Provider((ref) => ref.watch(appDatabaseProvider).shoppingListDao);
final recipeDaoProvider = Provider((ref) => ref.watch(appDatabaseProvider).recipeDao);
final mealPlanDaoProvider = Provider((ref) => ref.watch(appDatabaseProvider).mealPlanDao);
final familyProfileDaoProvider = Provider((ref) => ref.watch(appDatabaseProvider).familyProfileDao);
final feedbackDaoProvider = Provider((ref) => ref.watch(appDatabaseProvider).feedbackDao);
final preferencesDaoProvider = Provider((ref) => ref.watch(appDatabaseProvider).preferencesDao);
final purchaseHistoryDaoProvider = Provider((ref) => ref.watch(appDatabaseProvider).purchaseHistoryDao);
final storeDaoProvider = Provider((ref) => ref.watch(appDatabaseProvider).storeDao);
final budgetDaoProvider = Provider((ref) => ref.watch(appDatabaseProvider).budgetDao);
final scanHistoryDaoProvider = Provider((ref) => ref.watch(appDatabaseProvider).scanHistoryDao);
final activityEventDaoProvider = Provider((ref) => ref.watch(appDatabaseProvider).activityEventDao);
final produceTemplateDaoProvider = Provider((ref) => ref.watch(appDatabaseProvider).produceTemplateDao);

// ── Reactive streams ──────────────────────────────────────
final userPreferencesProvider = StreamProvider((ref) =>
    ref.watch(preferencesDaoProvider).watchPreferences());

final pantryItemsProvider = StreamProvider((ref) =>
    ref.watch(pantryDaoProvider).watchAllItems());

final expiringItemsProvider = StreamProvider((ref) =>
    ref.watch(pantryDaoProvider).watchExpiringItems());

final allRecipesProvider = StreamProvider((ref) =>
    ref.watch(recipeDaoProvider).watchAllRecipes());

final activeShoppingListsProvider = StreamProvider((ref) =>
    ref.watch(shoppingListDaoProvider).watchActiveLists());

final allMealPlansProvider = StreamProvider((ref) =>
    ref.watch(mealPlanDaoProvider).watchAllPlans());

final familyProfileProvider = StreamProvider((ref) =>
    ref.watch(familyProfileDaoProvider).watchProfile());
