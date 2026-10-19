import {callBedrock, callBedrockVisionImages, HAIKU_MODEL_ID} from "./bedrockService";
import {extractJson, validateChatResponse} from "../utils/responseParser";
import {ChatImage} from "../types";

/**
 * Turns photos of written recipes (cookbook pages, recipe cards) into recipe
 * cards:
 *
 * 1. Each photo is copied line by line, top to bottom, with no interpretation.
 * 2. A text-only pass marks which numbered lines are recipe titles.
 * 3. One recipe's lines — from its title up to the next title — are cut out
 *    here in code and only those are turned into a recipe card.
 *
 * Asking a model to read a page "as recipes" let it move text it thought
 * belonged elsewhere (the end of the recipe above, and its cook's name, were
 * moved into the next recipe). Copying lines verbatim and cutting by line
 * number in code keeps each recipe to what is printed between its title and
 * the next.
 */

export interface RecipeSection {
  title: string;
  lines: string[];
}

interface PhotoLines {
  kind: "written_recipe" | "other";
  lines: string[];
}

interface TitleMarks {
  title_lines: number[];
  requested_title_line: number | null;
}

export interface PhotoReaderResult {
  responseText: string;
  recipes: any[];
}

const OCR_SYSTEM_PROMPT = `You are an OCR engine. Copy the printed or handwritten text in the photo, line by line, exactly as it appears from the TOP edge of the photo to the BOTTOM edge. Output ONLY valid JSON, no markdown fences:
{"kind": "written_recipe" | "other", "lines": ["string"]}

- "kind": "written_recipe" when the photo shows the written text of a recipe (cookbook page, recipe card, handwritten note, clipping, screenshot); otherwise "other" with an empty "lines" array.
- Copy text only. Do NOT interpret, reorder, group, fix, or leave out anything. The first line you output is the topmost line of text in the photo, even when it is the end of a sentence or of another recipe; the last is the bottommost, even when it is the start of the next recipe.
- One entry per printed line. When a line has two columns (e.g. two ingredients side by side), keep both on the one line separated by "   ".
- Skip only text that is not part of the page's recipes: a page number, a tab or sticker sticking out at the edge, text on a different page in the background.`;

const TITLE_SYSTEM_PROMPT = `You are given numbered lines copied from cookbook pages or recipe cards, in order. Mark the lines that are recipe titles. Output ONLY valid JSON, no markdown fences:
{"title_lines": [number], "requested_title_line": number or null}

- A recipe title is the heading that names a recipe (e.g. "3-LAYER SALAD", "Grandma's Apple Pie"), usually short, often in capitals. NOT titles: ingredient lines, method sentences, sub-headings inside a recipe ("Topping:", "For the sauce"), and people's names (cookbooks print each contributor's name under their recipe).
- "requested_title_line": when the user's message picks one of the recipes (by name, or "the first one", "the second one"), that recipe's title line number; otherwise null.`;

const STRUCTURE_SYSTEM_PROMPT = `You turn the text of ONE written recipe into JSON for a recipe card. Use only the text given; add nothing that isn't in it. Output ONLY valid JSON, no markdown fences:
{
  "name": "string",
  "credit": "string or null",
  "description": "string",
  "cuisine": "string",
  "prep_time": number,
  "cook_time": number,
  "servings": number,
  "ingredients": [{"name": "string", "quantity": "string", "unit": "string", "category": "string", "optional": boolean}],
  "instructions": [{"step_number": number, "instruction": "string", "time_minutes": number or null, "tip": null}],
  "nutrition": {"calories": number, "protein": number, "carbs": number, "fat": number, "fiber": number}
}

RULES:
- "name": the recipe's title, in Title Case.
- Ingredients: every ingredient listed, with its amount and unit exactly as written (keep "c.", "Tbsp.", "pkg. (3 oz.)"). An ingredient with no amount gets "" for quantity and unit. "optional" is true only when the text says so.
- Instructions: the method in its original order, split into one step per action or sentence, keeping the original wording. "tip" is always null. "time_minutes" only when the step states a time, otherwise null.
- "credit": the person the recipe is from — typically a name on its own line at the very end, or "From the kitchen of …". null when there is none. Never make the credit an ingredient or a step.
- Estimate prep_time, cook_time, servings (when not given) and nutrition per serving. "description" is one short sentence about the dish. "category" is a grocery category such as produce, dairy, meat, pantry, spices, frozen, bakery.`;

const TRANSIENT_ERRORS = new Set([
  "ServiceUnavailableException",
  "ThrottlingException",
  "ModelNotReadyException",
  "InternalServerException",
  "TimeoutError",
]);

/** Retries Bedrock's momentary "unable to process" errors. */
async function withRetry<T>(call: () => Promise<T>, attempts = 3): Promise<T> {
  for (let attempt = 1; ; attempt++) {
    try {
      return await call();
    } catch (err: any) {
      if (attempt >= attempts || !TRANSIENT_ERRORS.has(err?.name)) throw err;
      console.warn(`[recipePhotoReader] ${err?.name}, retry ${attempt}`);
      await new Promise((r) => setTimeout(r, 1500 * attempt));
    }
  }
}

/**
 * Splits copied lines into recipes, each running from its title line up to
 * the next title line. Lines before the first title (the end of the recipe
 * before) are dropped.
 */
export function splitSections(lines: string[], titleLines: number[]): RecipeSection[] {
  const titles = new Set(titleLines.filter((i) => Number.isInteger(i) && i >= 0 && i < lines.length));
  const sections: RecipeSection[] = [];
  const untitled: string[] = [];
  lines.forEach((raw, i) => {
    const text = typeof raw === "string" ? raw.trim() : "";
    if (!text) return;
    if (titles.has(i)) {
      sections.push({title: text, lines: []});
    } else if (sections.length > 0) {
      sections[sections.length - 1].lines.push(text);
    } else {
      untitled.push(text);
    }
  });
  // A card with no title at all is one recipe.
  if (sections.length === 0 && untitled.length > 0) {
    return [{title: "", lines: untitled}];
  }
  return sections;
}

function normalize(title: string): string {
  return title.toLowerCase().replace(/[^a-z0-9]+/g, " ").trim();
}

/**
 * The recipe to make a card for: the one the user named, or the only one.
 * Null means ask which one.
 */
export function pickSection(
  sections: RecipeSection[],
  requestedTitle: string | null | undefined
): RecipeSection | null {
  if (requestedTitle) {
    const wanted = normalize(requestedTitle);
    const match =
      sections.find((s) => normalize(s.title) === wanted) ??
      sections.find((s) => wanted && normalize(s.title).includes(wanted));
    if (match) return match;
  }
  return sections.length === 1 ? sections[0] : null;
}

/** A section with no ingredients or method yet (cut off by the photo). */
function isCutOff(section: RecipeSection): boolean {
  return section.lines.join(" ").length < 40;
}

export function buildWhichRecipeQuestion(sections: RecipeSection[]): string {
  const names = sections.map((s) =>
    `- **${titleCase(s.title)}**${isCutOff(s) ? " (cut off — add a photo of the next page to get all of it)" : ""}`
  );
  return `I can see ${sections.length} recipes here:\n${names.join("\n")}\n\nWhich one should I make a recipe card for?`;
}

function titleCase(title: string): string {
  return title
    .toLowerCase()
    .replace(/(^|[\s\-(])([a-z])/g, (_m, p: string, c: string) => p + c.toUpperCase());
}

/**
 * Reads recipe photos. Returns null when the photos aren't of a written recipe,
 * so the caller can answer them as ordinary food photos.
 */
export async function readRecipePhotos(
  images: ChatImage[],
  userMessage: string
): Promise<PhotoReaderResult | null> {
  // Each photo on its own, so pages stay in the order they were sent.
  const pages = await Promise.all(images.map(async (image) =>
    extractJson<PhotoLines>(await withRetry(() => callBedrockVisionImages(
      OCR_SYSTEM_PROMPT,
      "Copy every line of text in this photo, top to bottom.",
      [image],
      {temperature: 0, maxTokens: 4096, modelId: HAIKU_MODEL_ID}
    )))
  ));
  if (!pages.some((p) => p?.kind === "written_recipe")) return null;
  const lines = pages.flatMap((p) =>
    Array.isArray(p?.lines) ? p.lines.filter((l) => typeof l === "string") : []
  );
  if (lines.length === 0) return null;

  const numbered = lines.map((l, i) => `${i}: ${l}`).join("\n");
  const marks = extractJson<TitleMarks>(await withRetry(() => callBedrock(
    TITLE_SYSTEM_PROMPT,
    `LINES:\n${numbered}\n\nUSER'S MESSAGE: ${userMessage}`,
    {temperature: 0, maxTokens: 300, modelId: HAIKU_MODEL_ID}
  )));
  const titleLines = Array.isArray(marks?.title_lines) ? marks.title_lines : [];
  const sections = splitSections(lines, titleLines);
  if (sections.length === 0) return null;

  const requested = typeof marks?.requested_title_line === "number" ?
    lines[marks.requested_title_line] ?? null :
    null;
  console.log(
    `[recipePhotoReader] photos=${images.length} lines=${lines.length} ` +
      `first=${JSON.stringify(lines.slice(0, 3))} titles=${JSON.stringify(sections.map((s) => s.title))} ` +
      `requested=${JSON.stringify(requested)}`
  );

  const section = pickSection(sections, requested);
  if (!section) {
    return {responseText: buildWhichRecipeQuestion(sections), recipes: []};
  }

  const recipeText = [section.title, ...section.lines].filter((l) => l).join("\n");
  const structured = extractJson<any>(await withRetry(() => callBedrock(
    STRUCTURE_SYSTEM_PROMPT,
    `RECIPE TEXT:\n${recipeText}`,
    {temperature: 0, maxTokens: 4096, modelId: HAIKU_MODEL_ID}
  )));
  const recipe = {...structured, from_photo: true};
  if (!recipe.name && section.title) recipe.name = titleCase(section.title);
  const {recipes} = validateChatResponse({responseText: "", recipes: [recipe]});
  const saved = recipes[0];

  const from = saved.credit ? ` (recipe from ${saved.credit})` : "";
  const cutOff = isCutOff(section) ?
    " It looks cut off — send the next page too and I'll fill in the rest." :
    "";
  return {
    responseText: `Saved **${saved.name}**${from} to your recipes.${cutOff}`,
    recipes,
  };
}
