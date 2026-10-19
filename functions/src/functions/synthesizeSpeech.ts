import {onCall, HttpsError} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {PollyClient, SynthesizeSpeechCommand} from "@aws-sdk/client-polly";
import {awsClientConfig, bedrockSecrets} from "../services/bedrockService";
import {checkKillSwitch} from "../middleware/killSwitch";
import {isEntitled} from "../services/entitlementService";

if (getApps().length === 0) initializeApp();

/** Polly's generative engine bills and caps input at 3000 characters. */
export const SPEECH_TEXT_MAX_CHARS = 3000;

/**
 * Generative en-US voice: warm and conversational. Changing it changes the
 * app's cached audio too, so bump VOICE_VERSION in natural_voice_service.dart.
 */
const VOICE_ID = "Ruth";

/**
 * Turns a line from the voice cooking assistant into natural speech with
 * Amazon Polly's generative engine. Premium only, like voice cooking itself.
 *
 * Returns base64 MP3. The app caches it on the device, so a recipe's steps
 * are only synthesized the first time they are cooked.
 */
export const synthesizeSpeech = onCall(
  {
    enforceAppCheck: true,
    timeoutSeconds: 30,
    memory: "256MiB",
    secrets: bedrockSecrets,
  },
  async (request) => {
    const isEmulator = process.env.FUNCTIONS_EMULATOR === "true";
    if (!isEmulator && !request.auth) {
      throw new HttpsError("permission-denied", "Authentication required.");
    }

    checkKillSwitch();

    const text = (request.data as {text?: unknown})?.text;
    if (typeof text !== "string" || text.trim() === "") {
      throw new HttpsError("invalid-argument", "Missing required field: text");
    }
    if (text.length > SPEECH_TEXT_MAX_CHARS) {
      throw new HttpsError("invalid-argument", "Text is too long to speak.");
    }

    const uid = request.auth?.uid ?? "emulator-test-user";
    if (!isEmulator && !(await isEntitled(uid))) {
      throw new HttpsError("permission-denied", "Voice cooking requires Premium.");
    }

    try {
      const polly = new PollyClient(awsClientConfig());
      const res = await polly.send(new SynthesizeSpeechCommand({
        Engine: "generative",
        VoiceId: VOICE_ID,
        OutputFormat: "mp3",
        SampleRate: "24000",
        TextType: "text",
        Text: text.trim(),
      }));
      if (!res.AudioStream) throw new Error("Polly returned no audio");
      const audio = Buffer.from(await res.AudioStream.transformToByteArray());
      console.log(
        `[synthesizeSpeech] uid=${uid} chars=${text.length} bytes=${audio.length}`
      );
      return {audio: audio.toString("base64"), format: "mp3"};
    } catch (err: any) {
      console.error("[synthesizeSpeech] Polly failed:", err?.name, err?.message);
      // The app falls back to the device voice on any error.
      throw new HttpsError("unavailable", "Speech is unavailable right now.");
    }
  }
);
