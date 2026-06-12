# PostToolUse hook: 한글 포함 .ps1 파일에 UTF-8 BOM 자동 부착
# PowerShell 5.1에서 BOM 없는 한글 .ps1이 파싱 깨지는 문제를 구조적으로 방지.
# stdin으로 PostToolUse JSON을 받아 tool_input.file_path를 검사한다.

try {
    $raw = [Console]::In.ReadToEnd()
    if (-not $raw) { exit 0 }
    $payload = $raw | ConvertFrom-Json
    $path = $payload.tool_input.file_path
    if (-not $path) { exit 0 }
    if ($path -notmatch '\.ps1$') { exit 0 }
    if (-not (Test-Path $path)) { exit 0 }

    $bytes = [System.IO.File]::ReadAllBytes($path)
    $hasBom = ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)
    $text = [System.Text.Encoding]::UTF8.GetString($bytes)
    $hasKorean = $text -match '[가-힣]'

    if ($hasKorean -and -not $hasBom) {
        $clean = [System.Text.UTF8Encoding]::new($false).GetString($bytes)
        [System.IO.File]::WriteAllText($path, $clean, [System.Text.UTF8Encoding]::new($true))
        Write-Output "[add-bom] UTF-8 BOM added to $path (Korean text, PS 5.1 safety)"
    }
    exit 0
}
catch {
    # 훅 실패가 작업을 막지 않도록 조용히 통과
    exit 0
}
