import assert from "node:assert/strict";
import {describe, it} from "node:test";
import {LIMITS, validateVoiceScriptRequest} from "../lib/utils/requestLimits.js";
import {buildVoiceScriptUserPrompt, sanitizeVoiceScript} from "../lib/prompts/voiceScriptPrompt.js";

const recipe = {
  name: "Alfredo",
  ingredients: [
    {name: "heavy cream", quantity: "1", unit: "cup"},
    {name: "parmesan", quantity: "1/2", unit: "cup", optional: false},
  ],
  instructions: [
    {step_number: 1, instruction: "Warm the cream."},
    {step_number: 2, instruction: "Stir in the parmesan."},
  ],
};

describe("validateVoiceScriptRequest", () => {
  it("accepts what the app sends", () => {
    const r = validateVoiceScriptRequest(recipe);
    assert.equal(r.name, "Alfredo");
    assert.deepEqual(r.ingredients[1], {name: "parmesan", quantity: "1/2", unit: "cup", optional: false});
    assert.equal(r.instructions.length, 2);
  });

  it("requires steps and bounds the size", () => {
    assert.throws(() => validateVoiceScriptRequest({...recipe, instructions: []}), /Missing/);
    const many = Array.from({length: LIMITS.voiceScriptSteps + 1},
      (_, i) => ({step_number: i + 1, instruction: "x"}));
    assert.throws(() => validateVoiceScriptRequest({...recipe, instructions: many}), /too long/);
  });
});

describe("voice script prompt and output", () => {
  it("lists amounts with each ingredient", () => {
    const prompt = buildVoiceScriptUserPrompt(validateVoiceScriptRequest(recipe));
    assert.match(prompt, /- 1 cup heavy cream/);
    assert.match(prompt, /2\. Stir in the parmesan\./);
  });

  it("keeps known steps in recipe order and drops junk", () => {
    const script = sanitizeVoiceScript({
      steps: [
        {step_number: 2, lines: ["Add half a cup of parmesan.", 7, "  "]},
        {step_number: 9, lines: ["Invented step."]},
        {step_number: 1, lines: ["Pour one cup of heavy cream into a pan."]},
      ],
    }, validateVoiceScriptRequest(recipe));
    assert.deepEqual(script, {steps: [
      {step_number: 1, lines: ["Pour one cup of heavy cream into a pan."]},
      {step_number: 2, lines: ["Add half a cup of parmesan."]},
    ]});
    assert.deepEqual(sanitizeVoiceScript("nonsense", validateVoiceScriptRequest(recipe)), {steps: []});
  });
});
