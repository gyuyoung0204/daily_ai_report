# 🤖 Daily AI/IT News Digest

매일 아침 AI·IT 업계의 최신 동향을 정리해주는 자동화 시스템

## 📋 특징

✨ **매일 아침 자동 생성** - 설정된 시간에 자동으로 최신 뉴스 수집  
⭐ **우선순위 표시** - 중요도에 따른 항목 분류  
🏷️ **카테고리 분류** - 💰 비즈니스, 🤖 AI, 🔧 인프라 등  
🔗 **원문 링크** - 각 뉴스마다 출처 링크 포함  
📱 **모바일 친화적** - 반응형 디자인으로 모든 기기에 최적화  

## 📁 파일 구조

```
daily_ai_report/
├── README.md                    # 이 파일
├── daily_ai_digest.html         # 메인 뉴스 다이제스트 (HTML)
├── scripts/
│   ├── generate_digest.ps1      # 다이제스트 생성 스크립트 (PowerShell)
│   └── schedule_daily_task.ps1  # Windows Task Scheduler 설정 스크립트
└── logs/
    └── digest_log.txt           # 생성 로그 기록
```

## 🚀 빠른 시작

### 1️⃣ HTML 다이제스트 보기
```bash
# 브라우저에서 열기
open daily_ai_digest.html
```

### 2️⃣ 매일 자동으로 생성되도록 설정 (Windows)
```powershell
# PowerShell을 관리자 권한으로 실행한 후
.\scripts\schedule_daily_task.ps1
```

### 3️⃣ 수동으로 다이제스트 생성
```powershell
.\scripts\generate_digest.ps1
```

## 📊 뉴스 구성

- **⭐ 최우선** (빨간 배경): 업계에 가장 큰 영향을 미치는 뉴스
- **일반 항목** (회색 배경): 주목할 만한 개발사항

각 항목에는 다음이 포함됩니다:
- 제목
- 간단한 설명 및 코멘트
- 원문 링크
- 카테고리 태그

## 🔧 커스터마이징

### HTML 스타일 변경
`daily_ai_digest.html` 파일의 `<style>` 섹션 수정

### 뉴스 소스 추가
`scripts/generate_digest.ps1`의 검색 쿼리 수정

### 자동 실행 시간 변경
`scripts/schedule_daily_task.ps1`에서 시간 설정 변경

## 📅 업데이트 주기

- **기본 설정**: 매일 아침 09:00 KST
- 커스터마이징 가능

## 🛠️ 요구사항

- Windows OS (Task Scheduler 사용)
- PowerShell 5.0+
- 인터넷 연결

## 📝 라이선스

MIT License

## 👤 작성자

- AI Report System (Automated)

---

**마지막 업데이트**: 2026-06-11  
**다음 업데이트**: 2026-06-12
