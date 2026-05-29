# PreToolUse hook — blocks any Bash command containing "rm -rf"
# Wire up in settings.json:
#   "PreToolUse": [{ "matcher": "Bash", "hooks": [{ "type": "command", "command": "pwsh -File examples/hooks/block-rm-rf.ps1" }] }]
#
# Exit code 2 cancels the tool call. Stdout is passed to Claude as context.

$event = [Console]::In.ReadToEnd() | ConvertFrom-Json

if ($event.tool_input.command -match "rm\s+-rf") {
    Write-Output "Blocked: rm -rf is not permitted in this project."
    exit 2
}

exit 0
