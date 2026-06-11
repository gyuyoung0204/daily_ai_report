---
name: daily-workflow
description: Self-healing automation workflow. Continuously improves project by detecting issues, fixing them, and documenting changes. Runs /ai-digest to find problems, /issue-processor to fix them, /documentation to record changes. Repeats until zero issues remain. Perfect for autonomous project improvement and continuous delivery.
---

# 🔄 Daily Workflow - 자가 개선 시스템

매일 아침 자동으로 프로젝트를 개선하는 자동화 워크플로우입니다.

## 🎯 역할

**문제 발견 → 자동 해결 → 문서화 → 반복**

3개 스킬을 순차적으로 실행하며, **이슈가 없을 때까지 무중단 진행**합니다.

---

## 📋 실행 흐름

```
📅 매일 아침 09:00 시작
  ↓
🔄 Loop 시작 (이슈 없을 때까지)
  ↓
1️⃣ /ai-digest 실행
   ├─ AI/IT 뉴스 생성
   ├─ 현재 구현 상태 분석
   ├─ 약점 및 부족점 발견
   └─ GitHub Issue 자동 생성 (새 이슈!)
  ↓
2️⃣ /issue-processor 실행
   ├─ 생성된 Issues 읽기
   ├─ 각 Issue 자동 분석
   ├─ 코드 자동 수정
   ├─ 변경사항 커밋
   └─ Issue 자동 종료 (이슈 해결!)
  ↓
3️⃣ /documentation 실행
   ├─ 변경 사항 감지
   ├─ SOUL/CLAUDE/README 업데이트
   └─ 진행률 반영
  ↓
🔍 이슈 개수 확인
   ├─ 0개 → 완료! (Loop 종료) ✨
   ├─ 감소 → 계속 반복
   └─ 변화 없음 → 종료 (Manual 검토 필요)
```

---

## 🔧 작동 원리

### Phase 1: 문제 발견 (/ai-digest)

```
분석 항목:
✓ 뉴스에서 나오는 새로운 기술
✓ 프로젝트와 관련된 트렌드
✓ 현재 구현의 약점
✓ 개선 가능한 기능
✓ 성능 최적화 기회
✓ 보안 이슈

생성:
→ GitHub Issue로 자동 등록 (Issue #n+1)
→ 상세 설명 + 구현 계획 포함
```

### Phase 2: 자동 해결 (/issue-processor)

```
각 Issue에 대해:
✓ 요구사항 분석
✓ 구현 계획 파싱
✓ 코드 자동 수정
✓ 테스트 실행
✓ 변경사항 커밋
✓ Issue 종료

결과:
→ 코드 변경사항 GitHub Push
→ Pull Request 생성 (자동)
→ Issue 상태 업데이트
```

### Phase 3: 문서화 (/documentation)

```
감지:
✓ 새로운 파일 생성
✓ 기존 파일 수정
✓ 함수/기능 추가
✓ 버그 수정

반영:
→ SOUL.md 업데이트 (필요시)
→ CLAUDE.md 업데이트 (필요시)
→ README.md 업데이트 (필요시)
→ 진행률 자동 계산
→ CHANGELOG.md 생성
```

---

## 📊 Loop 조건

### 반복 조건
```
현재 Issue 개수 > 0
AND
진전이 있음 (이전 Loop 대비 Issue 감소)
```

### 종료 조건
```
✅ 이슈 0개 (완벽한 상태)
OR
⚠️ 진전 없음 (Manual 검토 필요)
OR
❌ 같은 이슈 반복 (무한 루프 방지)
```

---

## 🎁 특징

### 1️⃣ **무중단 실행 (Non-Stop)**
- 한번 시작하면 이슈가 없을 때까지 계속 진행
- 중간에 사용자 개입 불필요

### 2️⃣ **자동화 (Fully Automated)**
- 발견 → 해결 → 문서화 모두 자동
- 수동 작업 0

### 3️⃣ **자가 개선 (Self-Healing)**
- 문제를 자동으로 발견하고 해결
- 시간이 지날수록 프로젝트 품질 향상

### 4️⃣ **투명성 (Transparent)**
- 모든 단계 로깅
- GitHub Issues로 투명하게 추적
- 언제든 상태 확인 가능

---

## 📈 예상 시나리오

### Day 1
```
Issue 발견: 5개
  → 해결: 3개
Issue 남음: 2개
다음 Loop로 진행...
```

### Day 2
```
Issue 발견: 2개 (기존) + 1개 (신규)
  → 해결: 3개
Issue 남음: 0개
✨ Workflow 완료!
```

---

## 🚀 사용 방법

### 자동 실행 (매일 09:00)
```
Windows Task Scheduler가 자동으로 실행
아무것도 할 필요 없음
```

### 수동 실행
```
Claude Code에서:
/daily-workflow

또는 직접 명령:
.\scripts\run-daily-workflow.ps1
```

---

## 📝 로깅

모든 단계가 기록됩니다:

```
logs/
├── daily-workflow-2026-06-11.log
│   ├─ [09:00] Workflow 시작
│   ├─ [09:05] /ai-digest 완료 (3개 Issue 생성)
│   ├─ [09:08] /issue-processor 완료 (3개 해결)
│   ├─ [09:10] /documentation 완료
│   ├─ [09:10] Loop 1 완료 (Issue 0개)
│   └─ [09:10] ✅ Workflow 성공!
```

---

## ⚙️ 설정

### 실행 시간
- 기본: 매일 09:00
- 변경: `schedule_daily_task.ps1`에서 수정

### Loop 최대 반복
- 기본: 10회 (무한 루프 방지)
- 변경: `/daily-workflow` 설정에서 수정

### 보고서
- Slack 알림 (선택)
- 이메일 레포트 (선택)

---

## 🎯 최종 목표

```
Day 1-7:   자동화 기반 마련, 이슈 발견 & 해결
Day 8-14:  추가 기능 개발, 문서화 자동화
Day 15+:   프로젝트 자가 개선 중심 전환

최종 상태:
→ 완전 자동화된 프로젝트
→ 지속적인 개선
→ 항상 최신 상태 유지 ✨
```

---

## 🔗 통합되는 스킬

1. **`/ai-digest`** - 문제 발견
2. **`/issue-processor`** - 자동 해결
3. **`/documentation`** - 문서화

---

**Start by saying:** "매일 자동화해줄래?" or "Daily workflow 시작!"
