import {onCall, HttpsError} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {callBedrock, bedrockSecrets, HAIKU_MODEL_ID} from "../services/bedrockService";
import {checkKillSwitch} from "../middleware/killSwitch";
import {isEntitled} from "../services/entitlementService";
import {
  buildVoiceScriptSystemPrompt,
  buildVoiceScriptUserPrompt,
  sanitizeVoiceScript,
} from "../prompts/voiceScriptPrompt";
import {extractJson} from "../utils/responseParser";
import {validateVoiceScriptRequest} from "../utils/requestLimits";

if (getApps().length === 0) initializeApp();

/**
 * Rewrites a recipe as a hands-free script for voice cooking: one short
 * action per line, with every ingredient amount spoken. Premium only, like
 * voice cooking itself. The app caches the result per recipe, so this runs
 * once per recipe rather than on every cook.
 */
export const buildVoiceScript = onCall(
  {
    enforceAppCheck: true,
    timeoutSeconds: 60,
    memory: "256MiB",
    secrets: bedrockSecrets,
  },
  async (request) => {
    const isEmulator = process.env.FUNCTIONS_EMULATOR === "true";
    if (!isEmulator && !request.auth) {
      throw new HttpsError("permission-denied", "Authentication required.");
    }

    checkKillSwitch();

    const recipe = validateVoiceScriptRequest(request.data);

    const uid = request.auth?.uid ?? "emulator-test-user";
    if (!isEmulator && !(await isEntitled(uid))) {
      throw new HttpsError("permission-denied", "Voice cooking requires Premium.");
    }

    try {
      const raw = await callBedrock(
        buildVoiceScriptSystemPrompt(),
        buildVoiceScriptUserPrompt(recipe),
        {temperature: 0.4, maxTokens: 4096, modelId: HAIKU_MODEL_ID}
      );
      return sanitizeVoiceScript(extractJson(raw), recipe);
    } catch (err: any) {
      console.error("[buildVoiceScript] failed:", err?.name, err?.message);
      // The app falls back to its own step wording.
      throw new HttpsError("unavailable", "Couldn't prepare the voice script.");
    }
  }
);
