# MCP Servers

MCP (Model Context Protocol) is an open protocol for extending Claude Code with external tools and data sources. An MCP server is a process that exposes **tools** and/or **resources** to Claude over a standard interface — giving it the ability to query databases, call APIs, read filesystems outside the project, and more.

## Tools vs resources

| Concept | What it is | How Claude uses it |
|---|---|---|
| **Tool** | A callable function with inputs and outputs | Invoked like any built-in tool |
| **Resource** | A readable data source (file, URL, database row) | Read via `ListMcpResourcesTool` / `ReadMcpResourceTool` |

Most servers expose tools. Resources are less common but useful for exposing structured reference data.

## Transport types

MCP servers communicate with Claude Code over one of two transports:

| Type | How it works | When to use |
|---|---|---|
| `stdio` | Claude Code spawns the server as a subprocess and communicates over stdin/stdout | Local servers, CLI tools, npm packages |
| `sse` | Claude Code connects to an already-running HTTP server via Server-Sent Events | Remote servers, shared team infrastructure |

## Configuration

MCP servers are configured in `.claude/settings.json` (project-scoped) or `~/.claude/settings.json` (global) under `mcpServers`.

**stdio server:**
```json
{
  "mcpServers": {
    "filesystem": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/dir"],
      "env": {}
    }
  }
}
```

**sse server:**
```json
{
  "mcpServers": {
    "my-internal-api": {
      "type": "sse",
      "url": "http://localhost:3000/sse"
    }
  }
}
```

Each server entry needs at minimum:
- `type` — `"stdio"` or `"sse"`
- `command` + `args` (stdio) or `url` (sse)

Use `env` to pass secrets as environment variables rather than hardcoding them in `args`.

## Tool naming

Tools from MCP servers are namespaced automatically:

```
mcp__<server-name>__<tool-name>
```

For example, a server named `github` with a tool `create_issue` becomes `mcp__github__create_issue`. This namespace prevents collisions with built-in tools.

## Scope

| Config file | Server available in |
|---|---|
| `~/.claude/settings.json` | Every project on your machine |
| `.claude/settings.json` | This project only |

Prefer project-scoped config for servers that are specific to a codebase (e.g., a database server for this project). Use global config for general-purpose servers you want everywhere (e.g., web search).

## Security

MCP servers run as subprocesses with your user permissions. Before adding one:

- Only install servers from sources you trust
- Pass secrets via `env`, not via `args` (args are visible in process listings)
- A malicious MCP server can read your files and make network calls — treat it like installing software

## Finding MCP servers

- Official servers: [github.com/modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers)
- Community registry: [mcp.so](https://mcp.so)
- Claude Code ships with several pre-connected servers (Gmail, Google Drive, Notion, etc.) visible in the integrations settings

## Examples in this repo

- `examples/mcp/settings-snippet.json` — project-scoped config for the official filesystem and GitHub MCP servers
