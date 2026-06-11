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

## 📊 현재 상태: 50% 완성 (4/11 Issues)

### ✅ 완료된 기능

| 항목 | 상태 | 설명 |
|------|------|------|
| 기본 아키텍처 | ✅ | HTML 템플릿, 스크립트 |
| /ai-digest 스킬 | ✅ | Issue #3 완료 |
| 중복 제거 (TF-IDF) | ✅ | 고급 알고리즘 구현 |
| 기본 로깅 | ✅ | logs/ 디렉토리 구성 |

### 🔧 진행 중인 기능

| 항목 | 진행도 | 설명 |
|------|--------|------|
| 실시간 뉴스 수집 | 20% | Issue #1 (Closed) - API 선택 단계 |
| 이메일 발송 | 40% | Issue #2 (Closed) - SMTP 설정 필요 |
| GitHub Actions | 75% | Issue #5 - 자동 댓글 기능 |

### 📋 미시작 기능

| 항목 | 상태 | 설명 |
|------|------|------|
| ROADMAP | ❌ | Issue #6 - 3개월 개발 계획 |
| TESTING | ❌ | Issue #7 - 품질 관리 전략 |
| Issue Template | ❌ | Issue #8 - GitHub 템플릿 |
| 로그 수집 | ❌ | Issue #9 - 중앙화된 로깅 |
| 성능 모니터링 | ❌ | Issue #10 - 실시간 대시보드 |
| 자동화 테스트 | ❌ | Issue #11 (Closed) - 테스트 프레임워크 |

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

**마지막 업데이트:** 2026-06-11  
**상태:** 매일 업데이트 중 ✨
