## GOAL

Minimal, deterministic router loading only required context and functions.

## QUERY CLASSIFICATION

```
INPUT: { text, type?, needs_web?, tags?: string[] }

CLASSIFY INTO:
  - data-access: Read/write files, CSV parsing, Google Drive sync
  - tracking: Log workouts, update progress, track metrics
  - planning: Weekly schedule, goal setting, deload planning
  - analysis: Calculate metrics, detect trends, compare periods
  - general: Questions, research, simple tasks

RULES:
  1. if query mentions "read", "CSV", "Google Drive", "parse" => data-access
  2. else if query mentions "log", "track", "update progress" => tracking
  3. else if query mentions "plan", "schedule", "organize" => planning
  4. else if query mentions "calculate", "metrics", "trend", "compare" => analysis
  5. else => general
```

## FUNCTION SELECTION

```
FUNCTION MAPPING:

DATA-ACCESS:
  keywords: {read, CSV, Google Drive, parse, import, export, sync}
  → load functions/io/google-drive-read.md (if mentions Drive)
  → load functions/io/csv-parse.md (if mentions CSV or parse)

TRACKING:
  keywords: {log, track, update, record, session, workout}
  → load functions/tracking/workout-log.md (if fitness domain)
  → load functions/tracking/progress-update.md (if mentions update/progress)

PLANNING:
  keywords: {plan, schedule, organize, week, calendar, reschedule}
  → load functions/planning/weekly-plan.md

ANALYSIS:
  keywords: {calculate, metrics, volume, PR, trend, analyze, compare}
  → load functions/analysis/metrics-calculate.md
```

## DOMAIN & CONTEXT SELECTION

```
DEFAULT:
  ROOT := ${PROJECT_ROOT:-.}
  include ${ROOT}/registry.md
  include ${ROOT}/domains/personal/profile/digest.md  # lightweight baseline profile

TRACKING_TAGS := {tracking, update, progress, journal, routine, review}
DEEP_PROFILE_TAGS := {deep-profile, review, retro}

if query mentions personal OR development domain OR intersects tags:
  # Base profile context (load facts only when needed)
  if tags ∩ DEEP_PROFILE_TAGS:
    include ${ROOT}/domains/personal/profile/facts.md

  # DEVELOPMENT domain - learning & skills
  if tags ∩ {dsa, algorithms, data-structures, leetcode, coding, problems}:
    include ${ROOT}/domains/development/tech/dsa/context.md
    if tags ∩ TRACKING_TAGS:
      include ${ROOT}/domains/development/tech/dsa/progress.md

  if tags ∩ {system-design, scalability, distributed-systems, architecture, design}:
    include ${ROOT}/domains/development/tech/system-design/context.md
    if tags ∩ TRACKING_TAGS:
      include ${ROOT}/domains/development/tech/system-design/progress.md

  if tags ∩ {finance, economics, investing, stocks}:
    include ${ROOT}/domains/development/knowledge/finance/context.md

  if tags ∩ {professional, career, work, frontend}:
    include ${ROOT}/domains/development/professional/index.md

  # PERSONAL domain - health, productivity, daily life
  if tags ∩ {calisthenics, pull, dips, lever, muscle-up, strength, workout, training, physical}:
    include ${ROOT}/domains/personal/health/fitness/calisthenics/digest.md

    if tags ∩ {plan, planning, protocol, program}:
      include ${ROOT}/domains/personal/health/fitness/calisthenics/context.md

    if tags ∩ TRACKING_TAGS OR {session, log, workout}:
      include ${ROOT}/domains/personal/health/fitness/calisthenics/progress.md

    if tags ∩ {session, start, finish}:
      include ${ROOT}/domains/personal/health/fitness/calisthenics/workflows/session.md

  if tags ∩ {nutrition, food, diet, supplements}:
    include ${ROOT}/domains/personal/health/nutrition/context.md

  if tags ∩ {schedule, plan, calendar}:
    include ${ROOT}/domains/personal/productivity/schedule/context.md

  if tags ∩ {goal, target, OKR}:
    include ${ROOT}/domains/personal/productivity/goals/context.md

  if tags ∩ {finances, budget, expenses}:
    include ${ROOT}/domains/personal/finances/context.md
```

## CONTEXT ORDER & BUDGET

```
ORDER:
  1) personal/profile/digest.md
  2) relevant functions/*.md (based on query classification)
  3) domain digest or core context (max 3 files)
  4) (optional) detailed contexts based on tags
  5) (optional) progress/tracking files when TRACKING_TAGS match

LIMITS:
  - max_functions = 3  # only load functions actually needed
  - max_files_from_domains = 5  # digest (1) + optional extras (max 4)
  - max_tokens_context = 4000
  - if estimate(context) > max_tokens_context → summarize or reduce loaded files
```

## EXAMPLES

```
Q: "Read this week's workout data from Google Drive CSV"
→ query_type: data-access
→ functions: [google-drive-read.md, csv-parse.md]
→ domains: [profile/digest.md]

Q: "Log workout: Pull-ups 5×5 @ +15kg" tags=[calisthenics,tracking]
→ query_type: tracking
→ functions: [workout-log.md]
→ domains: [profile/digest.md, calisthenics/digest.md, calisthenics/progress.md]

Q: "Plan next week, training 3x" tags=[schedule,planning]
→ query_type: planning
→ functions: [weekly-plan.md]
→ domains: [profile/digest.md, schedule/context.md]

Q: "Calculate my weekly volume" tags=[calisthenics,metrics]
→ query_type: analysis
→ functions: [metrics-calculate.md, csv-parse.md]
→ domains: [profile/digest.md, calisthenics/progress.md]

Q: "How do I improve pull-up strength?" tags=[calisthenics]
→ query_type: general
→ functions: []
→ domains: [profile/digest.md, calisthenics/digest.md, calisthenics/context.md]
```
