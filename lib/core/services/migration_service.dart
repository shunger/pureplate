import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import '../database/app_database.dart';

/// Handles migrating data from SmartShoppingScanner into PurePlate AI.
///
/// Uses raw sqlite3 to read the legacy database (avoids needing generated Drift
/// code for the legacy schema) and Drift's customInsert/customUpdate to write
/// into the new unified database.
class MigrationService {
  static const _scannerMigratedKey = 'migration_scanner_complete';

  final AppDatabase _db;

  MigrationService(this._db);

  /// Check if migration is needed from the legacy Scanner app.
  Future<MigrationStatus> checkMigrationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final scannerDone = prefs.getBool(_scannerMigratedKey) ?? false;

    final docsDir = await getApplicationDocumentsDirectory();
    final scannerDbPath =
        p.join(docsDir.path, 'smart_shopping_scanner.sqlite');

    final scannerDbExists = File(scannerDbPath).existsSync();

    return MigrationStatus(
      scannerMigrationNeeded: !scannerDone && scannerDbExists,
    );
  }

  /// Migrate data from SmartShoppingScanner.
  Future<MigrationResult> migrateFromScanner() async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final dbPath = p.join(docsDir.path, 'smart_shopping_scanner.sqlite');
      final dbFile = File(dbPath);

      if (!dbFile.existsSync()) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_scannerMigratedKey, true);
        return const MigrationResult(
            success: true, itemsMigrated: 0, errors: []);
      }

      final legacyDb =
          sqlite.sqlite3.open(dbPath, mode: sqlite.OpenMode.readOnly);

      int totalMigrated = 0;
      final errors = <String>[];

      // 1. Products
      totalMigrated += await _migrateTable(
        legacyDb: legacyDb,
        tableName: 'products',
        insertSql: 'INSERT OR REPLACE INTO products '
            '(id, barcode, plu_code, identifier_type, name, brand, description, '
            'price, currency, category, image_url, nutrition_info_json, '
            'ingredients_json, allergens_json, is_weight_based, unit_type, '
            'average_weight, seasonality_json, storage_instructions, '
            'ripeness_indicators_json, is_organic, is_gluten_free, is_vegan, '
            'is_custom, is_favorite, source, created_at, updated_at, last_looked_up) '
            'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        columnNames: [
          'id', 'barcode', 'plu_code', 'identifier_type', 'name', 'brand',
          'description', 'price', 'currency', 'category', 'image_url',
          'nutrition_info_json', 'ingredients_json', 'allergens_json',
          'is_weight_based', 'unit_type', 'average_weight', 'seasonality_json',
          'storage_instructions', 'ripeness_indicators_json', 'is_organic',
          'is_gluten_free', 'is_vegan', 'is_custom', 'is_favorite', 'source',
          'created_at', 'updated_at', 'last_looked_up',
        ],
        errors: errors,
      );

      // 2. Pantry Items
      totalMigrated += await _migrateTable(
        legacyDb: legacyDb,
        tableName: 'pantry_items',
        insertSql: 'INSERT OR REPLACE INTO pantry_items '
            '(id, product_id, name, category, quantity, unit_type, '
            'purchased_at, expires_at, location, notes, is_staple, '
            'reorder_threshold, is_bulk, purchase_price, status, '
            'firestore_pantry_id, firestore_item_id, created_at, updated_at) '
            'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        columnNames: [
          'id', 'product_id', 'name', 'category', 'quantity', 'unit_type',
          'purchased_at', 'expires_at', 'location', 'notes', 'is_staple',
          'reorder_threshold', 'is_bulk', 'purchase_price', 'status',
          'firestore_pantry_id', 'firestore_item_id', 'created_at', 'updated_at',
        ],
        errors: errors,
      );

      // 3. Shopping Lists
      totalMigrated += await _migrateTable(
        legacyDb: legacyDb,
        tableName: 'shopping_lists',
        insertSql: 'INSERT OR REPLACE INTO shopping_lists '
            '(id, name, store_id, store_name, store_type, created_at, '
            'updated_at, date_shopped, is_completed, is_active, is_archived, '
            'sort_order, firestore_id) '
            'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        columnNames: [
          'id', 'name', 'store_id', 'store_name', 'store_type', 'created_at',
          'updated_at', 'date_shopped', 'is_completed', 'is_active',
          'is_archived', 'sort_order', 'firestore_id',
        ],
        errors: errors,
      );

      // 4. Shopping List Items
      totalMigrated += await _migrateTable(
        legacyDb: legacyDb,
        tableName: 'shopping_list_items',
        insertSql: 'INSERT OR REPLACE INTO shopping_list_items '
            '(id, list_id, product_id, name, category, quantity, '
            'actual_price, sale_price, is_on_sale, is_completed, '
            'priority, notes, sort_order, added_at, updated_at) '
            'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        columnNames: [
          'id', 'list_id', 'product_id', 'name', 'category', 'quantity',
          'actual_price', 'sale_price', 'is_on_sale', 'is_completed',
          'priority', 'notes', 'sort_order', 'added_at', 'updated_at',
        ],
        errors: errors,
      );

      // 5. Purchase Histories
      totalMigrated += await _migrateTable(
        legacyDb: legacyDb,
        tableName: 'purchase_histories',
        insertSql: 'INSERT OR REPLACE INTO purchase_histories '
            '(id, barcode, product_name, brand, product_id, '
            'date_first_purchased, date_last_purchased) '
            'VALUES (?, ?, ?, ?, ?, ?, ?)',
        columnNames: [
          'id', 'barcode', 'product_name', 'brand', 'product_id',
          'date_first_purchased', 'date_last_purchased',
        ],
        errors: errors,
      );

      // 6. Purchase Records
      totalMigrated += await _migrateTable(
        legacyDb: legacyDb,
        tableName: 'purchase_records',
        insertSql: 'INSERT OR REPLACE INTO purchase_records '
            '(id, history_id, quantity, price, date_purchased, store_name, notes) '
            'VALUES (?, ?, ?, ?, ?, ?, ?)',
        columnNames: [
          'id', 'history_id', 'quantity', 'price', 'date_purchased',
          'store_name', 'notes',
        ],
        errors: errors,
      );

      // 7. Stores
      totalMigrated += await _migrateTable(
        legacyDb: legacyDb,
        tableName: 'stores',
        insertSql: 'INSERT OR REPLACE INTO stores '
            '(id, name, type, address, phone_number, website, is_active, '
            'preferred_currency, supports_tax_exempt, has_delivery, has_pickup, '
            'created_at, updated_at) '
            'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        columnNames: [
          'id', 'name', 'type', 'address', 'phone_number', 'website',
          'is_active', 'preferred_currency', 'supports_tax_exempt',
          'has_delivery', 'has_pickup', 'created_at', 'updated_at',
        ],
        errors: errors,
      );

      // 8. Store Aisles
      totalMigrated += await _migrateTable(
        legacyDb: legacyDb,
        tableName: 'store_aisles',
        insertSql: 'INSERT OR REPLACE INTO store_aisles '
            '(id, store_id, aisle_name, aisle_number, categories_json) '
            'VALUES (?, ?, ?, ?, ?)',
        columnNames: [
          'id', 'store_id', 'aisle_name', 'aisle_number', 'categories_json',
        ],
        errors: errors,
      );

      // 9. Produce Templates
      totalMigrated += await _migrateTable(
        legacyDb: legacyDb,
        tableName: 'produce_templates',
        insertSql: 'INSERT OR REPLACE INTO produce_templates '
            '(id, name, plu_code, category, unit_type, average_weight, '
            'avg_price_low, avg_price_high, seasonality_json, '
            'ripeness_indicators_json, storage_instructions, is_organic, is_built_in) '
            'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        columnNames: [
          'id', 'name', 'plu_code', 'category', 'unit_type', 'average_weight',
          'avg_price_low', 'avg_price_high', 'seasonality_json',
          'ripeness_indicators_json', 'storage_instructions', 'is_organic',
          'is_built_in',
        ],
        errors: errors,
      );

      // 10. Budgets
      totalMigrated += await _migrateTable(
        legacyDb: legacyDb,
        tableName: 'budgets',
        insertSql: 'INSERT OR REPLACE INTO budgets '
            '(id, period, amount, start_date, end_date, created_at) '
            'VALUES (?, ?, ?, ?, ?, ?)',
        columnNames: [
          'id', 'period', 'amount', 'start_date', 'end_date', 'created_at',
        ],
        errors: errors,
      );

      // 11. Budget Entries
      totalMigrated += await _migrateTable(
        legacyDb: legacyDb,
        tableName: 'budget_entries',
        insertSql: 'INSERT OR REPLACE INTO budget_entries '
            '(id, budget_id, list_id, amount, date) '
            'VALUES (?, ?, ?, ?, ?)',
        columnNames: [
          'id', 'budget_id', 'list_id', 'amount', 'date',
        ],
        errors: errors,
      );

      // 12. Activity Events
      totalMigrated += await _migrateTable(
        legacyDb: legacyDb,
        tableName: 'activity_events',
        insertSql: 'INSERT OR REPLACE INTO activity_events '
            '(id, type, source_type, source_id, source_name, actor_uid, '
            'actor_display_name, item_name, details_json, timestamp, is_read) '
            'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        columnNames: [
          'id', 'type', 'source_type', 'source_id', 'source_name', 'actor_uid',
          'actor_display_name', 'item_name', 'details_json', 'timestamp', 'is_read',
        ],
        errors: errors,
      );

      // 13. Scan History Entries
      totalMigrated += await _migrateTable(
        legacyDb: legacyDb,
        tableName: 'scan_history_entries',
        insertSql: 'INSERT OR REPLACE INTO scan_history_entries '
            '(id, barcode, scan_type, timestamp, confidence, product_id, error_message) '
            'VALUES (?, ?, ?, ?, ?, ?, ?)',
        columnNames: [
          'id', 'barcode', 'scan_type', 'timestamp', 'confidence',
          'product_id', 'error_message',
        ],
        errors: errors,
      );

      // 14. User Preferences (merge scanner-specific fields)
      try {
        final results =
            legacyDb.select('SELECT * FROM user_preferences_table LIMIT 1');
        if (results.isNotEmpty) {
          final row = results.first;
          await _db.customUpdate(
            'UPDATE user_preferences_table SET '
            'preferred_currency = ?, dietary_restrictions_json = ?, '
            'allergen_alerts_json = ?, scan_sound = ?, scan_sound_id = ?, '
            'haptic_feedback = ?, sync_enabled = ?, selected_list_id = ?, '
            'dismissed_hints_json = ?, notify_sharing_events = ?, '
            'notify_expiry_alerts = ?, notify_reorder_alerts = ?, '
            'theme = ?, language = ? '
            'WHERE id = 1',
            variables: _rowToVariables(row, [
              'preferred_currency', 'dietary_restrictions_json',
              'allergen_alerts_json', 'scan_sound', 'scan_sound_id',
              'haptic_feedback', 'sync_enabled', 'selected_list_id',
              'dismissed_hints_json', 'notify_sharing_events',
              'notify_expiry_alerts', 'notify_reorder_alerts',
              'theme', 'language',
            ]),
            updates: {},
          );
        }
      } catch (e) {
        errors.add('UserPreferences: $e');
      }

      legacyDb.dispose();

      // Mark migration complete.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_scannerMigratedKey, true);

      return MigrationResult(
        success: errors.isEmpty,
        itemsMigrated: totalMigrated,
        errors: errors,
      );
    } catch (e) {
      return MigrationResult(
        success: false,
        itemsMigrated: 0,
        errors: ['Scanner migration failed: $e'],
      );
    }
  }

  /// Generic table migration helper.
  ///
  /// Reads all rows from [tableName] in [legacyDb] and inserts into the new DB
  /// using [insertSql] with columns ordered by [columnNames].
  Future<int> _migrateTable({
    required sqlite.Database legacyDb,
    required String tableName,
    required String insertSql,
    required List<String> columnNames,
    required List<String> errors,
  }) async {
    try {
      final results = legacyDb.select('SELECT * FROM $tableName');
      for (final row in results) {
        await _db.customInsert(
          insertSql,
          variables: _rowToVariables(row, columnNames),
        );
      }
      return results.length;
    } catch (e) {
      errors.add('$tableName: $e');
      return 0;
    }
  }

  /// Convert a sqlite3 row to Drift Variable list, preserving types and nulls.
  List<Variable> _rowToVariables(
      sqlite.Row row, List<String> columnNames) {
    return columnNames.map((col) {
      final value = row[col];
      if (value == null) return const Variable(null);
      if (value is int) return Variable.withInt(value);
      if (value is double) return Variable.withReal(value);
      if (value is String) return Variable.withString(value);
      if (value is bool) return Variable.withBool(value);
      // sqlite3 package stores booleans as int 0/1.
      return Variable(value);
    }).toList();
  }
}

class MigrationStatus {
  final bool scannerMigrationNeeded;

  const MigrationStatus({
    required this.scannerMigrationNeeded,
  });

  bool get anyMigrationNeeded => scannerMigrationNeeded;
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
