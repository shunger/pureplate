import 'package:shared_preferences/shared_preferences.dart';

/// Handles migrating data from the two legacy apps into PurePlate AI.
///
/// Migration strategy:
/// 1. Detect if either legacy app's local database exists on device.
/// 2. Import data in priority order:
///    a. SmartShoppingScanner → pantry items, products, shopping lists, purchase history
///    b. MealPlannerAI → recipes, meal plans, family profile, feedback
/// 3. Mark migration as complete to avoid re-import.
/// 4. Merge conflicts: if both apps have overlapping data (e.g., shared Firestore
///    pantry), prefer Scanner's data (more structured) and supplement with
///    Meal Planner's AI-generated content.
class MigrationService {
  static const _scannerMigratedKey = 'migration_scanner_complete';
  static const _mealPlannerMigratedKey = 'migration_meal_planner_complete';

  /// Check if migration is needed from either legacy app.
  Future<MigrationStatus> checkMigrationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final scannerDone = prefs.getBool(_scannerMigratedKey) ?? false;
    final mealPlannerDone = prefs.getBool(_mealPlannerMigratedKey) ?? false;

    // TODO: Also check if legacy database files exist on disk.
    // final scannerDbExists = await _checkDatabaseFile('smart_shopping_scanner.db');
    // final mealPlannerDbExists = await _checkDatabaseFile('meal_planner.db');

    return MigrationStatus(
      scannerMigrationNeeded: !scannerDone,
      mealPlannerMigrationNeeded: !mealPlannerDone,
    );
  }

  /// Migrate data from SmartShoppingScanner.
  ///
  /// Imports:
  /// - Products (with barcode, nutrition, allergens)
  /// - PantryItems (with expiry dates, locations, quantities)
  /// - ShoppingLists + items (with pricing, store associations)
  /// - PurchaseHistory (price trends)
  /// - UserPreferences (dietary, notification settings)
  /// - Budget data
  Future<MigrationResult> migrateFromScanner() async {
    try {
      // TODO: Implementation steps:
      // 1. Open legacy Drift database (schema version 12).
      // 2. Read all tables using legacy DAOs or raw SQL.
      // 3. Map legacy models to new unified models.
      // 4. Insert into new database with upsert (handle duplicates).
      // 5. Preserve Firestore IDs for shared lists/pantries (continuity).
      // 6. Mark migration complete.

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_scannerMigratedKey, true);

      return const MigrationResult(
        success: true,
        itemsMigrated: 0,
        errors: [],
      );
    } catch (e) {
      return MigrationResult(
        success: false,
        itemsMigrated: 0,
        errors: ['Scanner migration failed: $e'],
      );
    }
  }

  /// Migrate data from MealPlannerAI.
  ///
  /// Imports:
  /// - FamilyProfile (dietary restrictions, cuisine preferences)
  /// - Recipes (bundled + AI-generated)
  /// - MealPlans + days
  /// - RecipeFeedback (loved/disliked/favorite)
  /// - UserPreferences (premium status, notification settings)
  Future<MigrationResult> migrateFromMealPlanner() async {
    try {
      // TODO: Implementation steps:
      // 1. Open legacy Drift database.
      // 2. Read FamilyProfile, Recipes, MealPlans, Feedback.
      // 3. Map to new unified models.
      // 4. Merge FamilyProfile with Scanner's UserPreferences.
      // 5. Import recipes (skip bundled duplicates by name).
      // 6. Preserve AI metadata for learning continuity.
      // 7. Mark migration complete.

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_mealPlannerMigratedKey, true);

      return const MigrationResult(
        success: true,
        itemsMigrated: 0,
        errors: [],
      );
    } catch (e) {
      return MigrationResult(
        success: false,
        itemsMigrated: 0,
        errors: ['Meal Planner migration failed: $e'],
      );
    }
  }
}

class MigrationStatus {
  final bool scannerMigrationNeeded;
  final bool mealPlannerMigrationNeeded;

  const MigrationStatus({
    required this.scannerMigrationNeeded,
    required this.mealPlannerMigrationNeeded,
  });

  bool get anyMigrationNeeded =>
      scannerMigrationNeeded || mealPlannerMigrationNeeded;
}

class MigrationResult {
  final bool success;
  final int itemsMigrated;
  final List<String> errors;

  const MigrationResult({
    required this.success,
    required this.itemsMigrated,
    required this.errors,
  });
}
