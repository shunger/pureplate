import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/models/product_category.dart';

part 'shopping_list.freezed.dart';
part 'shopping_list.g.dart';

/// Source of a shopping list — manually created or auto-generated from a meal plan.
enum ShoppingListSource { manual, mealPlan }

@freezed
class ShoppingListItem with _$ShoppingListItem {
  const ShoppingListItem._();

  const factory ShoppingListItem({
    required String id,
    required String listId,

    /// Link to Product table if from barcode scan.
    String? productId,

    required String name,
    String? brand,
    @Default(ProductCategory.other) ProductCategory category,
    @Default(1) double quantity,
    @Default('count') String unitType,

    /// Pricing.
    double? estimatedPrice,
    double? actualPrice,
    double? salePrice,
    @Default(false) bool isOnSale,

    /// Status.
    @Default(false) bool isCompleted,
    @Default(0) int priority,
    String? notes,

    /// AI meal plan link — which recipe needs this item.
    String? recipeId,
    String? recipeName,

    /// Whether pantry already has this (partial coverage).
    @Default(0) double pantryQuantityAvailable,

    /// Timestamps.
    required DateTime addedAt,
    DateTime? updatedAt,
    @Default(0) int sortOrder,
  }) = _ShoppingListItem;

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListItemFromJson(json);

  /// Net quantity needed after pantry deduction.
  double get quantityNeeded =>
      (quantity - pantryQuantityAvailable).clamp(0, double.infinity);
}

@freezed
class ShoppingList with _$ShoppingList {
  const ShoppingList._();

  const factory ShoppingList({
    required String id,
    required String name,
    @Default([]) List<ShoppingListItem> items,

    /// Store association.
    String? storeId,
    String? storeName,

    /// Source tracking.
    @Default(ShoppingListSource.manual) ShoppingListSource source,

    /// If auto-generated, which meal plan produced this.
    String? mealPlanId,

    /// Status.
    @Default(true) bool isActive,
    @Default(false) bool isCompleted,
    @Default(false) bool isArchived,

    /// Sharing.
    String? firestoreId,

    /// Timestamps.
    required DateTime createdAt,
    DateTime? dateShopped,
    @Default(0) int sortOrder,
  }) = _ShoppingList;

  factory ShoppingList.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListFromJson(json);

  double get totalEstimatedCost => items.fold(
      0, (sum, item) => sum + (item.estimatedPrice ?? 0) * item.quantity);

  int get completedItemCount => items.where((i) => i.isCompleted).length;

  double get completionPercent =>
      items.isEmpty ? 0 : completedItemCount / items.length;

  /// Items grouped by category for display.
  Map<ProductCategory, List<ShoppingListItem>> get itemsByCategory {
    final grouped = <ProductCategory, List<ShoppingListItem>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }
    return grouped;
  }
}
