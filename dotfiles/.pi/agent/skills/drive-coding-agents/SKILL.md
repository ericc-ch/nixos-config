---
name: drive-coding-agents
description: Delegate tasks to external coding CLIs (pi, agy, agent, opencode2) via non-interactive print mode. Use to fan out parallel subagents or isolate context.
---

# Drive coding agents as subagents

Drive external coding CLIs (`pi`, `agy`, `agent`, `opencode2`) from the outside using non-interactive print mode for context isolation and parallel task execution. Each call runs in its own process: one task in, result returned on stdout.

## The pattern

For every CLI, a subagent call is the same shape:

1. Pick the CLI and a model.
2. Run it in print mode with a **self-contained** task prompt. Give it everything it needs (goal, files, constraints, the exact output to return) — it will not see your context.
3. Always supply **permission auto-approval** flags (e.g. `--dangerously-skip-permissions`, `-f`, `--auto`) and set **increased timeouts** so headless runs never stall waiting for confirmation or timeout mid-task.
4. Capture stdout. Use `--output-format json` (or `--format json`) when you need usage/structured data instead of bare text.
5. Treat the process exit as the subagent's return: exit 0 + stdout = result; non-zero + stderr = failure to surface.

Constrain the subagent's scope **in the prompt itself** ("investigate only, report findings, do not modify any files"), not via flags — the subagent honors the task instruction. Keep the "return only X" instruction strict so captured stdout is usable without parsing prose.

## The four CLIs (verified on this machine)

All four are authenticated. Auth is not re-entered per call — it lives in stored credentials or env.

### pi
```bash
pi -a -p "<task>"
# explicit: pi -a --provider vercel-ai-gateway --model zai/glm-5.2 -p "<task>"
```
- Permissions: `-a` / `--approve` trusts project-local files for the run.
- Timeouts: `pi` runs until completion; wrap with `timeout 30m pi -a -p ...` when you want a safety cap on duration.
- Auth: API key via the `vercel-ai-gateway` provider (env `PI_PROVIDER`/`PI_MODEL` set it by default). This machine's pi is **not** on `google` despite the default.
- Output: text on stdout. `--mode json` for structured; `--mode rpc` for a headless JSON stream over stdio (multi-turn programmatic control).

### agy (Antigravity CLI)
```bash
agy models >/dev/null 2>&1   # warm auth first (see gotcha)
agy --dangerously-skip-permissions --print-timeout 30m -p "<task>"
agy --dangerously-skip-permissions --print-timeout 30m --output-format json -p "<task>"   # structured + usage
```
- Permissions: `--dangerously-skip-permissions` auto-approves all tool permission requests without prompting.
- Timeouts: `--print-timeout 30m` (or `1h`, `15m`). Default is only `5m0s`, which will timeout on non-trivial agent runs.
- Auth: Google OAuth via a stored refresh token. Print mode authenticates headless **after** the token is warm.
- Gotcha: the first run after the token expires triggers a Google OAuth **browser flow** and times out headlessly. Run `agy models` once to refresh the token (~20 min validity), then `-p`.
- Output: text on stdout; `--output-format json`/`stream-json` for structured.

### agent (Cursor Agent)
```bash
agent -p -f --trust --model cursor-grok-4.6-medium "<task>"
agent -p -f --trust --output-format json "<task>"
```
- Permissions: `-f` / `--force` (or `--yolo`) forces execution of all tools/commands without prompting. `--trust` trusts workspace root without interactive confirmation.
- Timeouts: wrap with `timeout 30m agent -p -f ...` if an external timeout ceiling is desired.
- Auth: stored Cursor desktop credentials. ⚠️ `CURSOR_API_KEY` is set on this machine but is an **empty string** — do not rely on the env var.
- Models: `agent --list-models` (e.g. `cursor-grok-4.6-medium`, `gpt-5.3-codex`, `claude-opus-5-thinking-high`, `composer-2.5`, `gpt-5.6-sol-high`). Effort is part of the model id (`-low`/`-medium`/`-high`/`-xhigh`, optional `-fast`).
- Output: text on stdout; `--output-format text|json|stream-json`.

### opencode2 (OpenCode 2.0)
```bash
opencode2 run --auto -m opencode-go/deepseek-v4-flash#max "<task>"
opencode2 run --auto -m opencode-go/deepseek-v4-flash#max --format json "<task>"
```
- Permissions: `--auto` auto-approves permissions that are not explicitly denied.
- Timeouts: wrap with `timeout 30m opencode2 run ...` if an external timeout ceiling is desired.
- Auth: `~/.local/share/opencode/auth.json` (providers: `openai`, `opencode-go`, `huggingface`, `nvidia`).
- Model format: `provider/model#variant`, where `#variant` is effort (e.g. `#max`, `#high`). List with `opencode2 models`.
- Gotcha: not every model in `opencode2 models` may actually be callable — `openai/gpt-5.4` errors bare. The `opencode-go/*` models work reliably; prefer them.
- Output: text on stdout; `--format json` for structured.

## Selecting a CLI & shared capabilities

All four CLIs share the same fundamental environment and tool power:
- **Identical tool power**: All CLIs have access to file operations (read, write, edit), codebase search (`grep`/`find`/`ls`), and bash command execution.
- **Shared skill library & context**: Running in the project workspace gives every CLI access to repository instructions (`AGENTS.md`) and the local/global skill library (`~/.gemini/config/skills/`).
- **Interchangeability**: Because tool capabilities are equivalent, choose a CLI based on your preferred LLM provider:
  - **`pi`** — Vercel AI Gateway provider models (e.g. ZAI/GLM).
  - **`agy`** — Google Gemini models and Antigravity toolchain.
  - **`agent`** — Cursor model lineup (Grok, Composer, Claude Opus, Codex, Sol).
  - **`opencode2`** — Multi-provider models (DeepSeek, GLM, Qwen, Kimi).

## Fan out in parallel

Each call is an independent process, so run several at once and wait on all of them:

```bash
pids=()
timeout 30m pi -a -p "task A" > out_pi.txt 2>err_pi.txt & pids+=($!)
timeout 30m agy --dangerously-skip-permissions --print-timeout 30m -p "task B" > out_agy.txt 2>err_agy.txt & pids+=($!)
timeout 30m agent -p -f --trust --model cursor-grok-4.6-medium "task C" > out_agent.txt 2>err_agent.txt & pids+=($!)
timeout 30m opencode2 run --auto -m opencode-go/deepseek-v4-flash#max "task D" > out_oc.txt 2>err_oc.txt & pids+=($!)
for p in "${pids[@]}"; do wait "$p"; done
```

Capture each child's exit code to know which succeeded. Keep prompts self-contained and the "return only X" instruction identical across siblings so outputs are comparable.

## Self-check

How to smoke-test all four with a trivial call (warm agy auth first):

```bash
pi -a -p "Reply with exactly one word: pong"
agy models >/dev/null 2>&1; agy --dangerously-skip-permissions --print-timeout 10m -p "Reply with exactly one word: pong"
agent -p -f --trust --model cursor-grok-4.6-medium "Reply with exactly one word: pong"
opencode2 run --auto -m opencode-go/deepseek-v4-flash#max "Reply with exactly one word: pong"
```

Each prints `pong`. If one hangs or errors, it is an auth/model issue for that CLI — see its gotcha above.
