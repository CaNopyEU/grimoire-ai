# FUNCTIONS

Available capabilities organized by category.

## I/O (Input/Output)
- id: google-drive-read | path: functions/io/ | purpose: Read files from Google Drive sync
- id: csv-parse | path: functions/io/ | purpose: Parse CSV data into structured format
- id: file-write | path: functions/io/ | purpose: Write data to files (TBD)

## Tracking
- id: workout-log | path: functions/tracking/ | purpose: Log training sessions to progress.md
- id: progress-update | path: functions/tracking/ | purpose: Update progress across all domains
- id: metrics-track | path: functions/tracking/ | purpose: Track key metrics over time (TBD)

## Planning
- id: weekly-plan | path: functions/planning/ | purpose: Create and adjust weekly schedules
- id: goal-review | path: functions/planning/ | purpose: Review and adjust goals (TBD)
- id: deload-schedule | path: functions/planning/ | purpose: Plan deload weeks (TBD)

## Analysis
- id: metrics-calculate | path: functions/analysis/ | purpose: Calculate performance metrics (volume, PRs, trends)
- id: trend-analysis | path: functions/analysis/ | purpose: Detect patterns and plateaus (TBD)
- id: comparison | path: functions/analysis/ | purpose: Compare periods/cycles (TBD)

# DOMAINS

Knowledge areas that provide context.

## Development
- tech/dsa | DSA learning and problem-solving
- tech/system-design | System architecture and scalability
- tech/fe-senior | Frontend development (placeholder)
- knowledge/finance | Finance and investing
- knowledge/human-history | Historical knowledge (placeholder)
- professional | Career and work

## Personal
- profile | User profile, preferences, language settings
- health/fitness/calisthenics | Training program and tracking
- health/fitness/swimming | Swimming (placeholder)
- health/fitness/yoga | Yoga and mobility (placeholder)
- health/nutrition | Nutrition and supplementation
- productivity/schedule | Time management
- productivity/goals | Goal setting and tracking
- productivity/metrics | Performance metrics (placeholder)
- finances | Personal finance (placeholder)

# USAGE

Functions are loaded when query requires specific capability:
- Query mentions "read from Google Drive" → load `google-drive-read.md`
- Query says "log workout" → load `workout-log.md`
- Query asks "calculate my progress" → load `metrics-calculate.md`
- Query needs "plan next week" → load `weekly-plan.md`

Domains are loaded based on tags (see `routers.md`).
