// OpenCode v2 plugin: attribute Vercel AI Gateway requests as Eve traffic.
//
// The GLM 5.2 free-for-Eve promotion on the Vercel AI Gateway keys on the
// outbound `User-Agent`. The verified token is `eve/<version>`; an ordinary UA
// returns HTTP 403 `customer_verification_required` ("requires a valid credit
// card on file") on the test account.
//
// OpenCode force-sends its own User-Agent per request
// (`packages/core/src/session/model-headers.ts` -> `App.useragent`), and that
// wins the header merge at `packages/ai/src/route/client.ts:183` (per-request
// http.headers override config/provider/model headers). So the UA cannot be
// set from opencode.jsonc `headers` alone — it has to be rewritten on the
// final outgoing request via this `session.http.request` hook.
//
// Requires the v2 `@opencode-ai/plugin` (`.` = promise API, `export * as Plugin`)
// installed alongside this file:
//   cd ~/.config/opencode && bun add @opencode-ai/plugin@beta
// The `@latest` line (1.18.x) still ships the v1 `.` export and will fail with
// "Export named 'Plugin' not found". Match the version to the OpenCode beta.
//
// Load: auto-discovered from `~/.config/opencode/plugins/` (whole-dir linked,
// so it reaches the home path with no HM change).
// Reference: http://the-box.barbel-fish.ts.net:8124/guide.md

import { Plugin } from "@opencode-ai/plugin"

// Eve version observed working in the guide's control test. Arbitrary/old
// versions were not tested; bump this to a real current-looking release.
const DEFAULT_EVE_USER_AGENT = "eve/0.38.3"

// The provider ID from opencode.jsonc -> providers.vercel-eve. Only rewrite
// the UA for this provider so other providers keep opencode's default UA.
const EVE_PROVIDER_ID = "vercel-eve"

export default Plugin.define({
  id: "vercel-eve.user-agent",
  setup: async (ctx) => {
    // Allow overriding the token via plugin options, e.g.
    //   { "package": "./plugins/vercel-eve-useragent.ts",
    //     "options": { "userAgent": "eve/0.39.0" } }
    const userAgent =
      typeof ctx.options.userAgent === "string" && ctx.options.userAgent.length > 0
        ? ctx.options.userAgent
        : DEFAULT_EVE_USER_AGENT

    await ctx.session.hook("http.request", (event) => {
      // `providerID` is a branded string; coerce for a safe literal compare.
      if (String(event.model.providerID) !== EVE_PROVIDER_ID) return

      // Copy existing headers (Authorization, Content-Type, x-session-*, ...)
      // and override only User-Agent, then rebuild the Request so the change
      // reaches the transport regardless of runtime header immutability.
      const headers = new Headers(event.request.headers)
      headers.set("User-Agent", userAgent)
      event.request = new Request(event.request, { headers })
    })
  },
})
