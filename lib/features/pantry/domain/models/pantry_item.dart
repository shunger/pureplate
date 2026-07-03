import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/models/product_category.dart';

part 'pantry_item.freezed.dart';
part 'pantry_item.g.dart';

/// Storage location within the home.
enum PantryLocation {
  pantry('Pantry'),
  fridge('Fridge'),
  freezer('Freezer');

  final String displayName;
  const PantryLocation(this.displayName);
}

/// Expiry status derived from [expiresAt].
enum ExpiryStatus { fresh, expiringSoon, expired, unknown }

/// Unified pantry item — the single source of truth for "what's in the house."
///
/// Used by:
/// - Pantry screen (display, edit)
/// - AI meal planner (ingredient availability)
/// - Auto shopping list (diff against recipe needs)
/// - Expiry notifications
@freezed
class PantryItem with _$PantryItem {
  const PantryItem._();

  const factory PantryItem({
    required String id,

    /// Foreign key to Product table (nullable for manually-added items).
    String? productId,

    required String name,
    String? brand,
    @Default(ProductCategory.other) ProductCategory category,

    /// Quantity and unit (e.g., 2 lbs, 3 count).
    @Default(1) double quantity,
    @Default('count') String unitType,

    /// Location in the home.
    @Default(PantryLocation.pantry) PantryLocation location,

    /// Dates.
    DateTime? purchasedAt,
    DateTime? expiresAt,

    /// Smart inventory flags.
    @Default(false) bool isStaple,
    @Default(0) double reorderThreshold,
    @Default(false) bool isBulk,
    double? purchasePrice,

    /// User notes.
    String? notes,
    String? imageUrl,

    /// Sharing / sync fields.
    String? firestorePantryId,
    String? firestoreItemId,

    /// Timestamps.
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _PantryItem;

  factory PantryItem.fromJson(Map<String, dynamic> json) =>
      _$PantryItemFromJson(json);

  /// Days until expiry (null if no expiry date set).
  int? get daysUntilExpiry {
    if (expiresAt == null) return null;
    return expiresAt!.difference(DateTime.now()).inDays;
  }

  /// Computed expiry status.
  ExpiryStatus get expiryStatus {
    final days = daysUntilExpiry;
    if (days == null) return ExpiryStatus.unknown;
    if (days < 0) return ExpiryStatus.expired;
    if (days <= 3) return ExpiryStatus.expiringSoon;
    return ExpiryStatus.fresh;
  }

  /// Whether this item needs reordering (staple below threshold).
  bool get needsReorder => isStaple && quantity <= reorderThreshold;

  /// Simplified representation for AI prompt context.
  Map<String, dynamic> toAiContext() => {
        'name': name,
        'quantity': quantity,
        'unit': unitType,
        'category': category.name,
        if (expiresAt != null) 'expires_in_days': daysUntilExpiry,
        if (isStaple) 'is_staple': true,
      };
}
