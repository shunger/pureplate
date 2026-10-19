import assert from "node:assert/strict";
import {describe, it} from "node:test";
import {
  buildWhichRecipeQuestion,
  pickSection,
  splitSections,
} from "../lib/services/recipePhotoReader.js";
import {validateChatRequest} from "../lib/utils/requestLimits.js";

// The cookbook page that went wrong: the tail of Patsy Ralston's recipe above,
// all of Ruby Cutter's 3-Layer Salad, and the start of Apricot Salad.
const lines = [
  "For third layer, mix Dream Whip and milk as",
  "directed. Add cream cheese. Whip well. Spread on",
  "top of salad. Grated American cheese may be sprinkled",
  "on top, if desired.",
  "Patsy Ralston",
  "3-LAYER SALAD",
  "1 box lime jello   1 c. chopped pecans",
  "2 c. drained crushed pineapple",
  "Prepare jello and add other ingredients. Set",
  "until firm.",
  "Cook the pineapple juice, sugar, flour and eggs",
  "unitl thick. Cool and spread on layer 2. Sprinkle with",
  "nuts.",
  "Ruby Cutter",
  "APRICOT SALAD",
];
const titleLines = [5, 14];

describe("splitSections", () => {
  const sections = splitSections(lines, titleLines);

  it("ignores lines above the first title", () => {
    const all = sections.flatMap((s) => s.lines).join(" ");
    assert.doesNotMatch(all, /Patsy Ralston|American cheese|Dream Whip/);
  });

  it("ends a recipe at the next title, keeping its cook's name", () => {
    assert.deepEqual(sections.map((s) => s.title), ["3-LAYER SALAD", "APRICOT SALAD"]);
    assert.equal(sections[0].lines.at(-1), "Ruby Cutter");
    assert.deepEqual(sections[1].lines, []);
  });

  it("joins a recipe continued on the next photo", () => {
    // Photo 2 starts mid-recipe, with no title.
    assert.deepEqual(splitSections(["Pie", "1 crust", "Bake 40 minutes."], [0]),
      [{title: "Pie", lines: ["1 crust", "Bake 40 minutes."]}]);
  });

  it("treats an untitled card as one recipe", () => {
    assert.deepEqual(splitSections(["2 eggs"], []), [{title: "", lines: ["2 eggs"]}]);
  });

  it("ignores title marks that aren't real line numbers", () => {
    assert.deepEqual(splitSections(["Pie", "1 crust"], [0, 7, -1, 1.5]),
      [{title: "Pie", lines: ["1 crust"]}]);
  });
});

describe("pickSection", () => {
  const sections = splitSections(lines, titleLines);

  it("asks when several recipes show and none was named", () => {
    assert.equal(pickSection(sections, null), null);
    const question = buildWhichRecipeQuestion(sections);
    assert.match(question, /\*\*3-Layer Salad\*\*/);
    assert.match(question, /\*\*Apricot Salad\*\* \(cut off/);
  });

  it("takes the recipe the user named", () => {
    assert.equal(pickSection(sections, "3-Layer Salad")?.title, "3-LAYER SALAD");
    assert.equal(pickSection(sections, "apricot")?.title, "APRICOT SALAD");
  });

  it("takes the only recipe without asking", () => {
    assert.equal(pickSection(sections.slice(0, 1), null)?.title, "3-LAYER SALAD");
  });
});

describe("validateChatRequest images", () => {
  const base = {
    userMessage: "card please",
    preferenceSummary: {family: {}, pantry_items: [], expiring_soon: []},
  };

  it("keeps several photos in order", () => {
    const req = validateChatRequest({
      ...base,
      images: [
        {base64: "AAAA", mediaType: "image/jpeg"},
        {base64: "BBBB", mediaType: "image/png"},
      ],
    });
    assert.deepEqual(req.images?.map((i) => i.base64), ["AAAA", "BBBB"]);
    assert.equal(req.imageBase64, "AAAA");
  });

  it("still accepts the single-photo fields", () => {
    const req = validateChatRequest({...base, imageBase64: "AAAA", imageMediaType: "image/jpeg"});
    assert.equal(req.images?.length, 1);
  });

  it("rejects too many photos", () => {
    const images = Array.from({length: 5}, () => ({base64: "A", mediaType: "image/jpeg"}));
    assert.throws(() => validateChatRequest({...base, images}), /at most 4/);
  });
});
