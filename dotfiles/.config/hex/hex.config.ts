import { defineHexConfig } from "@hex/commands";
import { execFile } from "node:child_process";
import { promisify } from "node:util";

const run = promisify(execFile);

// Hex's config engine has no environment access, so ask fish for the key kept
// in the gitignored conf.d/local.fish.
async function readApiKey() {
  const { stdout } = await run("fish", [
    "-c",
    "source $HOME/.config/fish/conf.d/local.fish; printf %s $GEMINI_API_KEY",
  ]);
  if (stdout.length === 0) {
    throw new Error(
      "GEMINI_API_KEY is unset in ~/.config/fish/conf.d/local.fish",
    );
  }
  return stdout;
}

const MODEL = "gemma-4-26b-a4b-it";
const THINKING_LEVEL = "HIGH";
const GOOGLE_API = "https://generativelanguage.googleapis.com/v1beta/models";

const PROMPT = `
Clean the transcript:
- fix spelling, capitalization, and punctuation
- keep wording style, slang, and swearing
- drop filler words and self-corrections (keep only the final choice)
- no em dashes or emojis
- don't translate Indonesian

Reply with only the cleaned text, with no preamble or explanation.

Examples:
- Raw: "Hey, I'm sorry, but I really don't think we should meet tomorrow, I mean Tuesday" -> Cleaned: "Hey, I'm sorry, but I really don't think we should meet Tuesday."
- Raw: "We need to order five, no wait, ten boxes." -> Cleaned: "We need to order 10 boxes."
- Raw: "Can you call John...actually, call Sarah instead." -> Cleaned: "Can you call Sarah instead?"
`.trim();

type GemmaPart = { readonly text?: string; readonly thought?: boolean };

async function vocabularyLine() {
  const { stdout } = await run("hex", ["vocabulary", "list", "--json"]);
  const {
    entries,
  }: { entries: Array<{ term: string; sounds_like?: string[] }> } =
    JSON.parse(stdout);
  const terms = entries.map(({ term, sounds_like }) => {
    const alternatives = (sounds_like ?? [])
      .map((word) => `"${word}"`)
      .join(", ");
    return alternatives
      ? `${term} (often transcribed as ${alternatives})`
      : term;
  });
  return terms.length > 0
    ? `\n\nSpell these names exactly and keep their capitalization: ${terms.join("; ")}.`
    : "";
}

type GoogleError = Error & { status?: number };

async function generate(
  apiKey: string,
  prompt: string,
  text: string,
): Promise<string> {
  const response = await fetch(`${GOOGLE_API}/${MODEL}:generateContent`, {
    method: "POST",
    headers: {
      "content-type": "application/json",
      "x-goog-api-key": apiKey,
    },
    body: JSON.stringify({
      systemInstruction: { parts: [{ text: prompt }] },
      contents: [{ role: "user", parts: [{ text }] }],
      generationConfig: {
        thinkingConfig: { thinkingLevel: THINKING_LEVEL },
      },
    }),
  });

  if (!response.ok) {
    const error: GoogleError = new Error(`Google answered ${response.status}`);
    error.status = response.status;
    throw error;
  }

  const body = await response.json();
  const parts: GemmaPart[] = body.candidates?.[0]?.content?.parts ?? [];
  const content = parts
    .filter((part) => part.thought !== true)
    .map((part) => part.text ?? "")
    .join("");
  if (content.trim().length === 0) {
    throw new Error("Google returned no text");
  }

  return content;
}

export default defineHexConfig({
  transformations: {
    "transform-over-api": {
      name: "Transform over API",
      description: "Clean up the text with a model over an API",
      timeout: 60000,
      transform: async (text) => {
        const prompt = PROMPT + (await vocabularyLine());
        const apiKey = await readApiKey();
        for (let attempt = 1; ; attempt++) {
          try {
            return await generate(apiKey, prompt, text);
          } catch (error) {
            const status = (error as { status?: number }).status;
            const retryable = status !== undefined && status >= 500;
            if (!retryable || attempt >= 3) {
              throw error;
            }
          }
        }
      },
    },
  },
});
