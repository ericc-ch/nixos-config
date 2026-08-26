---
name: review
description: Two-axis code review plus an adversarial pass over a diff. Use before committing or opening a PR, when asked to "review this", or after any nontrivial change.
---

# Code Review

Review with hostile skepticism: do not trust the author (yourself included). Assume the diff is broken until proven otherwise. Probe error paths, boundaries, races, and test validity. Report every flaw.

## Scope

Default baseline `main`. Uncommitted work: `git diff HEAD`. Committed: `git diff <base>...HEAD`. Review changed files only.

## Axis 1: Spec compliance

Find the originating request, ticket, or spec. Verify:
- Every requirement present.
- No unrequested scope creep.
- Behavior matches what was asked, not what looks reasonable.

## Axis 2: Standards and design

Check against repo conventions (`conventions` skill if loaded) and:
- Names that fail to explain purpose.
- Duplicate logic; missed shared-primitive extraction.
- Functions with too many responsibilities; layers that add nothing.
- Speculative generality: abstractions with one caller, params nobody passes.
- Comments narrating what code shows (see `plain`).
- Low-value tests per `tdd`'s delete list.

## Axis 3: Adversarial pass

Three challenge angles, one at a time:
1. **Saboteur.** How does this break in production? Worst inputs, concurrent access, partial failure, rollback story.
2. **Simplifier.** What could be deleted with no loss? Smallest diff that still works?
3. **Maintainer.** Will the next reader understand why without the chat transcript? What will they get wrong?

## Report

```
## Verdict
Ship | Fix first | Rework

## Findings
<severity>: <file:symbol> — <problem> — <smallest fix>
(blocking findings first; nitpicks labeled as such)

## Verified
<what you actually ran and observed>
```

A review with zero verified-runs behind it is an opinion, not a review.
