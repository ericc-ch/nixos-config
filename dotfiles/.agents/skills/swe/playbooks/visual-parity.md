# Visual parity

**You own pixel-exact equivalence. The baseline is the spec; you do not touch it.** For "make X match Y exactly", styling-system migrations, porting a UI across frameworks or themes. Equivalence is verified by image diff, not by eye.

1. Establish the baseline before any migration: a visual regression harness screenshotting the current component across its states, plus the target when matching two implementations. No baseline, no parity claim. Blocking prerequisite, not follow-up.
2. Anti-shortcut clauses, stated and held: no harness modifications, no baseline tampering, no component restructuring to make a diff pass. Baseline looks wrong? Stop and ask; do not edit it.
3. Migrate one component at a time; each is independent. Shared primitives migrate first as a blocking phase.
4. Verify each component against its baseline via image diff on the real surface. A nonzero diff is a fail: investigate the pixel delta, do not wave it through.
5. Run `playbooks/opening-a-pr.md` per component or safe batch.

**Reply:** components migrated, diff result for each, baseline harness location, what is left.
