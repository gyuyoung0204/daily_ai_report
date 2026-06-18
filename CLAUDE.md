# 👨‍💻 개발 가이드

## 현재 상태: 모든 GitHub Issues 정리 완료 (Open 0개)

**완료·검증됨 (테스트 통과):** 중복 감지 TF-IDF (#4) ✅ | GitHub Actions 자동 댓글 (#5) ✅ | 로그 중앙 수집 (#9) ✅ | 성능 모니터링 (#10) ✅ | /ai-digest 스킬 (#3) ✅ | 경로 이식성 수정 (#12) ✅

**v3·v4 성숙도 (2026-06-18 구축):** v3 검증 하네스 = `quality-evaluator`(검증 전담 서브에이전트, 제작↔검증 분업) + `verify-digest.ps1` 훅(다이제스트 생성 직후 자동 정형 검증, PASS 확인). v4 = `QUALITY_RUBRIC.md`(7차원 SSOT) + `/quality-check`(목표점수까지 측정·개선 루프) + 메모리 자가학습(`logs/lessons.md` 읽고→채점→교훈 append). **baseline 측정: 71.25점 🥉Working**(최저 차원=기능완성도 Lv2, 인사이트 하드코딩 #13).

**Issue #12 (2026-06-18 해결):** `generate_digest.ps1`·`session-status.ps1`의 하드코딩 절대경로(`C:\tmpfile\ai_report`)를 `$PSScriptRoot` 기반 상대경로로 교체. clone/이동한 위치에서도 다이제스트 생성 정상 동작 확인(`daily_ai_digest.html` 12,824 bytes, 커밋 `7e6f71c`).

**Issue는 Closed지만 실제 미완:** 실시간 뉴스 수집 (#1, 40% - news-curator 에이전트가 WebSearch로 실데이터 수집·통합, 자동 스케줄링은 미완)

**범위 제외 (제거됨):** 이메일 발송 (#2) - SMTP 발송 기능은 프로젝트 범위에서 제외하고 `send_email_digest.ps1` 및 관련 참조를 모두 삭제(2026-06-18)

**계획 취소 (not_planned):** #6 ROADMAP | #7 TESTING | #8 Issue Template | #11 자동화 테스트

---

## 파일 구조 (핵심만)

```
daily_ai_report/
├── SOUL.md                         # 프로젝트 비전
├── CLAUDE.md                       # 이 파일 (개발 가이드)
├── README.md                       # 사용 가이드
├── daily_ai_digest.html            # 최종 결과물
├── scripts/
│   ├── generate_digest.ps1         # 뉴스 생성 (수정 필요)
│   ├── duplicate_detection.ps1     # TF-IDF 중복 감지 (테스트 통과)
│   ├── test_duplicate_detection.ps1 # 중복 감지 실데이터 테스트
│   ├── collect_logs.ps1            # 로그 중앙 수집 (Issue #9)
│   ├── measure_performance.ps1     # 성능 측정 (Issue #10)
│   └── schedule_daily_task.ps1     # 자동화 설정
├── data/news_cache.json            # 중복 제거용 캐시
├── logs/                           # 실행 로그 + aggregated_summary.json + metrics.json
├── .github/workflows/
│   └── auto-issue-update.yml       # GitHub Actions
├── QUALITY_RUBRIC.md               # 품질 루브릭 SSOT (7차원·가중치·Lv0~4) [v4]
├── logs/quality_scores.json        # 회차별 점수 누적 [v4]
├── logs/lessons.md                 # 자가학습 교훈 메모리 [v4]
└── .claude/                        # Claude Code 하네스
    ├── settings.json               # env(팀) + hooks (커밋됨)
    ├── settings.local.json         # 권한 + 토큰 (gitignore)
    ├── skills/                     # 진입점 워크플로우 (/명령)
    │   ├── ai-digest/SKILL.md
    │   ├── issue-processor/SKILL.md
    │   ├── documentation/SKILL.md
    │   ├── daily-workflow/SKILL.md
    │   └── quality-check/SKILL.md   # 루브릭 측정 + 자가학습 루프 [v4]
    ├── agents/                     # 독립 컨텍스트 워커
    │   ├── news-curator.md
    │   ├── digest-builder.md
    │   ├── issue-manager.md
    │   ├── doc-keeper.md
    │   └── quality-evaluator.md     # 검증 전담 서브에이전트 (제작↔검증 분업) [v3]
    └── hooks/                      # 이벤트 자동화
        ├── add-bom.ps1             # 한글 .ps1 BOM 자동 부착
        ├── log-activity.ps1        # 파일 변경 로그 기록
        ├── session-status.ps1      # 세션 시작 상태 요약
        └── verify-digest.ps1        # 다이제스트 생성 직후 자동 정형 검증 [v3]
```

---

## 하네스 구조 (Claude Code)

공식 컨벤션에 따라 4계층으로 구성. **한 정보=한 곳** 원칙 적용.

| 계층 | 위치 | 역할 |
|------|------|------|
| 스킬 | `.claude/skills/` | 사용자 진입점·절차 (`/ai-digest` 등). 에이전트에 위임 |
| 에이전트 | `.claude/agents/` | 자체 컨텍스트를 갖는 전문 워커. 메인 대화 오염 방지 |
| 훅 | `.claude/settings.json` | 이벤트 가드레일 (BOM 부착·로그·상태·다이제스트 자동 검증) |
| 메모리 | `CLAUDE.md` (사실) + `logs/lessons.md` (자가학습 교훈) | 항상/회차마다 로드되는 사실 |

**위임 관계:**
- `/ai-digest` → news-curator + digest-builder + issue-manager
- `/issue-processor` → issue-manager
- `/documentation` → doc-keeper
- `/quality-check` → quality-evaluator(채점) → 약점은 /issue-processor·/documentation에 개선 위임 [v4 루프]
- `/daily-workflow` → 위 스킬 순차 오케스트레이션 (또는 에이전트 팀)

**검증 분업 (v3):** 제작(news-curator·digest-builder) ↔ 검증(quality-evaluator + verify-digest 훅)이 분리됨. 다이제스트 생성 직후 verify-digest 훅이 정형 예외를 자동 포착하고, 정밀 채점은 `/quality-check`가 수행.

**에이전트 팀:** `.claude/settings.json`의 `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`로 활성화 (인터랙티브 세션 전용).

---

## 개발 3원칙 (절대 지키기)

### 1️⃣ 중복 없이
- 한 정보는 한 곳에만 존재
- 문서끼리 겹치지 않기
- 오래된 SKILL은 삭제

### 2️⃣ 사실 기반
- 샘플이나 예상 금지
- 실제 파일과 기능만 문서화
- 진행률은 정확한 근거로

### 3️⃣ 정확함
- 모호한 표현 금지
- 구체적인 파일명, 라인번호 명시
- 테스트로 확인 후 문서화

---

## 다음 단계 (우선순위순)

### [높음] Issue #1: 실시간 뉴스 API 연동
- 파일: `scripts/generate_digest.ps1` 수정
- 작업: Google News / RSS 피드 연동 (현재 샘플 데이터 하드코딩 상태)

### [완료] Issue #4: 중복 제거 개선 ✅
- TF-IDF + 코사인 유사도 구현, 실데이터 테스트 통과
- `generate_digest.ps1` 파이프라인에 실제 통합됨
- 테스트: `scripts/test_duplicate_detection.ps1`

---

## 개발 규칙 5가지

1. **한글 인코딩**: `UTF8Encoding($false)` 사용. 한글 .ps1은 BOM 필요 (add-bom.ps1 훅이 자동 처리)
2. **Token 보안**: `.gitignore`에 등록, GitHub에 업로드 금지
3. **로그 기록**: 모든 작업을 `logs/digest_log.txt`에 기록 (log-activity.ps1 훅이 자동 기록)
4. **Git 커밋**: `feat(scope): description` 형식 준수
5. **자동 push**: 커밋 후 사용자 확인 없이 자동 push (사용자 지시)

> 상세 작업 절차는 `/daily-workflow` 스킬에 정의됨 (절차는 스킬, 사실은 이 파일).

---

## 빠른 참고

- **Issues:** https://github.com/gyuyoung0204/daily_ai_report/issues
- **Repository:** https://github.com/gyuyoung0204/daily_ai_report

---

**마지막 수정:** 2026-06-18  
**다음 우선순위:** Issue #1 - 실시간 뉴스 API ($rawNews 하드코딩 → RSS/API 연동)
