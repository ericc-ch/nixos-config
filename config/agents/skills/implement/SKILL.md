---
name: implement
description: Build a feature or task from a spec or ticket.
disable-model-invocation: true
---

# Implement

Build the feature or task described in your spec or ticket.

## Steps

1. **Review the task:** Read the ticket requirements and acceptance criteria.
2. **Build test-first:** Use `/tdd` to write failing tests before writing implementation code.
3. **Run checks:** Run typechecking and tests frequently during development. Run the full test suite when complete.
4. **Review your work:** Run `/code-review` to check your changes against project standards and spec requirements.
5. **Commit:** Commit your clean, passing changes to git.
