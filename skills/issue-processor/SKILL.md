---
name: issue-processor
description: Process GitHub Issues automatically. Use this skill to handle project tasks, track progress, and manage development workflow. Reads issue descriptions, executes planned tasks, updates progress in comments, and closes completed issues. Perfect for automating project management and tracking development milestones.
---

# GitHub Issue Processor

Automatically process GitHub Issues following their implementation plans.

## What This Skill Does

This skill orchestrates the complete issue lifecycle:

1. **Read Issues** - Fetches open issues from repository
2. **Parse Plans** - Extracts implementation plan from issue comments
3. **Execute Tasks** - Implements features/fixes according to plan
4. **Update Progress** - Posts progress updates as comments
5. **Close Issues** - Marks completed issues as done

## When to Use This Skill

Use this skill when you want to:
- Automate project task execution
- Track development progress automatically
- Process multiple issues in sequence
- Update issue status without manual intervention
- Create an automated workflow pipeline

## How It Works

### Input
- GitHub repository URL (or use current repo)
- Optional: Specific issue number to process
- Optional: Filter by label (e.g., "ready-to-implement")

### Output
1. **Issue Updates** - Progress comments on each issue
2. **Code Changes** - Implemented features/fixes
3. **Status Report** - Summary of completed work
4. **Closed Issues** - Marked as complete

## Processing Flow

```
Issue #1: Automate news collection
├── [Phase 1] Web Search API Integration
│   ├── [ ] Implement search logic
│   ├── [ ] Test with sample queries
│   └── Update comment with progress
├── [Phase 2] RSS Feed Parsing
│   ├── [ ] Parse tech news feeds
│   └── Update comment with progress
└── [Phase 3] Testing & Deployment
    ├── [ ] Run integration tests
    ├── [ ] Deploy to production
    └── Close issue when complete

Issue #2: Email Notification
├── [Phase 1] SMTP Configuration
└── [Phase 2] Automation Setup
└── [Phase 3] Testing

Issue #3: /ai-digest Skill
├── Status: ✅ COMPLETED
└── Closed

Issue #4: Duplicate Detection
├── [Phase 1] Algorithm Research
└── [Phase 2] Implementation
```

## Example Usage

```
User: "Process all open issues"
System:
1. 🔍 Found 4 open issues
2. 📋 #1 - Automate news collection
   └── Phase 1: Web API integration
   └── 📝 Posted progress comment
   └── ✅ Phase 1 complete
3. 📋 #2 - Email notification
   └── Phase 1: SMTP setup
   └── 📝 Posted progress comment
4. 📋 #3 - /ai-digest skill
   └── ✅ Already complete
   └── 🎉 Closing issue
5. 📋 #4 - Duplicate detection
   └── Phase 1: Research
   └── 📝 Posted progress comment

Result: 
✅ 1 issue closed
📝 3 issues updated with progress
🎯 Next: Phase 2 implementation
```

## Features

### Automatic Progress Tracking
- Reads and updates checklist items
- Tracks completion percentage
- Posts status comments

### Smart Issue Management
- Identifies completed issues
- Suggests next steps
- Assigns tasks based on priority

### Error Handling
- Handles API rate limits
- Retries failed operations
- Provides error summaries

## Integration with ai-digest

Works seamlessly with `/ai-digest` skill:
- News collection feeds into Issue #1 tasks
- Email notifications from Issue #2 support
- Duplicate detection from Issue #4 enhances news quality

## Tips for Best Results

- **Start with Issue #1** - Core news collection needs other features
- **Use labels** - Tag issues by priority for focused processing
- **Review progress** - Check comments before moving to next phase
- **Test incrementally** - Validate each phase before moving on

## Status Tracking Format

Each issue uses this format:

```markdown
## Status: [IN_PROGRESS / COMPLETED]

### Phase 1: [PHASE_NAME]
- [x] Task 1
- [ ] Task 2
- [ ] Task 3

**Progress:** 33% (1/3 tasks)
**Last Update:** 2026-06-11 15:45
**Next Step:** Complete Task 2
```

## Automated Workflow

1. **Morning (9 AM)**: Process high-priority issues
2. **Afternoon (3 PM)**: Check progress and update status
3. **Evening (6 PM)**: Close completed issues and prepare next day

Start by saying "Process open issues" or "Update issue progress"!