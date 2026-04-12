import type { Plugin } from "@opencode-ai/plugin"

// Based on packages/opencode/src/session/index.ts
const DEFAULT_TITLE_REGEX = /^(New session - |Child session - )\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z$/

function isDefaultTitle(title: string | null | undefined): boolean {
  if (!title) return true
  return DEFAULT_TITLE_REGEX.test(title)
}

const server: Plugin = async ({ client }) => {
  return {
    "chat.message": async (input) => {
      const sessionID = input.sessionID

      try {
        const { data: session } = await client.session.get({
          path: { id: sessionID },
        })

        if (!isDefaultTitle(session?.title)) return
        if (session?.parentID) return

        const { data: messages = [] } = await client.session.messages({
          path: { id: sessionID },
          query: { limit: 20 },
        })

        // Find real (non-synthetic) user messages
        const realUserMessages = messages.filter((m) => {
          if (m.info.role !== "user") return false
          return m.parts?.some((p: any) => !p.synthetic)
        })

        // Only proceed on the first real user message
        if (realUserMessages.length !== 1) return

        const textParts = realUserMessages[0].parts
          ?.filter((p: any) => p.type === "text" && !p.synthetic)
          .map((p: any) => p.text)
          .join(" ")
          .trim()

        if (!textParts) return

        const title = textParts.length > 100 ? textParts.substring(0, 97) + "..." : textParts

        await client.session.update({
          path: { id: sessionID },
          body: { title },
        })
      } catch (error) {
        await client.app.log({
          body: {
            service: "simple-title",
            level: "error",
            message: "Failed to set title",
            extra: { error: String(error), sessionID },
          },
        })
      }
    },
  }
}

export default {
  id: "simple-title",
  server,
}
