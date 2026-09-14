import assert from "node:assert/strict";
import {readFileSync} from "node:fs";
import {describe, it} from "node:test";
import {
  LIMITS,
  sanitizePreferenceSummary,
  trimChatHistory,
  validateChatRequest,
  validatePlanRequest,
} from "../lib/utils/requestLimits.js";

const sample = JSON.parse(
  readFileSync(new URL("./fixtures/samplePreferenceSummary.json", import.meta.url), "utf8")
);

function rejects(fn, messagePart) {
  assert.throws(fn, (err) => {
    assert.equal(err.code, "invalid-argument");
    if (messagePart) assert.match(err.message, messagePart);
    return true;
  });
}

describe("sanitizePreferenceSummary", () => {
  it("keeps everything the prompts use from a real app payload", () => {
    const summary = sanitizePreferenceSummary({...sample, pantry_only: true});

    assert.deepEqual(summary.family, {...sample.family, skill_level: undefined,
      spice_tolerance: undefined, variety_preference: undefined});
    assert.deepEqual(summary.pantry_items, sample.pantry_items);
    assert.deepEqual(summary.expiring_soon, sample.expiring_soon);
    assert.deepEqual(summary.staples_available, sample.staples_available);
    assert.deepEqual(summary.cuisine_affinities, sample.cuisine_affinities);
    assert.deepEqual(summary.loved_ingredients, sample.loved_ingredients);
    assert.deepEqual(summary.recent_meals_14d, sample.recent_meals_14d);
    assert.deepEqual(summary.recent_suggestions, []);
    assert.equal(summary.pantry_only, true);
  });

  it("bounds oversized lists and strings", () => {
    const summary = sanitizePreferenceSummary({
      ...sample,
      pantry_items: Array.from({length: 1000}, (_, i) => ({name: `item ${i}`})),
      loved_ingredients: Array.from({length: 1000}, () => "x".repeat(10_000)),
      cuisine_affinities: Object.fromEntries(
        Array.from({length: 500}, (_, i) => [`cuisine ${i}`, 9])
      ),
      family: {...sample.family, adults: 1e9, dietary_restrictions: ["y".repeat(5000)]},
    });

    assert.equal(summary.pantry_items.length, LIMITS.pantryItems);
    assert.equal(summary.loved_ingredients.length, LIMITS.listEntries);
    assert.equal(summary.loved_ingredients[0].length, LIMITS.textChars);
    assert.equal(Object.keys(summary.cuisine_affinities).length, LIMITS.cuisineEntries);
    assert.equal(Object.values(summary.cuisine_affinities)[0], 1);
    assert.equal(summary.family.adults, LIMITS.familyMembers);
    assert.equal(summary.family.dietary_restrictions[0].length, LIMITS.textChars);
  });

  it("turns missing or mistyped fields into empty values instead of crashing", () => {
    const summary = sanitizePreferenceSummary({
      pantry_items: "lots",
      family: null,
      expiring_soon: [null, 7, {quantity: 2}, {name: "milk"}],
    });

    assert.deepEqual(summary.pantry_items, []);
    assert.equal(summary.family.adults, 0);
    assert.deepEqual(summary.family.dietary_restrictions, []);
    assert.deepEqual(summary.expiring_soon, [{name: "milk"}]);
    assert.equal(sanitizePreferenceSummary("nope"), undefined);
  });
});

describe("trimChatHistory", () => {
  it("leaves normal-length history alone", () => {
    assert.equal(trimChatHistory("User: hi\nChef: hello"), "User: hi\nChef: hello");
  });

  it("keeps the newest turns of a long session", () => {
    const history = "old turn\n".repeat(10_000) + "User: newest question";
    const trimmed = trimChatHistory(history);

    assert.ok(trimmed.length <= LIMITS.chatHistoryChars);
    assert.ok(trimmed.endsWith("User: newest question"));
  });

  it("keeps the recipe being modified at the start", () => {
    const recipe = "[Recipe: Pad Thai]\nIngredients: noodles\n[/Recipe]\n";
    const trimmed = trimChatHistory(recipe + "Chef: tip\n".repeat(10_000) + "User: less salt?");

    assert.ok(trimmed.length <= LIMITS.chatHistoryChars);
    assert.ok(trimmed.startsWith("[Recipe: Pad Thai]"));
    assert.ok(trimmed.includes("[/Recipe]"));
    assert.ok(trimmed.endsWith("User: less salt?"));
  });
});

describe("validateChatRequest", () => {
  const valid = {userMessage: "What's for dinner?", chatHistory: "", preferenceSummary: sample};

  it("accepts what the app sends", () => {
    const request = validateChatRequest({...valid, activePlan: "Mon: tacos"});
    assert.equal(request.userMessage, valid.userMessage);
    assert.equal(request.activePlan, "Mon: tacos");
    assert.equal(request.imageBase64, undefined);
  });

  it("requires a message and a preference summary", () => {
    rejects(() => validateChatRequest({...valid, userMessage: "  "}), /Missing required fields/);
    rejects(() => validateChatRequest({...valid, preferenceSummary: undefined}), /Missing required fields/);
    rejects(() => validateChatRequest(null), /Missing required fields/);
  });

  it("rejects a message that's too long", () => {
    rejects(
      () => validateChatRequest({...valid, userMessage: "x".repeat(LIMITS.userMessageChars + 1)}),
      /too long/
    );
    validateChatRequest({...valid, userMessage: "x".repeat(LIMITS.userMessageChars)});
  });

  it("accepts supported photos and rejects other types or oversized ones", () => {
    const request = validateChatRequest({...valid, imageBase64: "aGk=", imageMediaType: "image/png"});
    assert.equal(request.imageMediaType, "image/png");

    rejects(
      () => validateChatRequest({...valid, imageBase64: "aGk=", imageMediaType: "image/svg+xml"}),
      /Unsupported image/
    );
    rejects(
      () => validateChatRequest({
        ...valid,
        imageBase64: "a".repeat(LIMITS.imageBase64Chars + 1),
        imageMediaType: "image/jpeg",
      }),
      /too large/
    );
  });

  it("trims an oversized history and active plan", () => {
    const request = validateChatRequest({
      ...valid,
      chatHistory: "turn\n".repeat(20_000),
      activePlan: "p".repeat(LIMITS.activePlanChars * 2),
    });
    assert.ok(request.chatHistory.length <= LIMITS.chatHistoryChars);
    assert.equal(request.activePlan.length, LIMITS.activePlanChars);
  });
});

describe("validatePlanRequest", () => {
  const valid = {
    feature: "quick_plan",
    days: 5,
    dayLabels: ["Mon", "Tue", "Wed", "Thu", "Fri"],
    mealType: "dinner",
    preferenceSummary: sample,
  };

  it("accepts what the app sends", () => {
    const request = validatePlanRequest(valid);
    assert.equal(request.days, 5);
    assert.deepEqual(request.dayLabels, valid.dayLabels);
    assert.equal(request.mealType, "dinner");
  });

  it("requires days and a preference summary", () => {
    rejects(() => validatePlanRequest({...valid, days: undefined}), /Missing required fields/);
    rejects(() => validatePlanRequest({...valid, preferenceSummary: []}), /Missing required fields/);
  });

  it("limits the plan length", () => {
    rejects(() => validatePlanRequest({...valid, days: LIMITS.planDays + 1}), /1 to/);
    rejects(() => validatePlanRequest({...valid, days: 2.5}), /1 to/);
    rejects(() => validatePlanRequest({...valid, days: -3}), /1 to/);
    assert.equal(validatePlanRequest({...valid, days: LIMITS.planDays}).days, LIMITS.planDays);
  });

  it("bounds day labels to the plan length", () => {
    const request = validatePlanRequest({
      ...valid,
      days: 2,
      dayLabels: ["Mon", "Tue", "x".repeat(1000)],
    });
    assert.deepEqual(request.dayLabels, ["Mon", "Tue"]);
  });
});
