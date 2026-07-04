import {Ingredient, PantryItem, ShoppingListItem} from "../types";

/**
 * Given a list of recipe ingredients and the user's pantry,
 * returns a deduplicated shopping list of items NOT in the pantry.
 */
export function diffShoppingList(
  allIngredients: Ingredient[],
  pantryItems: PantryItem[]
): ShoppingListItem[] {
  // Deduplicate ingredients by normalized name
  const deduped = new Map<string, Ingredient>();
  for (const ing of allIngredients) {
    const key = ing.name.toLowerCase().trim();
    if (!deduped.has(key)) {
      deduped.set(key, ing);
    }
  }

  // Build pantry lookup set with normalized names
  const pantryNames = new Set(
    pantryItems.map((p) => p.name.toLowerCase().trim())
  );

  // Filter out ingredients that match pantry items (exact or substring)
  const needed: ShoppingListItem[] = [];
  for (const [key, ing] of deduped) {
    if (ing.optional) continue;

    const inPantry = pantryNames.has(key) ||
      [...pantryNames].some(
        (pantryName) =>
          pantryName.includes(key) || key.includes(pantryName)
      );

    if (!inPantry) {
      needed.push({
        name: ing.name,
        quantity: ing.quantity || undefined,
        unit: ing.unit || undefined,
        category: ing.category || undefined,
      });
    }
  }

  return needed;
}
