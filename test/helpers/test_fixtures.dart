import 'package:pure_pantry/features/pantry/domain/models/pantry_item.dart';
import 'package:pure_pantry/features/recipes/domain/models/recipe.dart';
import 'package:pure_pantry/features/recipes/domain/models/ingredient.dart';
import 'package:pure_pantry/features/recipes/domain/models/instruction_step.dart';
import 'package:pure_pantry/features/meal_plan/domain/models/meal_plan.dart';
import 'package:pure_pantry/features/meal_plan/domain/models/family_profile.dart';
import 'package:pure_pantry/features/shopping_list/domain/models/shopping_list.dart';
import 'package:pure_pantry/features/products/domain/models/product.dart';
import 'package:pure_pantry/shared/models/product_category.dart';
import 'package:pure_pantry/shared/models/dietary_restriction.dart';

/// Factory functions for creating test domain objects with sensible defaults.
/// All parameters are optional with named overrides.

PantryItem makePantryItem({
  String id = 'pantry-1',
  String? productId,
  String name = 'Milk',
  String? brand,
  ProductCategory category = ProductCategory.dairy,
  double quantity = 1,
  String unitType = 'count',
  PantryLocation location = PantryLocation.fridge,
  DateTime? purchasedAt,
  DateTime? expiresAt,
  bool isStaple = false,
  double reorderThreshold = 0,
  bool isBulk = false,
  double? purchasePrice,
  String? notes,
  String? imageUrl,
  String? firestorePantryId,
  String? firestoreItemId,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  return PantryItem(
    id: id,
    productId: productId,
    name: name,
    brand: brand,
    category: category,
    quantity: quantity,
    unitType: unitType,
    location: location,
    purchasedAt: purchasedAt,
    expiresAt: expiresAt,
    isStaple: isStaple,
    reorderThreshold: reorderThreshold,
    isBulk: isBulk,
    purchasePrice: purchasePrice,
    notes: notes,
    imageUrl: imageUrl,
    firestorePantryId: firestorePantryId,
    firestoreItemId: firestoreItemId,
    createdAt: createdAt ?? DateTime(2024, 1, 1),
    updatedAt: updatedAt,
  );
}

Recipe makeRecipe({
  String id = 'recipe-1',
  String name = 'Test Recipe',
  String? description,
  String? cuisine,
  String? imageUrl,
  int prepTimeMinutes = 15,
  int cookTimeMinutes = 30,
  int servings = 4,
  String? difficulty,
  List<Ingredient>? ingredients,
  List<InstructionStep>? instructions,
  RecipeSource source = RecipeSource.bundled,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  return Recipe(
    id: id,
    name: name,
    description: description,
    cuisine: cuisine,
    imageUrl: imageUrl,
    prepTimeMinutes: prepTimeMinutes,
    cookTimeMinutes: cookTimeMinutes,
    servings: servings,
    difficulty: difficulty,
    ingredients: ingredients ?? [],
    instructions: instructions ?? [],
    source: source,
    createdAt: createdAt ?? DateTime(2024, 1, 1),
    updatedAt: updatedAt,
  );
}

MealPlan makeMealPlan({
  String id = 'plan-1',
  DateTime? createdAt,
  DateTime? startDate,
  DateTime? endDate,
  PlanType planType = PlanType.quick,
  List<MealPlanDay>? days,
}) {
  final start = startDate ?? DateTime(2024, 1, 8);
  return MealPlan(
    id: id,
    createdAt: createdAt ?? DateTime(2024, 1, 1),
    startDate: start,
    endDate: endDate ?? start.add(const Duration(days: 6)),
    planType: planType,
    days: days ?? [],
  );
}

MealPlanDay makeMealPlanDay({
  String id = 'day-1',
  String planId = 'plan-1',
  DateTime? date,
  String recipeId = 'recipe-1',
  String recipeName = 'Test Recipe',
  bool isCooked = false,
  int sortOrder = 0,
}) {
  return MealPlanDay(
    id: id,
    planId: planId,
    date: date ?? DateTime(2024, 1, 8),
    recipeId: recipeId,
    recipeName: recipeName,
    isCooked: isCooked,
    sortOrder: sortOrder,
  );
}

ShoppingList makeShoppingList({
  String id = 'list-1',
  String name = 'Weekly Groceries',
  List<ShoppingListItem>? items,
  String? storeId,
  String? storeName,
  ShoppingListSource source = ShoppingListSource.manual,
  String? mealPlanId,
  bool isActive = true,
  bool isCompleted = false,
  bool isArchived = false,
  DateTime? createdAt,
  DateTime? dateShopped,
}) {
  return ShoppingList(
    id: id,
    name: name,
    items: items ?? [],
    storeId: storeId,
    storeName: storeName,
    source: source,
    mealPlanId: mealPlanId,
    isActive: isActive,
    isCompleted: isCompleted,
    isArchived: isArchived,
    createdAt: createdAt ?? DateTime(2024, 1, 1),
    dateShopped: dateShopped,
  );
}

ShoppingListItem makeShoppingListItem({
  String id = 'item-1',
  String listId = 'list-1',
  String? productId,
  String name = 'Apples',
  String? brand,
  ProductCategory category = ProductCategory.produce,
  double quantity = 1,
  String unitType = 'count',
  double? estimatedPrice,
  double? actualPrice,
  bool isCompleted = false,
  int priority = 0,
  String? notes,
  double pantryQuantityAvailable = 0,
  DateTime? addedAt,
}) {
  return ShoppingListItem(
    id: id,
    listId: listId,
    productId: productId,
    name: name,
    brand: brand,
    category: category,
    quantity: quantity,
    unitType: unitType,
    estimatedPrice: estimatedPrice,
    actualPrice: actualPrice,
    isCompleted: isCompleted,
    priority: priority,
    notes: notes,
    pantryQuantityAvailable: pantryQuantityAvailable,
    addedAt: addedAt ?? DateTime(2024, 1, 1),
  );
}

Product makeProduct({
  String id = 'product-1',
  String? barcode = '036000291452',
  String? pluCode,
  String name = 'Test Product',
  String? brand = 'Test Brand',
  String? description,
  double? price,
  String? currency,
  ProductCategory category = ProductCategory.other,
  String? imageUrl,
  String? source = 'openFoodFacts',
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime(2024, 1, 1);
  return Product(
    id: id,
    barcode: barcode,
    pluCode: pluCode,
    name: name,
    brand: brand,
    description: description,
    price: price,
    currency: currency,
    category: category,
    imageUrl: imageUrl,
    source: source,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
  );
}

FamilyProfile makeFamilyProfile({
  String id = 'profile-1',
  int adults = 2,
  int kids = 0,
  List<KidAgeRange> kidAgeRanges = const [],
  List<DietaryRestriction> dietaryRestrictions = const [],
  List<String> cuisinePreferences = const [],
  PreferredCookTime preferredCookTime = PreferredCookTime.under45,
  BudgetLevel budgetLevel = BudgetLevel.moderate,
  List<String> pantryStaples = const [],
  List<String> dislikedIngredients = const [],
}) {
  return FamilyProfile(
    id: id,
    adults: adults,
    kids: kids,
    kidAgeRanges: kidAgeRanges,
    dietaryRestrictions: dietaryRestrictions,
    cuisinePreferences: cuisinePreferences,
    preferredCookTime: preferredCookTime,
    budgetLevel: budgetLevel,
    pantryStaples: pantryStaples,
    dislikedIngredients: dislikedIngredients,
  );
}

Ingredient makeIngredient({
  String name = 'Chicken Breast',
  String? quantity = '2',
  String? unit = 'lbs',
  String? category = 'meat',
  bool optional = false,
}) {
  return Ingredient(
    name: name,
    quantity: quantity,
    unit: unit,
    category: category,
    optional: optional,
  );
}
