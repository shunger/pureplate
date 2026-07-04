// ─── Preference Summary (matches PreferenceSummaryBuilder.build() output) ───

export interface FamilyInfo {
  adults: number;
  kids: number;
  kid_age_ranges?: string[];
  dietary_restrictions: string[];
  preferred_cook_time: string;
  budget_level: string;
}

export interface PantryItem {
  name: string;
  quantity?: number;
  unit?: string;
  category?: string;
  expiry_date?: string;
}

export interface PreferenceSummary {
  family: FamilyInfo;
  pantry_items: PantryItem[];
  expiring_soon: PantryItem[];
  staples_available: string[];
  cuisine_affinities: Record<string, number>;
  loved_ingredients: string[];
  disliked_ingredients: string[];
  favorite_recipes: string[];
  recent_meals_14d: string[];
}

// ─── generatePlan ───

export interface GeneratePlanRequest {
  feature: string;
  days: number;
  dayLabels: string[];
  mealType: string;
  preferenceSummary: PreferenceSummary;
}

export interface Ingredient {
  name: string;
  quantity: string;
  unit?: string;
  category?: string;
  optional?: boolean;
}

export interface Instruction {
  step_number: number;
  instruction: string;
  time_minutes?: number;
  tip?: string;
}

export interface NutritionInfo {
  calories?: number;
  protein?: number;
  carbs?: number;
  fat?: number;
  fiber?: number;
}

export interface Recipe {
  id?: string;
  name: string;
  description?: string;
  cuisine?: string;
  prep_time?: number;
  cook_time?: number;
  servings?: number;
  ingredients: Ingredient[];
  instructions: Instruction[];
  nutrition?: NutritionInfo;
}

export interface PlanDay {
  meal: Recipe;
}

export interface GeneratePlanResponse {
  plan: {
    days: PlanDay[];
  };
  shopping_list: ShoppingListItem[];
}

export interface ShoppingListItem {
  name: string;
  quantity?: string;
  unit?: string;
  category?: string;
}

// ─── chatWithChef ───

export interface ChatRequest {
  userMessage: string;
  chatHistory: string;
  preferenceSummary: PreferenceSummary;
  activePlan?: string;
}

export interface ChatResponse {
  responseText: string;
  recipes: Recipe[];
}

// ─── verifyReceipt ───

export interface VerifyReceiptRequest {
  receipt: string;
  source: "apple" | "google";
  productId: string;
}

export interface VerifyReceiptResponse {
  valid: boolean;
  expiresAt: string | null;
}
