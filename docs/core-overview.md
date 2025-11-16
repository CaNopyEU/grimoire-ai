# Grimoire AI – Core Overview

The Grimoire AI is a prompt-based orchestration system for AI agents. The repository is pure documentation – agents read Markdown files, nothing is compiled.

## Architecture
- **orchestrator.md** – main prompt with policies, query classification (data-access/tracking/planning/analysis/general).
- **routers.md** – deterministic rules for function + context loading, works with tags and limits.
- **registry.md** – catalog of available functions and domains.
- **functions/** – executable capabilities organized by category (io/, tracking/, planning/, analysis/).
- **domains/** – long-term knowledge, split into `development/` (learning, career) and `personal/` (profile, health, productivity).

All paths are relative to `${PROJECT_ROOT:-.}` so CLI clients can change root.

## Typical Flow
1. **Orchestrator** receives query, classifies into category (data-access/tracking/planning/analysis/general).
2. **Router** loads relevant functions and minimal domain context based on `tags` and keywords.
3. AI agent processes query using loaded functions and domain knowledge.
4. Returns structured output in user's configured language.

## Context & Personalization
- Baseline: `domains/personal/profile/digest.md` + selected domain files.
- Detailed facts (`facts.md`, `progress.md`, `journal.md`) loaded only with specific tags (`deep-profile`, `tracking`, `review`).
- Long workflows in `workflows/` subdirectories loaded on-demand, reducing baseline context.

## CLI Recommendations
- Set `PROJECT_ROOT` (e.g. `export PROJECT_ROOT=/path/grimoire-ai`) so prompts use correct paths.
- When providing tags via CLI, only specify what's necessary (e.g. `tags=[training,tracking]`) – router adds only needed files.
- For quick sessions: provide brief digest input, unnecessary files won't be loaded.

## Key Limits
- Max 3 functions loaded per query.
- Max 5 files from domains + digests.
- Max 4000 tokens context; if estimate exceeds limit, reduce loaded files.
- Policies prefer efficient approaches, Claude for code generation when needed.

## Documentation for Models
- `CLAUDE.md` contains model-specific instructions and CLI tips.
