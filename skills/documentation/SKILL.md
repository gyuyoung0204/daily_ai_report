---
name: documentation
description: Automatically optimize and maintain project documentation with zero duplication. Analyzes project state, updates SOUL/CLAUDE/README files, detects duplicate content, validates facts, and ensures documentation accuracy. Use this skill whenever the project state changes or documentation needs refresh.
---

# 📚 Documentation Automation Skill

Automatically maintain optimal project documentation with 3-role separation and zero duplication.

## What This Skill Does

### 1. **Project State Analysis**
- Reads GitHub Issues and current implementation status
- Calculates accurate progress percentage
- Identifies completed vs pending features

### 2. **Documentation Optimization**
Updates 3 core documents with strict role separation:

**SOUL.md** (비전/영혼)
- Why: 프로젝트 목표와 가치
- 40-50줄 (최소)
- 변경: 목표 변경 시만

**CLAUDE.md** (개발 가이드)
- How: 개발 규칙과 워크플로우
- 80-100줄 (최소)
- 변경: 개발 규칙/다음 단계 변경 시

**README.md** (사용 가이드)
- What: 현재 기능과 사용 방법
- 80-100줄 (최소)
- 변경: 기능 완성/진행률 변경 시

### 3. **Duplication Detection**
- Scans all documents for repeated content
- Reports any overlapping information
- Auto-removes redundancy

### 4. **Fact Validation**
- Verifies all claims against actual files
- Checks GitHub Issues against documentation
- Reports inconsistencies
- Example: "70% complete" → validates against Issue status

### 5. **File Structure Sync**
- Ensures file list matches actual repo
- Updates directory structures
- Validates all paths

---

## 3 Core Principles (절대 위반 금지)

### 1️⃣ **중복 없이 (Zero Duplication)**
- One fact = one location only
- Documents never overlap
- Cross-references instead of repetition

### 2️⃣ **사실 기반 (Fact-Based)**
- No assumptions or predictions
- Real file paths and status only
- Evidence-based progress claims

### 3️⃣ **정확함 (Accuracy)**
- Concrete file names, line numbers
- No vague language
- Test every claim

---

## When to Use This Skill

Use this skill:
- ✅ After completing an Issue
- ✅ When adding new feature
- ✅ When project state changes significantly
- ✅ Weekly documentation review
- ✅ Before pushing code to GitHub

Do NOT use:
- ❌ For every tiny change
- ❌ Without actual code changes
- ❌ To speculate about future

---

## How It Works

### Input
```
User: "문서 최적화해줄래?"
System: Analyzes:
  - Current GitHub Issues status
  - Existing documentation
  - Project file structure
  - Progress calculations
```

### Process

**Step 1: Analyze Current State**
```
✓ Read SOUL.md, CLAUDE.md, README.md
✓ Check GitHub Issues #1-5
✓ Count completed features
✓ Calculate progress %
```

**Step 2: Validate Facts**
```
✓ Verify "70%" claim → Count Issues
✓ Check file paths exist
✓ Confirm features mentioned are real
✓ Report any inconsistencies
```

**Step 3: Detect Duplication**
```
✓ Scan for repeated content
✓ Find overlapping information
✓ Identify cross-document conflicts
```

**Step 4: Optimize Documents**
```
✓ Update SOUL.md if goals changed
✓ Update CLAUDE.md if dev rules changed
✓ Update README.md for current state
✓ Ensure minimum line count
```

**Step 5: Report Changes**
```
✓ Show what was added/removed
✓ Highlight any removals
✓ Confirm zero duplication
```

### Output

```
📊 Documentation Audit Report:
  
✅ SOUL.md - 40줄 (목표 달성)
   ├─ 프로젝트 비전: ✓ 명확함
   ├─ 핵심 가치: ✓ 3개 명시
   └─ 대상 사용자: ✓ 정의됨

✅ CLAUDE.md - 100줄 (목표 달성)
   ├─ 현재 상태: ✓ 70% (근거: Issue #1-5 분석)
   ├─ 다음 단계: ✓ 우선순위 명시
   └─ 개발 규칙: ✓ 5가지 정의

✅ README.md - 90줄 (목표 달성)
   ├─ 완료 기능: ✓ 체크리스트
   ├─ 미완료 기능: ✓ 체크리스트
   └─ 빠른 시작: ✓ 3단계

🔍 Duplication Check:
   ✓ Zero duplicates found
   ✓ All cross-references valid
   ✓ No overlapping content

📈 Fact Validation:
   ✓ All claims verified
   ✓ File paths confirmed
   ✓ No inconsistencies

📁 File Structure:
   ✓ All files in sync
   ✓ Directory structure valid
```

---

## Documentation Standards

### Minimum Line Counts (축약은 여기까지만)
- **SOUL.md**: 40-50줄 (비전만 담기)
- **CLAUDE.md**: 80-100줄 (개발 필수 정보만)
- **README.md**: 80-100줄 (사용 필수 정보만)

### Style Guide
- 한글: 간결하고 명확하게
- 영문: 불릿 포인트 활용
- 이모지: 섹션 구분용만
- 링크: 다른 문서로 연결

### Update Rules
- ✅ Facts: 즉시 업데이트
- ✅ Progress: 매주 체크
- ⚠️ Speculations: 금지
- ⚠️ Redundancy: 즉시 제거

---

## Example Usage

```
User: "지난주에 Issue #1 시작했어"
Skill:
  1. Finds Issue #1 in GitHub
  2. Updates CLAUDE.md progress
  3. Checks for duplication
  4. Reports changes made

User: "새로운 스킬 만들었어"
Skill:
  1. Finds new SKILL.md
  2. Adds reference to CLAUDE.md
  3. Checks for duplication
  4. Validates structure

User: "문서 이상한데?"
Skill:
  1. Analyzes all 3 documents
  2. Detects inconsistencies
  3. Reports specific issues
  4. Suggests fixes
```

---

## Integration with Project

This skill works with:
- **GitHub Issues** - Reads project status
- **SOUL.md** - Maintains vision document
- **CLAUDE.md** - Updates dev guide
- **README.md** - Reflects current state

---

## Tips for Best Results

- ✅ Run weekly for maintenance
- ✅ Run after each major feature
- ✅ Use for documentation reviews
- ✅ Check duplication regularly
- ✅ Validate facts before publishing

---

**Start by saying:** "문서 최적화해줄래?" or "Documentation audit please!"
