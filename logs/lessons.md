# 🧠 자가학습 교훈 로그 (Memory)

> `/quality-check` 루프가 **채점 전 먼저 읽고**(반영), 채점 후 새 교훈을 **append**(저장)하는 메모리 파일입니다.
> 형식: `- [날짜] 놓친 것 → 왜 → 어떻게 고칠지`. 같은 실수를 라운드마다 반복하지 않기 위한 자리입니다.
> 연계: [QUALITY_RUBRIC.md](../QUALITY_RUBRIC.md) · [logs/quality_scores.json](quality_scores.json)

---

## 교훈

- [2026-06-18] (iter1, 총점 71.25 🥉Working) 개발자 인사이트 섹션이 하드코딩(generate_digest.ps1:133-151) → 뉴스를 새로 수집해도 인사이트가 고정돼 데이터-산출물 불일치(Gemma4 환각) → 다음 회차에 `$uniqueNews`에서 인사이트를 동적 생성하도록 개선(Issue #13). **기능완성도(Lv2)가 최저 가중 차원 = 다음 할 일.**
- [2026-06-18] 한글 .ps1에서 `$var건`처럼 변수 뒤에 한글이 붙으면 PowerShell이 변수명에 한글을 흡수해 빈값이 된다 → 반드시 `${var}건`으로 감쌀 것(verify-digest.ps1 수정으로 확인). 검증 훅의 정형 카운트는 ASCII 앵커(`target="_blank"`)로 세야 인코딩에 안전.
- [2026-06-18] 자동화·운영(Lv2): logs/metrics.json·aggregated_summary.json이 clone본에 없음(logs/ gitignore) → 운영 메트릭 미수집. 다음 개선 시 measure_performance.ps1을 파이프라인에 연결할 것.
- [2026-06-18] (iter2, 총점 75.94 Solid) 인사이트 동적화(Issue #13)가 해결됐음에도 기능 완성도가 Lv2에 머문 이유 = $rawNews 자체가 수동 하드코딩이라 Lv3(WebSearch 반자동 수집) 진입 조건을 충족하지 못함 → 다음 회차는 $rawNews를 RSS/API에서 실시간 가져오도록 Issue #1을 구체화할 것(/issue-processor 위임). 인사이트 동적화만으로는 점수 상승 폭이 제한적(가중 기여 +0.25점).
- [2026-06-18] (iter2, 총점 75.94 Solid) 자동화·운영(Lv2) 개선 없이는 목표 90점 달성 불가: 현재 가중 기여 0.50/1.00이고, Lv4 달성 시 1.00으로 +0.50점(총점 +12.5점) 기여. measure_performance.ps1을 generate_digest.ps1 파이프라인에 연결해 logs/metrics.json을 자동 생성하고, schedule_daily_task.ps1을 실행 등록하면 Lv3 이상 진입 가능. 운영 지표 자동화가 목표 점수 도달을 위한 두 번째 핵심 축.
