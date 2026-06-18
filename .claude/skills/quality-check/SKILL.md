---
name: quality-check
description: Measure digest/project quality against QUALITY_RUBRIC.md and improve until a target score is reached. Scores 7 weighted dimensions (0-4) via a verification sub-agent, records the round to logs/quality_scores.json, delegates the lowest dimension to existing skills, and re-scores. Includes a memory self-learning loop (read past lessons, prevent repeats). This is the v4 scoring brain — it does not fix code itself.
---

# 📊 /quality-check — 루브릭 기반 품질 측정 + 자가학습 루프 (v4)

산출물을 **막연한 감이 아니라 수치 루브릭으로 채점**하고, 목표 점수에 도달할 때까지 개선을 반복합니다.

> **위임:** 채점은 `quality-evaluator` 에이전트(검증 전담)에, 개선은 `/issue-processor`·`/documentation`에 위임합니다. 이 스킬은 **오케스트레이션만** 합니다(직접 코드 수정 안 함).

## 인자
- 목표 점수 (기본 90)
- 최대 반복 (기본 5)

## 루프 (저장 → 반영 → 측정)

```
/quality-check [목표=90] [최대반복=5]
   │
   ├─▶ [반영] logs/lessons.md(메모리) 먼저 읽기 — 지난 교훈을 채점 기준에 반영
   │
   ├─▶ [측정] quality-evaluator 호출
   │      ├─ QUALITY_RUBRIC.md + SOUL/CLAUDE 로드
   │      ├─ 정형 증거 수집(grep·파일·테스트·생성 실행) + 정성 판단(근거 인용)
   │      └─ 정형/정성 점수표 + 종합 총점·등급
   │
   ├─▶ [저장] logs/quality_scores.json에 회차 기록 + logs/lessons.md에 교훈 1~3줄 append
   │
   ├─ 종합 총점 ≥ 목표?  ── 예 ──▶ 최종 리포트 출력 후 종료 ✅
   │       │
   │       └─ 아니오
   │
   ├─▶ 최저 가중점수 차원 1~2개 → 개선 위임
   │      · 기능/데이터/테스트/견고성/보안 약점 → /issue-processor
   │      · 문서 약점 → /documentation
   │
   └─▶ 재채점 (최대 반복까지)
```

## 종료 조건 (안전장치)
- ✅ 종합 총점 ≥ 목표 → 종료
- ⚠️ 최대 반복(기본 5) 도달 → 사용자 보고 후 중단
- ❌ 점수 정체(2회 연속 미상승) → 임의 진행 대신 사용자 보고 후 중단 (무한 루프 방지)

## 산출물
- **점수 진단 리포트** — 차원별 0~4점(정형+정성) + 근거 + 종합 총점/등급 + 다음 개선 대상
- **[logs/quality_scores.json](logs/quality_scores.json)** — 회차별 점수 누적(추세 추적)
- **[logs/lessons.md](logs/lessons.md)** — 교훈 누적(메모리 자가학습)

## 3원칙 매핑
- **중복 없이:** 루브릭은 `QUALITY_RUBRIC.md` 한 곳에만. 이 스킬은 참조만.
- **사실 기반:** 점수는 실제 파일/이슈/테스트/grep 결과 인용. 근거 없는 점수 금지. 정체 시 임의 진행 금지.
- **정확함:** 각 점수에 구체적 파일명·라인·이슈번호 명시.

**Start by saying:** "품질 점검해줘" 또는 "/quality-check 90".
