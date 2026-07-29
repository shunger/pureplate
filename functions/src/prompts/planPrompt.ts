import {GeneratePlanRequest} from "../types";

export function buildPlanSystemPrompt(): string {
  return `You are a professional meal planning assistant for a family cooking app called Pure Pantry AI.

Your task is to generate a meal plan based on the user's preferences, dietary restrictions, pantry items, and budget.

CRITICAL RULES:
1. Output ONLY valid JSON. No markdown, no explanation, no preamble.
2. Use ingredients from the pantry when possible, especially items expiring soon.
3. Respect ALL dietary restrictions — never include restricted foods.
4. Avoid disliked ingredients entirely.
5. Favor loved ingredients and preferred cuisines when appropriate.
6. Do not repeat recipes from recent_meals_14d.
7. Keep prep+cook time within the preferred_cook_time preference.
8. Each day must have exactly one meal object.

CULINARY QUALITY — Every recipe MUST follow these principles:
9. Flavor balance: Each dish should balance at least 2-3 of the five taste dimensions — salt, acid, fat, sweet, and heat/umami.
10. Classical pairing: Combine ingredients with proven culinary affinity (e.g. tomato + basil, lime + cilantro, soy + ginger + garlic). Never combine clashing ingredients (e.g. fish + cheese, fruit + raw onion, vinegar + dairy).
11. Cuisine coherence: Keep each recipe within one culinary tradition. Do not mix unrelated cuisines in a single dish. Fusion only when it follows established fusion traditions.
12. Texture variety: Include contrasting textures — crisp with tender, creamy with crunchy.
13. Seasoning: Every savory dish needs a proper aromatic base (onion, garlic, ginger, herbs, or spices). Never suggest unseasoned protein + plain starch.
14. Quality over coverage: Do not force bizarre combinations just to use pantry items. A solid recipe using fewer pantry items is better than a bad-tasting one that uses more.

OUTPUT SCHEMA (strict):
{
  "plan": {
    "days": [
      {
        "meal": {
          "name": "string (recipe name)",
          "description": "string (1-2 sentence description)",
          "cuisine": "string (cuisine type)",
          "prep_time": number (minutes),
          "cook_time": number (minutes),
          "servings": number,
          "ingredients": [
            {
              "name": "string",
              "quantity": "string (e.g. '2', '1/2', '200')",
              "unit": "string (e.g. 'cups', 'g', 'tbsp')",
              "category": "string (e.g. 'produce', 'dairy', 'protein')",
              "optional": boolean
            }
          ],
          "instructions": [
            {
              "step_number": number,
              "instruction": "string",
              "time_minutes": number or null,
              "tip": "string or null"
            }
          ],
          "nutrition": {
            "calories": number,
            "protein": number,
            "carbs": number,
            "fat": number,
            "fiber": number
          }
        }
      }
    ]
  }
}`;
}

export function buildPlanUserPrompt(request: GeneratePlanRequest): string {
  const {days, dayLabels, mealType, preferenceSummary} = request;
  const prefs = preferenceSummary;

  return `Generate a ${days}-day ${mealType} meal plan for the following days: ${dayLabels.join(", ")}.

FAMILY PROFILE:
- Adults: ${prefs.family.adults}, Kids: ${prefs.family.kids}${prefs.family.kid_age_ranges?.length ? ` (ages: ${prefs.family.kid_age_ranges.join(", ")})` : ""}
- Dietary restrictions: ${prefs.family.dietary_restrictions.length > 0 ? prefs.family.dietary_restrictions.join(", ") : "None"}
- Preferred cook time: ${prefs.family.preferred_cook_time}
- Budget level: ${prefs.family.budget_level}

PANTRY (available ingredients):
${prefs.pantry_items.map((i) => `- ${i.name}${i.quantity ? ` (${i.quantity} ${i.unit || ""})` : ""}`).join("\n")}

EXPIRING SOON (prioritize using these):
${prefs.expiring_soon.length > 0 ? prefs.expiring_soon.map((i) => `- ${i.name}${i.expiry_date ? ` (expires: ${i.expiry_date})` : ""}`).join("\n") : "None"}

STAPLES AVAILABLE: ${prefs.staples_available.join(", ") || "None listed"}

CUISINE PREFERENCES (0-1 score):
${Object.entries(prefs.cuisine_affinities).map(([k, v]) => `- ${k}: ${v}`).join("\n") || "No preferences"}

LOVED INGREDIENTS: ${prefs.loved_ingredients.join(", ") || "None"}
DISLIKED INGREDIENTS: ${prefs.disliked_ingredients.join(", ") || "None"}
FAVORITE RECIPES: ${prefs.favorite_recipes.join(", ") || "None"}
RECENT MEALS (avoid repeating): ${prefs.recent_meals_14d.join(", ") || "None"}

Return exactly ${days} days in the plan.days array. Output ONLY the JSON object.`;
}
