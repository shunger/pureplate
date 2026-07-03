/// Priority levels for shopping list items.
///
/// Bridges the DB TEXT column ('normal', 'low', 'high', 'urgent')
/// and the domain model's int priority field (0-3).
enum ItemPriority {
  normal,
  low,
  high,
  urgent;

  /// Numeric sort value matching the domain model's `priority` int field.
  int get sortValue => switch (this) {
        ItemPriority.normal => 0,
        ItemPriority.low => 1,
        ItemPriority.high => 2,
        ItemPriority.urgent => 3,
      };

  /// Text value stored in the Drift DB column.
  String get dbValue => name;

  /// Human-readable label for UI display.
  String get displayName => switch (this) {
        ItemPriority.normal => 'Normal',
        ItemPriority.low => 'Low',
        ItemPriority.high => 'High',
        ItemPriority.urgent => 'Urgent',
      };

  /// Parse a DB text value back to the enum. Defaults to [normal].
  static ItemPriority fromDb(String? value) {
    if (value == null) return ItemPriority.normal;
    return ItemPriority.values.asNameMap()[value] ?? ItemPriority.normal;
  }

  /// Convert an int priority value to the enum. Defaults to [normal].
  static ItemPriority fromInt(int value) => switch (value) {
        1 => ItemPriority.low,
        2 => ItemPriority.high,
        3 => ItemPriority.urgent,
        _ => ItemPriority.normal,
      };
}
