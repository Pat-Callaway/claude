# Memory

Memory is Claude Code's persistent, file-based storage system. Information saved to memory survives across sessions — Claude can recall facts about you, your project, your preferences, and where to find things, without you having to re-explain them every conversation.

## How it works

Memory lives in a directory on disk. Two things are always present:

```
~/.claude/projects/<project-slug>/memory/
├── MEMORY.md          ← index file, always loaded into context
├── user_role.md       ← individual memory files
├── feedback_tests.md
└── project_deadline.md
```

**MEMORY.md** is a lightweight index — one line per memory entry. It is loaded at the start of every session so Claude can decide which individual files are relevant to load. Keep it under 200 lines; entries beyond that are truncated.

**Individual memory files** contain the full content for one memory. They are only loaded when relevant to the current task.

## File format

Every memory file uses YAML frontmatter followed by the content body:

```markdown
---
name: short-kebab-case-slug
description: one-line summary used to judge relevance in future sessions
metadata:
  type: user | feedback | project | reference
---

Memory content here. For feedback and project types, structure as:
rule or fact, then **Why:** and **How to apply:** lines.

Link to related memories with [[their-name]].
```

The `description` field is what Claude reads to decide whether to load the file — make it specific enough to be useful as a retrieval signal.

## Memory types

### user
Facts about who you are: role, goals, expertise, preferences. Helps Claude tailor explanations and recommendations to your level.

Save when: you share your background, domain knowledge, or working style.

### feedback
Guidance about how Claude should behave — both corrections ("don't do X") and validated approaches ("yes, keep doing Y"). This is the most important type for shaping consistent behavior across sessions.

Save when: you correct Claude's approach, or confirm a non-obvious choice worked well.

Body structure: lead with the rule, then `**Why:**` (the reason you gave) and `**How to apply:**` (when it kicks in). The *why* is critical — it lets Claude judge edge cases rather than blindly following the rule.

### project
Non-obvious facts about current work: who owns what, deadlines, architectural decisions, incidents. Captures context that isn't derivable from the code or git history.

Save when: you share motivation, constraints, deadlines, or decisions behind the work.

Body structure: same as feedback — fact, then `**Why:**` and `**How to apply:**`. Include absolute dates (not "Thursday" — convert to "2026-03-05") so entries stay interpretable after time passes.

### reference
Pointers to where things live in external systems: Linear projects, Slack channels, Grafana dashboards, internal wikis.

Save when: you point Claude to an external resource it should know about for this project.

## What NOT to save

Memory is for things that aren't derivable from reading the current state. Skip:

- Code patterns, architecture, file paths — read the codebase instead
- Git history, recent changes — use `git log` / `git blame`
- Debugging recipes — the fix is in the code; the commit message has context
- Anything already in `CLAUDE.md`
- In-progress task state — use tasks for that, not memory

## Memory staleness

A memory that names a file, function, or flag is a claim about what existed when it was written — not necessarily now. Before acting on a recalled memory:

- Named a file path → check the file exists
- Named a function or symbol → grep for it
- Summarized repo state → prefer `git log` or reading the code over the snapshot

If a recalled memory conflicts with current reality, trust what you observe and update or remove the stale memory.

## Linked memories

Reference related memories in the body with `[[slug]]`, where `slug` matches another memory's `name:` field. This lets Claude navigate related context efficiently. Linking to a slug that doesn't exist yet is fine — it marks something worth writing later.

## Memory vs other persistence

| Mechanism | Use for |
|---|---|
| Memory | Facts that should survive across conversations |
| Tasks | Tracking steps and progress within the current conversation |
| Plan | Aligning on implementation approach before writing code |
| `CLAUDE.md` | Project conventions everyone (including CI) should follow |

## Examples in this repo

- `examples/memory/user-example.md` — user type: role and expertise
- `examples/memory/feedback-example.md` — feedback type: a corrected behavior with why/how
- `examples/memory/project-example.md` — project type: a deadline and its motivation
- `examples/memory/reference-example.md` — reference type: an external system pointer
