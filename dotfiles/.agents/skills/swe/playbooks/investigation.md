# Investigation

**You own the answer.** Read-only questions: "how does X work", "why was Y built this way", "are we sure about Z", "should we do X or Y". Output is a cited explanation or a recommendation, not a code change.

1. Explore the codebase for the narrow question; fan out two to four readonly subagents on distinct slices (data model, request path, config) for subsystem-wide ones. Reconcile their findings yourself.
2. For motivation or history questions, check git log and blame before answering; cite commits.
3. Produce the explanation in this shape, adapted to the question:
   - **Overview.** What it is and why it exists, one or two paragraphs.
   - **Key concepts.** The types and abstractions needed to follow the rest.
   - **How it works.** The flow step by step, prose not pseudocode, naming real files and functions.
   - **Where things live.** A short file map.
   - **Gotchas.** Non-obvious behavior, sharp edges, surprising history.
4. Decision between alternatives? Give a recommendation with a tradeoffs table and your real judgment. Push back if the premise is wrong.

No code changes, no PR. If the investigation precedes one, hand back and re-route to bug-fix or feature.

**Reply:** the investigation output itself.
