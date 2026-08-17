import { Plugin } from "@opencode-ai/plugin"

const EVE_USER_AGENT = "eve/0.38.3"
const GATEWAY_ORIGIN = "https://ai-gateway.vercel.sh"

export default Plugin.define({
  id: "vercel-eve.user-agent",
  setup: async (ctx) => {
    await ctx.session.hook("http.request", (event) => {
      const url = new URL(event.request.url)
      if (url.origin !== GATEWAY_ORIGIN) return
      event.request.headers.set("User-Agent", EVE_USER_AGENT)
    })
  },
})
