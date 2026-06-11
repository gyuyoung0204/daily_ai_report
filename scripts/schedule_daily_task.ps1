# Windows Task Scheduler에 매일 자동 실행 작업 등록
# 관리자 권한으로 실행해야 함

param(
    [string]$Time = "09:00",  # 실행 시간 (기본값: 아침 9시)
    [string]$TaskName = "Daily_AI_IT_Digest"
)

# 관리자 권한 확인
$isAdmin = [Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544'
if (-not $isAdmin) {
    Write-Host "❌ 이 스크립트는 관리자 권한으로 실행해야 합니다." -ForegroundColor Red
    Write-Host "PowerShell을 관리자 권한으로 열어주세요." -ForegroundColor Yellow
    exit 1
}

Write-Host "🚀 Windows Task Scheduler 설정을 시작합니다..." -ForegroundColor Cyan

try {
    # 스크립트 경로 확인
    $scriptPath = (Split-Path -Parent $PSScriptRoot) + "\scripts\generate_digest.ps1"

    if (-not (Test-Path $scriptPath)) {
        Write-Host "❌ 스크립트를 찾을 수 없습니다: $scriptPath" -ForegroundColor Red
        exit 1
    }

    # 기존 작업 제거 (있으면)
    Write-Host "📋 기존 작업 확인 중..." -ForegroundColor Yellow
    $existingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue

    if ($existingTask) {
        Write-Host "⚠️ 기존 작업을 제거합니다: $TaskName" -ForegroundColor Yellow
        Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
        Start-Sleep -Seconds 2
    }

    # 작업 트리거 설정 (매일 지정된 시간)
    $trigger = New-ScheduledTaskTrigger -Daily -At $Time

    # 작업 작업 설정 (PowerShell 스크립트 실행)
    $action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
        -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""

    # 작업 설정 (실패 시 재시도, 작업 중복 실행 방지)
    $settings = New-ScheduledTaskSettingsSet `
        -AllowStartIfOnBatteries `
        -DontStopIfGoingOnBatteries `
        -StartWhenAvailable `
        -MultipleInstances IgnoreNew

    # 작업 등록
    Write-Host "📝 예약된 작업을 등록 중입니다..." -ForegroundColor Yellow
    Register-ScheduledTask `
        -TaskName $TaskName `
        -Trigger $trigger `
        -Action $action `
        -Settings $settings `
        -Description "자동으로 AI/IT 뉴스 다이제스트를 생성하고 HTML 파일을 업데이트합니다." | Out-Null

    Write-Host "✅ 작업이 성공적으로 등록되었습니다!" -ForegroundColor Green
    Write-Host "📅 실행 시간: 매일 $Time" -ForegroundColor Green
    Write-Host "📁 생성 위치: $(Split-Path -Parent $scriptPath)\daily_ai_digest.html" -ForegroundColor Green

    # 작업 정보 출력
    Write-Host "`n📋 작업 정보:" -ForegroundColor Cyan
    $task = Get-ScheduledTask -TaskName $TaskName
    Write-Host "  - 작업 이름: $($task.TaskName)"
    Write-Host "  - 상태: $($task.State)"
    Write-Host "  - 경로: $($task.TaskPath)"

    Write-Host "`n💡 팁:" -ForegroundColor Cyan
    Write-Host "  • 작업 스케줄러를 열려면: taskschd.msc"
    Write-Host "  • 작업을 수동으로 실행하려면: schtasks /run /tn $TaskName"
    Write-Host "  • 작업을 제거하려면: Unregister-ScheduledTask -TaskName $TaskName"

}
catch {
    Write-Host "❌ 오류 발생: $_" -ForegroundColor Red
    exit 1
}
