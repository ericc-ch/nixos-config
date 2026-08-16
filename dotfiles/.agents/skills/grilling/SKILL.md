---
name: grilling
description: Interview the user in rounds to clarify a plan, decision, or idea. Use when the user asks to clarify or stress-test their thinking.
---

Interview me to clarify this plan or decision. Follow these rules:

1. **Map the design tree.** Every decision branches into the decisions that hang off it.
2. **Ask in rounds.** The frontier is every decision whose prerequisites are settled: the questions you can ask now without guessing answers. Ask the whole frontier in one round: number each question, include your recommended answer. Wait for my answers before the next round.
3. **Resolve decisions in order.** Settled decisions push the frontier outward and unblock the questions that depended on them. A question that depends on another question still open in this round belongs to a later round.
4. **Search for facts yourself.** When a frontier question needs a fact from the environment (filesystem, tools), dispatch a sub-agent to find it. Do not ask me for anything you could look up. Do not block on it: ask the rest of the frontier now. Only the questions downstream of the fact-finding wait.
5. **Wait for confirmation.** The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not execute or build until I confirm we agree on the plan.
