---
name: implement
description: Build a feature or task from a spec or ticket.
---

# Implement

Build the feature or task described in your spec or ticket.
Ask if you should commit after the work is done.

## Steps

1. **Review the task:** Read the ticket requirements and acceptance criteria.
2. **Build test-first:** Use `/tdd`. Write failing tests for what
   callers still see, then change the code. If you are deleting
   something, do not add a test whose only check is that the old
   name is gone.
3. **Run checks:** Run typechecking and tests frequently during development. Run the full test suite when complete.
4. **Review your work:** Run `/code-review` to check your changes against project standards and spec requirements.
5. **Commit:** Commit your clean, passing changes to git (if requested).
