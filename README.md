# Grimoire AI

A prompt-based orchestration system for AI agents that manages context, knowledge domains, and personalized interactions through markdown files.

## Overview

The Grimoire AI is a pure documentation-based system where AI agents read structured markdown files to understand your context, preferences, and knowledge domains. Nothing is compiled - everything is human-readable markdown.

## Architecture

- **orchestrator.md** - Main prompt with policies, classifies queries, identifies functions
- **routers.md** - Deterministic routing rules for function + context loading
- **registry.md** - Catalog of available functions and domains
- **functions/** - Executable capabilities (I/O, tracking, planning, analysis)
- **domains/** - Long-term knowledge, split into `development/` and `personal/`

## First-Time Setup

When you first set up this system, you'll need to initialize your profile:

```bash
# Run the initialization script
./scripts/init.sh
```

This will guide you through:
1. Setting up your user profile (name, birth date, timezone, etc.)
2. Configuring language preferences for agent responses
3. Setting up environment paths (.env)
4. Creating your first domain contexts

## Quick Start

1. **Clone and Setup**
   ```bash
   git clone <your-repo>
   cd grimoire-ai
   cp .env.example .env
   # Edit .env with your paths
   export PROJECT_ROOT="$PWD"
   ```

2. **Initialize Your Profile**
   ```bash
   ./scripts/init.sh
   ```

3. **Start Using with AI Agents**
   - Point your AI agent to `orchestrator.md` as the main prompt
   - Provide queries with optional `type` and `tags` parameters
   - The orchestrator will route to the appropriate agent with minimal context

## Structure

```
grimoire-ai/
├── orchestrator.md          # Main entry point (includes policies)
├── routers.md              # Routing logic
├── registry.md             # Function & domain catalog
├── functions/              # Executable capabilities
│   ├── io/                # I/O operations (Google Drive, CSV)
│   ├── tracking/          # Progress tracking
│   ├── planning/          # Schedule & goal planning
│   └── analysis/          # Metrics & trend analysis
├── domains/               # Knowledge domains
│   ├── development/       # Learning & career
│   │   ├── tech/         # Technical skills (DSA, System Design, etc.)
│   │   ├── knowledge/    # General knowledge (Finance, History, etc.)
│   │   └── professional/ # Career & work
│   └── personal/         # Personal life
│       ├── profile/      # User profile & preferences
│       ├── health/       # Fitness, nutrition, recovery
│       ├── productivity/ # Goals, metrics, schedule
│       └── finances/     # Personal finance tracking
└── docs/                 # System documentation
```

## How It Works

1. **Orchestrator** receives query, classifies type, and identifies needed functions
2. **Router** loads relevant functions and minimal domain context based on tags
3. **AI agent** processes query using loaded functions and domain knowledge
4. Returns structured output in user's configured language

## Context & Personalization

- Baseline: `domains/personal/profile/digest.md` + selected domain files
- Detailed facts (`facts.md`, `progress.md`, `journal.md`) loaded only with specific tags
- Long workflows in `workflows/` subdirectories loaded on-demand
- This keeps baseline context small and efficient

## Key Limits

- Max 3 functions loaded per query
- Max 5 domain files + digests
- Max 4000 tokens context
- Hard cap: 12k tokens per request
- See `orchestrator.md` for policies

## Configuration

### Environment Variables

See `.env.example` for all available configuration options:
- Google Drive paths (if using sync)
- Local paths relative to project root
- CSV export locations
- Project root override

### Profile Settings

Edit `domains/personal/profile/index.md` to configure:
- **output_language** - Language for agent responses (en, sk, cs, etc.)
- **thinking_language** - Internal reasoning language for agents
- **timezone** - Your local timezone
- **preferences** - Communication style, detail level, etc.

## Configuration

### Environment Variables (`.env`)
```bash
# Required
PROJECT_ROOT=/absolute/path/to/grimoire-ai

# Optional: Cloud sync (Google Drive, Dropbox, iCloud)
GOOGLE_DRIVE_AI_SYNC="/path/to/Google Drive/AI sync"
FITNESS_THIS_WEEK_CSV="$GOOGLE_DRIVE_AI_SYNC/this-week.csv"

# Optional: API keys (if using API-based agents)
ANTHROPIC_API_KEY=your_key_here
```

### Profile Settings (`domains/personal/profile/index.md`)
- **output_language** - Language for responses (en, sk, cs, etc.)
- **thinking_language** - Internal reasoning language (optional)
- **detail_level** - Response verbosity (concise|balanced|detailed)
- **date_format** - Preferred date format

### Adding Custom Domains
1. Create: `domains/[category]/[name]/context.md`
2. Add routing rule in `routers.md`
3. See `domains/development/knowledge/finance/` for template

### Adding Custom Functions
1. Create: `functions/[category]/[name].md`
2. Register in `registry.md`
3. Add keyword mapping in `routers.md`
4. See `functions/README.md` for template

## Documentation

- [Quick Start](docs/quickstart.md) - Get started in 5 minutes
- [Core Overview](docs/core-overview.md) - System architecture
- `CLAUDE.md` - Claude Code specific settings

## Maintenance

**Daily**: Update progress.md after sessions
**Weekly**: Review digest.md files, archive old logs
**Monthly**: Update context.md files with new info
**Quarterly**: Deep review of facts.md and goals

## Contributing

This is a personal knowledge management system. Fork and customize for your own needs.

## License

MIT License - Feel free to use as a template for your own Grimoire AI.
