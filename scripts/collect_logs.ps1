# Log Aggregation System (Issue #9)
# logs/ 디렉토리의 모든 로그를 중앙 JSON으로 수집/요약

param(
    [string]$LogDir = "$PSScriptRoot\..\logs",
    [string]$OutputFile = "$PSScriptRoot\..\logs\aggregated_summary.json"
)

$ErrorActionPreference = "Stop"

$entries = @()
$logFiles = @(Get-ChildItem -Path $LogDir -Filter "*.txt" -File -ErrorAction SilentlyContinue)
$logFiles += @(Get-ChildItem -Path $LogDir -Filter "*.log" -File -ErrorAction SilentlyContinue)

foreach ($file in $logFiles) {
    $lines = Get-Content -Path $file.FullName -Encoding UTF8
    foreach ($line in $lines) {
        # 형식: "yyyy-MM-dd HH:mm:ss | [LEVEL] message" 또는 "yyyy-MM-dd HH:mm:ss [LEVEL] message"
        if ($line -match '^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})\s*\|?\s*\[(\w+)\]\s*(.*)$') {
            $entries += [PSCustomObject]@{
                timestamp = $Matches[1]
                level     = $Matches[2]
                message   = $Matches[3]
                source    = $file.Name
            }
        }
    }
}

$errorCount = @($entries | Where-Object { $_.level -eq "ERROR" }).Count
$infoCount  = @($entries | Where-Object { $_.level -eq "INFO" }).Count

$summary = [ordered]@{
    generated_at  = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    log_files     = @($logFiles | ForEach-Object { $_.Name })
    total_entries = $entries.Count
    error_count   = $errorCount
    info_count    = $infoCount
    recent_errors = @($entries | Where-Object { $_.level -eq "ERROR" } | Select-Object -Last 5)
    entries       = $entries
}

$json = $summary | ConvertTo-Json -Depth 5
[System.IO.File]::WriteAllText($OutputFile, $json, [System.Text.UTF8Encoding]::new($false))

Write-Host "로그 수집 완료: $($logFiles.Count)개 파일, $($entries.Count)개 엔트리 (ERROR $errorCount / INFO $infoCount)"
Write-Host "출력: $OutputFile"
