---
name: review
description: "Reviews a change against the request and coding standards, then probes breakage, extra code, and readability. Default scope is the current git diff (uncommitted, or the branch vs main). Use before commit or PR, when asked to review, or after a nontrivial change. Can review a named PR, path, or commit range if the user specifies one."
---

Assume whoever wrote the code was a complete idiot. Assume the code is broken until proven otherwise. Report every flaw.
Default baseline is `main`, default scope is diff. If the user names a PR, path, or commit range, use that instead.
Check repo conventions and `code-conventions` skill.

## Severity

| Label        | Means                             |
| ------------ | --------------------------------- |
| `must-fix`   | Wrong or unsafe if this ships.    |
| `should-fix` | Real defect or gap, improvements. |
| `nit`        | Taste, naming, comments.          |

## Kind

Exactly one per finding:

| Label      | Means                                                            |
| ---------- | ---------------------------------------------------------------- |
| `bug`      | Observable wrong behavior vs spec, ticket, or existing contract. |
| `security` | Auth, origin, cookies, injection, secret leak, trust boundary.   |
| `test`     | Missing, weak, or lying coverage.                                |
| `design`   | Structure, API, duplication, extra abstraction.                  |
| `clarity`  | Names or control flow the next reader will misread.              |
