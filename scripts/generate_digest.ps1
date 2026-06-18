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
    # 2026-06-18 news-curator 에이전트가 WebSearch로 출처 검증한 실데이터 8건
    $rawNews = @(
        [PSCustomObject]@{
            title = "마이크로소프트, Build 2026에서 자체 개발 MAI 모델 7종 공개"
            description = "MS가 OpenAI 의존 탈피를 선언하며 추론·코딩·이미지·음성·전사 등 7개 자체 모델을 Azure AI Foundry에 출시했다."
            url = "https://blogs.microsoft.com/blog/2026/06/02/microsoft-build-2026-be-yourself-at-work/"
            source = "Microsoft Official Blog"; date = "2026-06-02"; priority = $true
            category = "category-ai"; categoryLabel = "AI 모델"
        },
        [PSCustomObject]@{
            title = "Anthropic, SEC에 IPO 초안(S-1) 기밀 제출... 기업가치 9,650억 달러"
            description = "앤트로픽이 6월 1일 SEC에 기밀 S-1을 제출하며 2026년 최대 AI IPO 레이스에 합류했고, 상장 시점은 빠르면 10월로 거론된다."
            url = "https://www.cnbc.com/2026/06/01/anthropic-ipo-s1-prospectus.html"
            source = "CNBC"; date = "2026-06-01"; priority = $true
            category = "category-biz"; categoryLabel = "비즈니스"
        },
        [PSCustomObject]@{
            title = "Claude Opus 4.8, AI 인텔리전스 인덱스 1위... 60점 벽 최초 돌파"
            description = "앤트로픽의 Claude Opus 4.8이 Artificial Analysis Intelligence Index에서 61.4점으로 1위에 오르며 60점을 처음 돌파한 모델이 됐다."
            url = "https://llm-stats.com/llm-updates"
            source = "LLM Stats / Artificial Analysis"; date = "2026-05-27"; priority = $true
            category = "category-ai"; categoryLabel = "AI 모델"
        },
        [PSCustomObject]@{
            title = "Google I/O 2026, Gemini 3.5 Flash 출시... 추론·코딩 성능 대폭 향상"
            description = "구글이 I/O 2026에서 Gemini 3.5 Flash를 공개했으며 전작 대비 4배 빠른 속도와 76.2% Terminal-Bench 스코어를 기록했다."
            url = "https://www.marktechpost.com/2026/05/20/google-introduces-gemini-3-5-flash-at-i-o-2026-a-faster-and-cheaper-model-for-ai-agents-and-coding/"
            source = "MarkTechPost"; date = "2026-05-20"; priority = $false
            category = "category-ai"; categoryLabel = "AI 모델"
        },
        [PSCustomObject]@{
            title = "빅테크 4사, 2026년 AI 인프라 투자액 최대 6,650억 달러 전망"
            description = "MS·아마존·구글·메타의 2026년 자본지출 합산이 전년(3,810억 달러) 대비 최대 74% 급증한 6,650억 달러에 달할 것으로 블룸버그가 추산했다."
            url = "https://finance.yahoo.com/news/big-tech-set-to-spend-650-billion-in-2026-as-ai-investments-soar-163907630.html"
            source = "Yahoo Finance / Bloomberg"; date = "2026-06-01"; priority = $false
            category = "category-infra"; categoryLabel = "인프라"
        },
        [PSCustomObject]@{
            title = "CNCF, OpenTelemetry 정식 졸업... AI 에이전트 관측 표준으로 부상"
            description = "CNCF가 OpenTelemetry Graduation을 발표하며 GenAI 시맨틱 컨벤션이 LLM 호출·에이전트·툴 실행 추적의 업계 표준으로 자리잡았다."
            url = "https://thenewstack.io/opentelemetry-hits-general-availability/"
            source = "The New Stack"; date = "2026-06-01"; priority = $false
            category = "category-infra"; categoryLabel = "인프라"
        },
        [PSCustomObject]@{
            title = "Q1 2026 글로벌 벤처 투자 3,000억 달러 역대 최고... OpenAI·앤트로픽 견인"
            description = "2026년 1분기 전 세계 스타트업 투자가 3,000억 달러로 사상 최대를 기록했으며, OpenAI·앤트로픽·xAI·Waymo 4곳이 전체의 63%를 흡수했다."
            url = "https://news.crunchbase.com/venture/record-breaking-funding-ai-global-q1-2026/"
            source = "Crunchbase News"; date = "2026-06-04"; priority = $false
            category = "category-biz"; categoryLabel = "비즈니스"
        },
        [PSCustomObject]@{
            title = "Crusoe, AI 데이터센터 계약 전력 5기가와트 육박... 파이프라인 40GW 상회"
            description = "AI 특화 클라우드 Crusoe가 데이터센터·클라우드 합산 계약 전력 4.9GW를 달성했으며 전체 파이프라인은 40GW를 넘어섰다고 밝혔다."
            url = "https://www.crusoe.ai/resources/newsroom/crusoes-contracted-ai-infrastructure-capacity-approaches-5-gigawatts-across-data-centers-and-cloud"
            source = "Crusoe AI Newsroom"; date = "2026-06-09"; priority = $false
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
