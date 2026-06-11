# 🤖 Daily AI/IT News Digest - 개발 가이드

## 📌 프로젝트 개요

**목표:** 매일 AI/IT 업계의 최신 뉴스를 자동으로 수집, 정리하여 HTML 다이제스트로 제공하는 완전 자동화 시스템

**핵심 가치:**
- ⚡ **자동화** - 매일 아침 자동으로 뉴스 수집
- 🎯 **정보 집약** - 중요한 것만 우선순위로 표시
- 🌍 **다국어 지원** - 한글/영문 완벽 지원
- 🤖 **AI 자동화** - Claude Code 스킬로 완전 자동화

**대상 사용자:** IT/AI 업계 종사자들이 매일 아침 5분만에 핵심 뉴스를 파악할 수 있도록

---

## 🎨 현재 진행 상태 (70% 완성)

### ✅ 완료된 부분

**1. 프론트엔드 (100%)**
- HTML5 반응형 디자인 ✅
- 그래디언트 배경, 카드 레이아웃 ✅
- 한글 완벽 지원 (UTF-8) ✅
- 모바일 친화적 디자인 ✅

**2. 자동화 기반 (90%)**
- PowerShell 스크립트 ✅
- Windows Task Scheduler 통합 ✅
- JSON 캐싱 시스템 ✅
- Git 자동화 ✅

**3. GitHub 통합 (95%)**
- Issues 생성/관리 ✅
- GitHub Actions Workflow ✅
- 자동 댓글 시스템 ✅
- 보안 설정 (.gitignore) ✅

**4. Claude Code 스킬 (100%)**
- `/ai-digest` 스킬 ✅
- `/issue-processor` 스킬 ✅

### ❌ 미완료 부분

**1. 실시간 뉴스 수집 (0%)**
- API 연동 필요 (Google News, TechCrunch 등)
- RSS 피드 파서 필요
- Web scraping 로직 필요
- → **Issue #1 (우선순위: 높음)**

**2. 이메일 발송 (0%)**
- SMTP 설정 필요
- 이메일 템플릿 필요
- 매일 자동 발송 로직
- → **Issue #2 (우선순위: 중간)**

**3. 고급 중복 제거 (30%)**
- 기본: URL/제목 기반 (완료)
- 고급: TF-IDF, 코사인 유사도 필요
- → **Issue #4 (우선순위: 중간)**

---

## 📁 프로젝트 구조 & 파일 역할

```
daily_ai_report/
├── 📄 README.md                          # 사용자 가이드
├── 📄 CLAUDE.md                          # 이 파일 (개발 가이드)
│
├── 🌐 daily_ai_digest.html               # 메인 뉴스 페이지
│   └── 역할: 최종 결과물, 브라우저에서 열어서 보는 뉴스 페이지
│
├── 📂 scripts/                           # 자동화 스크립트
│   ├── generate_digest.ps1               # 핵심 스크립트
│   │   └── 역할: 뉴스 수집 → 중복 제거 → HTML 생성
│   │   └── 수정 필요: API 연동 로직 추가
│   │
│   └── schedule_daily_task.ps1           # 자동화 설정
│       └── 역할: Windows Task Scheduler에 등록
│       └── 현재: 매일 09:00 실행 설정됨
│
├── 📂 templates/                         # HTML 템플릿
│   └── digest_template.html              # 재사용 가능한 템플릿
│       └── 역할: 동적 뉴스 생성 시 기본 구조
│
├── 📂 data/                              # 데이터 저장
│   └── news_cache.json                   # 뉴스 캐시
│       └── 역할: 중복 제거, 매일 업데이트
│
├── 📂 logs/                              # 로그 파일
│   └── digest_log.txt                    # 실행 기록
│       └── 역할: 트러블슈팅, 성능 모니터링
│
├── 📂 .github/workflows/                 # GitHub Actions
│   └── auto-issue-update.yml             # 자동화 워크플로우
│       └── 역할: 코드 푸시 시 자동으로 Issue에 댓글
│
├── 📂 skills/                            # Claude Code 스킬
│   ├── ai-digest/SKILL.md                # 뉴스 생성 스킬
│   │   └── 역할: /ai-digest 명령으로 사용
│   │
│   └── issue-processor/SKILL.md          # 이슈 처리 스킬
│       └── 역할: /issue-processor 명령으로 자동 처리
│
├── .gitignore                            # Git 무시 설정
│   └── 역할: Token, 로그 등 민감한 파일 보호
│
└── .git/                                 # Git 저장소
    └── 역할: 버전 관리 및 GitHub 연동
```

---

## 🚀 다음 단계 (우선순위순)

### 1️⃣ **[높음] Issue #1: 실시간 뉴스 수집 자동화**

**목표:** `generate_digest.ps1`에 실제 뉴스 API 연동

**구현 계획:**
```
Phase 1: Web Search API 통합
  - [ ] Google News API or RSS feed 선택
  - [ ] API 키 설정
  - [ ] 뉴스 검색 함수 작성
  
Phase 2: 뉴스 소스 다양화
  - [ ] TechCrunch (RSS)
  - [ ] Medium AI 태그 (Web scraping)
  - [ ] GitHub Trending
  - [ ] Product Hunt
  
Phase 3: 한글 뉴스 추가
  - [ ] 네이버 뉉스 크롤링
  - [ ] 한글 기술 블로그
  - [ ] 국내 AI 관련 뉴스
```

**파일 수정 필요:**
- `scripts/generate_digest.ps1` - API 연동 로직 추가

---

### 2️⃣ **[중간] Issue #2: 이메일 알림 기능**

**목표:** 매일 아침 뉴스를 이메일로 자동 발송

**구현 계획:**
```
Phase 1: SMTP 설정
  - [ ] Gmail SMTP 또는 회사 메일 서버 설정
  - [ ] 인증 정보 .env 파일에 저장
  
Phase 2: 이메일 템플릿
  - [ ] HTML 이메일 포맷
  - [ ] 구독자 목록 관리
  
Phase 3: 자동 발송
  - [ ] Task Scheduler에서 발송 스크립트 실행
  - [ ] 실패 시 로그 기록 및 재시도
```

**새 파일 필요:**
- `scripts/send_email_digest.ps1`
- `.env` (구독자 이메일, SMTP 정보)

---

### 3️⃣ **[중간] Issue #4: 중복 제거 알고리즘 개선**

**목표:** 단순 URL 기반에서 의미 기반 중복 제거로 업그레이드

**구현 계획:**
```
Phase 1: 문장 유사도 분석
  - [ ] TF-IDF 구현 또는 라이브러리 사용
  - [ ] 코사인 유사도 계산
  
Phase 2: 제목 기반 중복 제거
  - [ ] 유사도 threshold 설정 (예: 80% 이상 중복)
  - [ ] 테스트
  
Phase 3: 본문 기반 중복 제거
  - [ ] 요약(summary) 기반 비교
  - [ ] 성능 최적화
```

**파일 수정 필요:**
- `scripts/generate_digest.ps1` - 중복 제거 함수 개선

---

## 💡 개발 규칙 (이 프로젝트에서 중요한 것들)

### 1. **한글 인코딩**
```
⚠️ 반드시 UTF-8 사용
❌ 사용 금지: Out-File 기본 인코딩
✅ 사용 필수: [System.Text.UTF8Encoding]::new($false)
```

### 2. **API Token 보안**
```
⚠️ Token 절대 Git에 커밋하지 말기
✅ .gitignore에 등록하기
✅ .env 파일 또는 .claude/settings.local.json에 저장
✅ GitHub Settings → Secrets에 저장 (CI/CD 사용 시)
```

### 3. **GitHub Actions**
```
⚠️ 작은 변경도 자동으로 커밋하면 안 될 때가 있음
✅ 의미있는 변경만 push하기
✅ Issue와 연결된 작업만 처리하기
```

### 4. **로그 파일**
```
✅ 모든 중요한 작업은 logs/digest_log.txt에 기록
✅ 에러 발생 시 상세 로그 남기기
✅ 타임스탬프 포함하기
```

### 5. **Git 커밋 메시지**
```
형식: <type>(<scope>): <subject>

예시:
feat(news-api): Add TechCrunch RSS feed integration
fix(duplicate-detection): Improve similarity algorithm
docs(readme): Update API setup instructions

Type 종류:
- feat: 새로운 기능
- fix: 버그 수정
- improve: 기존 기능 개선
- docs: 문서 수정
- refactor: 코드 구조 개선
- test: 테스트 추가
```

---

## 🔄 작업 흐름

### 새 기능 추가 시

```
1. GitHub Issue 확인 (#1, #2, #3 등)
   └─ 요구사항, 예상 완료 시간 확인

2. 로컬에서 기능 구현
   └─ scripts/generate_digest.ps1 또는 필요한 파일 수정

3. 로그 파일에 작업 기록
   └─ logs/digest_log.txt 업데이트

4. 테스트 (로컬에서 먼저)
   └─ PowerShell에서 스크립트 실행
   └─ daily_ai_digest.html 확인

5. Git 커밋
   └─ git add (민감한 파일 제외)
   └─ git commit -m "feat(...): ..."

6. GitHub Push
   └─ git push origin main
   └─ GitHub Actions 자동 실행 (Issues에 자동 댓글)

7. Issue 체크 확인
   └─ GitHub 웹사이트에서 Issue 확인
   └─ 필요하면 progress 업데이트
```

---

## 📊 핵심 파일 수정 가이드

### `scripts/generate_digest.ps1` (가장 중요!)

**현재 상태:** 샘플 데이터로 HTML 생성

**다음 단계:**
```powershell
# 1. 뉴스 수집 함수 추가 필요
function Get-TechNews {
    # API/RSS feed에서 뉴스 가져오기
}

# 2. 뉴스 필터링 (우선순위 판별)
function Get-PriorityNews {
    # "Anthropic", "Claude", "OpenAI" 등 키워드로 필터링
}

# 3. 중복 제거 개선
function Remove-DuplicateNews {
    # 현재: URL/제목 기반
    # 개선: TF-IDF 유사도 기반
}
```

---

## 🎯 최종 목표

```
현재 (70% 완성)
  ↓
+ 실시간 뉴스 API (Issue #1) → 85% 완성
  ↓
+ 이메일 발송 (Issue #2) → 95% 완성
  ↓
+ 고급 중복 제거 (Issue #4) → 100% 완성 🎉

완성되면:
- 매일 아침 09:00 자동 실행
- AI/IT 뉴스 자동 수집
- 한글/영문 뉴스 모두 포함
- 이메일로 자동 발송
- GitHub Issues로 진행률 추적
- 완전 무인 자동화 시스템 ✨
```

---

## 📞 문제 해결 (Troubleshooting)

### ❌ 한글이 깨질 때
```powershell
# 원인: 인코딩 설정 오류
# 해결: UTF8Encoding($false) 사용
$UTF8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($Path, $Content, $UTF8NoBom)
```

### ❌ API Token이 GitHub에 노출됐을 때
```bash
# 1. .gitignore에 파일 추가
# 2. git reset --soft HEAD~1
# 3. 파일 제외하고 다시 커밋
# 4. 새 Token 발급받기
```

### ❌ Task Scheduler가 작동하지 않을 때
```powershell
# 1. PowerShell 실행 정책 확인
Get-ExecutionPolicy

# 2. 필요하면 정책 변경
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 3. Task 수동 생성
# .\scripts\schedule_daily_task.ps1 다시 실행
```

---

## 🔗 중요한 링크

- **GitHub Repository:** https://github.com/gyuyoung0204/daily_ai_report
- **Issues:** https://github.com/gyuyoung0204/daily_ai_report/issues
- **Actions:** https://github.com/gyuyoung0204/daily_ai_report/actions

---

## 📝 마지막 확인사항

✅ **시작 전 체크리스트:**
- [ ] 최신 코드를 GitHub에서 pull 했는지 확인
- [ ] .env 파일이 .gitignore에 있는지 확인
- [ ] logs/ 디렉토리가 존재하는지 확인
- [ ] data/news_cache.json이 존재하는지 확인
- [ ] PowerShell 권한이 있는지 확인 (관리자 권한)

✅ **작업 후 체크리스트:**
- [ ] 로컬에서 테스트했는지 확인
- [ ] logs/digest_log.txt에 기록했는지 확인
- [ ] Git 커밋 메시지가 명확한지 확인
- [ ] 민감한 파일은 제외했는지 확인
- [ ] GitHub에 push 했는지 확인

---

**문서 마지막 업데이트:** 2026-06-11
**다음 우선순위:** Issue #1 - 실시간 뉴스 수집 API 연동
