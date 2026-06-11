# Advanced Duplicate Detection using TF-IDF
# 뉴스 항목 간 유사도를 분석하여 정교한 중복 제거

param(
    [array]$NewsItems,
    [double]$SimilarityThreshold = 0.85
)

function Get-TfIdfScore {
    param(
        [string]$Text,
        [array]$AllTexts
    )

    # 텍스트 정규화
    $normalized = $Text.ToLower() -replace '[^a-z0-9가-힣\s]', ''
    $words = $normalized -split '\s+' | Where-Object { $_.Length -gt 1 }

    # TF (Term Frequency) 계산
    $tf = @{}
    foreach ($word in $words) {
        if ($tf.ContainsKey($word)) {
            $tf[$word] += 1
        } else {
            $tf[$word] = 1
        }
    }

    # 단어 빈도를 정규화
    foreach ($word in $tf.Keys) {
        $tf[$word] = $tf[$word] / $words.Count
    }

    return $tf
}

function Get-CosineSimilarity {
    param(
        [hashtable]$TfA,
        [hashtable]$TfB
    )

    # 공통 단어 찾기
    $commonWords = @($TfA.Keys) | Where-Object { $TfB.ContainsKey($_) }

    if ($commonWords.Count -eq 0) { return 0 }

    # 분자: 두 벡터의 내적
    $dotProduct = 0
    foreach ($word in $commonWords) {
        $dotProduct += $TfA[$word] * $TfB[$word]
    }

    # 분모: 각 벡터의 크기
    $magnitudeA = [Math]::Sqrt(($TfA.Values | ForEach-Object { $_ * $_ } | Measure-Object -Sum).Sum)
    $magnitudeB = [Math]::Sqrt(($TfB.Values | ForEach-Object { $_ * $_ } | Measure-Object -Sum).Sum)

    if ($magnitudeA -eq 0 -or $magnitudeB -eq 0) { return 0 }

    return $dotProduct / ($magnitudeA * $magnitudeB)
}

function Remove-DuplicateNews {
    param(
        [array]$NewsItems,
        [double]$Threshold = 0.85
    )

    if ($NewsItems.Count -le 1) { return $NewsItems }

    $uniqueNews = @()
    $processedIndices = @()

    for ($i = 0; $i -lt $NewsItems.Count; $i++) {
        if ($processedIndices -contains $i) { continue }

        $currentNews = $NewsItems[$i]
        $uniqueNews += $currentNews
        $processedIndices += $i

        # 현재 뉴스와 비교할 텍스트 (제목 + 설명)
        $currentText = "$($currentNews.title) $($currentNews.description)"
        $currentTf = Get-TfIdfScore $currentText

        # 나머지 뉴스 항목과 비교
        for ($j = $i + 1; $j -lt $NewsItems.Count; $j++) {
            if ($processedIndices -contains $j) { continue }

            $compareNews = $NewsItems[$j]
            $compareText = "$($compareNews.title) $($compareNews.description)"
            $compareTf = Get-TfIdfScore $compareText

            # 코사인 유사도 계산
            $similarity = Get-CosineSimilarity $currentTf $compareTf

            # 유사도가 높으면 중복으로 표시
            if ($similarity -ge $Threshold) {
                $processedIndices += $j
                Write-Verbose "중복 감지: '$($currentNews.title)' vs '$($compareNews.title)' (유사도: $([Math]::Round($similarity*100,1))%)"
            }
        }
    }

    return $uniqueNews
}

# 스크립트가 직접 실행되는 경우
if ($MyInvocation.InvocationName -ne '.') {
    Write-Host "중복 제거 모듈 로드됨"
    Write-Host "사용: Remove-DuplicateNews -NewsItems `$items -Threshold 0.85"
}

# Export 함수
Export-ModuleMember -Function @(
    'Get-TfIdfScore',
    'Get-CosineSimilarity',
    'Remove-DuplicateNews'
)
