import {onCall, HttpsError} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {callBedrock, callBedrockVision, bedrockSecrets} from "../services/bedrockService";
import {checkKillSwitch} from "../middleware/killSwitch";
import {checkRateLimit} from "../middleware/rateLimiter";
import {buildChatSystemPrompt, buildChatUserPrompt} from "../prompts/chatPrompt";
import {extractJson, validateChatResponse} from "../utils/responseParser";
import {ChatRequest} from "../types";

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

    // Rate limit (skip in emulator without auth)
    const uid = request.auth?.uid ?? "emulator-test-user";
    await checkRateLimit(uid, "chat");

    // Validate input
    const data = request.data as ChatRequest;
    if (!data.userMessage || !data.preferenceSummary) {
      throw new HttpsError(
        "invalid-argument",
        "Missing required fields: userMessage, preferenceSummary"
      );
    }

    // Validate image size if present (reject base64 > ~5MB)
    const hasImage = !!data.imageBase64 && !!data.imageMediaType;
    if (hasImage) {
      const maxBase64Chars = Math.ceil(5 * 1024 * 1024 * 4 / 3);
      if (data.imageBase64!.length > maxBase64Chars) {
        throw new HttpsError(
          "invalid-argument",
          "Image is too large. Please use a smaller image (max 5MB)."
        );
      }
    }

    const systemPrompt = buildChatSystemPrompt();
    const userPrompt = buildChatUserPrompt(data);

    let parsed: any;
    let attempts = 0;
    const maxAttempts = 2;

    while (attempts < maxAttempts) {
      attempts++;
      try {
        const temperature = attempts === 1 ? 0.7 : 0.3;
        const bedrockOptions = {temperature, maxTokens: 4096};

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
    };
  }
);
