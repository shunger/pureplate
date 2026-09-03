// ─── Preference Summary (matches PreferenceSummaryBuilder.build() output) ───

export interface FamilyInfo {
  adults: number;
  kids: number;
  kid_age_ranges?: string[];
  dietary_restrictions: string[];
  preferred_cook_time: string;
  budget_level: string;
  skill_level?: string;
  spice_tolerance?: string;
  variety_preference?: string;
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
  recent_suggestions: string[];
  pantry_only?: boolean;
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
  imageBase64?: string;
  imageMediaType?: "image/jpeg" | "image/png" | "image/webp";
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
  productId?: string | null;
  autoRenewing?: boolean;
  environment?: string | null;
}

/** Normalized result of asking Apple or Google about a subscription. */
export interface VerifiedSubscription {
  /** True only if the store confirms an unexpired, entitled subscription. */
  valid: boolean;
  productId: string | null;
  /** ISO 8601, or null when the store reported no expiry. */
  expiresAt: string | null;
  /**
   * Stable identity for the subscription across renewals: Apple's
   * originalTransactionId, or the Google purchase token.
   */
  originalTransactionId: string | null;
  environment: "production" | "sandbox" | null;
  autoRenewing: boolean;
  /** Machine-readable reason when `valid` is false. */
  reason?: string;
}

/** Server-owned premium status at users/{uid}/entitlement/current. */
export interface EntitlementDoc {
  isPremium: boolean;
  productId: string | null;
  /** Epoch ms. */
  expiresAt: number | null;
  source: "apple" | "google" | null;
  originalTransactionId: string | null;
  environment: string | null;
  autoRenewing: boolean;
  /** Epoch ms. */
  updatedAt: number;
}

/** Weekly usage, returned to the client so it can show quota before the wall. */
export interface QuotaStatus {
  /** True for premium subscribers and users inside the free trial. */
  unlimited: boolean;
  used: number;
  limit: number;
  remaining: number;
  /** Epoch ms when the weekly counters reset. */
  resetAt: number;
  /** Epoch ms the free trial ends, or null if it does not apply. */
  trialEndsAt: number | null;
}
