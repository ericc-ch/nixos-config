/**
 * Tokens-per-second extension.
 *
 * Measures end-to-end output token rate, shown in the footer status bar.
 * The rate spans the whole turn (turn start → turn end), so time to first
 * token and tool execution are included in the denominator.
 *
 * - Live rate during streaming: estimated from text and thinking delta
 *   characters (≈ chars/4) ÷ elapsed time since turn start, refreshed
 *   ~10×/sec. Replaced by the real count at message end; the estimate never
 *   feeds the average.
 * - Interim rate: shows right after streaming ends (TTFT + generation).
 * - Final rate per turn: authoritative `usage.output` ÷ full turn duration
 *   (turn start → turn end), so TTFT and tool execution are included.
 * - Session average: token-weighted (Σoutput ÷ Σturn duration) across all
 *   completed turns in the current session, shown alongside the per-turn
 *   rate. In-memory only; resets on session start. `--` until the first
 *   turn lands.
 *
 * Global install: ~/.pi/agent/extensions/personal/ (all projects).
 * Coexists with pi's working indicator; uses its own status slot ("toks").
 */

import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

/** Rough characters-per-output-token estimate for the live rate display. */
const CHARS_PER_TOKEN = 4;
/** Minimum milliseconds between live status updates (throttle). */
const LIVE_UPDATE_MS = 100;
/** Footer status slot key. */
const STATUS_KEY = "toks";

type Phase = "idle" | "waiting" | "generating";

/** Authoritative per-turn result, shown while idle until the next turn. */
interface FinishedRate {
  readonly ratePerSec: number;
}

export default function (pi: ExtensionAPI): void {
  // Active streaming measurement state (per current turn).
  let phase: Phase = "idle";
  let turnStart = 0;
  let firstTokenAt = 0;
  let streamedChars = 0;
  let lastLiveAt = 0;
  // True once the turn's assistant stream ended normally (message_end).
  // Aborted streams (Esc mid-token) never finalize into the averages.
  let streamCompleted = false;
  // Most recent finalized rate, shown while idle until the next turn.
  let lastFinished: FinishedRate | undefined;
  // Running session totals for the token-weighted average. In-memory only;
  // reset on session_start. Accumulated at turn_end (real usage + full turn
  // duration), never from the chars/4 live estimate.
  let totalOutput = 0;
  let totalElapsedMs = 0;

  /** Running session average (tok/s), or `--` before the first turn lands. */
  const avgSegment = (): string => {
    if (totalElapsedMs <= 0) return " · avg --";
    const avg = totalOutput / (totalElapsedMs / 1000);
    return ` · avg ${avg.toFixed(1)}`;
  };

  const showWaiting = (ctx: ExtensionContext): void => {
    ctx.ui.setStatus(STATUS_KEY, ctx.ui.theme.fg("dim", "⏳ …"));
  };

  const showLive = (ctx: ExtensionContext, now: number): void => {
    // End-to-end elapsed from turn start, so the live estimate already
    // includes time-to-first-token, like the final rate.
    const elapsedSec = (now - turnStart) / 1000;
    if (elapsedSec <= 0) return;
    const rate = streamedChars / CHARS_PER_TOKEN / elapsedSec;
    const head = ctx.ui.theme.fg("accent", `⚡ ~${rate.toFixed(1)} tok/s`);
    const rest = ctx.ui.theme.fg("dim", avgSegment());
    ctx.ui.setStatus(STATUS_KEY, head + rest);
  };

  const showFinished = (ctx: ExtensionContext, result: FinishedRate): void => {
    const head = ctx.ui.theme.fg("success", `✓ ${result.ratePerSec.toFixed(1)} tok/s`);
    const rest = ctx.ui.theme.fg("dim", avgSegment());
    ctx.ui.setStatus(STATUS_KEY, head + rest);
  };

  pi.on("session_start", () => {
    phase = "idle";
    turnStart = 0;
    firstTokenAt = 0;
    streamedChars = 0;
    lastLiveAt = 0;
    streamCompleted = false;
    lastFinished = undefined;
    totalOutput = 0;
    totalElapsedMs = 0;
  });

  pi.on("turn_start", (_event, ctx) => {
    if (!ctx.hasUI) return;
    phase = "waiting";
    turnStart = Date.now();
    firstTokenAt = 0;
    streamedChars = 0;
    lastLiveAt = 0;
    streamCompleted = false;
    showWaiting(ctx);
  });

  pi.on("message_update", (event, ctx) => {
    if (!ctx.hasUI || phase === "idle") return;
    if (event.message.role !== "assistant") return;
    const ev = event.assistantMessageEvent;
    // Count generated text and reasoning tokens (both are output tokens).
    if (ev.type !== "text_delta" && ev.type !== "thinking_delta") return;
    const now = Date.now();
    if (phase === "waiting") {
      firstTokenAt = now;
      phase = "generating";
    }
    streamedChars += ev.delta.length;
    if (now - lastLiveAt >= LIVE_UPDATE_MS) {
      lastLiveAt = now;
      showLive(ctx, now);
    }
  });

  pi.on("message_end", (event, ctx) => {
    if (!ctx.hasUI) return;
    if (event.message.role !== "assistant") return;
    // No streamed tokens (instant/cached or errored before any token).
    if (firstTokenAt === 0) {
      phase = "idle";
      return;
    }
    const outputTokens = event.message.usage.output;
    if (outputTokens <= 0) return;
    phase = "idle";
    streamCompleted = true;
    // Interim rate: TTFT + generation only. The final rate, which also
    // includes tool execution, replaces this at turn_end.
    const elapsedMs = Date.now() - turnStart;
    if (elapsedMs <= 0) return;
    const interim: FinishedRate = { ratePerSec: outputTokens / (elapsedMs / 1000) };
    showFinished(ctx, interim);
  });

  pi.on("turn_end", (event, ctx) => {
    const wasGenerating = phase === "generating";
    const finalized = streamCompleted;
    const outputTokens =
      event.message.role === "assistant" ? (event.message.usage?.output ?? 0) : 0;
    phase = "idle";
    firstTokenAt = 0;
    streamedChars = 0;
    lastLiveAt = 0;
    streamCompleted = false;
    // Final rate spans the whole turn (start → end): TTFT + generation +
    // tool execution. Only turns that streamed to completion are counted.
    if (finalized && outputTokens > 0) {
      const elapsedMs = Date.now() - turnStart;
      if (elapsedMs <= 0) return;
      const result: FinishedRate = {
        ratePerSec: outputTokens / (elapsedMs / 1000),
      };
      totalOutput += outputTokens;
      totalElapsedMs += elapsedMs;
      lastFinished = result;
      if (ctx.hasUI) showFinished(ctx, result);
      return;
    }
    // Restore a stable display if we were aborted mid-stream.
    if (wasGenerating && ctx.hasUI) {
      if (lastFinished) showFinished(ctx, lastFinished);
      else ctx.ui.setStatus(STATUS_KEY, undefined);
    }
  });
}
