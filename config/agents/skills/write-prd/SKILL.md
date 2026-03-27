---
name: write-prd
description: Load this skill when writing a Product Requirements Document (PRD) to plan new features or projects.
---

This skill helps you and the user align on what to build by creating a Product Requirements Document (PRD).

A PRD is a planning document that defines the problem, the proposed solution, and the scope of a project before any code is written. It acts as a source of truth and a roadmap for implementation.

## How to write the PRD

1. **Interview the User:** You MUST ask the user clarifying questions to understand the problem they are trying to solve, the target audience, and any known constraints or out-of-scope items. Do not start writing until you have a solid understanding of their goals. You can also explore the codebase to get context on existing systems to help inform your questions.
2. **Draft the Document:** Write the PRD based on your shared understanding.

## THE GOLDEN RULE: Actionable Task Tracking

The implementation plan in the PRD **must** be highly actionable.

You must break down the execution phase into granular, specific tasks using markdown checkboxes (`- [ ]`). **Fill the PRD with as many checkboxes as necessary to cover the entire scope of work.** This allows the user to easily track progress and check things off as the feature is built.

**Example format for tasks:**

- [ ] Create the database migration for the `user_preferences` table.
- [ ] Build the API endpoint to fetch user settings.
- [ ] Update the frontend dashboard to display the new settings toggle.
- [ ] Write unit tests for the settings state manager.
