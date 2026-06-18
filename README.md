# 🤖 Daily AI/IT News Digest

> AI/IT 업계 최신 뉴스를 매일 아침 자동으로 정리해주는 시스템

[💡 프로젝트 비전은 SOUL.md를 보세요](SOUL.md)

---

## ✨ 특징

- ⚡ **완전 자동화** - 매일 정시 자동 생성
- 🎯 **정보 집약** - 중요도로 우선순위 표시
- 🏷️ **분류 정렬** - 💰 비즈니스, 🤖 AI, 🔧 인프라
- 🔗 **원문 링크** - 각 뉴스마다 출처 포함
- 📱 **모바일 최적** - 반응형 디자인
- 🌍 **다국어** - 한글/영문 완벽 지원

---

## 📊 현재 상태

### ✅ 완료된 기능 (실제 테스트 통과)

| 항목 | 상태 | 검증 방법 |
|------|------|----------|
| 기본 아키텍처 | ✅ | HTML 템플릿, 스크립트 |
| /ai-digest 스킬 | ✅ | Issue #3 완료 |
| 중복 제거 (TF-IDF) | ✅ | Issue #4 - 실데이터 테스트 PASS (`scripts/test_duplicate_detection.ps1`) |
| 중복 제거 파이프라인 통합 | ✅ | generate_digest.ps1에서 실제 호출 확인 |
| 로그 중앙 수집 | ✅ | Issue #9 - 23개 엔트리 수집 확인 (`scripts/collect_logs.ps1`) |
| 성능 모니터링 | ✅ | Issue #10 - 1.7초 실측 기록 (`scripts/measure_performance.ps1`) |
| GitHub Actions 자동 댓글 | ✅ | Issue #5 - YAML 파싱/멀티라인 출력 버그 수정 후 run 성공 |
| 경로 이식성 (상대경로) | ✅ | Issue #12 - 하드코딩 `C:\tmpfile` 제거, 이동 후 생성 성공 (HTML 12,824 bytes, 커밋 `7e6f71c`) |

### 🔧 미완성 기능 (Issue는 Closed지만 실제 미완)

| 항목 | 실제 진행도 | 남은 작업 |
|------|------------|----------|
| 실시간 뉴스 수집 | 20% | Issue #1 - 현재 샘플 데이터, 실제 API/RSS 연동 필요 |
| 이메일 발송 | 40% | Issue #2 - 코드 완성, SMTP 자격증명 설정 필요 |

---

## 🚀 빠른 시작

### 1️⃣ HTML 보기
```bash
# 브라우저에서 열기
open daily_ai_digest.html
```

### 2️⃣ 수동 생성 (테스트용)
```powershell
# PowerShell에서 실행
.\scripts\generate_digest.ps1
```

### 3️⃣ 자동화 설정 (Windows)
```powershell
# 관리자 권한 PowerShell에서
.\scripts\schedule_daily_task.ps1
# → 매일 09:00에 자동 실행됨
```

---

## 📁 주요 파일

| 파일 | 설명 |
|------|------|
| `daily_ai_digest.html` | 생성된 뉴스 페이지 |
| `scripts/generate_digest.ps1` | 뉴스 수집 및 생성 |
| `data/news_cache.json` | 뉴스 캐시 (중복 제거) |
| `logs/digest_log.txt` | 실행 로그 |

---

## 📚 문서

- **[SOUL.md](SOUL.md)** - 프로젝트 비전과 목표
- **[CLAUDE.md](CLAUDE.md)** - 개발자 가이드
- **[GitHub Issues](https://github.com/gyuyoung0204/daily_ai_report/issues)** - 진행 상황

---

## 🛠️ 시스템 요구사항

- Windows OS (Task Scheduler 사용)
- PowerShell 5.0+
- 인터넷 연결

---

## 📈 다음 예정

1. 🔄 **실시간 뉴스 API 연동** - Google News, TechCrunch RSS
2. 📧 **이메일 자동 발송** - 아침 뉴스를 메일로
3. 🔍 **중복 제거 개선** - AI 기반 유사도 분석

---

## 📞 문제 해결

### 한글이 깨질 때?
`scripts/generate_digest.ps1`에서 UTF-8 인코딩 확인

### Task Scheduler가 안 될 때?
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\scripts\schedule_daily_task.ps1
```

---

**마지막 업데이트:** 2026-06-18  
**상태:** 매일 업데이트 중 ✨
