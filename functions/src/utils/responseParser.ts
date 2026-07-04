/**
 * Extracts and parses JSON from LLM output that may contain markdown fences
 * or other non-JSON preamble/postamble text.
 */
export function extractJson<T>(raw: string): T {
  let text = raw.trim();

  // Strip markdown code fences
  const fenceMatch = text.match(/```(?:json)?\s*([\s\S]*?)```/);
  if (fenceMatch) {
    text = fenceMatch[1].trim();
  }

  // Try direct parse first
  try {
    return JSON.parse(text) as T;
  } catch {
    // Find the first { or [ and last } or ]
    const firstBrace = text.indexOf("{");
    const firstBracket = text.indexOf("[");
    let start: number;

    if (firstBrace === -1 && firstBracket === -1) {
      throw new Error("No JSON object or array found in response");
    } else if (firstBrace === -1) {
      start = firstBracket;
    } else if (firstBracket === -1) {
      start = firstBrace;
    } else {
      start = Math.min(firstBrace, firstBracket);
    }

    const isArray = text[start] === "[";
    const closeChar = isArray ? "]" : "}";
    const lastClose = text.lastIndexOf(closeChar);

    if (lastClose === -1 || lastClose <= start) {
      throw new Error("Malformed JSON in response");
    }

    const jsonStr = text.substring(start, lastClose + 1);
    return JSON.parse(jsonStr) as T;
  }
}

/**
 * Validates that a parsed plan response has the required structure.
 * Applies defaults for missing optional fields.
 */
export function validatePlanResponse(data: any): any {
  if (!data.plan || !Array.isArray(data.plan.days)) {
    throw new Error("Response missing plan.days array");
  }

  for (const day of data.plan.days) {
    if (!day.meal || !day.meal.name) {
      throw new Error("Each day must have a meal with a name");
    }
    // Apply defaults
    day.meal.prep_time = day.meal.prep_time ?? 0;
    day.meal.cook_time = day.meal.cook_time ?? 0;
    day.meal.servings = day.meal.servings ?? 4;
    day.meal.ingredients = day.meal.ingredients ?? [];
    day.meal.instructions = day.meal.instructions ?? [];

    for (const ing of day.meal.ingredients) {
      ing.quantity = String(ing.quantity ?? "");
      ing.optional = ing.optional ?? false;
    }

    for (let i = 0; i < day.meal.instructions.length; i++) {
      day.meal.instructions[i].step_number =
        day.meal.instructions[i].step_number ?? i + 1;
    }
  }

  return data;
}

/**
 * Validates chat response structure and applies defaults.
 */
export function validateChatResponse(data: any): any {
  data.responseText = data.responseText ?? "";
  data.recipes = data.recipes ?? [];

  for (const recipe of data.recipes) {
    recipe.id = recipe.id ?? "";
    recipe.name = recipe.name ?? "Untitled Recipe";
    recipe.prep_time = recipe.prep_time ?? 0;
    recipe.cook_time = recipe.cook_time ?? 0;
    recipe.servings = recipe.servings ?? 4;
    recipe.ingredients = recipe.ingredients ?? [];
    recipe.instructions = recipe.instructions ?? [];

    for (const ing of recipe.ingredients) {
      ing.quantity = String(ing.quantity ?? "");
      ing.optional = ing.optional ?? false;
    }

    for (let i = 0; i < recipe.instructions.length; i++) {
      recipe.instructions[i].step_number =
        recipe.instructions[i].step_number ?? i + 1;
    }
  }

  return data;
}
