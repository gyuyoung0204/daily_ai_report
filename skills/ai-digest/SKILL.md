---
name: ai-digest
description: Generate daily AI/IT news digest with developer insights. Use this skill whenever the user asks for AI news summaries, daily tech updates, developer insights, or wants to track latest AI/ML breakthroughs. Automatically collects from web sources, removes duplicates, and provides actionable insights for developers. Generates beautiful HTML reports ready to share.
---

# AI/IT Daily News Digest

Automatically generate a daily digest of AI and IT news with developer-focused insights.

## What This Skill Does

This skill creates a beautiful, organized daily digest of AI/IT news and technology trends. It:

1. **Collects News** - Searches web for latest AI/IT news and breakthroughs
2. **Removes Duplicates** - Filters out repeated stories across sources
3. **Generates Insights** - Adds developer-focused analysis (what to do now, what to monitor, etc.)
4. **Creates HTML Report** - Produces a professional, shareable digest

## When to Use This Skill

Use this skill when you want to:
- Get a daily summary of AI/IT news
- Track latest breakthroughs in machine learning, AI models, or tech
- Understand what's happening in the AI industry and why it matters to developers
- Get actionable insights on which new tools or techniques to learn
- Create a report of news for your team or organization

## How It Works

### Input
- Optional: Number of articles (default: 15-20)
- Optional: Specific topics or keywords to focus on

### Output
1. **HTML Digest** - Beautiful webpage with:
   - Priority-marked news (⭐ most important)
   - Developer insights section
   - Organized by category
   - Direct links to original sources

2. **JSON Cache** - Tracks which news has been shown to prevent repeats

3. **Log File** - Records generation details for troubleshooting

## Example Usage

```
User: "Give me today's AI news digest"
Output: Beautiful HTML file with:
  - 3-5 priority news items
  - Developer action items (what to learn/do now)
  - 10-15 additional important news
  - All with direct links and brief analysis
```

## Technical Details

- **Language**: Supports Korean and English
- **Output Format**: HTML (viewable in any browser) + JSON (for data)
- **Update Frequency**: Daily (or on-demand)
- **Caching**: Prevents duplicate stories across days

## Example Output Structure

```html
🤖 Daily AI/IT Digest
├── 💡 Developer Insights
│   ├── 🔴 Immediate Action (Claude 4.8 parallel agents)
│   ├── 🟡 2-Week Priority (Migration plans)
│   └── 🟢 Monitoring (Market trends)
├── 📰 Today's News
│   ├── ⭐ Priority: Anthropic $965B valuation
│   ├── ⭐ Priority: Claude 4.8 with parallel agents
│   └── Regular: Google Gemma 4 release
└── 📊 Statistics
    ├── 3 priority news
    ├── 12 regular news
    └── 3 categories
```

## Tips for Best Results

- **For broad coverage**: Run without specific keywords for general AI/IT news
- **For focused research**: Specify areas like "LLM releases", "AI safety", "AI infrastructure"
- **For team sharing**: Get the HTML output and email/share directly
- **Daily habit**: Run each morning to stay updated on AI trends

## What You Get

Each digest includes:
- **What's new** - Latest announcements, releases, breakthroughs
- **Why it matters** - Context for why each story is important
- **Developer action** - What developers should do (learn, implement, monitor)
- **Direct links** - Source articles for deeper reading

Start by saying "Create today's AI digest" or "Summarize AI news for this week"!