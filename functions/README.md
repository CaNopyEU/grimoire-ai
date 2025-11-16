# Functions

Executable capabilities that the AI agent can use to perform specific operations.

## Categories

### I/O (Input/Output)
Operations for reading and writing data.

- **google-drive-read.md** - Read files from Google Drive Desktop sync folder
  - Use when: Accessing CSV exports, synced markdown files
  - Prerequisites: Google Drive Desktop installed, paths in `.env`

- **csv-parse.md** - Parse CSV data into structured format
  - Use when: Processing workout logs, financial data, exports
  - Supports: TypeScript, Python, Bash parsing methods

### Tracking
Progress logging and updates across domains.

- **workout-log.md** - Log training sessions to progress.md
  - Use when: After workouts, importing from CSV
  - Updates: progress.md, digest.md
  - Detects: Personal records (PRs)

- **progress-update.md** - Update progress files across all domains
  - Use when: Learning sessions, weekly reviews, milestones
  - Supports: DSA, fitness, any domain with progress.md

### Planning
Schedule and goal management.

- **weekly-plan.md** - Create and adjust weekly schedules
  - Use when: Sunday planning, mid-week adjustments
  - Considers: Training frequency, recovery, constraints
  - Outputs: Structured weekly plan

### Analysis
Metrics calculation and trend detection.

- **metrics-calculate.md** - Calculate performance metrics
  - Use when: Weekly/monthly reviews, detecting plateaus
  - Calculates: Volume, PRs, trends, improvement rates
  - Visualizes: Tables, ASCII charts

## How to Use

### 1. Query Mentions Capability
If user asks to "read from Google Drive", router loads `io/google-drive-read.md`.

### 2. Router Classification
Router classifies query:
- **data-access** → loads I/O functions
- **tracking** → loads tracking functions
- **planning** → loads planning functions
- **analysis** → loads analysis functions

### 3. Functions Provide Instructions
Each function contains:
- **PURPOSE**: What it does
- **WHEN TO USE**: Triggers
- **USAGE**: Code examples (TypeScript, Bash, Python)
- **PATTERNS**: Common use cases
- **RELATED**: Links to related functions

### 4. Agent Applies Function
AI agent reads function instructions and applies them to solve the query.

## Examples

**Query**: "Read this week's workout data from Google Drive CSV"
- Classification: data-access
- Functions loaded: `google-drive-read.md`, `csv-parse.md`
- Agent uses instructions to read and parse the CSV

**Query**: "Log workout: Pull-ups 5×5 @ +15kg"
- Classification: tracking
- Functions loaded: `workout-log.md`
- Agent uses workout-log instructions to append to progress.md

**Query**: "Calculate my weekly volume"
- Classification: analysis
- Functions loaded: `metrics-calculate.md`, `csv-parse.md`
- Agent reads progress data, calculates metrics

## Adding New Functions

1. **Create file**: `functions/[category]/[name].md`
2. **Follow template**:
   ```markdown
   ---
   scope: function
   category: [io|tracking|planning|analysis]
   priority: [high|medium|low]
   tags: [relevant, tags]
   ---
   # PURPOSE
   [What it does]

   # WHEN TO USE
   [Triggers]

   # USAGE
   [Code examples]

   # RELATED FUNCTIONS
   [Links]
   ```
3. **Register**: Add to `registry.md`
4. **Map**: Add routing rule in `routers.md`

## Best Practices

- **One function, one purpose**: Keep functions focused
- **Code examples**: Include TypeScript, Bash, Python when applicable
- **Error handling**: Show how to handle common errors
- **Related functions**: Link to complementary functions
- **Real examples**: Use actual use cases from domains

## Token Efficiency

Functions are loaded on-demand:
- Max 3 functions per query (see `routers.md`)
- Each function ~400-800 tokens
- Only load functions actually needed
- Prefer smaller, focused functions over large multi-purpose ones

---

See `registry.md` for complete function catalog.
