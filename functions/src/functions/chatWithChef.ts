import {onCall, HttpsError} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {callBedrock, callBedrockVision, bedrockSecrets, HAIKU_MODEL_ID} from "../services/bedrockService";
import {checkKillSwitch} from "../middleware/killSwitch";
import {checkRateLimit} from "../middleware/rateLimiter";
import {buildChatSystemPrompt, buildChatUserPrompt} from "../prompts/chatPrompt";
import {extractJson, validateChatResponse} from "../utils/responseParser";
import {validateChatRequest} from "../utils/requestLimits";

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
    const hasImage = data.imageBase64 !== undefined;

    // Rate limit (skip in emulator without auth)
    const uid = request.auth?.uid ?? "emulator-test-user";
    const quota = await checkRateLimit(uid, "chat");

    const systemPrompt = buildChatSystemPrompt();
    const userPrompt = buildChatUserPrompt(data);

    let parsed: any;
    let attempts = 0;
    const maxAttempts = 2;

    while (attempts < maxAttempts) {
      attempts++;
      try {
        const temperature = attempts === 1 ? 0.7 : 0.3;
        const bedrockOptions = {temperature, maxTokens: 4096, modelId: HAIKU_MODEL_ID};

        const raw = hasImage
          ? await callBedrockVision(
              systemPrompt,
              userPrompt,
              data.imageBase64!,
              data.imageMediaType!,
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
      recipes: parsed.recipes,
      quota,
    };
  }
);
