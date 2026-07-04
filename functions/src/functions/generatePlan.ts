import {onCall, HttpsError} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {callBedrock, bedrockSecrets} from "../services/bedrockService";
import {checkKillSwitch} from "../middleware/killSwitch";
import {checkRateLimit} from "../middleware/rateLimiter";
import {buildPlanSystemPrompt, buildPlanUserPrompt} from "../prompts/planPrompt";
import {extractJson, validatePlanResponse} from "../utils/responseParser";
import {diffShoppingList} from "../utils/shoppingListDiffer";
import {GeneratePlanRequest, Ingredient} from "../types";

if (getApps().length === 0) initializeApp();

export const generatePlan = onCall(
  {
    enforceAppCheck: true,
    timeoutSeconds: 120,
    memory: "512MiB",
    secrets: bedrockSecrets,
  },
  async (request) => {
    // Auth check
    if (!request.auth) {
      throw new HttpsError("permission-denied", "Authentication required.");
    }

    // Kill switch
    checkKillSwitch();

    // Rate limit
    await checkRateLimit(request.auth.uid, "plan");

    // Validate input
    const data = request.data as GeneratePlanRequest;
    if (!data.days || !data.preferenceSummary) {
      throw new HttpsError(
        "invalid-argument",
        "Missing required fields: days, preferenceSummary"
      );
    }

    const systemPrompt = buildPlanSystemPrompt();
    const userPrompt = buildPlanUserPrompt(data);

    let parsed: any;
    let attempts = 0;
    const maxAttempts = 2;

    while (attempts < maxAttempts) {
      attempts++;
      try {
        const temperature = attempts === 1 ? 0.3 : 0.1;
        const raw = await callBedrock(systemPrompt, userPrompt, {
          temperature,
          maxTokens: 4096,
        });

        parsed = extractJson(raw);
        parsed = validatePlanResponse(parsed);
        break;
      } catch (err: any) {
        if (attempts >= maxAttempts) {
          if (err.message?.includes("timeout") || err.name === "TimeoutError") {
            throw new HttpsError("deadline-exceeded", "AI request timed out. Please try again.");
          }
          throw new HttpsError(
            "internal",
            "Failed to generate meal plan. Please try again."
          );
        }
        // Retry with lower temperature
      }
    }

    // Build shopping list by diffing recipe ingredients vs pantry
    const allIngredients: Ingredient[] = [];
    for (const day of parsed.plan.days) {
      if (day.meal?.ingredients) {
        allIngredients.push(...day.meal.ingredients);
      }
    }

    const shoppingList = diffShoppingList(
      allIngredients,
      data.preferenceSummary.pantry_items
    );

    return {
      plan: parsed.plan,
      shopping_list: shoppingList,
    };
  }
);
