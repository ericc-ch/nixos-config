---
name: do-work
description: "Plans, changes code, and proves the result on the real app or command. Use when the user asks to implement, fix, refactor, investigate, work on something, do a ticket, or follow a spec. Skip for casual chat with no code or file changes, and skip when they only want a written plan."
---

# Do Work

Plan, execute, verify. Casual chat stays casual. Anything that changes code or answers a hard question runs through here.

When the input is a spec, a ticket, or a direct request: read that task first (`wiki/CONTEXT.md` if present), state types and module shape before logic, use `tdd` when a cheap local test exists, typecheck as you go, prove it on the real surface, then `review` your own diff before handing back.

## First moves

1. Read `references/principles.md` once per session before substantive work.
2. Match the task to a playbook below. Read the playbook file and follow its steps.
3. No playbook fits? Run the figure-it-out move inside `playbooks/feature.md` step 2: design the smallest plan yourself and state it before coding.

## Playbooks

| Task                                                       | Playbook                      |
| ---------------------------------------------------------- | ----------------------------- |
| Reported defect, something broke                           | `playbooks/bug-fix.md`        |
| New or changed behavior, spec, or ticket                   | `playbooks/feature.md`        |
| Read-only question ("how does X work", "should we X or Y") | `playbooks/investigation.md`  |
| Behavior-preserving change (rename, extract, dedupe)       | `playbooks/refactoring.md`    |
| Measured slowness                                          | `playbooks/perf-issue.md`     |
| Sketch to settle a design decision                         | `playbooks/prototype.md`      |
| Make X match Y exactly, styling migration                  | `playbooks/visual-parity.md`  |
| Long unattended run ("going to bed", "until done")         | `playbooks/autonomous-run.md` |
| Take over prior agent's work                               | `playbooks/session-pickup.md` |
| End of every code playbook                                 | `playbooks/opening-a-pr.md`   |

Architecture hunting (what to reshape, not how to ship a known refactor) is `survey-architecture`. This playbook table is for work you already intend to do.

## Principles

The full index lives in `references/principles.md`. The five that decide most tasks:

- **Laziness protocol.** Smallest change that solves it. Bias to deletion.
- **Model the domain.** Encode it in a structure (state machine, table, typed model), not scattered conditionals.
- **Prove it works.** Verify against the real artifact. "It compiles" is not evidence. Wrong surface or inconclusive is a fail.
- **Never block on the human.** Reversible work proceeds; present results; let the human course-correct. Pause only for irreversible actions (force-push, deploy, deletion).
- **Guard the context window.** Bulk reading and fan-out go to subagents; keep summaries in the main thread.

Read a principle's full entry in `references/principles.md` whenever you apply it. Name in your reply which principles shaped decisions.

## Verification bar

- Reproduce bugs yourself on the matching surface before fixing. A bug you cannot reproduce you cannot prove fixed.
- Run the feature, read the actual output, screenshot the UI. Unit tests show branch behavior, not bug absence.
- After finishing, re-read the diff as a hostile reviewer before handing back.

## Autonomy ladder

1. Reversible and in-scope: just do it. Commits, local files, running tests, installing dev deps.
2. Ambiguous but reversible: pick the best option, proceed, flag the choice in the reply.
3. Irreversible or out-of-band (push to shared branch, deploy, delete data, message a human): stop and ask.

"No" is an acceptable answer. If the task does not earn its place, say so with reasons instead of building it.

## Subagents

Spawn via the task tool for parallel exploration, bulk reading, or mechanical sweeps. Give each one a specific scope (paths, the question, what to return), readonly for investigation. Review the diff yourself; never pass through a delegate's summary as your own finding.

## Writing the reply

Per the `plain` rules: short declarative sentences, no em dashes, no mid-sentence colons. Frame impact for the user first, then what the next maintainer inherits.

Every playbook ends with a reply that states: what changed, root cause or design choice, how you verified, open decisions.
