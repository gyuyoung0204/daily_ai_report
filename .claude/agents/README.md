# 🤝 에이전트 팀 (Agent Team) 구성

이 디렉토리는 daily_ai_report 프로젝트의 **에이전트 팀 역할(teammate roles)** 을 정의합니다.

## 활성화 상태

`.claude/settings.json`에서 실험적 에이전트 팀 기능이 켜져 있습니다:

```json
{ "env": { "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1" } }
```

> ⚠️ **요구사항**: Claude Code v2.1.32+ / **인터랙티브 세션 전용**(headless·SDK·CI에서는 동작 안 함).

## 팀 역할 (4종)

| 역할 | 파일 | 담당 | 대응 워크플로우 |
|------|------|------|----------------|
| 📰 news-curator | `news-curator.md` | AI/IT 뉴스 수집·선별 | Issue #1 |
| 🎨 digest-builder | `digest-builder.md` | HTML 생성 + TF-IDF 중복 제거 | Issue #4 |
| 🔧 issue-manager | `issue-manager.md` | GitHub 이슈 등록·처리·종료 | /ai-digest, /issue-processor |
| 📚 doc-keeper | `doc-keeper.md` | SOUL/CLAUDE/README 동기화 | /documentation |

## 사용 방법 (인터랙티브 Claude Code에서)

에이전트 팀은 CLI 플래그가 아니라 **자연어 지시**로 띄웁니다:

```
news-curator로 오늘 AI 뉴스를 모으고, digest-builder로 HTML을 만든 다음,
issue-manager로 결과를 이슈에 기록하는 팀을 구성해줘.
```

- 팀 config(`~/.claude/teams/`)와 task list(`~/.claude/tasks/`)는 런타임에 자동 생성됩니다. 손으로 편집하지 마세요(덮어쓰기됨).
- 개별 역할(`.claude/agents/*.md`)은 버전 관리되어 팀이 공유·개선합니다.

## 참고
- [서브에이전트 공식 문서](https://code.claude.com/docs/en/sub-agents)
- [에이전트 팀 공식 문서](https://code.claude.com/docs/en/agent-teams)
