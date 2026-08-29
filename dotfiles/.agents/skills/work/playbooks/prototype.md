# Prototype

**The prototype is a throwaway instrument; the real build follows feature.** For "prototype", "mock it up", "try this layout", or any empirical fork ("which behavior, which timing") you would otherwise ask the human to settle.

Here speed beats polish and the verification bar inverts: the observation is the test, not an assertion. Code quality does not matter. Be bold: propose variations nobody asked for, throw an approach away and try another.

1. Name the decision the prototype exists to make. No decision means no prototype; route to feature instead.
2. Open design space? Gather prior art first, summarize themes and layouts, let the user pick directions before building.
3. Build throwaway in `/tmp/proto-<name>/`, never inside production source. Visual decision: vanilla HTML/CSS/JS or the lightest stack that renders it, dev server with hot reload. Behavioral or timing question: the smallest script that exercises it.
4. Comparing alternatives? Build them behind one switcher (buttons or keypress), each variant labeled so the user can name it.
5. Verify by observing: screenshot each visual variant and drive the interaction; log the timing or output for behavioral ones. The eye and the observed number are the test here.
6. Present variants, evidence, tradeoffs, recommendation. Hand the chosen direction to feature for the real build.

**Reply:** variants explored, the evidence (screenshots or observed output), tradeoffs, recommendation, scratch path. Say plainly the prototype is throwaway.
