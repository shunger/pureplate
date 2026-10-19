import {VoiceScript, VoiceScriptRequest} from "../types";

/**
 * System prompt that turns a written recipe into the hands-free script the
 * voice cooking assistant reads one line at a time.
 */
export function buildVoiceScriptSystemPrompt(): string {
  return `You turn a written recipe into a hands-free spoken script. The cook's hands are busy and they cannot look at or scroll the screen, so everything they need must be in what you say. A voice reads your lines aloud ONE AT A TIME, and the cook says "next" when they're ready for the following line.

HOW TO WRITE THE LINES:
- One action per line. Never put two things to do in the same line.
- When a step adds several ingredients, give each ingredient its own line with its exact amount: "Add one cup of heavy cream." then "Now add half a cup of grated parmesan."
- Always say the amount from the ingredient list. Never say "the cream" or "the spices" without the amount. If an ingredient is used in more than one step, say how much to use this time ("Add half of the garlic, about two cloves.").
- Prep actions get their own lines too: "Dice one medium onion."
- Say how to tell it's done, by sight, smell, or feel, plus the time: "Stir until it starts to thicken, about three minutes."
- If a line involves waiting two minutes or more, end it with a timer offer using the exact phrase "Say set a timer for N minutes if you want one." with N written as digits.
- Keep each line short: one or two sentences, under about 25 words.
- Talk like a friendly cook standing next to them. Use contractions. Vary how lines start ("Now", "Next", "Then", "Okay"), but don't start every line with a filler word.
- Spell out amounts the way people say them: "half a teaspoon", "one and a half cups", "three hundred fifty degrees". Never use abbreviations (tbsp, tsp, oz, lb, °F), fractions like 1/2, symbols, numbering, lists, or markdown.
- Don't tell them to say "next"; the app does that. Don't mention step numbers or the screen.
- Don't add ingredients or steps that aren't in the recipe, and don't skip any.
- Every written step must appear, in order, with at least one line.

RESPONSE FORMAT — Output ONLY valid JSON, no markdown fences, no preamble:
{"steps": [{"step_number": 1, "lines": ["...", "..."]}]}`;
}

export function buildVoiceScriptUserPrompt(recipe: VoiceScriptRequest): string {
  const ingredients = recipe.ingredients.map((i) => {
    const amount = [i.quantity, i.unit].filter((s) => s).join(" ");
    return `- ${amount ? `${amount} ` : ""}${i.name}${i.optional ? " (optional)" : ""}`;
  }).join("\n");
  const steps = recipe.instructions
    .map((s) => `${s.step_number}. ${s.instruction}`)
    .join("\n");

  return `RECIPE: ${recipe.name}

INGREDIENTS:
${ingredients || "- (none listed)"}

WRITTEN STEPS:
${steps}`;
}

/**
 * Keeps only well-formed lines for steps that exist in the recipe, in recipe
 * order. A step the model missed is left out; the app falls back to its own
 * wording for that step.
 */
export function sanitizeVoiceScript(
  parsed: unknown,
  recipe: VoiceScriptRequest
): VoiceScript {
  const raw = (parsed as {steps?: unknown})?.steps;
  const byNumber = new Map<number, string[]>();
  if (Array.isArray(raw)) {
    for (const step of raw) {
      const number = (step as {step_number?: unknown})?.step_number;
      const lines = (step as {lines?: unknown})?.lines;
      if (typeof number !== "number" || !Array.isArray(lines)) continue;
      const clean = lines
        .filter((l): l is string => typeof l === "string")
        .map((l) => l.trim().slice(0, 400))
        .filter((l) => l !== "")
        .slice(0, 20);
      if (clean.length > 0) byNumber.set(number, clean);
    }
  }

  return {
    steps: recipe.instructions
      .filter((s) => byNumber.has(s.step_number))
      .map((s) => ({step_number: s.step_number, lines: byNumber.get(s.step_number)!})),
  };
}
