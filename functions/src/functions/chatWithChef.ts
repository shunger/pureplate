import {onCall, HttpsError} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {callBedrock, bedrockSecrets} from "../services/bedrockService";
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
    // Auth check
    if (!request.auth) {
      throw new HttpsError("permission-denied", "Authentication required.");
    }

    // Kill switch
    checkKillSwitch();

    // Rate limit
    await checkRateLimit(request.auth.uid, "chat");

    // Validate input
    const data = request.data as ChatRequest;
    if (!data.userMessage || !data.preferenceSummary) {
      throw new HttpsError(
        "invalid-argument",
        "Missing required fields: userMessage, preferenceSummary"
      );
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
        const raw = await callBedrock(systemPrompt, userPrompt, {
          temperature,
          maxTokens: 4096,
        });

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
