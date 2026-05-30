# Agent Prompt Examples

The hardest part of using agents well is writing prompts that are self-contained enough for a cold start. These examples show the pattern for common scenarios.

---

## Codebase exploration (Explore agent)

```
subagent_type: Explore
search breadth: medium

Find every place in the codebase that calls `sendEmail`. I need to know which files
call it and what arguments they pass. Look for both direct calls and any wrappers
around it. Report file paths and line numbers only — no code review needed.
```

**Why Explore:** Read-only search with no need for code changes or multi-step reasoning. Fast and cheap.

---

## Implementation planning (Plan agent)

```
subagent_type: Plan

We need to add rate limiting to the POST /api/login endpoint in src/routes/auth.ts.
The app uses Express. There is no existing rate-limiting middleware. We want
5 attempts per 15 minutes per IP, returning 429 on breach.

Design an implementation plan: what package to use, where to add it, what the
middleware should look like, and any edge cases to consider. Do not write code —
return a step-by-step plan only.
```

**Why Plan:** Gets architecture decisions settled before any code is written, without burning the main context on research.

---

## Parallel independent research

Two agents running in the background simultaneously:

```
Agent 1 (run_in_background: true):
  Audit src/db/ for any raw SQL string concatenation that could be a SQL injection
  risk. Report file, line number, and the vulnerable pattern. Under 200 words.

Agent 2 (run_in_background: true):
  Audit src/api/ for any endpoints that read user-supplied input directly into a
  file path without sanitization. Report file, line number, and the pattern.
  Under 200 words.
```

**Why parallel:** Both tasks are independent reads of different directories. Running sequentially would double the wall-clock time for no reason.

---

## Isolated code change (worktree isolation)

```
subagent_type: claude
isolation: worktree

Refactor all console.log calls in src/ to use the logger at src/utils/logger.ts.
The logger exports: logger.info(), logger.warn(), logger.error(). Map log levels
by context — errors and exceptions go to error, warnings to warn, everything else
to info. Do not change any test files. Commit the changes when done.
```

**Why worktree:** A sweeping multi-file rename — safer to review the diff on an isolated branch before merging rather than having it land directly in the working tree.

---

## Bad prompt vs good prompt

| | Bad | Good |
|---|---|---|
| Goal | "Fix the auth bug" | "Fix the null crash in `validateToken` at src/auth/session.ts:142" |
| Context | (none) | "The function returns null for expired tokens instead of throwing `TokenExpiredError` (src/errors.ts:18)" |
| Output | (none) | "Make it throw; don't change the function signature" |
| Scope | (none) | "No other files need to change" |

The bad prompt forces the agent to spend half its budget just figuring out what you meant. The good prompt lets it go straight to work.
