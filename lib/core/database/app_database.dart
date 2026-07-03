import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Tables.
import 'tables/products_table.dart';
import 'tables/pantry_items_table.dart';
import 'tables/shopping_lists_table.dart';
import 'tables/shopping_list_items_table.dart';
import 'tables/recipes_table.dart';
import 'tables/meal_plans_table.dart';
import 'tables/meal_plan_days_table.dart';
import 'tables/recipe_feedback_table.dart';
import 'tables/family_profiles_table.dart';
import 'tables/user_preferences_table.dart';
import 'tables/purchase_history_table.dart';
import 'tables/stores_table.dart';
import 'tables/produce_templates_table.dart';
import 'tables/budgets_table.dart';
import 'tables/activity_events_table.dart';
import 'tables/scan_history_table.dart';

// DAOs.
import 'daos/product_dao.dart';
import 'daos/pantry_dao.dart';
import 'daos/shopping_list_dao.dart';
import 'daos/recipe_dao.dart';
import 'daos/meal_plan_dao.dart';
import 'daos/family_profile_dao.dart';
import 'daos/feedback_dao.dart';
import 'daos/preferences_dao.dart';
import 'daos/purchase_history_dao.dart';
import 'daos/store_dao.dart';
import 'daos/budget_dao.dart';
import 'daos/scan_history_dao.dart';
import 'daos/activity_event_dao.dart';
import 'daos/produce_template_dao.dart';

part 'app_database.g.dart';

/// Unified PurePlate AI database — merges all tables from SmartShoppingScanner
/// and MealPlannerAI into a single schema.
///
/// 19 tables, 14 DAOs, schema version 1.
///
/// Tables by origin:
///   Scanner:  Products, PantryItems, ShoppingLists (enhanced),
///             ShoppingListItems (enhanced), PurchaseHistories, PurchaseRecords,
///             Stores, StoreAisles, ProduceTemplates, Budgets, BudgetEntries,
///             ActivityEvents, ScanHistoryEntries
///   Planner:  Recipes, MealPlans, MealPlanDays, RecipeFeedback, FamilyProfiles
///   Merged:   UserPreferencesTable (fields from both apps)
@DriftDatabase(
  tables: [
    // Product catalog & scanning.
    Products,
    ProduceTemplates,
    ScanHistoryEntries,

    // Pantry inventory — the core shared data model.
    PantryItems,

    // Shopping.
    ShoppingLists,
    ShoppingListItems,

    // Meal planning & recipes.
    Recipes,
    MealPlans,
    MealPlanDays,
    RecipeFeedback,

    // Family & preferences.
    FamilyProfiles,
    UserPreferencesTable,

    // Purchase tracking & budgets.
    PurchaseHistories,
    PurchaseRecords,
    Budgets,
    BudgetEntries,

    // Stores.
    Stores,
    StoreAisles,

    // Activity feed.
    ActivityEvents,
  ],
  daos: [
    ProductDao,
    PantryDao,
    ShoppingListDao,
    RecipeDao,
    MealPlanDao,
    FamilyProfileDao,
    FeedbackDao,
    PreferencesDao,
    PurchaseHistoryDao,
    StoreDao,
    BudgetDao,
    ScanHistoryDao,
    ActivityEventDao,
    ProduceTemplateDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For testing — accepts an in-memory executor.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();

          // Seed the default user preferences row.
          await into(userPreferencesTable)
              .insert(UserPreferencesTableCompanion.insert());
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Future schema migrations go here.
          // Example:
          // if (from < 2) {
          //   await m.addColumn(pantryItems, pantryItems.someNewColumn);
          // }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pure_plate.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
