# PostToolUse hook (v3 자동 검증 컨베이어):
# daily_ai_digest.html이 막 생성/수정된 직후 QUALITY_RUBRIC.md의 정형 지표 일부를 자동 점검한다.
# 다이제스트는 generate_digest.ps1(PowerShell)로 쓰이므로 Write 도구가 아닌 '최근 수정 시각'으로 감지한다.
# 사람이 전체를 정독하는 대신 '품질 예외'만 포착하는 가벼운 게이트. 작업은 막지 않는다(항상 exit 0).

try {
    # stdin(PostToolUse JSON)은 소비만 한다(파싱 실패해도 무시)
    $null = [Console]::In.ReadToEnd()

    $projectDir = $env:CLAUDE_PROJECT_DIR
    if (-not $projectDir) { $projectDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot) }

    $htmlPath = Join-Path $projectDir "daily_ai_digest.html"
    if (-not (Test-Path $htmlPath)) { exit 0 }

    # 방금(15초 이내) 생성/수정된 경우에만 검증 — 무관한 도구 호출에는 반응하지 않는다
    $ageSec = ((Get-Date) - (Get-Item $htmlPath).LastWriteTime).TotalSeconds
    if ($ageSec -gt 15) { exit 0 }

    $verifyLog = Join-Path $projectDir "logs\verify_log.txt"
    $logDir = Split-Path $verifyLog
    if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }

    $html = Get-Content -Path $htmlPath -Raw -Encoding UTF8
    $exceptions = @()

    # 1) 미치환 플레이스홀더 남았는가
    if ($html -match '\{\{[A-Z_]+\}\}') { $exceptions += "미치환 플레이스홀더 잔존" }

    # 2) 출처 표기율: 뉴스 항목 수 vs 출처 링크 수 (ASCII 앵커로 인코딩 안전하게)
    $newsCount = ([regex]::Matches($html, 'class="news-item')).Count
    $linkCount = ([regex]::Matches($html, 'target="_blank"')).Count
    if ($newsCount -gt 0 -and $linkCount -lt $newsCount) {
        $exceptions += "출처 링크 누락 ($linkCount/$newsCount)"
    }

    # 3) 산출물 크기 sanity
    $size = (Get-Item $htmlPath).Length
    if ($size -lt 2000) { $exceptions += "산출물 비정상 (${size}b)" }

    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    if ($exceptions.Count -eq 0) {
        $line = "$ts | [VERIFY] PASS - 뉴스 ${newsCount}건, 출처 ${linkCount}건, ${size}b"
        Add-Content -Path $verifyLog -Value $line -Encoding UTF8
        Write-Output "[verify-digest] PASS: 뉴스 ${newsCount}건 / 출처 ${linkCount}건 / ${size}b. 상세 채점은 /quality-check"
    } else {
        $joined = $exceptions -join "; "
        $line = "$ts | [VERIFY] EXCEPTION - $joined"
        Add-Content -Path $verifyLog -Value $line -Encoding UTF8
        Write-Output "[verify-digest] WARN 품질 예외: $joined -> /quality-check 로 정밀 진단 권장"
    }
    exit 0
}
catch {
    # 훅 실패가 작업을 막지 않도록 조용히 통과
    exit 0
}
