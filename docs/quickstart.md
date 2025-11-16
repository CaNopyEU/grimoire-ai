# Quick Start Guide

Get your Grimoire AI up and running in 5 minutes.

## Prerequisites

- Git (for cloning)
- Bash shell (for initialization script)
- Text editor (for customization)
- AI agent (Claude Code, ChatGPT, or similar)

## Step 1: Clone & Setup

```bash
# Clone the repository
git clone <your-repo-url> grimoire-ai
cd grimoire-ai

# Create environment file
cp .env.example .env

# Edit .env with your paths
# Set PROJECT_ROOT to absolute path of this directory
nano .env  # or your preferred editor
```

## Step 2: Initialize Your Profile

Run the initialization script:

```bash
./scripts/init.sh
```

This will ask you:
1. Basic info (name, location, timezone)
2. Language preferences (output & thinking languages)
3. Communication preferences (detail level, style)
4. Interests and focus areas

Your profile will be created automatically.

## Step 3: Customize Your Domains

Add content to domains that matter to you:

```bash
# Example: Set up fitness tracking
nano domains/personal/health/fitness/calisthenics/context.md

# Example: Add career info
nano domains/development/professional/index.md

# Example: Configure schedule
nano domains/personal/productivity/schedule/context.md
```

## Step 4: Connect Your AI Agent

### Using Claude Code

Point Claude Code to the orchestrator:

```bash
# In your terminal
export PROJECT_ROOT="$PWD"

# Then start Claude Code and provide:
# "Read orchestrator.md and help me with [your task]"
```

### Using ChatGPT or Other Agents

1. Copy content of `orchestrator.md`
2. Paste into your agent as system prompt
3. Provide additional context by copying relevant domain files

## Step 5: Test It Out

Try some queries with tags:

```bash
# Training query
"I'm going to train today" tags=[calisthenics,session]

# Planning query
"Plan my week" tags=[schedule,planning]

# Learning query
"I want to study DSA" tags=[dsa,tracking]

# Code query
"Write a script to parse my workout logs" type=code
```

## Understanding the System

### How It Works

1. **You ask a question** (with optional type and tags)
2. **Orchestrator classifies** the query and selects an agent
3. **Router loads context** based on tags (minimal files only)
4. **Agent processes** your query with focused context
5. **You get a response** in your preferred language and style

### Key Files

- `orchestrator.md` - Main entry point
- `routers.md` - Context loading rules
- `domains/personal/profile/digest.md` - Your profile (always loaded)
- `domains/[category]/[domain]/context.md` - Domain knowledge

### Tags Guide

Tags control what context gets loaded:

**Always include domain tags:**
- `calisthenics`, `training` → loads fitness context
- `dsa`, `coding` → loads DSA context
- `schedule`, `planning` → loads schedule context

**Add tracking tags when logging:**
- `tracking`, `progress`, `journal` → loads detailed logs

**Add deep-profile when needed:**
- `deep-profile`, `review` → loads detailed profile facts

## Common Tasks

### Starting a Workout

```
Query: "I'm going to train"
Tags: [calisthenics, session]
Agent: physical
Context: digest.md, calisthenics/context.md, workflows/session.md
```

### Logging Progress

```
Query: "Log today's workout: Pull-ups 5x5 @ +15kg"
Tags: [calisthenics, tracking]
Agent: physical
Context: ... + progress.md
```

### Planning Week

```
Query: "Plan next week, I have a deadline on Wednesday"
Tags: [schedule, planning]
Agent: tasks
Context: digest.md, schedule/context.md
```

### Code Task

```
Query: "Write TypeScript function to calculate moving average"
Type: code
Agent: code (Claude)
Context: digest.md + minimal relevant context
```

## Next Steps

### Customize Further

1. **Add more domains**: Create new domain directories for your interests
2. **Create workflows**: Add step-by-step guides in `workflows/` subdirectories
3. **Set up sync**: Configure Google Drive/Dropbox sync in `.env`
4. **Add tracking**: Create `progress.md` files for domains you want to track

### Read Documentation

- [Core Overview](core-overview.md) - System architecture
- [README](../README.md) - Main documentation with configuration guide
- See `routers.md` for advanced routing rules
- See `functions/README.md` for function development

### Best Practices

1. **Keep digests light**: Under 200 tokens for fast loading
2. **Use tags consistently**: Helps router find right context
3. **Update regularly**: Keep progress logs and digests current
4. **Archive old data**: Move historical logs to archive directories
5. **Review quarterly**: Update facts, goals, and contexts

## Troubleshooting

### Profile Not Loading

- Check `initialized: true` in `domains/personal/profile/index.md`
- Verify `PROJECT_ROOT` is set correctly in `.env`
- Run `./scripts/init.sh` again if needed

### Context Too Large

- Use more `digest.md` files instead of full `context.md`
- Reduce number of files loaded in `routers.md`
- Use tags more specifically to load only needed context

### Wrong Language Responses

- Check `output_language` in profile
- Verify language code is correct (en, sk, cs, etc.)
- Agent may not support all languages - try common ones first

## Getting Help

- Check [README.md](../README.md) for configuration and setup
- Review [core-overview.md](core-overview.md) for architecture
- Read [CLAUDE.md](../CLAUDE.md) for model-specific tips
- See `orchestrator.md` for system policies

## Examples

See example domains for reference:
- `domains/development/tech/dsa/` - Learning tracking
- `domains/personal/health/fitness/calisthenics/` - Training tracking
- `domains/personal/productivity/schedule/` - Time management

---

**You're all set!** Start using your Grimoire AI and customize as you go.
