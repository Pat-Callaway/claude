# PostToolUse hook — appends each tool call to tool-calls.log
# Wire up in settings.json:
#   "PostToolUse": [{ "matcher": "", "hooks": [{ "type": "command", "command": "pwsh -File examples/hooks/log-tool-calls.ps1" }] }]

$event = [Console]::In.ReadToEnd() | ConvertFrom-Json
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$input_summary = $event.tool_input | ConvertTo-Json -Compress
$line = "$timestamp  [$($event.tool_name)]  $input_summary"

$log_path = Join-Path $PSScriptRoot "tool-calls.log"
Add-Content -Path $log_path -Value $line
