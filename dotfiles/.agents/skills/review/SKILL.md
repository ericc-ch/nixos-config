---
name: review
description: "Reviews a change against the request and coding standards, then probes breakage, extra code, and readability. Default scope is the current git diff (uncommitted, or the branch vs main). Use before commit or PR, when asked to review, or after a nontrivial change. Can review a named PR, path, or commit range if the user specifies one."
---

# Code Review

Do not trust the author (yourself included). Assume the diff is broken until proven otherwise. Probe error paths, boundaries, races, and test validity. Report every flaw.

Review *process* stays in your head. The report uses **severity** and **kind** only. Do not name personas, axes, or probe roles in the user-facing writeup.

## Scope

Default baseline `main`. Uncommitted work: `git diff HEAD`. Committed: `git diff <base>...HEAD`. If the user names a PR, path, or commit range, use that instead. Review changed files only.

## Process (not report labels)

1. **Request.** Find the ticket, spec, or ask. Every requirement present, no extra scope, behavior matches what was asked.
2. **Standards.** Check repo conventions (`coding-standards` if loaded): names, duplication, shallow layers, speculative generality, comments, low-value tests (`tdd` delete list).
3. **Probes.** Answer these; do not print the headings:
   - What input, timing, or partial failure breaks this?
   - What in the diff can be deleted with no loss?
   - What will the next reader get wrong without the chat?

## Severity (when to act)

Exactly one per finding:

| Label | Means |
| --- | --- |
| `must-fix` | Wrong or unsafe if this ships. Verdict cannot be Ship. |
| `should-fix` | Real defect or gap; ship only with an explicit reason. |
| `nit` | Taste, naming, comments. Never blocks Ship by itself. |

Do not invent extra levels (`blocking`, `medium`, `P0`, persona names).

## Kind (what it is)

Exactly one per finding:

| Label | Means |
| --- | --- |
| `bug` | Observable wrong behavior vs spec, ticket, or existing contract. |
| `security` | Auth, origin, cookies, injection, secret leak, trust boundary. |
| `test` | Missing, weak, or lying coverage. |
| `design` | Structure, API, duplication, extra abstraction. |
| `clarity` | Names or control flow the next reader will misread. |

A security bug is `security`, not both. If unsure between `bug` and `design`, pick `bug` when a user or test can see it fail.

## Report

```
## Verdict
Ship | Fix first | Rework

## Findings
<severity> <kind> — <file:symbol> — <problem> — <smallest fix>
(must-fix first, then should-fix, then nit)

## Verified
<what you actually ran and observed>
```

Verdict: **Ship** only if there is no `must-fix`. **Fix first** if `must-fix` exists and the shape is right. **Rework** if the approach is wrong.

A review with zero verified-runs behind it is an opinion, not a review.
