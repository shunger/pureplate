import 'package:drift/drift.dart';
import 'shopping_lists_table.dart';
import 'products_table.dart';

/// ShoppingListItems — merged from both apps.
/// Supports both barcode-scanned items (productId FK) and
/// AI-generated ingredient items (name + recipeId).
class ShoppingListItems extends Table {
  TextColumn get id => text()();
  TextColumn get listId => text().references(ShoppingLists, #id)();

  // Product link (for scanned items).
  TextColumn get productId => text().nullable().references(Products, #id)();

  // Direct name (for AI-generated or manual items without a product).
  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();

  TextColumn get category => text().withDefault(const Constant('other'))();
  RealColumn get quantity => real().withDefault(const Constant(1.0))();
  TextColumn get unitType => text().withDefault(const Constant('count'))();

  // Pricing (from Scanner).
  RealColumn get estimatedPrice => real().nullable()();
  RealColumn get actualPrice => real().nullable()();
  RealColumn get salePrice => real().nullable()();
  BoolColumn get isOnSale => boolean().withDefault(const Constant(false))();

  // Status.
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get priority => text().withDefault(const Constant('normal'))();
  TextColumn get notes => text().nullable()();

  // Meal plan recipe link (from Meal Planner).
  TextColumn get recipeId => text().nullable()();
  TextColumn get recipeName => text().nullable()();

  // Pantry deduction — how much of this item is already in the pantry.
  RealColumn get pantryQuantityAvailable => real().withDefault(const Constant(0.0))();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  // Timestamps.
  DateTimeColumn get addedAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
