# 👨‍💻 개발 가이드

## 현재 상태: 모든 GitHub Issues 정리 완료 (Open 0개)

**완료·검증됨 (테스트 통과):** 중복 감지 TF-IDF (#4) ✅ | GitHub Actions 자동 댓글 (#5) ✅ | 로그 중앙 수집 (#9) ✅ | 성능 모니터링 (#10) ✅ | /ai-digest 스킬 (#3) ✅ | 경로 이식성 수정 (#12) ✅

**Issue #12 (2026-06-18 해결):** `generate_digest.ps1`·`session-status.ps1`의 하드코딩 절대경로(`C:\tmpfile\ai_report`)를 `$PSScriptRoot` 기반 상대경로로 교체. clone/이동한 위치에서도 다이제스트 생성 정상 동작 확인(`daily_ai_digest.html` 12,824 bytes, 커밋 `7e6f71c`).

**Issue는 Closed지만 실제 미완:** 실시간 뉴스 수집 (#1, 40% - news-curator 에이전트가 WebSearch로 실데이터 6건 수집·통합, 자동 스케줄링은 미완) | 이메일 실발송 (#2, 60% - SMTP 자격증명만 남음)

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
│   ├── send_email_digest.ps1       # 이메일 발송 (SMTP 설정 필요)
│   └── schedule_daily_task.ps1     # 자동화 설정
├── data/news_cache.json            # 중복 제거용 캐시
├── logs/                           # 실행 로그 + aggregated_summary.json + metrics.json
├── .github/workflows/
│   └── auto-issue-update.yml       # GitHub Actions
└── .claude/                        # Claude Code 하네스
    ├── settings.json               # env(팀) + hooks (커밋됨)
    ├── settings.local.json         # 권한 + 토큰 (gitignore)
    ├── skills/                     # 진입점 워크플로우 (/명령)
    │   ├── ai-digest/SKILL.md
    │   ├── issue-processor/SKILL.md
    │   ├── documentation/SKILL.md
    │   └── daily-workflow/SKILL.md
    ├── agents/                     # 독립 컨텍스트 워커
    │   ├── news-curator.md
    │   ├── digest-builder.md
    │   ├── issue-manager.md
    │   └── doc-keeper.md
    └── hooks/                      # 이벤트 자동화
        ├── add-bom.ps1             # 한글 .ps1 BOM 자동 부착
        ├── log-activity.ps1        # 파일 변경 로그 기록
        └── session-status.ps1      # 세션 시작 상태 요약
```

---

## 하네스 구조 (Claude Code)

공식 컨벤션에 따라 4계층으로 구성. **한 정보=한 곳** 원칙 적용.

| 계층 | 위치 | 역할 |
|------|------|------|
| 스킬 | `.claude/skills/` | 사용자 진입점·절차 (`/ai-digest` 등). 에이전트에 위임 |
| 에이전트 | `.claude/agents/` | 자체 컨텍스트를 갖는 전문 워커. 메인 대화 오염 방지 |
| 훅 | `.claude/settings.json` | 이벤트 가드레일 (BOM 부착·로그·상태) |
| 메모리 | `CLAUDE.md` | 항상 로드되는 사실 (이 파일) |

**위임 관계:**
- `/ai-digest` → news-curator + digest-builder
- `/issue-processor` → issue-manager
- `/documentation` → doc-keeper
- `/daily-workflow` → 위 3개 스킬 순차 오케스트레이션 (또는 에이전트 팀)

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

### [중간] Issue #2: 이메일 실발송 활성화
- 파일: `scripts/send_email_digest.ps1` (구문 오류 수정 완료, 테스트 모드 실행 확인)
- 작업: SMTP 자격증명 설정(.env) 후 발송 주석 해제

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
