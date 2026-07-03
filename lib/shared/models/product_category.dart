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
}
