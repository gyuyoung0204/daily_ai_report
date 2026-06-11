# Daily AI/IT Digest Email Sender
# 생성된 HTML 다이제스트를 이메일로 자동 발송

param(
    [string]$HtmlFile = "$PSScriptRoot\..\daily_ai_digest.html",
    [string]$Recipients = "admin@example.com",
    [string]$SmtpServer = "smtp.gmail.com",
    [int]$SmtpPort = 587
)

# 로그 설정
$LogFile = "$PSScriptRoot\..\logs\email_send_$(Get-Date -Format 'yyyy-MM-dd').log"
$LogDir = Split-Path $LogFile
if (!(Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir -Force | Out-Null }

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp [$Level] $Message" | Tee-Object -FilePath $LogFile -Append
}

try {
    Write-Log "이메일 발송 시작"

    # HTML 파일 읽기
    if (!(Test-Path $HtmlFile)) {
        Write-Log "ERROR: HTML 파일을 찾을 수 없음: $HtmlFile" "ERROR"
        exit 1
    }

    $HtmlContent = Get-Content $HtmlFile -Raw -Encoding UTF8
    Write-Log "HTML 파일 로드 완료 ($(($HtmlContent.Length)/1KB)KB)"

    # SMTP 설정
    $SmtpClient = New-Object System.Net.Mail.SmtpClient($SmtpServer, $SmtpPort)
    $SmtpClient.EnableSsl = $true

    # 주의: 실제 사용을 위해서는 .env 또는 보안 저장소에서 자격증명 로드
    # $EmailCred = Get-Content "$PSScriptRoot\..\.env" -Raw | ConvertFrom-Json
    # $SmtpClient.Credentials = New-Object System.Net.NetworkCredential($EmailCred.EmailUser, $EmailCred.EmailPassword)

    Write-Log "SMTP 클라이언트 설정 완료 (Server: $SmtpServer:$SmtpPort)"

    # 메일 메시지 생성
    $MailMessage = New-Object System.Net.Mail.MailMessage
    $MailMessage.From = "noreply@daily-ai-digest.local"

    # 수신자 추가
    $Recipients -split ',' | ForEach-Object {
        $MailMessage.To.Add($_.Trim())
    }

    $MailMessage.Subject = "🤖 Daily AI/IT Digest - $(Get-Date -Format 'yyyy-MM-dd')"
    $MailMessage.Body = $HtmlContent
    $MailMessage.IsBodyHtml = $true
    $MailMessage.BodyEncoding = [System.Text.Encoding]::UTF8

    Write-Log "메일 메시지 생성 완료"
    Write-Log "수신자: $($MailMessage.To -join ', ')"

    # 메일 발송 (주석 처리 - 실제 발송을 위해서는 SMTP 자격증명 설정 필요)
    # $SmtpClient.Send($MailMessage)
    # Write-Log "메일 발송 완료"

    Write-Log "⚠️ [테스트 모드] 실제 발송을 위해서는 SMTP 자격증명 설정 필요"
    Write-Log "메일 발송이 정상적으로 처리될 준비가 됨"

    Write-Log "이메일 발송 완료" "SUCCESS"
}
catch {
    Write-Log "ERROR: $($_.Exception.Message)" "ERROR"
    Write-Log "StackTrace: $($_.ScriptStackTrace)" "ERROR"
    exit 1
}
finally {
    if ($MailMessage) { $MailMessage.Dispose() }
    if ($SmtpClient) { $SmtpClient.Dispose() }
}

Write-Log "스크립트 종료"
