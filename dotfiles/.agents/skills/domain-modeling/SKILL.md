---
name: domain-modeling
description: Maintain project domain terms and record architectural decisions.
---

# Domain Modeling

Maintain project terminology in `CONTEXT.md` and record major decisions in `docs/adr/`.

## File Structure

```
/
├── CONTEXT.md               ← Domain glossary
└── docs/
    └── adr/                 ← Architectural decision records
        ├── 0001-title.md
        └── 0002-title.md
```

Create these files lazily when the first term or decision needs to be saved.

---

## Guidelines

### 1. Maintain the Glossary (`CONTEXT.md`)

- Update `CONTEXT.md` whenever new project terms are defined.
- Challenge ambiguous or overloaded terms during conversation.
- Use `CONTEXT.md` for domain terms only (do not include general programming terms or temporary specs).

### 2. Record Architectural Decisions (`docs/adr/`)

Create an Architectural Decision Record (ADR) file only when a decision meets all 3 criteria:

1. **Hard to reverse:** Changing your mind later incurs significant cost.
2. **Surprising without context:** A future developer will wonder why this approach was chosen.
3. **Real trade-off:** Multiple valid options existed and one was chosen for specific reasons.

See `ADR-FORMAT.md` and `CONTEXT-FORMAT.md` for formatting templates.
