# Perf issue

**Tie every fix to a measurement.** Never read source instead of measuring.

1. Capture a baseline trace on the real surface (profiler, timing script, request log). Save the artifact.
2. Generate hypotheses from eight strategy families. A family earns an attempt only when the trace shows its signal; a focused fix on the dominant cost beats applying all eight.
   - **Elimination.** Work that need not exist: unused computation, always-off feature gate, redundant sync. Deleting beats every other family when it applies.
   - **Divide and conquer.** Dominant cost scales with input size. Chunk, shard, prune, or parallelize.
   - **Caching.** Same computation repeats on identical inputs. Name what invalidates it before claiming the win.
   - **Indirection.** Expensive work a cheaper intermediate absorbs: index over scan, queue shifting work off the interactive thread.
   - **Batching.** Many operations each paying fixed overhead (RPC, query, draw call). Coalesce to pay once per batch.
   - **Redundancy.** One slow instance or attempt dominates the wait. Replicas or hedged requests trade load for tail latency; only when headroom exists.
   - **Lazy evaluation.** Cost lands on results never used yet (eager init, offscreen rendering). Defer until first use.
   - **Scheduling.** Work must happen but not in the interactive moment. Move to idle callbacks, background warmup, post-frame cleanup.
3. Fix from the trace, one hypothesis at a time, measuring each attempt before the next (sequence-verifiable-units).
4. Capture a post-fix trace and compare artifacts. Inconclusive is a fail.
5. Run `playbooks/opening-a-pr.md`; cite baseline and after numbers in the PR body.

**Reply:** baseline number, post-fix number, delta, artifact path.
