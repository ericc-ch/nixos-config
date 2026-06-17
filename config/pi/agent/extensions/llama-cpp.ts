/**
 * Llama.cpp Local Provider Extension
 *
 * Connects pi to a local llama.cpp server running llama-server.
 * Auto-discovers loaded models from the /v1/models endpoint.
 *
 * Usage:
 *   1. Start llama-server:  llama-server -m path/to/model.gguf
 *   2. In pi, /model to select llama-cpp/<model-id>
 *   3. Optionally set as default in settings.json
 *
 * Default server URL: http://localhost:8080/v1
 * Set LLAMA_CPP_URL env var to override (e.g., "http://192.168.1.5:8080/v1")
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default async function (pi: ExtensionAPI) {
  const baseUrl = process.env["LLAMA_CPP_URL"] ?? "http://localhost:8080/v1";

  let models: Array<{ id: string; name?: string }>;

  try {
    const response = await fetch(`${baseUrl}/models`);
    if (!response.ok) throw new Error(`HTTP ${response.status}`);

    const payload = (await response.json()) as {
      data: Array<{
        id: string;
        object?: string;
        created?: number;
        owned_by?: string;
      }>;
    };

    models = payload.data.map((m) => ({
      id: m.id,
      name: m.id.replace(/\.(gguf|Q\d+.*)$/i, "").replaceAll(/-/g, " "),
    }));

    if (models.length === 0) throw new Error("No models returned");
  } catch (err) {
    // If server isn't running, register a placeholder so the provider
    // still appears. User can try again via /model.
    console.warn(
      `[llama-cpp] Could not reach ${baseUrl}/models —`,
      err instanceof Error ? err.message : String(err),
    );
    models = [
      {
        id: "local-model",
        name: "Default Local Model",
      },
    ];
  }

  pi.registerProvider("llama-cpp", {
    name: "Llama.cpp (Local)",
    baseUrl,
    apiKey: "not-needed",
    api: "openai-completions",
    authHeader: false,
    compat: {
      // llama.cpp doesn't support reasoning_effort (use --reasoning flag instead)
      supportsReasoningEffort: false,
      // llama.cpp uses max_tokens (not max_completion_tokens)
      maxTokensField: "max_tokens",
      // ✗ supportsDeveloperRole not needed — llama.cpp maps developer→system internally
    },
    models: models.map((m) => ({
      id: m.id,
      name: m.name ?? m.id,
      reasoning: false,
      input: ["text"],
      cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
      contextWindow: 8192,
      maxTokens: 4096,
    })),
  });
}
