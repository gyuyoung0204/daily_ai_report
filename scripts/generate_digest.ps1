# Daily AI/IT News Digest Generator v3.0
# Features: Advanced TF-IDF duplicate detection, Email integration, Caching
# PowerShell 5.0+ compatible

# 저장소 루트를 스크립트 위치 기준 상대경로로 해석 (이식성 - Issue #12)
$scriptDir = Split-Path -Parent $PSScriptRoot
$OutputPath = "$scriptDir\daily_ai_digest.html"
$LogPath = "$scriptDir\logs\digest_log.txt"
$CachePath = "$scriptDir\data\news_cache.json"
$TemplatePath = "$scriptDir\templates\digest_template.html"
$DuplicateDetectionScript = "$scriptDir\scripts\duplicate_detection.ps1"
$EmailScript = "$scriptDir\scripts\send_email_digest.ps1"

# Create log directory
$logDir = Split-Path -Parent $LogPath
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

# Log function
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp | [$Level] $Message"
    Write-Host $logEntry
    Add-Content -Path $LogPath -Value $logEntry -Encoding UTF8
}

Write-Log "========== Daily AI/IT Digest Generation Started ==========" "INFO"

try {
    # Check template exists
    if (-not (Test-Path $TemplatePath)) {
        throw "Template not found: $TemplatePath"
    }

    # Load template
    $htmlTemplate = Get-Content -Path $TemplatePath -Raw -Encoding UTF8

    # Prepare data
    $currentDate = Get-Date -Format "yyyy년 M월 d일 (ddd)"
    $lastUpdated = Get-Date -Format "yyyy-MM-dd HH:mm"
    $nextUpdate = (Get-Date).AddDays(1).ToString("yyyy-MM-dd 09:00")

    # Load duplicate detection module (Issue #4)
    . $DuplicateDetectionScript

    # News items as structured objects (enables duplicate detection before rendering)
    # 2026-06-12 news-curator 에이전트가 WebSearch로 출처 검증한 실데이터
    $rawNews = @(
        [PSCustomObject]@{
            title = "마이크로소프트, MAI 모델 7종 동시 출시로 OpenAI 의존도 낮춘다"
            description = "MS가 Build 2026에서 추론·코딩·이미지·음성·전사 분야의 자체 개발 MAI 모델 7종을 공개, 최대 10배 효율 향상을 주장하는 Frontier Tuning 기술도 함께 발표했다."
            url = "https://microsoft.ai/news/building-a-hillclimbing-machine-launching-seven-new-mai-models/"
            source = "Microsoft AI News"; date = "2026-06-02"; priority = $true
            category = "category-ai"; categoryLabel = "AI 모델"
        },
        [PSCustomObject]@{
            title = "애플 WWDC 2026: 구글 Gemini 탑재 'Siri AI' 공개, iOS 27 발표"
            description = "애플이 WWDC 2026에서 구글 Gemini 기반으로 완전히 재설계된 Siri AI를 발표하고, 경쟁 챗봇과의 연동 계획도 함께 공개했다."
            url = "https://techcrunch.com/2026/06/09/wwdc-2026-everything-announced-on-siri-ai-os-27-apple-intelligence-and-more/"
            source = "TechCrunch"; date = "2026-06-09"; priority = $true
            category = "category-ai"; categoryLabel = "AI 모델"
        },
        [PSCustomObject]@{
            title = "OpenAI, 비밀 S-1 SEC 제출…IPO 경쟁 본격화"
            description = "OpenAI가 기업공개를 위해 SEC에 비밀 예비 S-1을 제출했으며, 852B 밸류에이션으로 2026년 하반기 상장을 검토 중이다."
            url = "https://fortune.com/2026/06/09/openai-files-confidential-s-1-sec-ipo/"
            source = "Fortune"; date = "2026-06-09"; priority = $false
            category = "category-biz"; categoryLabel = "비즈니스"
        },
        [PSCustomObject]@{
            title = "Anthropic, 965B 밸류에이션으로 IPO 비밀 제출…OpenAI 첫 추월"
            description = "Anthropic이 65B Series H 마감 직후 SEC에 S-1을 비밀 제출하며 OpenAI(852B)를 처음으로 기업가치에서 앞질렀고, 연환산 매출 47B을 공개했다."
            url = "https://fortune.com/2026/06/01/anthropic-confidentially-files-ipo-965-billion-valuation/"
            source = "Fortune"; date = "2026-06-01"; priority = $false
            category = "category-biz"; categoryLabel = "비즈니스"
        },
        [PSCustomObject]@{
            title = "NVIDIA·SK하이닉스, AI 팩토리용 차세대 메모리 다년간 공동 개발 협약"
            description = "양사가 Vera Rubin 슈퍼컴퓨터·RTX Spark PC·Jetson Thor 로봇 플랫폼용 메모리를 공동 개발하는 다년 기술 파트너십을 체결했다."
            url = "https://nvidianews.nvidia.com/news/sk-hynix-ai-factory"
            source = "NVIDIA Newsroom"; date = "2026-06-07"; priority = $false
            category = "category-infra"; categoryLabel = "인프라"
        },
        [PSCustomObject]@{
            title = "마블, AI 인프라 수요 급증에 힘입어 S&P 500 편입 확정"
            description = "AI 데이터센터 맞춤형 칩 수요 폭증을 배경으로 Marvell이 6월 22일부터 S&P 500에 공식 편입되며, 주가가 급등했다."
            url = "https://www.fxleaders.com/news/2026/06/11/marvell-joins-sp-500-on-ai-infrastructure-surge/"
            source = "FX Leaders"; date = "2026-06-11"; priority = $false
            category = "category-infra"; categoryLabel = "인프라"
        }
    )

    # Apply TF-IDF duplicate removal before rendering
    $uniqueNews = @(Remove-DuplicateNews -NewsItems $rawNews -Threshold 0.85)
    Write-Log "Duplicate detection: $($rawNews.Count) -> $($uniqueNews.Count) items" "INFO"

    $priorityCount = @($uniqueNews | Where-Object { $_.priority }).Count
    $categoryCount = @($uniqueNews | Select-Object -ExpandProperty category -Unique).Count

    # Render news items to HTML
    $newsItems = ($uniqueNews | ForEach-Object {
        $priorityClass = if ($_.priority) { " priority" } else { "" }
        $priorityBadge = if ($_.priority) { '<span class="priority-badge">★ 최우선</span>' } else { "" }
        @"
<div class="news-item$priorityClass">
    $priorityBadge
    <h3>$($_.title)</h3>
    <div class="news-meta">📅 $($_.date) | 📌 $($_.source)</div>
    <p>$($_.description)</p>
    <a href="$($_.url)" target="_blank">기사 읽기</a>
    <div><span class="category-tag $($_.category)">$($_.categoryLabel)</span></div>
</div>
"@
    }) -join "`n"

    # Developer insights
    $insights = @"
<div class="insights-section">
    <h3>개발자를 위한 인사이트</h3>
    <div class="insight-item">
        <span class="insight-label">즉시 확인:</span>
        <div class="insight-content">
            • Claude Opus 4.8 병렬 에이전트 API - 지금 바로 코드 검토 필요<br>
            • Gemma 4 오픈소스 공개 - 로컬 모델로 자체 에이전트 구현 가능
        </div>
    </div>
    <div class="insight-item">
        <span class="insight-label">2주 내 확인:</span>
        <div class="insight-content">
            • 병렬 에이전트 구현 방법 학습<br>
            • OpenAI 의존성 줄일 수 있는지 검토
        </div>
    </div>
</div>
"@

    # Replace placeholders
    $htmlContent = $htmlTemplate -replace '{{DATE}}', $currentDate
    $htmlContent = $htmlContent -replace '{{LAST_UPDATED}}', $lastUpdated
    $htmlContent = $htmlContent -replace '{{NEXT_UPDATE}}', $nextUpdate
    $htmlContent = $htmlContent -replace '{{TOTAL_NEWS}}', $uniqueNews.Count
    $htmlContent = $htmlContent -replace '{{PRIORITY_COUNT}}', $priorityCount
    $htmlContent = $htmlContent -replace '{{CATEGORIES}}', $categoryCount
    $htmlContent = $htmlContent -replace '{{INSIGHTS_SECTION}}', $insights
    $htmlContent = $htmlContent -replace '{{NEWS_ITEMS}}', $newsItems
    $htmlContent = $htmlContent -replace '{{ERROR_MESSAGE}}', ''

    # Save HTML with proper UTF-8 encoding (no BOM)
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($OutputPath, $htmlContent, $Utf8NoBomEncoding)
    Write-Log "HTML generation completed: $OutputPath" "INFO"

    # Update cache
    $cacheData = @{
        metadata = @{
            version = "1.0"
            last_updated = (Get-Date).ToString('o')
            total_news = 3
        }
        cache = @(
            @{ url = "https://www.crescendo.ai/news/latest-ai-news-and-updates"; title = "Anthropic 965B"; date = (Get-Date -Format "yyyy-MM-dd") },
            @{ url = "https://llm-stats.com/llm-updates"; title = "Claude Opus 4.8"; date = (Get-Date -Format "yyyy-MM-dd") },
            @{ url = "https://llm-stats.com/ai-news"; title = "Gemma 4"; date = (Get-Date -Format "yyyy-MM-dd") }
        )
    }
    $cacheData | ConvertTo-Json -Depth 10 | Out-File -FilePath $CachePath -Encoding UTF8
    Write-Log "Cache updated" "INFO"

    Write-Log "========== Daily AI/IT Digest Generation Completed Successfully ==========" "INFO"
}
catch {
    Write-Log "Error: $_" "ERROR"
    Write-Log "========== Generation Failed ==========" "ERROR"
    exit 1
}
