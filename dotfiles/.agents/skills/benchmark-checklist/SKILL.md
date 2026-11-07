---
name: benchmark-checklist
description: "Vets a performance number before you report or act on it. Checks the limiter, tuning, limits, errors, repeatability, relevance, and whether the work happened. Use when you run a benchmark or claim a speedup or regression."
---

# Benchmark checklist

Answer each question with evidence from a run, not a guess about the code.

## Before you run

- Write the claim you expect to make, in the words you would ship. Example: "Export is 30% faster at p50 on the 60k-row dataset."
- Read the measurement script. Note what it times, counts, and ignores.
- Check the load with `uptime` and the core count with `nproc`. If the machine is busy, interleave the sides so both see the same noise, and say so.

## The questions

1. **Why not double?** Name the limiter: a core, a lock, the disk, the network, or the load generator. Use a profiler or system counters taken during a run, then map it to source. A guess from reading the code is not a limiter. If the load generator saturates first, you measured the load generator.
2. **Was it tuned?** Run both sides the way production runs them: release builds, production flags, pools, caches, versions, and data. If one side runs on defaults, you compared configurations, not implementations.
3. **Did it break limits?** Do the arithmetic. Compare bytes per second with bandwidth, operations per second with cores, and the time saved with the time the changed piece took. Removing a piece that took 10% of the run can make the run at most about 11% faster. A result past a limit measured something else.
4. **Did it error?** Count failures and non-success responses. Check that outputs are correct, not just present. Rejections are fast and timeouts are slow.
5. **Does it reproduce?** Run each side at least 5 times, alternating A, B, A, B. Report the median and range. A gap smaller than the run-to-run spread is no measurable difference.
6. **Does it matter?** Measure the end-to-end path a user waits on, with realistic data and concurrency. Report the micro result as a share of the whole.
7. **Did it even happen?** Confirm the work ran inside the timed region: the request reached the server, the rows were written, the bytes were read, and the code used the result. Lazy code and timeouts produce numbers for work that never happened.

## Report

- Lead with the verdict: faster, slower, no measurable difference, or inconclusive.
- Give the number, unit, run count, range, and limiter. Example: "p50 41 ms to 33 ms, median of 7 runs per side, range 32 to 35 ms after, bound by JSON parsing on one core."
- Call it inconclusive when you claim a difference but cannot name the limiter, when a side ran untuned, or when you could not check questions 4 and 7. Name the gap.
- Keep a PR body to one primary number. Put the runs, range, and limiter in a linked artifact.
