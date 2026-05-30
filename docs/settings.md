# Settings & Permissions

Claude Code's behavior is controlled by JSON settings files. These files configure permissions, hooks, MCP servers, environment variables, and more.

## Settings files

Three files are read on startup, in order from lowest to highest precedence:

| File | Scope | Committed to git? |
|---|---|---|
| `~/.claude/settings.json` | Global — every project on your machine | No (personal) |
| `.claude/settings.json` | Project — everyone who clones this repo | Yes |
| `.claude/settings.local.json` | Local override — your machine only | No (add to `.gitignore`) |

Higher-precedence files win on conflicts. `settings.local.json` is the right place for personal API keys, tokens, or permission overrides you don't want to share.

## Full schema

```json
{
  "permissions": {
    "allow": [],
    "deny": []
  },
  "hooks": {},
  "mcpServers": {},
  "env": {}
}
```

Each section is independent — you can use any combination.

## Permissions

The `permissions` block controls which tool calls require user approval.

```json
{
  "permissions": {
    "allow": [
      "Bash(git *)",
      "Bash(npm install *)",
      "Read",
      "Edit"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(curl * | bash *)"
    ]
  }
}
```

### Pattern syntax

| Pattern | Matches |
|---|---|
| `"Read"` | Any Read tool call |
| `"Bash(git *)"` | Any Bash command starting with `git` |
| `"Bash(npm install *)"` | Bash commands starting with `npm install` |
| `"mcp__github__*"` | Any tool from the `github` MCP server |

Patterns use glob-style matching. The tool name comes first; argument patterns go inside parentheses.

### Precedence

**deny always beats allow.** If a tool call matches both an `allow` and a `deny` pattern, it is blocked. The prompt order is:

```
deny → blocked (no prompt)
allow → permitted (no prompt)
no match → user is prompted
```

### Common allow patterns

```json
"allow": [
  "Bash(git *)",
  "Bash(npm *)",
  "Bash(npx *)",
  "Read",
  "Edit",
  "Write",
  "Glob",
  "Grep"
]
```

Read, Edit, Write, Glob, and Grep are low-risk local operations — allowing them removes the most frequent prompts. Bash commands are higher-risk, so allow them selectively by prefix.

## Environment variables

The `env` block injects variables into Claude Code's process at startup. Useful for setting project-specific config without modifying your shell profile:

```json
{
  "env": {
    "NODE_ENV": "development",
    "LOG_LEVEL": "debug"
  }
}
```

Variables in `settings.local.json` are the right place for secrets (API keys, tokens) — they stay off disk in the committed files.

## Hooks

The `hooks` block is covered in full in `docs/hooks.md`. Short form:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "",
        "hooks": [{ "type": "command", "command": "pwsh -File examples/hooks/log-tool-calls.ps1" }]
      }
    ]
  }
}
```

## MCP servers

The `mcpServers` block is covered in full in `docs/mcp.md`. Short form:

```json
{
  "mcpServers": {
    "github": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "..." }
    }
  }
}
```

## Managing settings with /update-config

Rather than editing JSON by hand, use the built-in `/update-config` skill:

```
/update-config allow npm commands
/update-config add Bash(pytest *) to project settings
/update-config set LOG_LEVEL=debug in env
```

`/update-config` writes to the correct file (project vs global vs local) and handles the JSON structure for you.

## This repo's settings

- `.claude/settings.json` — project permissions shared with anyone who clones the repo
- `.claude/settings.local.json` — personal allow-list for git operations (not committed)

## Examples in this repo

- `examples/settings/settings-full-example.json` — all four sections wired together in one file
