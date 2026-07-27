---
name: to-tickets
description: Split a specification or plan into small end-to-end task tickets with clear dependencies.
disable-model-invocation: true
---

# To Tickets

Split a specification, plan, or conversation into small task tickets. Each ticket must declare which other tickets block it.

Verify that `/setup-matt-pocock-skills` was run to configure your issue tracker settings.

## Process

### 1. Gather context
Read the conversation context and any referenced spec or issue link.

### 2. Inspect the codebase
Review the codebase to confirm current structure and domain terms before writing ticket titles.

### 3. Create task tickets
Split the work into complete end-to-end tasks.

- **Vertical feature slices:** Each task MUST build a complete feature slice (UI, API, database, and tests). Do not split tasks horizontally by tech layer (do not create "UI-only" tickets).
- **Standalone testable units:** Each completed task MUST be verifiable on its own.
- **Sized for one session:** Sized so one task fits cleanly into a single chat window.
- **Large refactors:** For large code refactors across many files, first add the new pattern alongside the old pattern. Next, migrate files in small batches. Finally, delete the old pattern when all files are updated.

### 4. Review with the user
Show the list of proposed tickets with:
- **Title:** Short name
- **Blocked by:** Prerequisites that must finish first
- **Delivers:** The feature behavior completed by this ticket

Ask the user to confirm ticket size and dependency order.

### 5. Publish to tracker
- **Local tracker:** Write one file per ticket under `.scratch/<feature-slug>/issues/<NN>-<slug>.md` in order.
- **Remote tracker (GitHub, Linear, etc.):** Create issue tickets in dependency order and link blockers. Tag tickets with `ready-for-agent`.

<local-ticket-template>

# <NN> — <Ticket title>

**What to build:** The feature behavior completed by this task.

**Blocked by:** Ticket numbers/titles that must finish first, or "None".

**Status:** ready-for-agent

- [ ] Acceptance criterion 1
- [ ] Acceptance criterion 2

</local-ticket-template>
