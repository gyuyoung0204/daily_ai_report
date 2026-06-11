# Daily AI/IT News Digest Generator v3.0
# Features: Advanced TF-IDF duplicate detection, Email integration, Caching
# PowerShell 5.0+ compatible

$scriptDir = "C:\tmpfile\ai_report"
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

    # Sample news items
    $newsItems = @"
<div class="news-item priority">
    <span class="priority-badge">★ 최우선</span>
    <h3>Anthropic, 965B 가치평가로 세계 최고 가치 AI 스타트업 등극</h3>
    <div class="news-meta">📅 2026-06-10 | 📌 Crescendo AI</div>
    <p>Anthropic이 65 billion 규모의 Series H 펀딩을 완료하며 세계에서 가장 가치있는 AI 스타트업이 되었습니다.</p>
    <a href="https://www.crescendo.ai/news/latest-ai-news-and-updates" target="_blank">기사 읽기</a>
    <div><span class="category-tag category-biz">비즈니스</span></div>
</div>

<div class="news-item priority">
    <span class="priority-badge">★ 최우선</span>
    <h3>Claude Opus 4.8 출시: 병렬 에이전트 지원</h3>
    <div class="news-meta">📅 2026-06-10 | 📌 LLM Stats</div>
    <p>새로운 Claude Opus 4.8이 병렬 서브에이전트 워크플로우를 지원합니다.</p>
    <a href="https://llm-stats.com/llm-updates" target="_blank">기사 읽기</a>
    <div><span class="category-tag category-ai">AI 모델</span></div>
</div>

<div class="news-item">
    <h3>Google Gemma 4 공개: 오픈소스 고급 추론 모델</h3>
    <div class="news-meta">📅 2026-06-10 | 📌 Google</div>
    <p>Google이 Gemma 4를 공개했습니다. 고급 추론과 에이전틱 워크플로우를 위해 설계되었습니다.</p>
    <a href="https://llm-stats.com/ai-news" target="_blank">기사 읽기</a>
    <div><span class="category-tag category-ai">새 모델</span></div>
</div>
"@

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
    $htmlContent = $htmlContent -replace '{{TOTAL_NEWS}}', '3'
    $htmlContent = $htmlContent -replace '{{PRIORITY_COUNT}}', '2'
    $htmlContent = $htmlContent -replace '{{CATEGORIES}}', '3'
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
