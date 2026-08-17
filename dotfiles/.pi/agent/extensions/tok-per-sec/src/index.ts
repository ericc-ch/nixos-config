/**
 * Tokens-per-second extension.
 *
 * Measures output token generation rate and time-to-first-token, shown in the
 * footer status bar.
 *
 * - Live rate during streaming: estimated from text and thinking delta
 *   characters (≈ chars/4), refreshed ~10×/sec.
 * - Final rate per turn: authoritative `usage.output` ÷ generation time
 *   (first token → message end), excluding network time-to-first-token.
 * - TTFT: time from turn start to the first streamed token.
 *
 * Global install: ~/.pi/agent/extensions/tok-per-sec/ (all projects).
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
	readonly ttftMs: number;
}

export default function (pi: ExtensionAPI): void {
	// Active streaming measurement state (per current turn).
	let phase: Phase = "idle";
	let turnStart = 0;
	let firstTokenAt = 0;
	let streamedChars = 0;
	let lastLiveAt = 0;
	// Most recent finalized rate, shown while idle until the next turn.
	let lastFinished: FinishedRate | undefined;

	const ttftSegment = (ttftMs: number): string => ` · TTFT ${(ttftMs / 1000).toFixed(2)}s`;

	const showWaiting = (ctx: ExtensionContext): void => {
		ctx.ui.setStatus(STATUS_KEY, ctx.ui.theme.fg("dim", "⏳ …"));
	};

	const showLive = (ctx: ExtensionContext, now: number): void => {
		const elapsedSec = (now - firstTokenAt) / 1000;
		if (elapsedSec <= 0) return;
		const rate = streamedChars / CHARS_PER_TOKEN / elapsedSec;
		const head = ctx.ui.theme.fg("accent", `⚡ ~${rate.toFixed(1)} tok/s`);
		const rest = ctx.ui.theme.fg("dim", ttftSegment(firstTokenAt - turnStart));
		ctx.ui.setStatus(STATUS_KEY, head + rest);
	};

	const showFinished = (ctx: ExtensionContext, result: FinishedRate): void => {
		const head = ctx.ui.theme.fg("success", `✓ ${result.ratePerSec.toFixed(1)} tok/s`);
		const rest = ctx.ui.theme.fg("dim", ttftSegment(result.ttftMs));
		ctx.ui.setStatus(STATUS_KEY, head + rest);
	};

	pi.on("session_start", () => {
		phase = "idle";
		turnStart = 0;
		firstTokenAt = 0;
		streamedChars = 0;
		lastLiveAt = 0;
		lastFinished = undefined;
	});

	pi.on("turn_start", (_event, ctx) => {
		if (!ctx.hasUI) return;
		phase = "waiting";
		turnStart = Date.now();
		firstTokenAt = 0;
		streamedChars = 0;
		lastLiveAt = 0;
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
		const genMs = Date.now() - firstTokenAt;
		phase = "idle";
		if (outputTokens <= 0 || genMs <= 0) return;
		const result: FinishedRate = {
			ratePerSec: outputTokens / (genMs / 1000),
			ttftMs: firstTokenAt - turnStart,
		};
		lastFinished = result;
		showFinished(ctx, result);
	});

	pi.on("turn_end", (_event, ctx) => {
		const wasGenerating = phase === "generating";
		phase = "idle";
		firstTokenAt = 0;
		streamedChars = 0;
		// Restore a stable display if we were aborted mid-stream.
		if (wasGenerating && ctx.hasUI) {
			if (lastFinished) showFinished(ctx, lastFinished);
			else ctx.ui.setStatus(STATUS_KEY, undefined);
		}
	});
}
