# 👨‍💻 개발 가이드

## 현재 상태: 모든 GitHub Issues 정리 완료 (Open 0개)

**완료·검증됨 (테스트 통과):** 중복 감지 TF-IDF (#4) ✅ | GitHub Actions 자동 댓글 (#5) ✅ | 로그 중앙 수집 (#9) ✅ | 성능 모니터링 (#10) ✅ | /ai-digest 스킬 (#3) ✅

**Issue는 Closed지만 실제 미완:** 실시간 뉴스 수집 (#1, 20% - 샘플 데이터) | 이메일 실발송 (#2, 60% - SMTP 자격증명만 남음)

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
└── skills/
    ├── ai-digest/SKILL.md
    ├── issue-processor/SKILL.md
    └── documentation/SKILL.md      # 문서 자동화 (신규)
```

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

1. **한글 인코딩**: `UTF8Encoding($false)` 사용
2. **Token 보안**: `.gitignore`에 등록, GitHub에 업로드 금지
3. **로그 기록**: 모든 작업을 `logs/digest_log.txt`에 기록
4. **Git 커밋**: `feat(scope): description` 형식 준수
5. **승인 후 push**: 수정 전에 항상 사용자에게 물어보기

---

## 워크플로우

```
Issue 확인
  ↓
로컬에서 구현
  ↓
logs에 기록
  ↓
테스트 (먼저 물어보기)
  ↓
사용자 승인 ← ⭐ 중요!
  ↓
git add/commit/push
  ↓
GitHub Actions 자동 실행
```

---

## 빠른 참고

- **Issues:** https://github.com/gyuyoung0204/daily_ai_report/issues
- **Repository:** https://github.com/gyuyoung0204/daily_ai_report

---

**마지막 수정:** 2026-06-11  
**다음 우선순위:** Issue #1 - 실시간 뉴스 API
