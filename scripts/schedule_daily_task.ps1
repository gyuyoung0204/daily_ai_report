# Windows Task Scheduler에 매일 자동 실행 작업 등록
# 관리자 권한으로 실행해야 함

param(
    [string]$Time = "09:00",
    [string]$TaskName = "Daily_AI_IT_Digest",
    [string]$TaskPath = "\AI_Digest\",
    [switch]$Remove
)

# ============================================================================
# 관리자 권한 확인
# ============================================================================
function Test-AdminRights {
    $isAdmin = [Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544'
    if (-not $isAdmin) {
        Write-Host "❌ 이 스크립트는 관리자 권한으로 실행해야 합니다." -ForegroundColor Red
        Write-Host "PowerShell을 관리자 권한으로 열어주세요." -ForegroundColor Yellow
        Write-Host "`n방법:" -ForegroundColor Cyan
        Write-Host "  1. Windows 검색에서 'PowerShell' 입력" -ForegroundColor Gray
        Write-Host "  2. 'Windows PowerShell (관리자)' 우클릭" -ForegroundColor Gray
        Write-Host "  3. '관리자 권한으로 실행' 클릭" -ForegroundColor Gray
        exit 1
    }
    return $true
}

# ============================================================================
# 스크립트 경로 해결 (상대 경로 버그 수정)
# ============================================================================
function Resolve-ScriptPath {
    param([string]$ScriptPath)

    # 절대 경로 변환
    if (-not [System.IO.Path]::IsPathRooted($ScriptPath)) {
        $ScriptPath = Join-Path (Get-Location) $ScriptPath
    }

    $resolvedPath = Resolve-Path -Path $ScriptPath -ErrorAction SilentlyContinue

    if ($null -eq $resolvedPath) {
        Write-Host "❌ 스크립트 경로를 찾을 수 없습니다: $ScriptPath" -ForegroundColor Red
        return $null
    }

    return $resolvedPath.Path
}

# ============================================================================
# 기존 작업 제거
# ============================================================================
function Remove-ExistingTask {
    param([string]$TaskName, [string]$TaskPath)

    try {
        $fullTaskName = "$TaskPath$TaskName"
        $existingTask = Get-ScheduledTask -TaskName $TaskName -TaskPath $TaskPath -ErrorAction SilentlyContinue

        if ($existingTask) {
            Write-Host "⚠️ 기존 작업을 제거합니다: $fullTaskName" -ForegroundColor Yellow
            Unregister-ScheduledTask -TaskName $TaskName -TaskPath $TaskPath -Confirm:$false -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 2
            Write-Host "✅ 기존 작업 제거 완료" -ForegroundColor Green
            return $true
        }
        return $false
    }
    catch {
        Write-Host "⚠️ 기존 작업 제거 중 오류: $_" -ForegroundColor Yellow
        return $false
    }
}

# ============================================================================
# 작업 경로 생성
# ============================================================================
function Ensure-TaskPath {
    param([string]$TaskPath)

    try {
        $folder = Get-ScheduledTask -TaskPath $TaskPath -ErrorAction SilentlyContinue
        if ($null -eq $folder) {
            Write-Host "📁 작업 폴더를 생성합니다: $TaskPath" -ForegroundColor Yellow
            # 폴더는 자동으로 생성되지 않으므로 작업 생성 시 함께 생성됨
        }
    }
    catch {
        # 무시 - 작업 생성 시 폴더도 자동 생성됨
    }
}

# ============================================================================
# 시간 형식 검증
# ============================================================================
function Test-TimeFormat {
    param([string]$Time)

    if ($Time -match '^\d{2}:\d{2}$') {
        $parts = $Time -split ':'
        $hour = [int]$parts[0]
        $minute = [int]$parts[1]

        if ($hour -ge 0 -and $hour -le 23 -and $minute -ge 0 -and $minute -le 59) {
            return $true
        }
    }

    Write-Host "❌ 잘못된 시간 형식입니다: $Time" -ForegroundColor Red
    Write-Host "올바른 형식: HH:MM (예: 09:00, 14:30)" -ForegroundColor Yellow
    return $false
}

# ============================================================================
# 메인 - 작업 등록
# ============================================================================
function Register-DigestTask {
    param(
        [string]$Time,
        [string]$TaskName,
        [string]$TaskPath,
        [string]$ScriptPath
    )

    Write-Host "`n🚀 Windows Task Scheduler 설정을 시작합니다...`n" -ForegroundColor Cyan

    # 시간 검증
    if (-not (Test-TimeFormat -Time $Time)) {
        exit 1
    }

    # 스크립트 경로 확인
    $resolvedScriptPath = Resolve-ScriptPath -ScriptPath $ScriptPath

    if ($null -eq $resolvedScriptPath) {
        exit 1
    }

    Write-Host "✅ 스크립트 경로 확인: $resolvedScriptPath" -ForegroundColor Green

    # 기존 작업 제거
    Remove-ExistingTask -TaskName $TaskName -TaskPath $TaskPath

    # 작업 폴더 확인
    Ensure-TaskPath -TaskPath $TaskPath

    try {
        # 작업 트리거 (매일 지정된 시간)
        $trigger = New-ScheduledTaskTrigger `
            -Daily `
            -At $Time `
            -ErrorAction Stop

        # 작업 액션 (PowerShell 스크립트 실행)
        # ExecutionPolicy 개선: RemoteSigned 사용 (보안성 향상)
        $action = New-ScheduledTaskAction `
            -Execute "PowerShell.exe" `
            -Argument "-NoProfile -ExecutionPolicy RemoteSigned -File `"$resolvedScriptPath`"" `
            -ErrorAction Stop

        # 작업 설정
        $settings = New-ScheduledTaskSettingsSet `
            -AllowStartIfOnBatteries `
            -DontStopIfGoingOnBatteries `
            -StartWhenAvailable `
            -MultipleInstances IgnoreNew `
            -ExecutionTimeLimit ([timespan]::Zero) `
            -ErrorAction Stop

        # 주요 설정:
        # - AllowStartIfOnBatteries: 배터리 상태에서도 실행
        # - DontStopIfGoingOnBatteries: 배터리로 전환되어도 계속 실행
        # - StartWhenAvailable: 예정된 시간을 놓쳤을 때 다음 기회에 실행
        # - MultipleInstances IgnoreNew: 중복 실행 방지
        # - ExecutionTimeLimit: 제한 없음 (크기가 크면 시간이 걸릴 수 있음)

        # 작업 등록
        Write-Host "`n📝 예약된 작업을 등록 중입니다..." -ForegroundColor Yellow

        $task = Register-ScheduledTask `
            -TaskName $TaskName `
            -TaskPath $TaskPath `
            -Trigger $trigger `
            -Action $action `
            -Settings $settings `
            -Description "자동으로 AI/IT 뉴스 다이제스트를 생성합니다. 뉴스 수집, 중복 제거, 개발자 인사이트 생성 포함." `
            -Force `
            -ErrorAction Stop

        Write-Host "`n✅ 작업이 성공적으로 등록되었습니다!`n" -ForegroundColor Green

        # 작업 정보 출력
        Write-Host "📋 작업 정보:" -ForegroundColor Cyan
        Write-Host "  작업 이름      : $TaskName" -ForegroundColor Gray
        Write-Host "  작업 경로      : $TaskPath" -ForegroundColor Gray
        Write-Host "  실행 시간      : 매일 $Time" -ForegroundColor Gray
        Write-Host "  상태           : $($task.State)" -ForegroundColor Gray
        Write-Host "  마지막 실행    : $($task.LastRunTime)" -ForegroundColor Gray
        Write-Host "  다음 실행      : $($task.NextRunTime)" -ForegroundColor Gray

        # 팁 출력
        Write-Host "`n💡 유용한 팁:" -ForegroundColor Cyan
        Write-Host "  🔍 작업 스케줄러 열기:" -ForegroundColor Gray
        Write-Host "     taskschd.msc" -ForegroundColor Cyan

        Write-Host "`n  ⚙️ 작업 관리:" -ForegroundColor Gray
        Write-Host "     • 즉시 실행: schtasks /run /tn `"$TaskPath$TaskName`"" -ForegroundColor Cyan
        Write-Host "     • 비활성화: schtasks /change /tn `"$TaskPath$TaskName`" /disable" -ForegroundColor Cyan
        Write-Host "     • 활성화:   schtasks /change /tn `"$TaskPath$TaskName`" /enable" -ForegroundColor Cyan
        Write-Host "     • 제거:     schtasks /delete /tn `"$TaskPath$TaskName`" /f" -ForegroundColor Cyan

        Write-Host "`n  📊 로그 확인:" -ForegroundColor Gray
        Write-Host "     logs\digest_log.txt" -ForegroundColor Cyan

        Write-Host "`n✨ 설정이 완료되었습니다! 매일 $Time에 자동으로 실행됩니다.`n" -ForegroundColor Green

        return $true
    }
    catch {
        Write-Host "`n❌ 작업 등록 실패: $_" -ForegroundColor Red
        Write-Host "`n문제 해결:" -ForegroundColor Yellow
        Write-Host "  1. PowerShell이 관리자 권한으로 실행 중인지 확인" -ForegroundColor Gray
        Write-Host "  2. 스크립트 경로가 올바른지 확인" -ForegroundColor Gray
        Write-Host "  3. 다른 PowerShell 창에서 실행 중인지 확인" -ForegroundColor Gray
        return $false
    }
}

# ============================================================================
# 메인 - 작업 제거
# ============================================================================
function Unregister-DigestTask {
    param([string]$TaskName, [string]$TaskPath)

    Write-Host "🗑️ 작업을 제거합니다: $TaskPath$TaskName" -ForegroundColor Yellow

    try {
        Unregister-ScheduledTask -TaskName $TaskName -TaskPath $TaskPath -Confirm:$false -ErrorAction Stop
        Write-Host "✅ 작업이 성공적으로 제거되었습니다." -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ 작업 제거 실패: $_" -ForegroundColor Red
        return $false
    }
}

# ============================================================================
# 메인 실행
# ============================================================================

# 관리자 권한 확인
Test-AdminRights

# 스크립트 경로 설정
$scriptPath = Join-Path (Split-Path -Parent $PSScriptRoot) "scripts\generate_digest.ps1"

# 제거 모드
if ($Remove) {
    Unregister-DigestTask -TaskName $TaskName -TaskPath $TaskPath
    exit 0
}

# 등록 모드
Register-DigestTask -Time $Time -TaskName $TaskName -TaskPath $TaskPath -ScriptPath $scriptPath
