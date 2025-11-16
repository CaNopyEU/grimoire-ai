---
scope: function
category: io
priority: high
tags: [csv, parse, data]
---
# PURPOSE
Parse CSV files (workout logs, financial data, etc.) into structured format

# WHEN TO USE
- Processing Google Sheets exports
- Analyzing workout tracking data
- Importing financial records
- Converting CSV to JSON/markdown

# USAGE

## 1. Basic CSV Parsing (Bash)
```bash
# Read CSV line by line
while IFS=',' read -r col1 col2 col3; do
    echo "Date: $col1, Exercise: $col2, Reps: $col3"
done < workout-log.csv

# Skip header
tail -n +2 workout-log.csv | while IFS=',' read -r date exercise reps; do
    echo "$date: $exercise - $reps reps"
done
```

## 2. Parse with awk
```bash
# Print specific columns
awk -F',' '{print $1, $3, $5}' data.csv

# Sum column (e.g., total reps)
awk -F',' '{sum+=$3} END {print "Total:", sum}' workout-log.csv

# Filter rows
awk -F',' '$2 == "Pull-ups" {print $0}' workout-log.csv
```

## 3. TypeScript/JavaScript
```typescript
import fs from 'fs';
import { parse } from 'csv-parse/sync';

interface WorkoutRow {
    date: string;
    exercise: string;
    sets: number;
    reps: number;
    load: number;
}

// Parse CSV file
function parseWorkoutCSV(filePath: string): WorkoutRow[] {
    const content = fs.readFileSync(filePath, 'utf-8');

    const records = parse(content, {
        columns: true,  // Use first row as headers
        skip_empty_lines: true,
        cast: (value, context) => {
            // Auto-convert numbers
            if (context.column === 'sets' ||
                context.column === 'reps' ||
                context.column === 'load') {
                return parseInt(value);
            }
            return value;
        }
    });

    return records as WorkoutRow[];
}

// Usage
const workouts = parseWorkoutCSV(process.env.CALISTHENICS_THIS_WEEK_CSV!);
console.table(workouts);
```

## 4. Python
```python
import csv
import os

def parse_workout_csv(file_path):
    workouts = []
    with open(file_path, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            workouts.append({
                'date': row['date'],
                'exercise': row['exercise'],
                'sets': int(row['sets']),
                'reps': int(row['reps']),
                'load': float(row['load'])
            })
    return workouts

# Usage
csv_path = os.getenv('CALISTHENICS_THIS_WEEK_CSV')
workouts = parse_workout_csv(csv_path)
```

# COMMON PATTERNS

## Calculate Weekly Volume
```typescript
function calculateWeeklyVolume(workouts: WorkoutRow[]) {
    const volumeByExercise = new Map<string, number>();

    for (const workout of workouts) {
        const volume = workout.sets * workout.reps * (workout.load || 1);
        const current = volumeByExercise.get(workout.exercise) || 0;
        volumeByExercise.set(workout.exercise, current + volume);
    }

    return Object.fromEntries(volumeByExercise);
}
```

## Extract Progress Data
```bash
# Get max load for exercise
awk -F',' '$2 == "Pull-ups" {if ($5 > max) max=$5} END {print "Max load:", max "kg"}' workout.csv

# Count sessions this week
awk -F',' 'NR > 1 {dates[$1]++} END {print "Sessions:", length(dates)}' workout.csv
```

## Convert CSV to Markdown Table
```typescript
function csvToMarkdownTable(filePath: string): string {
    const workouts = parseWorkoutCSV(filePath);

    let md = '| Date | Exercise | Sets | Reps | Load |\n';
    md += '|------|----------|------|------|------|\n';

    for (const w of workouts) {
        md += `| ${w.date} | ${w.exercise} | ${w.sets} | ${w.reps} | ${w.load}kg |\n`;
    }

    return md;
}

// Save to progress.md
const table = csvToMarkdownTable(process.env.CALISTHENICS_THIS_WEEK_CSV!);
fs.appendFileSync('domains/personal/health/fitness/calisthenics/progress.md', table);
```

# ERROR HANDLING

## Malformed CSV
```typescript
try {
    const records = parse(content, { columns: true });
} catch (error) {
    console.error('CSV parsing failed:', error.message);
    // Check for:
    // - Inconsistent column counts
    // - Missing headers
    // - Encoding issues
}
```

## Missing Columns
```typescript
function validateCSV(records: any[]): boolean {
    const required = ['date', 'exercise', 'sets', 'reps', 'load'];

    if (records.length === 0) return false;

    const headers = Object.keys(records[0]);
    return required.every(col => headers.includes(col));
}
```

# NOTES
- Handle quoted fields (e.g., "Pull-ups, wide grip")
- Watch for encoding (UTF-8 vs Windows-1252)
- Empty cells may be empty string or null
- Date formats may vary (DD.MM.YYYY vs MM/DD/YYYY)

# RELATED FUNCTIONS
- `google-drive-read.md` - Read CSV from Google Drive
- `workout-log.md` - Process workout data specifically
- `metrics-calculate.md` - Calculate metrics from parsed data
