---
scope: personal
topic: profile
priority: high
last_updated: [TO_BE_INITIALIZED]
tags: [profile]
---
# PURPOSE
Quick profile for all agents. This file is loaded by default for most queries.

# PROFILE
<!-- Fill in during initialization -->
- Name: [YOUR_NAME]
- Birth date: [DD.MM.YYYY]
- Location: [CITY, COUNTRY]
- Timezone: [e.g., Europe/Prague, America/New_York]

# LANGUAGE SETTINGS
<!-- Configure how agents should communicate with you -->
- output_language: [en|sk|cs|de|es|fr|etc.] # Language for agent responses
- thinking_language: [en|sk|cs|de|es|fr|etc.] # Language for internal reasoning (optional, defaults to output_language)
- date_format: [DD.MM.YYYY|MM/DD/YYYY|YYYY-MM-DD] # Preferred date format

# COMMUNICATION PREFERENCES
<!-- How you prefer agents to interact -->
- detail_level: [concise|balanced|detailed] # How verbose should responses be
- explanation_style: [technical|simplified|adaptive] # Technical depth preference
- formatting: [markdown|plain|structured] # Output formatting preference

# INTERESTS & GOALS
<!-- High-level overview, details go in domain-specific files -->
- Primary interests: [e.g., fitness, coding, finance, learning]
- Current focus areas: [what you're actively working on]
- Long-term goals: [broader objectives]

# DOMAIN LINKS
<!-- Links to detailed domain contexts -->
- Health & Fitness: [health/fitness/*/context.md]
- Nutrition: [health/nutrition/context.md]
- Productivity: [productivity/*/context.md]
- Career: [../../development/professional/index.md]
- Learning: [../../development/tech/*/context.md]
- Finance: [finances/context.md]

# INITIALIZATION STATUS
initialized: false  # Set to true after running init.sh
