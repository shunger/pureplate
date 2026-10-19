import {onCall, HttpsError} from "firebase-functions/v2/https";
import {initializeApp, getApps} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";
import {BedrockRuntimeClient, InvokeModelCommand} from "@aws-sdk/client-bedrock-runtime";
import sharp from "sharp";
import {awsClientConfig, bedrockSecrets, callBedrock, HAIKU_MODEL_ID} from "../services/bedrockService";
import {extractJson} from "../utils/responseParser";
import {checkKillSwitch} from "../middleware/killSwitch";
import {isEntitled} from "../services/entitlementService";

if (getApps().length === 0) initializeApp();

/**
 * Stability AI image models on Bedrock (Amazon's Nova Canvas reached end
 * of life on 2026-09-30). Only offered in us-west-2.
 */
/**
 * Stable Image Ultra: it follows a description much more closely than Stable
 * Image Core (layer order, serving style), at about twice the price, so the
 * first photo is right rather than needing a redraw.
 */
const IMAGE_MODEL_ID = "stability.stable-image-ultra-v1:1";
const IMAGE_REGION = "us-west-2";

/** Photos a day per account, so a runaway client can't run up the bill. */
const DAILY_LIMIT_PREMIUM = 80;
const DAILY_LIMIT_FREE = 20;

const DAY_MS = 24 * 60 * 60 * 1000;

interface ImageRequest {
  name: string;
  description: string;
  cuisine: string;
  ingredients: string[];
  /** The method, so the picture shows the dish the steps make. */
  steps: string[];
}

function text(value: unknown, max: number): string {
  return typeof value === "string" ? value.trim().slice(0, max) : "";
}

function validate(data: unknown): ImageRequest {
  const raw = (data && typeof data === "object" ? data : {}) as Record<string, unknown>;
  const name = text(raw.name, 120);
  if (!name) {
    throw new HttpsError("invalid-argument", "Missing required field: name");
  }
  const ingredients = Array.isArray(raw.ingredients) ?
    raw.ingredients.map((i) => text(i, 40)).filter((i) => i).slice(0, 8) :
    [];
  const steps = Array.isArray(raw.steps) ?
    raw.steps.map((st) => text(st, 300)).filter((st) => st).slice(0, 20) :
    [];
  return {
    name,
    description: text(raw.description, 300),
    cuisine: text(raw.cuisine, 40),
    ingredients,
    steps,
  };
}

/** Counts this request against the day's limit; throws when it's used up. */
async function consumeDailyQuota(uid: string, limit: number): Promise<void> {
  const db = getFirestore();
  const ref = db.doc(`users/${uid}/quota/recipeImages`);
  const now = Date.now();
  await db.runTransaction(async (tx) => {
    const data = (await tx.get(ref)).data() as {dayStart?: number; count?: number} | undefined;
    const fresh = !data?.dayStart || now - data.dayStart >= DAY_MS;
    const count = fresh ? 0 : data?.count ?? 0;
    if (count >= limit) {
      throw new HttpsError("resource-exhausted", "Daily recipe photo limit reached.");
    }
    tx.set(ref, {dayStart: fresh ? now : data!.dayStart, count: count + 1});
  });
}

const DESCRIBE_SYSTEM_PROMPT = `You write the prompt for an image model that will photograph a finished dish. Read the recipe and picture the dish exactly as these steps make it and as it is served. Output ONLY valid JSON, no markdown fences:
{"look": "string", "avoid": ["string"]}

- "look": at most 50 words describing only what the camera sees, WITHOUT the recipe's name: how it is served, following the steps (anything spread or poured into a pan and set, chilled, or baked until firm is served as a cut square on a plate showing its layers from the side; soups and stews in a bowl; skillet dishes on a plate), its shape, then its parts in the order the camera meets them: start with the TOP surface and its garnish (the image model draws the first thing named on top), then each layer below it in order down to the bottom, saying "on top", "in the middle", "on the bottom". Work the layers out from the steps: the first thing put in the pan is the bottom, and each thing spread or poured on afterwards goes above it, so the LAST thing spread on is the top (then any garnish sprinkled over it). Give colours and textures. Name only the garnish the steps actually put on top; fruit or nuts mixed into a layer show only inside that layer, never as pieces on top. An ingredient that is cooked, mixed, set, or blended in is not seen whole (lime jello is a smooth set green gelatin layer, not limes; crushed pineapple mixed into it shows only as small flecks).
- "avoid": up to 8 short things the image model might wrongly draw for this dish, e.g. whole or sliced fruit that is only an ingredient, a glass trifle bowl (unless the steps say to serve it in one), leafy greens for a dessert "salad", fruit cubes on top, a crust the recipe doesn't have.`;

interface DishLook {
  look: string;
  avoid: string[];
}

/**
 * What the finished dish looks like, read from the whole recipe. The name and
 * ingredient list alone mislead the image model (it drew limes and a trifle
 * bowl for a layered lime-jello "3-Layer Salad").
 */
async function describeDish(r: ImageRequest): Promise<DishLook | null> {
  if (r.steps.length === 0) return null;
  try {
    const recipe = [
      `Recipe: ${r.name}`,
      r.description && `Description: ${r.description}`,
      r.ingredients.length && `Ingredients: ${r.ingredients.join(", ")}`,
      `Steps:\n${r.steps.map((st, i) => `${i + 1}. ${st}`).join("\n")}`,
    ].filter(Boolean).join("\n");
    const parsed = extractJson<Partial<DishLook>>(await callBedrock(DESCRIBE_SYSTEM_PROMPT, recipe, {
      temperature: 0.2,
      maxTokens: 300,
      modelId: HAIKU_MODEL_ID,
    }));
    const look = typeof parsed?.look === "string" ?
      parsed.look.replace(/\s+/g, " ").trim().slice(0, 500) :
      "";
    if (!look) return null;
    const avoid = Array.isArray(parsed?.avoid) ?
      parsed.avoid.filter((a): a is string => typeof a === "string")
        .map((a) => a.trim().slice(0, 40)).filter((a) => a).slice(0, 8) :
      [];
    console.log(`[generateRecipeImage] look=${JSON.stringify(look)} avoid=${JSON.stringify(avoid)}`);
    return {look, avoid};
  } catch (err: any) {
    console.warn("[generateRecipeImage] describe failed:", err?.name, err?.message);
    return null;
  }
}

const BASE_NEGATIVE_PROMPT =
  "text, words, letters, watermark, logo, menu, people, hands, " +
  "cartoon, illustration, drawing, blurry, raw meat, packaging";

export function buildNegativePrompt(look?: DishLook | null): string {
  return [BASE_NEGATIVE_PROMPT, ...(look?.avoid ?? [])].join(", ").slice(0, 1000);
}

export function buildImagePrompt(r: ImageRequest, look?: DishLook | null): string {
  if (look) {
    // The name is left out: words like "salad" pull the picture toward the
    // usual dish of that name rather than this recipe.
    return (
      `Realistic, appetizing food photograph. ${look.look} ` +
      "Home-cooked, on a kitchen table, soft natural light, shallow depth of field, shot from slightly above"
    ).slice(0, 1000);
  }
  const parts = [`Appetizing, realistic food photograph of ${r.name}`];
  if (r.cuisine) parts.push(`${r.cuisine} cuisine`);
  if (r.description) parts.push(r.description);
  if (r.ingredients.length) parts.push(`made with ${r.ingredients.join(", ")}`);
  parts.push(
    "plated as a home-cooked meal on a kitchen table, soft natural light, " +
      "shallow depth of field, shot from slightly above"
  );
  return parts.join(". ").slice(0, 1000);
}

/**
 * Creates a photo for a recipe that has none (AI-made recipes), using
 * Stable Image Ultra, and returns it as a compact JPEG. The app saves it on the
 * device, so each recipe is only drawn once.
 */
export const generateRecipeImage = onCall(
  {
    enforceAppCheck: true,
    timeoutSeconds: 90,
    memory: "1GiB",
    secrets: bedrockSecrets,
  },
  async (request) => {
    const isEmulator = process.env.FUNCTIONS_EMULATOR === "true";
    if (!isEmulator && !request.auth) {
      throw new HttpsError("permission-denied", "Authentication required.");
    }

    checkKillSwitch();

    const recipe = validate(request.data);
    const uid = request.auth?.uid ?? "emulator-test-user";
    const premium = isEmulator || await isEntitled(uid);
    await consumeDailyQuota(uid, premium ? DAILY_LIMIT_PREMIUM : DAILY_LIMIT_FREE);

    const look = await describeDish(recipe);
    try {
      const client = new BedrockRuntimeClient({...awsClientConfig(), region: IMAGE_REGION});
      const res = await client.send(new InvokeModelCommand({
        modelId: IMAGE_MODEL_ID,
        contentType: "application/json",
        accept: "application/json",
        body: JSON.stringify({
          prompt: buildImagePrompt(recipe, look),
          negative_prompt: buildNegativePrompt(look),
          aspect_ratio: "3:2",
          output_format: "jpeg",
        }),
      }));

      const body = JSON.parse(new TextDecoder().decode(res.body)) as {
        images?: string[];
        finish_reasons?: (string | null)[];
      };
      const filtered = body.finish_reasons?.find((r) => r);
      if (filtered) {
        // The model's content filter declined this prompt.
        console.warn(`[generateRecipeImage] filtered: ${filtered}`);
        throw new HttpsError("failed-precondition", "Couldn't make a photo for this recipe.");
      }
      const image = body.images?.[0];
      if (!image) throw new Error("Stable Image Ultra returned no image");

      const jpeg = await sharp(Buffer.from(image, "base64"))
        .resize(800, 600, {fit: "cover"})
        .jpeg({quality: 78, mozjpeg: true})
        .toBuffer();

      console.log(`[generateRecipeImage] uid=${uid} bytes=${jpeg.length}`);
      return {image: jpeg.toString("base64"), format: "jpeg"};
    } catch (err: any) {
      if (err instanceof HttpsError) throw err;
      // A refused prompt is a permanent answer for this recipe rather than a
      // transient fault.
      if (err?.name === "ValidationException") {
        console.warn("[generateRecipeImage] refused:", err?.message);
        throw new HttpsError("failed-precondition", "Couldn't make a photo for this recipe.");
      }
      console.error("[generateRecipeImage] failed:", err?.name, err?.message);
      throw new HttpsError("unavailable", "Recipe photos are unavailable right now.");
    }
  }
);
