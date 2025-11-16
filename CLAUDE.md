# Claude Guide

See main overview in [`docs/core-overview.md`](docs/core-overview.md). This file contains only Claude Code specifics.

## Model Settings
- Default Claude profile: **Claude Code** (most accurate for complex tasks)
- Best for: code generation, complex analysis, multi-step workflows
- Paths loaded via `${PROJECT_ROOT:-.}`; set `export PROJECT_ROOT=/path/grimoire-ai` before CLI session
- Access to functions in `functions/` for specific capabilities

## Response Style
- Format output in user's configured language (see `profile/index.md`)
- Be concise – only relevant steps and results, no extra commentary
- Use appropriate functions from `functions/` when needed
- Provide token estimate if available for budget tracking

## Working with Functions
- Check `registry.md` for available functions
- Load functions from `functions/` when query requires specific capability
- Google Drive operations: use `functions/io/google-drive-read.md`
- CSV parsing: use `functions/io/csv-parse.md`
- Workout logging: use `functions/tracking/workout-log.md`
- Metrics calculation: use `functions/analysis/metrics-calculate.md`

## CLI Quick Start
```bash
# 1. Set environment
export PROJECT_ROOT="$PWD"
source .env  # if exists

# 2. Start session with short prompt
# "You are Claude Code..." (see orchestrator)

# 3. Add tags to queries that minimize context
# e.g. type=code tags=[tracking]
```

## Environment Check
- Test access to Google Drive paths: `ls "$GOOGLE_DRIVE_AI_SYNC"`.
- Load CSV exports via variables defined in `.env`.
- For missing files, always output which path was invalid.
