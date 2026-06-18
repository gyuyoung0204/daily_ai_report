# PostToolUse hook: 파일 변경을 logs/digest_log.txt에 기록 (개발규칙 #3)
# stdin으로 PostToolUse JSON을 받아 어떤 파일이 어떤 도구로 변경됐는지 남긴다.

try {
    $raw = [Console]::In.ReadToEnd()
    if (-not $raw) { exit 0 }
    $payload = $raw | ConvertFrom-Json
    $tool = $payload.tool_name
    $path = $payload.tool_input.file_path
    if (-not $path) { exit 0 }

    $projectDir = $env:CLAUDE_PROJECT_DIR
    # fallback: 훅 위치(.claude/hooks) 기준 저장소 루트 (이식성 - Issue #12)
    if (-not $projectDir) { $projectDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot) }
    $logPath = Join-Path $projectDir "logs\digest_log.txt"
    $logDir = Split-Path $logPath
    if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }

    $rel = $path.Replace($projectDir, "").TrimStart("\", "/")
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "$ts | [HOOK] $tool -> $rel"
    Add-Content -Path $logPath -Value $line -Encoding UTF8
    exit 0
}
catch {
    exit 0
}
