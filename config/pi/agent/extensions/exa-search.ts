/**
 * Exa Search Tools - Web and code search via Exa AI MCP
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { Type, StringEnum } from "@mariozechner/pi-ai";

const EXA_MCP_URL = "https://mcp.exa.ai/mcp";

async function exaMcpCall(toolName: string, args: object, timeout: number, signal: AbortSignal) {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), timeout);
  const combinedSignal = AbortSignal.any([controller.signal, signal]);

  try {
    const response = await fetch(EXA_MCP_URL, {
      method: "POST",
      headers: {
        "content-type": "application/json",
        accept: "application/json, text/event-stream",
      },
      body: JSON.stringify({
        jsonrpc: "2.0",
        id: 1,
        method: "tools/call",
        params: { name: toolName, arguments: args },
      }),
      signal: combinedSignal,
    });

    if (!response.ok) {
      throw new Error(`Exa API error: ${response.status}`);
    }

    const text = await response.text();
    for (const line of text.split("\n")) {
      if (line.startsWith("data: ")) {
        const data = JSON.parse(line.slice(6));
        if (data.result?.content?.[0]?.text) {
          return data.result.content[0].text;
        }
      }
    }
    return "No results found";
  } finally {
    clearTimeout(timeoutId);
  }
}

export default function (pi: ExtensionAPI) {
  const year = new Date().getFullYear();

  pi.registerTool({
    name: "websearch",
    label: "Web Search",
    description: `Search the web using Exa AI. Provides up-to-date information for current events and recent data. The current year is ${year}. Use this year when searching for recent information.`,
    parameters: Type.Object({
      query: Type.String({ description: "Search query" }),
      numResults: Type.Optional(Type.Number({ description: "Number of results (default: 8)" })),
    }),
    async execute(_id, params, signal) {
      const result = await exaMcpCall(
        "web_search_exa",
        {
          query: params.query,
          type: "auto",
          numResults: params.numResults ?? 8,
          livecrawl: "fallback",
        },
        25000,
        signal,
      );
      return { content: [{ type: "text", text: result }], details: {} };
    },
  });

  pi.registerTool({
    name: "codesearch",
    label: "Code Search",
    description:
      "Search for code examples, API documentation, and programming guides using Exa AI. Use for any programming-related question.",
    parameters: Type.Object({
      query: Type.String({ description: "Search query (e.g., 'React useState examples')" }),
      tokensNum: Type.Optional(
        Type.Number({ description: "Token count 1000-50000 (default: 5000)" }),
      ),
    }),
    async execute(_id, params, signal) {
      const result = await exaMcpCall(
        "get_code_context_exa",
        {
          query: params.query,
          tokensNum: params.tokensNum ?? 5000,
        },
        30000,
        signal,
      );
      return { content: [{ type: "text", text: result }], details: {} };
    },
  });
}
