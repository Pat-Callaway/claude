# Hooks

Hooks are shell commands that Claude Code runs automatically in response to specific events — before or after tool calls, when Claude stops, or when a notification fires. They let you add logging, guardrails, and automation without modifying Claude's behavior directly.

## Hook events

| Event | When it fires | Can block? |
|---|---|---|
| `PreToolUse` | Before a tool call executes | Yes |
| `PostToolUse` | After a tool call completes | No |
| `Stop` | When Claude finishes responding | No |
| `SubagentStop` | When a subagent finishes | No |
| `Notification` | When Claude Code emits a status or permission notification | No |

## Configuration

Hooks live in `.claude/settings.json` (project-scoped) or `~/.claude/settings.json` (global) under a `hooks` key.

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "pwsh -File examples/hooks/log-tool-calls.ps1"
          }
        ]
      }
    ]
  }
}
```

Each entry has:
- `matcher` — tool name to target (e.g. `"Bash"`, `"Edit"`) or `""` to match every tool
- `hooks` — array of `{ "type": "command", "command": "..." }` objects

For non-tool events (`Stop`, `SubagentStop`, `Notification`), omit `matcher` — there is no tool to match.

## Input

Claude Code writes a JSON object to the hook's stdin describing the event.

**PreToolUse / PostToolUse:**
```json
{
  "session_id": "abc123",
  "tool_name": "Bash",
  "tool_input": { "command": "git status" },
  "tool_response": { "output": "On branch main..." }
}
```
`tool_response` is only present in `PostToolUse`.

**Stop:**
```json
{
  "session_id": "abc123",
  "stop_reason": "end_turn"
}
```

## Exit codes and blocking

Only `PreToolUse` hooks can block a tool call:

| Exit code | Effect |
|---|---|
| `0` | Allow — tool call proceeds normally |
| `2` | Block — tool call is cancelled; Claude is told why |
| Any other non-zero | Error — tool call still proceeds |

For all other events, exit codes are ignored.

## Output

Anything a `PreToolUse` hook writes to **stdout** is passed to Claude as context before the tool runs. Use this to inject warnings or instructions.

For all other events, stdout is ignored — write to a log file instead.

## Tips

- Use `matcher: ""` to catch every tool call with a single hook
- Hooks run synchronously — slow hooks delay every tool call, so keep them fast
- Chain multiple hooks under one event by adding entries to the `hooks` array
- On Windows use `pwsh -File script.ps1`; on macOS/Linux use `bash script.sh`
- The `/update-config` skill can add hooks to `settings.json` for you

## Examples in this repo

- `examples/hooks/log-tool-calls.ps1` — PostToolUse hook that appends every tool call to a log file
- `examples/hooks/block-rm-rf.ps1` — PreToolUse hook that blocks any Bash command containing `rm -rf`
- `examples/hooks/settings-snippet.json` — settings.json wiring for both examples
