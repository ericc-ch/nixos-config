---
name: harden-repo
description: "Hardens repo setup from hard sessions. Use after the agent struggled to find files, repeated a preventable mistake, or lacked logs or access. Skip personal style lessons, use sharpen-skills instead. Skip code verdicts, use code-review instead."
---

Propose repo fixes from one hard session. You change the setup, not the code. You propose only. You change nothing until the user picks a candidate.

## Source

Use the current session by default. Read the full session before you decide anything. If the session left context, point a fresh run at the session log instead. Skip smooth sessions. A smooth session has little to teach.

## Process

1. Read `writing-for-agents` first. Follow it for every file you propose.
2. Collect friction moments. Each moment needs a quote or a tool count. Note where the agent searched too long, where a tool could have caught a mistake, and where the agent lacked information.
3. Classify each moment. A mechanical breach gets a check. Only a judgement call with no check gets prose. Discard any candidate you cannot trace to a specific moment.
4. Order the list by harm. Treat the order as a draft. A quiet and costly mistake can rank above a loud and cheap one.
5. Propose the list and wait. Change nothing until the user picks one or more candidates.
6. Build only what the user picked. Use commands you have seen work. Try each check against the repo before you let it block merges. A proposed check must fail on the old code and pass on fixed code.

## Where fixes land

| What went wrong | Fix it with |
| --- | --- |
| The agent took long to find a file or fact | A navigation pointer from a file the agent already reads |
| The agent made a mistake a tool could have caught | An automated check such as a lint rule, type, test, pre-commit hook, or CI job |
| The reviewer missed a judgement call | A rule in `CODING_STANDARDS.md` for the reviewer |
| `AGENTS.md` or `CLAUDE.md` is large | Move steering out into standards or checks |
| A tool call cost much and returned little | Streamline the tool or replace it |
| A steering file holds lines that change nothing | Delete those lines |
| The agent needed facts it could not reach | Widen access such as a dev log on disk or read only service access |

## Rules

- Keep standards with the reviewer. The reviewer reads a diff and has room to apply a rule. The builder carries search and debug load and has no room. Keep `AGENTS.md` to pointers only.
- Connect before you build. If a check exists but was not wired, the fix is to wire it.
- If the repo has no guardrail at all, report that as its own finding. A guardrail means a pre-commit hook and a CI job that runs lint, typecheck, and tests.
- Prefer fewer strong checks. A rule that fires on good code is a sign to remove it.
- One session pulls toward its own topic. Say what the session was about. Do not present the list as a full audit.
- This skill stores no memory. It changes the setup so the same mistake cannot repeat.

## Relation to nearby skills

- Use `code-review` for a verdict on the code. Use this skill for a verdict on the setup.
- Use `improve-codebase` to fix code shape. Use this skill to fix agent setup.
- Use `sharpen-skills` to change agent behavior. Use this skill to change repo checks, pointers, and standards.

## Close out

Report each candidate you proposed, each fix you built, and the proof that the check runs. List each skipped moment with a one line reason.
