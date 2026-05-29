# Claude Code Learning Repository

This repo is a structured, hands-on reference for learning Claude Code — Anthropic's CLI tool and agentic coding environment. Each topic is explored with real working examples that are committed to git so they can be studied, reused, and pushed to GitHub.

## What we are building

A clean, well-documented repository that covers:

- `CLAUDE.md` — how this file works and why it matters
- Skills — custom slash commands and built-in skill reference
- Hooks — event-driven shell commands (pre/post tool calls, on-stop, etc.)
- Agents — spawning subagents, the Agent tool, specialized agent types
- MCP servers — extending Claude Code with external tool integrations
- Memory — the persistent `.claude/memory/` system across sessions
- Settings & permissions — `settings.json`, allowlists, environment variables

## Repository structure

```
claude-cli/
├── CLAUDE.md                  # This file — loaded every session
├── .claude/
│   ├── settings.json          # Permissions, hooks, env vars
│   ├── commands/              # Custom skill definitions (.md files)
│   └── memory/                # Persistent memory across sessions
├── docs/
│   ├── skills.md              # Skills deep-dive notes
│   ├── hooks.md               # Hooks deep-dive notes
│   ├── agents.md              # Agents deep-dive notes
│   ├── mcp.md                 # MCP servers deep-dive notes
│   └── memory.md              # Memory system deep-dive notes
└── examples/                  # Working code examples per topic
```

## Conventions

- All documentation is written in plain GitHub-flavored Markdown
- Examples are self-contained and runnable where possible
- Commit messages follow the pattern: `topic: short description` (e.g. `hooks: add pre-tool example`)
- No generated boilerplate — every file has a reason to exist

## Instructions for Claude

- This is a learning project — explain the *why* behind decisions, not just the *what*
- Keep explanations concise; link to official docs rather than reproducing them verbatim
- When adding examples, prefer minimal working cases over exhaustive ones
- Commit after each topic section is complete so the git history tells the learning story
- Do not add features or files outside the roadmap without asking first
- Default to no comments in code unless the behavior would surprise a reader

## Useful references

- Claude Code docs: https://docs.anthropic.com/en/docs/claude-code
- Claude API docs: https://docs.anthropic.com/en/api
- GitHub repo for issues/feedback: https://github.com/anthropics/claude-code
