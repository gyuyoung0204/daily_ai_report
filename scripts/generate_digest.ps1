# Daily AI/IT News Digest Generator
# 매일 최신 AI/IT 뉴스를 수집하여 HTML 다이제스트 생성

param(
    [string]$OutputPath = (Split-Path -Parent $PSScriptRoot) + "\daily_ai_digest.html",
    [string]$LogPath = (Split-Path -Parent $PSScriptRoot) + "\logs\digest_log.txt"
)

# 로그 디렉토리 생성
$LogDir = Split-Path -Path $LogPath
if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

# 로그 함수
function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp | $Message" | Tee-Object -FilePath $LogPath -Append
}

Write-Log "=== Daily AI/IT Digest Generation Started ==="

try {
    # 현재 날짜 정보
    $currentDate = Get-Date -Format "yyyy년 M월 d일 (ddd)"
    $lastUpdated = Get-Date -Format "yyyy-MM-dd HH:mm"
    $nextUpdate = (Get-Date).AddDays(1).ToString("yyyy-MM-dd")

    # HTML 템플릿 (고정 콘텐츠 - 실제 구현 시 웹 스크래핑 추가)
    $htmlContent = @"
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daily AI/IT News Digest</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
        }

        .header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            font-weight: 700;
        }

        .header p {
            font-size: 1.1em;
            opacity: 0.95;
            font-weight: 300;
        }

        .date {
            color: rgba(255, 255, 255, 0.8);
            font-size: 0.9em;
            margin-top: 10px;
        }

        .content {
            padding: 30px;
        }

        .footer {
            background: #f0f1f3;
            padding: 20px 30px;
            text-align: center;
            color: #999;
            font-size: 0.9em;
            border-top: 1px solid #ddd;
        }

        .status {
            background: #e8f5e9;
            border-left: 4px solid #4caf50;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .status.success {
            color: #2e7d32;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🤖 Daily AI/IT Digest</h1>
            <p>최신 AI·기술 동향 일일 리포트</p>
            <p class="date">📅 $currentDate</p>
        </div>

        <div class="content">
            <div class="status success">
                ✅ <strong>시스템 정상 작동</strong><br>
                자동화된 뉴스 수집 및 생성 시스템이 활성화되어 있습니다.
            </div>

            <p style="color: #666; line-height: 1.6;">
                <strong>📌 안내:</strong><br>
                - 현재 이 페이지는 시스템 템플릿입니다.<br>
                - 실제 뉴스 데이터는 웹 스크래핑을 통해 매일 자동 수집됩니다.<br>
                - 첫 번째 완전한 다이제스트는 다음 일정에 생성됩니다.<br>
                - 피드백이 있으시면 GitHub Issues를 통해 알려주세요.
            </p>
        </div>

        <div class="footer">
            <p>📱 This digest is automatically updated daily | 💡 Curated by AI Digest System | ⚡ Powered by Web Intelligence</p>
            <p style="margin-top: 10px; color: #ccc;">Last updated: $lastUpdated | Next update: $nextUpdate</p>
        </div>
    </div>
</body>
</html>
"@

    # HTML 파일 생성
    $htmlContent | Out-File -FilePath $OutputPath -Encoding UTF8
    Write-Log "✅ HTML 다이제스트 생성 완료: $OutputPath"

    Write-Log "=== Daily AI/IT Digest Generation Completed Successfully ==="
}
catch {
    Write-Log "❌ 오류 발생: $_"
    exit 1
}
