# Agents

Agents are subprocesses Claude Code can spawn to handle work in parallel or in isolation. Each agent starts with its own fresh context window — it has no memory of the parent conversation unless you brief it explicitly in the prompt.

## The Agent tool

Claude Code spawns agents via the built-in `Agent` tool. Key parameters:

| Parameter | Type | Description |
|---|---|---|
| `description` | string | 3–5 word label shown in the UI |
| `prompt` | string | The full task brief — must be self-contained |
| `subagent_type` | string | Which specialized agent to use (default: `general-purpose`) |
| `run_in_background` | boolean | Run without blocking the parent (default: `false`) |
| `isolation` | `"worktree"` | Clone the repo into a temporary git worktree so changes are isolated |

## Built-in agent types

| Type | Best for |
|---|---|
| `claude` | Catch-all; full tool access |
| `general-purpose` | Multi-step research, open-ended investigation |
| `Explore` | Fast read-only search — finding files, symbols, references |
| `Plan` | Designing implementation strategy before writing code |
| `claude-code-guide` | Questions about Claude Code CLI, Agent SDK, or Anthropic API |
| `statusline-setup` | Configuring the Claude Code status line |

## Foreground vs background

**Foreground** (default) — parent waits for the agent to finish before continuing. Use when you need the result to inform your next step.

**Background** (`run_in_background: true`) — parent continues immediately; you are notified when the agent completes. Use for genuinely independent work that doesn't block the main task.

## Worktree isolation

Setting `isolation: "worktree"` checks the repo out into a temporary branch and directory. The agent's file edits don't touch your working tree. If the agent makes no changes, the worktree is cleaned up automatically; otherwise the branch name and path are returned so you can review or merge.

Use this when an agent might make sweeping changes you want to review before applying, or when running multiple agents in parallel that each modify files.

## Writing a good prompt

The agent starts cold — it knows nothing about the conversation, the codebase, or why the task matters. A good prompt:

- States the goal and the **why** behind it
- Mentions what has already been tried or ruled out
- Names specific files, symbols, or line numbers where relevant
- Specifies the expected output format
- Ends with a scope cap if you only need a short answer

A bad prompt: `"Fix the bug"` — the agent has no idea what bug or where.

A good prompt: `"There's a null-pointer crash in src/auth/session.ts:142 when a user logs in with an expired token. The validateToken function returns null instead of throwing. Fix it so it throws a TokenExpiredError instead. The error class is already defined at src/errors.ts:18."`

## Continuing an agent

If an agent is still running or recently completed, send it a follow-up message with `SendMessage` targeting its ID or name rather than spawning a new one. A new `Agent` call always starts fresh with no prior context.

## When to use agents vs inline tools

Use an **agent** when:
- The task needs more than 3 rounds of search/read to explore
- You want to protect the main context window from noisy output
- Two or more independent tasks can run in parallel
- A task needs worktree isolation

Use **inline tools** when:
- You already know the file path or symbol name
- The task is a single targeted lookup
- You need the result immediately and it's cheap to get

## Examples in this repo

- `examples/agents/example-prompts.md` — reference prompts for common agent scenarios
