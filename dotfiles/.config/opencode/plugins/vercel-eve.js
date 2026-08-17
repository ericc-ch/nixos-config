// OpenCode v2 plugin: route Vercel AI Gateway requests as Eve traffic.
//
// Vercel's GLM 5.2 promotion is free for requests carrying an Eve product
// token in the HTTP `User-Agent`. Without it the Gateway rejects
// unverified accounts with "credit-card-required" / customer verification.
// See http://the-box.barbel-fish.ts.net:8124/guide.md
//
// v2 plugin contract: `export default { id, setup }`. We register the
// `http.request` session hook — the same mechanism the built-in GitHub
// Copilot provider uses to attach per-provider headers — and set the
// Eve User-Agent on every request routed to the `vercel-eve` provider.
// No imports or node_modules needed.

const EVE_USER_AGENT = "eve/0.38.3"
const PROVIDER_ID = "vercel-eve"

export default {
  id: "vercel-eve.user-agent",
  async setup(ctx) {
    await ctx.session.hook("http.request", (event) => {
      if (event.model?.providerID !== PROVIDER_ID) return
      event.request.headers.set("User-Agent", EVE_USER_AGENT)
    })
  },
}
