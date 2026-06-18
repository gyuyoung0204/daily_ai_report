# SessionStart hook: 세션 시작 시 프로젝트 상태 요약 출력
# 열린 GitHub 이슈 수와 마지막 성능 메트릭을 보여줘 작업 맥락을 빠르게 잡게 한다.
# 토큰은 settings.local.json에서 읽으며, 없으면 이슈 조회는 건너뛴다.

try {
    $projectDir = $env:CLAUDE_PROJECT_DIR
    # fallback: 훅 위치(.claude/hooks) 기준 저장소 루트 (이식성 - Issue #12)
    if (-not $projectDir) { $projectDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot) }

    $lines = @()
    $lines += "[daily_ai_report] 세션 상태"

    # 마지막 성능 메트릭
    $metricsPath = Join-Path $projectDir "logs\metrics.json"
    if (Test-Path $metricsPath) {
        try {
            $metrics = Get-Content $metricsPath -Raw -Encoding UTF8 | ConvertFrom-Json
            $last = @($metrics)[-1]
            if ($last) { $lines += "  최근 다이제스트 생성: $($last.duration_ms)ms / 성공 $($last.success)" }
        } catch {}
    }

    # 열린 이슈 수 (토큰 있을 때만)
    $localSettings = Join-Path $projectDir ".claude\settings.local.json"
    $token = $null
    if (Test-Path $localSettings) {
        $m = Select-String -Path $localSettings -Pattern 'ghp_[A-Za-z0-9]+' | Select-Object -First 1
        if ($m) { $token = $m.Matches[0].Value }
    }
    if ($token) {
        try {
            $headers = @{ "Authorization" = "token $token"; "Accept" = "application/vnd.github.v3+json" }
            $open = Invoke-RestMethod -Uri "https://api.github.com/repos/gyuyoung0204/daily_ai_report/issues?state=open" -Headers $headers -Method Get -TimeoutSec 5
            $lines += "  열린 GitHub 이슈: $(@($open).Count)개"
        } catch {
            $lines += "  (GitHub 이슈 조회 생략)"
        }
    }

    $lines -join "`n" | Write-Output
    exit 0
}
catch {
    exit 0
}
