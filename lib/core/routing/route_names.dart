/// Centralized route path constants.
class Routes {
  Routes._();

  // Root
  static const splash = '/';

  // Onboarding
  static const onboardingWelcome = '/onboarding/welcome';
  static const onboardingFamily = '/onboarding/family';
  static const onboardingDietary = '/onboarding/dietary';
  static const onboardingCooking = '/onboarding/cooking';

  // Bottom nav tabs
  static const home = '/home';
  static const pantry = '/pantry';
  static const planner = '/planner';
  static const lists = '/lists';

  // Pantry sub-routes
  static const pantryItemDetail = '/pantry/item/:id';
  static const addPantryItem = '/pantry/add';

  // Scanner
  static const scanner = '/scanner';
  static const productSearch = '/products/search';
  static const productDetail = '/products/:id';

  // Meal plan
  static const planGeneration = '/planner/generate';
  static const chat = '/planner/chat';
  static const inventorySuggestions = '/planner/inventory';

  // Recipes
  static const recipes = '/recipes';
  static const recipeDetail = '/recipes/:id';
  static const cookingMode = '/cooking/:recipeId';

  // Shopping lists
  static const listDetail = '/lists/:id';
  static const addListItem = '/lists/:id/add-item';

  // Settings & profile
  static const settings = '/settings';
  static const profileEdit = '/profile/edit';
  static const dietaryPreferences = '/settings/dietary';
  static const notificationSettings = '/settings/notifications';

  // Sharing
  static const collaborators = '/collaborators/:firestoreId';
  static const activityFeed = '/activity';

  // Premium
  static const premium = '/premium';
  static const subscriptionManage = '/premium/manage';
}
