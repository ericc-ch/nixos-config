---
name: to-spec
description: Turn the current conversation into a clean specification document and publish it to the issue tracker.
disable-model-invocation: true
---

# To Spec

Turn your conversation context and codebase knowledge into a clear feature specification. Do NOT interview the user again; summarize what has already been decided.

Verify that `/setup-matt-pocock-skills` was run to configure your issue tracker settings.

## Process

1. **Inspect the codebase.** Read relevant code and existing ADR files to understand the current system architecture.
2. **Identify test boundaries.** Decide where to test the feature. Prefer testing at high-level boundaries (such as public APIs or major interfaces) over private implementation details.
3. **Draft the specification.** Use the template below and publish the completed document to your issue tracker. Tag it with the `ready-for-agent` label.

<spec-template>

## Problem Statement

The problem the user is facing, written from the user's perspective.

## Solution

The proposed solution, written from the user's perspective.

## User Stories

A numbered list of user stories. Format each story as:

1. As an <actor>, I want <feature>, so that <benefit>.

Include stories covering all major paths and edge cases.

## Implementation Decisions

List technical decisions made during discussion:
- Modules created or modified
- Interface or API contract updates
- Database schema changes
- Architectural decisions

Do NOT list exact file paths or temporary code lines that will become outdated quickly.

## Testing Decisions

List testing strategies:
- High-level boundaries to test
- Test files or suites to create or extend

## Out of Scope

List features or ideas explicitly excluded from this specification.

## Further Notes

Any additional notes or references.

</spec-template>
