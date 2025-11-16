---
scope: function
category: tracking
priority: high
tags: [workout, tracking, logging]
---
# PURPOSE
Log workout sessions to progress.md and update digest.md

# WHEN TO USE
- After completing a training session
- When manually entering past workouts
- Batch importing from CSV/spreadsheet

# INPUT FORMAT

## Structured Input
```yaml
date: 2024-11-15
session_type: Pull
exercises:
  - name: Pull-ups
    sets: 5
    reps: 5
    load: +15kg
    rir: 2
  - name: Rows
    sets: 4
    reps: 8
    load: BW
notes: "Felt strong, good session"
```

## Natural Language
```
"Log workout: Pull-ups 5×5 @ +15kg (RIR 2), Rows 4×8 bodyweight. Felt strong."
```

# USAGE

## 1. Manual Log Entry
```bash
# Append to progress.md
cat >> domains/personal/health/fitness/calisthenics/progress.md <<EOF

### Session - $(date +%A, %Y-%m-%d)
**Pull**
- Pull-ups: 5×5 @ +15kg (RIR 2)
- Rows: 4×8 @ BW

**Notes**: Felt strong, good session
EOF
```

## 2. TypeScript Logger
```typescript
interface Exercise {
    name: string;
    sets: number;
    reps: number;
    load: string;
    rir?: number;
}

interface WorkoutSession {
    date: Date;
    type: 'Pull' | 'Push' | 'Legs' | 'Full Body';
    exercises: Exercise[];
    notes?: string;
}

function logWorkout(session: WorkoutSession, progressFile: string) {
    const dateStr = session.date.toLocaleDateString('en-US', {
        weekday: 'long',
        year: 'numeric',
        month: '2-digit',
        day: '2-digit'
    });

    let log = `\n### Session - ${dateStr}\n`;
    log += `**${session.type}**\n`;

    for (const ex of session.exercises) {
        const rir = ex.rir ? ` (RIR ${ex.rir})` : '';
        log += `- ${ex.name}: ${ex.sets}×${ex.reps} @ ${ex.load}${rir}\n`;
    }

    if (session.notes) {
        log += `\n**Notes**: ${session.notes}\n`;
    }

    fs.appendFileSync(progressFile, log);
    console.log('✓ Workout logged');
}

// Usage
logWorkout({
    date: new Date(),
    type: 'Pull',
    exercises: [
        { name: 'Pull-ups', sets: 5, reps: 5, load: '+15kg', rir: 2 },
        { name: 'Rows', sets: 4, reps: 8, load: 'BW' }
    ],
    notes: 'Felt strong'
}, 'domains/personal/health/fitness/calisthenics/progress.md');
```

## 3. Import from CSV
```typescript
import { parseWorkoutCSV } from '../io/csv-parse';

function importCSVToProgress(csvPath: string, progressPath: string) {
    const workouts = parseWorkoutCSV(csvPath);

    // Group by date
    const sessionsByDate = new Map<string, typeof workouts>();
    for (const w of workouts) {
        const sessions = sessionsByDate.get(w.date) || [];
        sessions.push(w);
        sessionsByDate.set(w.date, sessions);
    }

    // Log each session
    for (const [date, exercises] of sessionsByDate) {
        let log = `\n### Session - ${date}\n`;
        for (const ex of exercises) {
            log += `- ${ex.exercise}: ${ex.sets}×${ex.reps} @ ${ex.load}kg\n`;
        }
        fs.appendFileSync(progressPath, log);
    }

    console.log(`✓ Imported ${sessionsByDate.size} sessions`);
}
```

# AUTOMATION

## Post-Workout Script
```bash
#!/bin/bash
# workout-log.sh - Quick workout logger

echo "Workout Logger"
echo "=============="
read -p "Exercise: " exercise
read -p "Sets: " sets
read -p "Reps: " reps
read -p "Load (kg, +Xkg, or BW): " load
read -p "RIR (optional): " rir

DATE=$(date +"%A, %Y-%m-%d")
PROGRESS_FILE="domains/personal/health/fitness/calisthenics/progress.md"

if [ -n "$rir" ]; then
    RIR_STR=" (RIR $rir)"
else
    RIR_STR=""
fi

cat >> "$PROGRESS_FILE" <<EOF

### Quick Log - $DATE
- $exercise: ${sets}×${reps} @ ${load}${RIR_STR}
EOF

echo "✓ Logged to $PROGRESS_FILE"
```

## Auto-sync from Google Sheets
```typescript
// Run this as cron job or on-demand
async function syncFromGoogleSheets() {
    const csvPath = process.env.CALISTHENICS_THIS_WEEK_CSV!;
    const progressPath = 'domains/personal/health/fitness/calisthenics/progress.md';

    // Read last sync timestamp
    const lastSync = getLastSyncTime();

    // Parse CSV
    const workouts = parseWorkoutCSV(csvPath);

    // Filter new entries since last sync
    const newWorkouts = workouts.filter(w =>
        new Date(w.date) > lastSync
    );

    if (newWorkouts.length === 0) {
        console.log('No new workouts to sync');
        return;
    }

    // Import new workouts
    importCSVToProgress(newWorkouts, progressPath);

    // Update sync timestamp
    setLastSyncTime(new Date());

    console.log(`✓ Synced ${newWorkouts.length} new workouts`);
}
```

# UPDATE DIGEST

After logging, update digest.md with current status:

```typescript
function updateDigest(latestSession: WorkoutSession) {
    const digestPath = 'domains/personal/health/fitness/calisthenics/digest.md';
    const content = fs.readFileSync(digestPath, 'utf-8');

    // Update "NEXT SESSION" section
    const updated = content.replace(
        /# NEXT SESSION\n.*?\n.*?\n/s,
        `# NEXT SESSION\n- Last: ${latestSession.date.toLocaleDateString()}\n- Type: ${latestSession.type}\n`
    );

    fs.writeFileSync(digestPath, updated);
}
```

# CHECK FOR PRs

```typescript
function checkForPRs(session: WorkoutSession, progressPath: string) {
    const content = fs.readFileSync(progressPath, 'utf-8');
    const prs: string[] = [];

    for (const ex of session.exercises) {
        // Parse load
        const loadNum = parseFloat(ex.load.replace(/[^0-9.]/g, ''));

        // Search for previous best in progress.md
        const regex = new RegExp(`${ex.name}: (\\d+)×(\\d+) @ \\+?(\\d+)`, 'gi');
        let maxLoad = 0;
        let match;

        while ((match = regex.exec(content)) !== null) {
            const prevLoad = parseFloat(match[3]);
            if (prevLoad > maxLoad) maxLoad = prevLoad;
        }

        // Check if PR
        if (loadNum > maxLoad) {
            prs.push(`${ex.name}: ${ex.load} (previous best: ${maxLoad}kg)`);
        }
    }

    if (prs.length > 0) {
        console.log('🎉 PRs achieved:');
        prs.forEach(pr => console.log(`  - ${pr}`));
    }

    return prs;
}
```

# NOTES
- Always include RIR for load management
- Note any form issues or pain
- Track sleep quality and stress (affects interpretation)
- Update digest.md when program changes

# RELATED FUNCTIONS
- `csv-parse.md` - Parse workout CSVs
- `progress-update.md` - Update progress tracking
- `metrics-calculate.md` - Calculate volume, PRs, etc.
