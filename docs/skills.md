# Skills (Custom Slash Commands)

Skills let you define reusable prompts that run as slash commands inside Claude Code.

## How they work

A skill is a plain Markdown file. The filename becomes the command name.

```
.claude/commands/summarize.md  →  /summarize
.claude/commands/audit.md      →  /audit
```

Invoke them in the Claude Code prompt:
```
/summarize src/index.ts
/audit
```

## Argument passing

Use `$ARGUMENTS` anywhere in the file to capture text typed after the command:

```markdown
Review the file at: $ARGUMENTS
...
```

```
/summarize src/utils.ts
# Claude sees: "Review the file at: src/utils.ts"
```

## Scope

| File location | Available in |
|---|---|
| `~/.claude/commands/name.md` | Every project on your machine |
| `.claude/commands/name.md` | This project only |

## Namespacing with subdirectories

```
.claude/commands/git/standup.md  →  /git:standup
.claude/commands/db/migrate.md   →  /db:migrate
```

## Built-in skills (always available)

Claude Code ships with several built-in skills:

| Command | What it does |
|---|---|
| `/init` | Generate a CLAUDE.md for the current project |
| `/review` | Review a pull request |
| `/simplify` | Refactor changed code for quality and brevity |
| `/security-review` | Security audit of pending branch changes |
| `/update-config` | Modify settings.json, hooks, permissions |
| `/claude-api` | Build/debug Anthropic SDK apps |

## Tips

- Keep skill prompts focused — one skill, one job
- Use `$ARGUMENTS` to make skills reusable across contexts
- Commit project-scoped skills to `.claude/commands/` so the team shares them
- Global skills in `~/.claude/commands/` are personal and not in source control

## Example skills in this repo

- `.claude/commands/summarize.md` — summarize any file or directory in under 200 words
