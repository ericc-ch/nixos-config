import type { Plugin } from "@opencode-ai/plugin"

const server: Plugin = async ({ client }) => {
  const titledSessions = new Set<string>()

  return {
    "chat.message": async (input, output) => {
      const sessionID = input.sessionID

      if (titledSessions.has(sessionID)) return
      titledSessions.add(sessionID)

      // Extract text from non-synthetic text parts
      const textParts = output.parts
        .filter((part) => part.type === "text" && !part.synthetic)
        .map((part) => (part as { text: string }).text)
        .join(" ")
        .trim()

      if (!textParts) return

      const title = textParts.length > 100 ? textParts.substring(0, 97) + "..." : textParts

      await client.session.update({
        path: { id: sessionID },
        body: { title },
      })
    },
  }
}

export default {
  id: "simple-title",
  server,
}
