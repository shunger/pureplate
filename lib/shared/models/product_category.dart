/// Product categories shared across pantry, shopping lists, and recipe ingredients.
enum ProductCategory {
  produce('Produce', '🥬'),
  dairy('Dairy & Eggs', '🥛'),
  meat('Meat & Seafood', '🥩'),
  bakery('Bakery', '🍞'),
  beverages('Beverages', '🥤'),
  canned('Canned & Jarred', '🥫'),
  frozen('Frozen', '🧊'),
  pantryStaple('Pantry Staples', '🫙'),
  snacks('Snacks', '🍿'),
  condiments('Condiments & Sauces', '🫒'),
  spices('Spices & Seasonings', '🧂'),
  healthBeauty('Health & Beauty', '🧴'),
  household('Household', '🧹'),
  other('Other', '📦');

  final String displayName;
  final String emoji;
  const ProductCategory(this.displayName, this.emoji);

  /// Map from OpenFoodFacts categories string to ProductCategory.
  static ProductCategory fromOpenFoodFacts(String? categories) {
    if (categories == null) return ProductCategory.other;
    final lower = categories.toLowerCase();
    if (lower.contains('dairy') || lower.contains('milk') || lower.contains('cheese') || lower.contains('yogurt')) return dairy;
    if (lower.contains('meat') || lower.contains('beef') || lower.contains('pork') || lower.contains('chicken')) return meat;
    if (lower.contains('fish') || lower.contains('seafood')) return meat;
    if (lower.contains('fruit') || lower.contains('vegetable') || lower.contains('produce')) return produce;
    if (lower.contains('bread') || lower.contains('bakery') || lower.contains('pastry')) return bakery;
    if (lower.contains('frozen')) return frozen;
    if (lower.contains('beverage') || lower.contains('drink') || lower.contains('juice') || lower.contains('water')) return beverages;
    if (lower.contains('snack') || lower.contains('cookie') || lower.contains('chip') || lower.contains('candy')) return snacks;
    if (lower.contains('spice') || lower.contains('herb') || lower.contains('seasoning')) return spices;
    if (lower.contains('condiment') || lower.contains('sauce') || lower.contains('ketchup') || lower.contains('mustard')) return condiments;
    if (lower.contains('canned') || lower.contains('jarred')) return canned;
    return other;
  }

  /// Map from UPC Database category string.
  static ProductCategory fromUPCDatabase(String? category) {
    if (category == null) return ProductCategory.other;
    final lower = category.toLowerCase();
    if (lower.contains('food') || lower.contains('grocery')) return pantryStaple;
    if (lower.contains('health') || lower.contains('beauty') || lower.contains('personal care')) return healthBeauty;
    if (lower.contains('household') || lower.contains('cleaning')) return household;
    return other;
  }
}
