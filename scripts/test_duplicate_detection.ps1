# Test for duplicate_detection.ps1 (Issue #4)
# 실제 뉴스 데이터로 TF-IDF 중복 감지 검증

$ErrorActionPreference = "Stop"
. "$PSScriptRoot\duplicate_detection.ps1"

$testNews = @(
    [PSCustomObject]@{ title = "Anthropic raises 65 billion Series H funding round"; description = "Anthropic completed a massive 65 billion dollar funding round becoming the most valuable AI startup" },
    [PSCustomObject]@{ title = "Anthropic completes 65 billion dollar Series H round"; description = "Anthropic raised 65 billion in Series H funding making it the most valuable AI startup in the world" },
    [PSCustomObject]@{ title = "Google releases Gemma 4 open source model"; description = "Google announced Gemma 4 an open source model designed for advanced reasoning and agentic workflows" },
    [PSCustomObject]@{ title = "Claude Opus 4.8 supports parallel agents"; description = "The new Claude Opus 4.8 model supports parallel subagent workflows for complex tasks" },
    [PSCustomObject]@{ title = "구글 제마 4 오픈소스 모델 공개"; description = "구글이 고급 추론과 에이전트 워크플로우를 위한 오픈소스 모델 제마 4를 공개했다" }
)

Write-Host "=== TF-IDF 중복 감지 테스트 ==="
Write-Host "입력: $($testNews.Count)건 (1,2번은 같은 뉴스의 다른 표현)"
Write-Host ""

$result = Remove-DuplicateNews -NewsItems $testNews -Threshold 0.5

Write-Host "출력: $($result.Count)건"
foreach ($item in $result) {
    Write-Host "  - $($item.title)"
}
Write-Host ""

# 검증
$passed = $true
if ($result.Count -ge $testNews.Count) {
    Write-Host "FAIL: 중복이 하나도 제거되지 않음" -ForegroundColor Red
    $passed = $false
}
if ($result.Count -lt 4) {
    Write-Host "FAIL: 서로 다른 뉴스가 잘못 제거됨 (4건이어야 함, 실제 $($result.Count)건)" -ForegroundColor Red
    $passed = $false
}
$titles = $result | ForEach-Object { $_.title }
if ($titles -notcontains "Google releases Gemma 4 open source model") {
    Write-Host "FAIL: 고유 뉴스(Gemma 4)가 제거됨" -ForegroundColor Red
    $passed = $false
}

if ($passed) {
    Write-Host "PASS: 중복 1건 제거, 고유 뉴스 4건 보존" -ForegroundColor Green
    exit 0
} else {
    exit 1
}
