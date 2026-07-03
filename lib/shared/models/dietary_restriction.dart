/// Shared dietary restriction enum used across pantry, recipes, and family profiles.
enum DietaryRestriction {
  vegetarian('Vegetarian'),
  vegan('Vegan'),
  glutenFree('Gluten-Free'),
  dairyFree('Dairy-Free'),
  nutFree('Nut-Free'),
  shellfishFree('Shellfish-Free'),
  eggFree('Egg-Free'),
  soyFree('Soy-Free'),
  keto('Keto'),
  paleo('Paleo'),
  halal('Halal'),
  kosher('Kosher'),
  lowSodium('Low Sodium'),
  diabeticFriendly('Diabetic-Friendly');

  final String displayName;
  const DietaryRestriction(this.displayName);
}
