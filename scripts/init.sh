#!/bin/bash
# Grimoire AI - Initialization Script
# This script guides you through setting up your personal Grimoire AI

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          Grimoire AI - First-Time Initialization           ║${NC}"
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo ""

# Check if already initialized
if [ -f "$PROJECT_ROOT/.initialized" ]; then
    echo -e "${YELLOW}Warning: This system appears to be already initialized.${NC}"
    read -p "Do you want to re-initialize? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Initialization cancelled."
        exit 0
    fi
fi

# Step 1: Basic Profile Information
echo -e "${GREEN}Step 1/5: Basic Profile Information${NC}"
echo "-----------------------------------"

read -p "Your name: " USER_NAME
read -p "Birth date (DD.MM.YYYY): " BIRTH_DATE
read -p "Location (City, Country): " LOCATION
read -p "Timezone (e.g., Europe/Prague, America/New_York): " TIMEZONE

# Step 2: Language Settings
echo ""
echo -e "${GREEN}Step 2/5: Language Settings${NC}"
echo "-----------------------------------"
echo "Available languages: en (English), sk (Slovak), cs (Czech), de (German), es (Spanish), fr (French)"
read -p "Output language (language for agent responses) [en]: " OUTPUT_LANG
OUTPUT_LANG=${OUTPUT_LANG:-en}

read -p "Thinking language (for internal reasoning, default: same as output) [$OUTPUT_LANG]: " THINKING_LANG
THINKING_LANG=${THINKING_LANG:-$OUTPUT_LANG}

echo "Date formats: 1) DD.MM.YYYY  2) MM/DD/YYYY  3) YYYY-MM-DD"
read -p "Preferred date format (1-3) [1]: " DATE_FORMAT_CHOICE
case $DATE_FORMAT_CHOICE in
    2) DATE_FORMAT="MM/DD/YYYY" ;;
    3) DATE_FORMAT="YYYY-MM-DD" ;;
    *) DATE_FORMAT="DD.MM.YYYY" ;;
esac

# Step 3: Communication Preferences
echo ""
echo -e "${GREEN}Step 3/5: Communication Preferences${NC}"
echo "-----------------------------------"
echo "Detail level: 1) concise  2) balanced  3) detailed"
read -p "Choose detail level (1-3) [2]: " DETAIL_CHOICE
case $DETAIL_CHOICE in
    1) DETAIL_LEVEL="concise" ;;
    3) DETAIL_LEVEL="detailed" ;;
    *) DETAIL_LEVEL="balanced" ;;
esac

echo "Explanation style: 1) technical  2) simplified  3) adaptive"
read -p "Choose explanation style (1-3) [3]: " STYLE_CHOICE
case $STYLE_CHOICE in
    1) EXPLANATION_STYLE="technical" ;;
    2) EXPLANATION_STYLE="simplified" ;;
    *) EXPLANATION_STYLE="adaptive" ;;
esac

# Step 4: Interests & Focus Areas
echo ""
echo -e "${GREEN}Step 4/5: Interests & Focus Areas${NC}"
echo "-----------------------------------"
read -p "Primary interests (comma-separated, e.g., fitness, coding, finance): " INTERESTS
read -p "Current focus areas (what you're actively working on): " FOCUS_AREAS
read -p "Long-term goals (broader objectives): " LONG_TERM_GOALS

# Step 5: Environment Configuration
echo ""
echo -e "${GREEN}Step 5/5: Environment Configuration${NC}"
echo "-----------------------------------"

# Create .env file
if [ ! -f "$PROJECT_ROOT/.env" ]; then
    echo "Creating .env file..."
    cp "$PROJECT_ROOT/.env.example" "$PROJECT_ROOT/.env"

    # Update PROJECT_ROOT in .env
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s|PROJECT_ROOT=.*|PROJECT_ROOT=$PROJECT_ROOT|" "$PROJECT_ROOT/.env"
    else
        # Linux
        sed -i "s|PROJECT_ROOT=.*|PROJECT_ROOT=$PROJECT_ROOT|" "$PROJECT_ROOT/.env"
    fi

    echo -e "${GREEN}✓ .env file created${NC}"
else
    echo -e "${YELLOW}! .env file already exists, skipping${NC}"
fi

# Update profile files
echo ""
echo "Updating profile files..."

CURRENT_DATE=$(date +%Y-%m-%d)

# Update index.md
cat > "$PROJECT_ROOT/domains/personal/profile/index.md" <<EOF
---
scope: personal
topic: profile
priority: high
last_updated: $CURRENT_DATE
tags: [profile]
---
# PURPOSE
Quick profile for all agents. This file is loaded by default for most queries.

# PROFILE
- Name: $USER_NAME
- Birth date: $BIRTH_DATE
- Location: $LOCATION
- Timezone: $TIMEZONE

# LANGUAGE SETTINGS
- output_language: $OUTPUT_LANG
- thinking_language: $THINKING_LANG
- date_format: $DATE_FORMAT

# COMMUNICATION PREFERENCES
- detail_level: $DETAIL_LEVEL
- explanation_style: $EXPLANATION_STYLE
- formatting: markdown

# INTERESTS & GOALS
- Primary interests: $INTERESTS
- Current focus areas: $FOCUS_AREAS
- Long-term goals: $LONG_TERM_GOALS

# DOMAIN LINKS
- Health & Fitness: [health/fitness/*/context.md]
- Nutrition: [health/nutrition/context.md]
- Productivity: [productivity/*/context.md]
- Career: [../../development/professional/index.md]
- Learning: [../../development/tech/*/context.md]
- Finance: [finances/context.md]

# INITIALIZATION STATUS
initialized: true
initialized_date: $CURRENT_DATE
EOF

# Update digest.md
cat > "$PROJECT_ROOT/domains/personal/profile/digest.md" <<EOF
---
scope: personal
topic: profile_digest
priority: high
last_updated: $CURRENT_DATE
tags: [profile, digest]
---
# PURPOSE
Lightweight profile summary loaded by default. Keep this under 200 tokens.

# QUICK FACTS
- Name: $USER_NAME
- Location: $LOCATION, $TIMEZONE
- Output language: $OUTPUT_LANG

# CURRENT FOCUS
$(echo "$FOCUS_AREAS" | sed 's/^/- /')

# KEY PREFERENCES
- Communication: $DETAIL_LEVEL
- Explanation style: $EXPLANATION_STYLE

# NOTES
This is a minimal digest. For detailed facts, see \`facts.md\` (loaded only with \`deep-profile\` tag).
EOF

# Update facts.md header
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/last_updated: \[TO_BE_INITIALIZED\]/last_updated: $CURRENT_DATE/" "$PROJECT_ROOT/domains/personal/profile/facts.md"
else
    sed -i "s/last_updated: \[TO_BE_INITIALIZED\]/last_updated: $CURRENT_DATE/" "$PROJECT_ROOT/domains/personal/profile/facts.md"
fi

# Mark as initialized
touch "$PROJECT_ROOT/.initialized"
echo "$CURRENT_DATE" > "$PROJECT_ROOT/.initialized"

# Summary
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║            Initialization Complete! ✓                      ║${NC}"
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo ""
echo -e "${BLUE}Your Grimoire AI is now configured:${NC}"
echo -e "  • Profile: $USER_NAME ($LOCATION)"
echo -e "  • Language: $OUTPUT_LANG"
echo -e "  • Style: $DETAIL_LEVEL, $EXPLANATION_STYLE"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. Review and customize: ${YELLOW}domains/personal/profile/facts.md${NC}"
echo -e "  2. Add domain-specific contexts in: ${YELLOW}domains/${NC}"
echo -e "  3. Configure API keys in: ${YELLOW}.env${NC} (if using API-based agents)"
echo -e "  4. Start using: Point your AI agent to ${YELLOW}orchestrator.md${NC}"
echo ""
echo -e "${BLUE}Documentation:${NC}"
echo -e "  • Quick start: ${YELLOW}README.md${NC}"
echo -e "  • Architecture: ${YELLOW}docs/core-overview.md${NC}"
echo -e "  • Model setup: ${YELLOW}CLAUDE.md${NC} or ${YELLOW}GEMINI.md${NC}"
echo ""
echo -e "${GREEN}Happy knowledge building! 🚀${NC}"
