import {onCall, HttpsError} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {callBedrock, callBedrockVisionImages, bedrockSecrets, HAIKU_MODEL_ID} from "../services/bedrockService";
import {checkKillSwitch} from "../middleware/killSwitch";
import {checkRateLimit} from "../middleware/rateLimiter";
import {buildChatSystemPrompt, buildChatUserPrompt} from "../prompts/chatPrompt";
import {buildVoiceCookingSystemPrompt, buildVoiceCookingUserPrompt} from "../prompts/voiceCookingPrompt";
import {extractJson, validateChatResponse} from "../utils/responseParser";
import {validateChatRequest} from "../utils/requestLimits";
import {readRecipePhotos} from "../services/recipePhotoReader";

if (getApps().length === 0) initializeApp();

export const chatWithChef = onCall(
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
    checkKillSwitch();

    // Validate and bound the input (message length, history, image type and
    // size) before charging quota, so a rejected request is free.
    const data = validateChatRequest(request.data);
    const isVoice = data.mode === "voice";
    const hasImage = !isVoice && (data.images?.length ?? 0) > 0;

    // Rate limit (skip in emulator without auth)
    const uid = request.auth?.uid ?? "emulator-test-user";
    const quota = await checkRateLimit(uid, "chat");

    // Photos of a written recipe become a recipe card; other photos (a dish,
    // ingredients) are answered by the chef below.
    if (hasImage && data.images) {
      try {
        const card = await readRecipePhotos(data.images, data.userMessage);
        if (card) return {...card, quota};
      } catch (err: any) {
        // Not falling back to the chef here: reading a page "as a chat" is
        // what mixed neighbouring recipes together.
        console.error("chatWithChef: recipe photo reader failed:", err?.name, err?.message);
        return {
          responseText: "Sorry, I couldn't read that photo just now. Please send it again in a moment.",
          recipes: [],
          quota,
        };
      }
    }

    // Voice replies are spoken aloud mid-cook, so they get their own
    // conversational prompt and a short token budget.
    const systemPrompt = isVoice ? buildVoiceCookingSystemPrompt() : buildChatSystemPrompt();
    const userPrompt = isVoice ? buildVoiceCookingUserPrompt(data) : buildChatUserPrompt(data);

    let parsed: any;
    let attempts = 0;
    const maxAttempts = 2;

    while (attempts < maxAttempts) {
      attempts++;
      try {
        // A photo is often a written recipe to copy word for word, so keep
        // the model close to what it reads.
        const temperature = hasImage ? 0.2 : attempts === 1 ? 0.7 : 0.3;
        const bedrockOptions = {temperature, maxTokens: isVoice ? 512 : 4096, modelId: HAIKU_MODEL_ID};

        const raw = hasImage
          ? await callBedrockVisionImages(
              systemPrompt,
              userPrompt,
              data.images!,
              bedrockOptions
            )
          : await callBedrock(systemPrompt, userPrompt, bedrockOptions);

        parsed = extractJson(raw);
        parsed = validateChatResponse(parsed);
        break;
      } catch (err: any) {
        console.error(`chatWithChef: attempt ${attempts} failed:`, err.name, err.message, err.stack);
        if (attempts >= maxAttempts) {
          if (err.message?.includes("timeout") || err.name === "TimeoutError") {
            throw new HttpsError("deadline-exceeded", "AI request timed out. Please try again.");
          }
          throw new HttpsError(
            "internal",
            "Failed to get response. Please try again."
          );
        }
      }
    }

    return {
      responseText: parsed.responseText,
      recipes: isVoice ? [] : parsed.recipes,
      quota,
    };
  }
);
