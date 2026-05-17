/**
 * OpenCode Free Provider Extension
 *
 * Provides access to OpenCode's free tier models via their Zen API.
 * Uses "public" as the API key and sets the required x-opencode-client header.
 *
 * Usage:
 *   pi -e ~/.pi/agent/extensions/opencode-free.ts
 *   Then /model to select opencode-free/deepseek-v4-flash-free
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	pi.registerProvider("opencode-free", {
		name: "OpenCode Free",
		baseUrl: "https://opencode.ai/zen/v1",
		apiKey: "public",
		api: "openai-completions",
		authHeader: true,
		headers: {
			"User-Agent": "opencode/1.15.4 ai-sdk/provider-utils/4.0.23 runtime/bun/1.3.13",
			"x-opencode-client": "cli",
			"x-opencode-project": "6d474f8c1ac09f44f07b22991942c2ab0da6d63e",
			"x-opencode-request": "msg_e372db217001VGy70L3Ja6zafE",
			"x-opencode-session": "ses_1c8d24dfeffeOBTefYtgahcOHD",
		},
		models: [
			{
				id: "deepseek-v4-flash-free",
				name: "DeepSeek V4 Flash Free",
				reasoning: true,
				input: ["text"],
				cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
				contextWindow: 200000,
				maxTokens: 128000,
				compat: {
					requiresReasoningContentOnAssistantMessages: true,
					thinkingFormat: "deepseek",
				},
				thinkingLevelMap: {
					minimal: null,
					low: null,
					medium: null,
					high: "high",
					xhigh: "max",
				},
			},
		],
	});
}
