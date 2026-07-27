---
name: handoff
description: Save current chat summary into a handoff document for a fresh session.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

# Handoff

Save a concise summary of the current session to your OS temporary directory so a new chat window can continue the task.

## Rules

1. **Save to temp directory:** Write to `$TMPDIR` (or `/tmp`) with a clear filename (e.g., `handoff-<topic>.md`).
2. **Reference existing artifacts:** Do not re-copy full specs or plans into the handoff file. Point to existing spec files, issues, or commit SHAs instead.
3. **Include suggested skills:** List recommended skills for the next chat session.
4. **Remove secrets:** Do not include API keys, credentials, or private user data.
