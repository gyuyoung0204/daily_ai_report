# 🧠 자가학습 교훈 로그 (Memory)

> `/quality-check` 루프가 **채점 전 먼저 읽고**(반영), 채점 후 새 교훈을 **append**(저장)하는 메모리 파일입니다.
> 형식: `- [날짜] 놓친 것 → 왜 → 어떻게 고칠지`. 같은 실수를 라운드마다 반복하지 않기 위한 자리입니다.
> 연계: [QUALITY_RUBRIC.md](../QUALITY_RUBRIC.md) · [logs/quality_scores.json](quality_scores.json)

---

## 교훈

- [2026-06-18] (iter1, 총점 71.25 🥉Working) 개발자 인사이트 섹션이 하드코딩(generate_digest.ps1:133-151) → 뉴스를 새로 수집해도 인사이트가 고정돼 데이터-산출물 불일치(Gemma4 환각) → 다음 회차에 `$uniqueNews`에서 인사이트를 동적 생성하도록 개선(Issue #13). **기능완성도(Lv2)가 최저 가중 차원 = 다음 할 일.**
- [2026-06-18] 한글 .ps1에서 `$var건`처럼 변수 뒤에 한글이 붙으면 PowerShell이 변수명에 한글을 흡수해 빈값이 된다 → 반드시 `${var}건`으로 감쌀 것(verify-digest.ps1 수정으로 확인). 검증 훅의 정형 카운트는 ASCII 앵커(`target="_blank"`)로 세야 인코딩에 안전.
- [2026-06-18] 자동화·운영(Lv2): logs/metrics.json·aggregated_summary.json이 clone본에 없음(logs/ gitignore) → 운영 메트릭 미수집. 다음 개선 시 measure_performance.ps1을 파이프라인에 연결할 것.
