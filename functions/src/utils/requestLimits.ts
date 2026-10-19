import {HttpsError} from "firebase-functions/v2/https";
import {
  ChatRequest,
  FamilyInfo,
  GeneratePlanRequest,
  PantryItem,
  PreferenceSummary,
  VoiceScriptRequest,
} from "../types";

/**
 * Size limits for AI requests.
 *
 * Every field of a request ends up in the prompt sent to Bedrock, so an
 * unbounded field is an unbounded bill. The limits sit well above what the app
 * sends (it caps pantry items at 50 and plans at 7 days). Text the user typed
 * is rejected when too long; context the app assembles is trimmed instead, so a
 * long chat session keeps working.
 */
export const LIMITS = {
  userMessageChars: 4000,
  chatHistoryChars: 40000,
  /** Leading recipe context the recipe chat puts before the conversation. */
  chatHistoryHeadChars: 8000,
  activePlanChars: 20000,
  textChars: 200,
  shortTextChars: 40,
  planDays: 14,
  pantryItems: 150,
  listEntries: 100,
  cuisineEntries: 40,
  familyMembers: 30,
  imageBase64Chars: Math.ceil((5 * 1024 * 1024 * 4) / 3),
  /** Pages of a recipe sent together; all photos stay under the 10MB call limit. */
  images: 4,
  imagesTotalBase64Chars: 9 * 1024 * 1024,
  voiceScriptIngredients: 60,
  voiceScriptSteps: 40,
  voiceScriptStepChars: 1500,
} as const;

const IMAGE_TYPES = ["image/jpeg", "image/png", "image/webp"] as const;

const HISTORY_TRIMMED = "\n…(earlier conversation trimmed)…\n";

function reject(message: string): never {
  throw new HttpsError("invalid-argument", message);
}

function asRecord(value: unknown): Record<string, unknown> | undefined {
  return value && typeof value === "object" && !Array.isArray(value) ?
    (value as Record<string, unknown>) :
    undefined;
}

function text(value: unknown, max: number = LIMITS.textChars): string {
  return typeof value === "string" ? value.slice(0, max) : "";
}

function optionalText(
  value: unknown,
  max: number = LIMITS.textChars
): string | undefined {
  return typeof value === "string" ? value.slice(0, max) : undefined;
}

function textList(
  value: unknown,
  maxEntries: number = LIMITS.listEntries,
  maxChars: number = LIMITS.textChars
): string[] {
  if (!Array.isArray(value)) return [];
  return value
    .filter((entry): entry is string => typeof entry === "string")
    .slice(0, maxEntries)
    .map((entry) => entry.slice(0, maxChars));
}

function memberCount(value: unknown): number {
  if (typeof value !== "number" || !Number.isFinite(value)) return 0;
  return Math.min(Math.max(Math.floor(value), 0), LIMITS.familyMembers);
}

function pantryItems(value: unknown, maxEntries: number): PantryItem[] {
  if (!Array.isArray(value)) return [];
  const items: PantryItem[] = [];
  for (const entry of value) {
    if (items.length >= maxEntries) break;
    const raw = asRecord(entry);
    const name = text(raw?.name);
    if (!raw || !name) continue;

    const item: PantryItem = {name};
    if (typeof raw.quantity === "number" && Number.isFinite(raw.quantity)) {
      item.quantity = raw.quantity;
    }
    const unit = optionalText(raw.unit, LIMITS.shortTextChars);
    if (unit !== undefined) item.unit = unit;
    const category = optionalText(raw.category, LIMITS.shortTextChars);
    if (category !== undefined) item.category = category;
    const expiry = optionalText(raw.expiry_date, LIMITS.shortTextChars);
    if (expiry !== undefined) item.expiry_date = expiry;
    items.push(item);
  }
  return items;
}

function cuisineAffinities(value: unknown): Record<string, number> {
  const affinities: Record<string, number> = {};
  const raw = asRecord(value);
  if (!raw) return affinities;
  for (const [cuisine, score] of Object.entries(raw)) {
    if (Object.keys(affinities).length >= LIMITS.cuisineEntries) break;
    if (typeof score !== "number" || !Number.isFinite(score)) continue;
    affinities[cuisine.slice(0, LIMITS.shortTextChars)] =
      Math.min(Math.max(score, 0), 1);
  }
  return affinities;
}

function family(value: unknown): FamilyInfo {
  const raw = asRecord(value) ?? {};
  return {
    adults: memberCount(raw.adults),
    kids: memberCount(raw.kids),
    kid_age_ranges: textList(raw.kid_age_ranges, 10, LIMITS.shortTextChars),
    dietary_restrictions: textList(raw.dietary_restrictions, 30),
    preferred_cook_time: text(raw.preferred_cook_time, LIMITS.shortTextChars),
    budget_level: text(raw.budget_level, LIMITS.shortTextChars),
    skill_level: optionalText(raw.skill_level, LIMITS.shortTextChars),
    spice_tolerance: optionalText(raw.spice_tolerance, LIMITS.shortTextChars),
    variety_preference:
      optionalText(raw.variety_preference, LIMITS.shortTextChars),
  };
}

/**
 * Rebuilds a preference summary from only the fields the prompts use, with
 * every list and string bounded. Missing or mistyped fields become empty
 * rather than crashing the prompt builder. Returns undefined if [value]
 * isn't an object at all.
 */
export function sanitizePreferenceSummary(
  value: unknown
): PreferenceSummary | undefined {
  const raw = asRecord(value);
  if (!raw) return undefined;
  return {
    family: family(raw.family),
    pantry_items: pantryItems(raw.pantry_items, LIMITS.pantryItems),
    expiring_soon: pantryItems(raw.expiring_soon, LIMITS.listEntries),
    staples_available: textList(raw.staples_available, LIMITS.pantryItems),
    cuisine_affinities: cuisineAffinities(raw.cuisine_affinities),
    loved_ingredients: textList(raw.loved_ingredients),
    disliked_ingredients: textList(raw.disliked_ingredients),
    favorite_recipes: textList(raw.favorite_recipes),
    recent_meals_14d: textList(raw.recent_meals_14d),
    recent_suggestions: textList(raw.recent_suggestions),
    pantry_only: raw.pantry_only === true,
  };
}

/**
 * Bounds the conversation history. Keeps the leading recipe block the recipe
 * chat sends (so the model still knows which recipe is being modified) and the
 * most recent turns, dropping the middle of a long session.
 */
export function trimChatHistory(history: string): string {
  if (history.length <= LIMITS.chatHistoryChars) return history;

  let head = "";
  if (history.startsWith("[Recipe:")) {
    const end = history.indexOf("[/Recipe]");
    if (end !== -1) {
      head = history.slice(
        0,
        Math.min(end + "[/Recipe]".length, LIMITS.chatHistoryHeadChars)
      );
    }
  }
  const tail = LIMITS.chatHistoryChars - head.length - HISTORY_TRIMMED.length;
  return head + HISTORY_TRIMMED + history.slice(history.length - tail);
}

/** Validates and bounds a chatWithChef request. */
export function validateChatRequest(data: unknown): ChatRequest {
  const raw = asRecord(data) ?? {};
  const preferenceSummary = sanitizePreferenceSummary(raw.preferenceSummary);
  const userMessage = raw.userMessage;
  if (
    typeof userMessage !== "string" ||
    userMessage.trim() === "" ||
    !preferenceSummary
  ) {
    reject("Missing required fields: userMessage, preferenceSummary");
  }
  if (userMessage.length > LIMITS.userMessageChars) {
    reject(
      `Your message is too long. Please keep it under ${LIMITS.userMessageChars} characters.`
    );
  }

  const request: ChatRequest = {
    userMessage,
    chatHistory:
      typeof raw.chatHistory === "string" ? trimChatHistory(raw.chatHistory) : "",
    preferenceSummary,
  };
  if (typeof raw.activePlan === "string") {
    request.activePlan = raw.activePlan.slice(0, LIMITS.activePlanChars);
  }
  if (raw.mode === "voice") {
    request.mode = "voice";
  }

  const rawImages: {base64: unknown; mediaType: unknown}[] = [];
  if (Array.isArray(raw.images)) {
    if (raw.images.length > LIMITS.images) {
      reject(`Please send at most ${LIMITS.images} photos at a time.`);
    }
    for (const image of raw.images) {
      const record = asRecord(image) ?? {};
      rawImages.push({base64: record.base64, mediaType: record.mediaType});
    }
  } else if (raw.imageBase64 != null && raw.imageMediaType != null) {
    rawImages.push({base64: raw.imageBase64, mediaType: raw.imageMediaType});
  }

  let totalChars = 0;
  const images = rawImages.map(({base64, mediaType}) => {
    if (
      typeof base64 !== "string" ||
      !IMAGE_TYPES.includes(mediaType as (typeof IMAGE_TYPES)[number])
    ) {
      reject("Unsupported image. Please use a JPEG, PNG or WebP photo.");
    }
    if (base64.length > LIMITS.imageBase64Chars) {
      reject("Image is too large. Please use a smaller image (max 5MB).");
    }
    totalChars += base64.length;
    return {base64, mediaType: mediaType as (typeof IMAGE_TYPES)[number]};
  });
  if (totalChars > LIMITS.imagesTotalBase64Chars) {
    reject("Those photos are too large together. Please send fewer at a time.");
  }
  if (images.length > 0) {
    request.images = images;
    request.imageBase64 = images[0].base64;
    request.imageMediaType = images[0].mediaType;
  }
  return request;
}

/** Validates and bounds a generatePlan request. */
export function validatePlanRequest(data: unknown): GeneratePlanRequest {
  const raw = asRecord(data) ?? {};
  const preferenceSummary = sanitizePreferenceSummary(raw.preferenceSummary);
  const days = raw.days;
  if (typeof days !== "number" || !days || !preferenceSummary) {
    reject("Missing required fields: days, preferenceSummary");
  }
  if (!Number.isInteger(days) || days < 1 || days > LIMITS.planDays) {
    reject(`A meal plan can be 1 to ${LIMITS.planDays} days long.`);
  }

  return {
    feature: text(raw.feature, LIMITS.shortTextChars),
    days,
    dayLabels: textList(raw.dayLabels, days, LIMITS.shortTextChars),
    mealType: text(raw.mealType, LIMITS.shortTextChars) || "dinner",
    preferenceSummary,
  };
}

/** Validates and bounds a buildVoiceScript request (one recipe). */
export function validateVoiceScriptRequest(data: unknown): VoiceScriptRequest {
  const raw = asRecord(data) ?? {};
  const name = text(raw.name);
  const ingredients = Array.isArray(raw.ingredients) ? raw.ingredients : [];
  const instructions = Array.isArray(raw.instructions) ? raw.instructions : [];
  if (!name || instructions.length === 0) {
    reject("Missing required fields: name, instructions");
  }
  if (
    ingredients.length > LIMITS.voiceScriptIngredients ||
    instructions.length > LIMITS.voiceScriptSteps
  ) {
    reject("This recipe is too long for voice cooking.");
  }

  return {
    name,
    ingredients: ingredients.map(asRecord).filter((i) => i !== undefined).map((i) => ({
      name: text(i.name),
      quantity: text(i.quantity, LIMITS.shortTextChars),
      unit: text(i.unit, LIMITS.shortTextChars),
      optional: i.optional === true,
    })).filter((i) => i.name !== ""),
    instructions: instructions.map(asRecord).filter((i) => i !== undefined).map((i, index) => ({
      step_number: typeof i.step_number === "number" ? i.step_number : index + 1,
      instruction: text(i.instruction, LIMITS.voiceScriptStepChars),
    })).filter((i) => i.instruction !== ""),
  };
}
