# Performance Monitoring (Issue #10)
# 다이제스트 생성 성능을 측정하여 logs/metrics.json에 누적 기록

param(
    [string]$MetricsFile = "$PSScriptRoot\..\logs\metrics.json"
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $PSScriptRoot
$digestScript = "$PSScriptRoot\generate_digest.ps1"

# 측정 시작
$proc = Get-Process -Id $PID
$memBefore = $proc.WorkingSet64
$sw = [System.Diagnostics.Stopwatch]::StartNew()

# 다이제스트 생성 실행
$digestOutput = powershell -NoProfile -ExecutionPolicy Bypass -File $digestScript 2>&1
$exitCode = $LASTEXITCODE

$sw.Stop()
$proc.Refresh()
$memAfter = $proc.WorkingSet64

# 산출물 크기 측정
$htmlFile = "$scriptDir\daily_ai_digest.html"
$htmlSizeKB = if (Test-Path $htmlFile) { [math]::Round((Get-Item $htmlFile).Length / 1KB, 1) } else { 0 }

$metric = [ordered]@{
    timestamp        = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    duration_ms      = $sw.ElapsedMilliseconds
    exit_code        = $exitCode
    success          = ($exitCode -eq 0)
    output_size_kb   = $htmlSizeKB
    memory_delta_mb  = [math]::Round(($memAfter - $memBefore) / 1MB, 2)
}

# 기존 메트릭에 누적
$history = @()
if (Test-Path $MetricsFile) {
    $existing = Get-Content $MetricsFile -Raw -Encoding UTF8 | ConvertFrom-Json
    $history = @($existing)
}
$history += [PSCustomObject]$metric

$json = ConvertTo-Json @($history) -Depth 3
[System.IO.File]::WriteAllText($MetricsFile, $json, [System.Text.UTF8Encoding]::new($false))

# 요약 출력
Write-Host "=== 성능 측정 결과 ==="
Write-Host "실행 시간   : $($metric.duration_ms) ms"
Write-Host "성공 여부   : $($metric.success)"
Write-Host "산출물 크기 : $($metric.output_size_kb) KB"
Write-Host "누적 기록   : $($history.Count)회"
Write-Host "메트릭 파일 : $MetricsFile"

# 임계값 경고 (10초 초과 시)
if ($metric.duration_ms -gt 10000) {
    Write-Host "WARNING: 실행 시간이 10초를 초과했습니다" -ForegroundColor Yellow
}
