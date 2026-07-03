enum Allergen {
  milk('Milk'),
  eggs('Eggs'),
  fish('Fish'),
  shellfish('Shellfish'),
  nuts('Tree Nuts'),
  peanuts('Peanuts'),
  wheat('Wheat'),
  soy('Soy'),
  sesame('Sesame');

  const Allergen(this.displayName);
  final String displayName;

  /// Parse allergens from OpenFoodFacts allergen string.
  static List<Allergen>? fromOpenFoodFacts(String? allergens) {
    if (allergens == null || allergens.isEmpty) return null;
    final lower = allergens.toLowerCase();
    final result = <Allergen>[];
    if (lower.contains('milk') || lower.contains('dairy')) result.add(Allergen.milk);
    if (lower.contains('egg')) result.add(Allergen.eggs);
    if (lower.contains('fish')) result.add(Allergen.fish);
    if (lower.contains('shellfish') || lower.contains('crustacean')) result.add(Allergen.shellfish);
    if (lower.contains('tree nuts') || lower.contains('nuts')) result.add(Allergen.nuts);
    if (lower.contains('peanut')) result.add(Allergen.peanuts);
    if (lower.contains('wheat') || lower.contains('gluten')) result.add(Allergen.wheat);
    if (lower.contains('soy') || lower.contains('soybean')) result.add(Allergen.soy);
    if (lower.contains('sesame')) result.add(Allergen.sesame);
    return result.isEmpty ? null : result;
  }
}
