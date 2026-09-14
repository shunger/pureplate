import {onCall, HttpsError} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {callBedrock, bedrockSecrets, HAIKU_MODEL_ID} from "../services/bedrockService";
import {checkKillSwitch} from "../middleware/killSwitch";
import {checkRateLimit} from "../middleware/rateLimiter";
import {buildPlanSystemPrompt, buildPlanUserPrompt} from "../prompts/planPrompt";
import {extractJson, validatePlanResponse} from "../utils/responseParser";
import {diffShoppingList} from "../utils/shoppingListDiffer";
import {validatePlanRequest} from "../utils/requestLimits";
import {Ingredient} from "../types";

if (getApps().length === 0) initializeApp();

export const generatePlan = onCall(
  {
    enforceAppCheck: true,
    timeoutSeconds: 120,
    memory: "512MiB",
    secrets: bedrockSecrets,
  },
  async (request) => {
    // Auth check (skipped in emulator when no Auth emulator is running)
    const isEmulator = process.env.FUNCTIONS_EMULATOR === "true";
    if (!isEmulator && !request.auth) {
      throw new HttpsError("permission-denied", "Authentication required.");
    }

    // Kill switch
    console.log("generatePlan: checking kill switch");
    checkKillSwitch();

    // Validate and bound the input before charging quota, so a malformed or
    // oversized request doesn't use up the user's allowance.
    const data = validatePlanRequest(request.data);
    console.log("generatePlan: input days:", data.days);

    // Rate limit (skip in emulator without auth)
    const uid = request.auth?.uid ?? "emulator-test-user";
    console.log("generatePlan: checking rate limit for uid:", uid);
    const quota = await checkRateLimit(uid, "plan");

    const systemPrompt = buildPlanSystemPrompt();
    const userPrompt = buildPlanUserPrompt(data);

    let parsed: any;
    let attempts = 0;
    const maxAttempts = 2;

    while (attempts < maxAttempts) {
      attempts++;
      try {
        const temperature = attempts === 1 ? 0.3 : 0.1;
        console.log(`generatePlan: calling Bedrock attempt ${attempts}, temp=${temperature}`);
        const raw = await callBedrock(systemPrompt, userPrompt, {
          temperature,
          maxTokens: 4096,
          modelId: HAIKU_MODEL_ID,
        });
        console.log("generatePlan: Bedrock returned", raw.length, "chars");

        parsed = extractJson(raw);
        parsed = validatePlanResponse(parsed);
        console.log("generatePlan: parsed", parsed.plan.days.length, "days");
        break;
      } catch (err: any) {
        console.error(`generatePlan: attempt ${attempts} failed:`, err.message || err);
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
      quota,
    };
  }
);
