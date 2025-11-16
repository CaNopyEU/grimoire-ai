---
scope: function
category: tracking
priority: medium
tags: [progress, update, tracking]
---
# PURPOSE
Update progress files and digests across all domains

# WHEN TO USE
- After completing learning sessions (DSA, System Design)
- After workouts (update fitness progress)
- Weekly/monthly reviews
- Goal achievement milestones

# USAGE

## 1. Update Learning Progress (DSA)
```typescript
interface ProblemSolved {
    name: string;
    difficulty: 'Easy' | 'Medium' | 'Hard';
    topic: string;
    timeTaken: number; // minutes
    notes?: string;
}

function logDSAProgress(problem: ProblemSolved) {
    const progressPath = 'domains/development/tech/dsa/progress.md';
    const date = new Date().toLocaleDateString();

    const entry = `- [x] ${problem.name} - ${problem.difficulty} - ${problem.timeTaken}min - ${problem.notes || ''}\n`;

    // Append to current week section
    appendToSection(progressPath, '## Week of', entry);

    console.log(`✓ Logged ${problem.name}`);
}
```

## 2. Update Fitness Digest
```typescript
function updateFitnessDigest(updates: {
    currentFocus?: string;
    nextSession?: string;
    keyLifts?: Record<string, string>;
}) {
    const digestPath = 'domains/personal/health/fitness/calisthenics/digest.md';
    let content = fs.readFileSync(digestPath, 'utf-8');

    if (updates.currentFocus) {
        content = updateSection(content, '# CURRENT FOCUS', updates.currentFocus);
    }

    if (updates.keyLifts) {
        let liftsSection = '# KEY LIFTS (CURRENT)\n';
        for (const [exercise, details] of Object.entries(updates.keyLifts)) {
            liftsSection += `- ${exercise}: ${details}\n`;
        }
        content = updateSection(content, '# KEY LIFTS', liftsSection);
    }

    fs.writeFileSync(digestPath, content);
    console.log('✓ Digest updated');
}

// Usage
updateFitnessDigest({
    keyLifts: {
        'Pull-ups': '5×5 @ +15kg',
        'Dips': '5×5 @ +20kg'
    }
});
```

## 3. Batch Update from CSV
```bash
#!/bin/bash
# update-progress-from-csv.sh

CSV_PATH="$GOOGLE_DRIVE_AI_SYNC/this-week.csv"
PROGRESS_PATH="domains/personal/health/fitness/calisthenics/progress.md"

echo "## Week of $(date +%Y-%m-%d)" >> "$PROGRESS_PATH"

tail -n +2 "$CSV_PATH" | while IFS=',' read -r date exercise sets reps load; do
    echo "- $exercise: ${sets}×${reps} @ ${load}kg" >> "$PROGRESS_PATH"
done

echo "✓ Progress updated from CSV"
```

## 4. Weekly Review Update
```typescript
interface WeeklyReview {
    weekOf: Date;
    domain: string;
    achievements: string[];
    challenges: string[];
    nextWeekFocus: string[];
}

function logWeeklyReview(review: WeeklyReview) {
    const progressPath = `domains/${review.domain}/progress.md`;

    let log = `\n## Week of ${review.weekOf.toISOString().split('T')[0]}\n\n`;
    log += `### Achievements\n`;
    review.achievements.forEach(a => log += `- ✓ ${a}\n`);

    log += `\n### Challenges\n`;
    review.challenges.forEach(c => log += `- ${c}\n`);

    log += `\n### Next Week Focus\n`;
    review.nextWeekFocus.forEach(f => log += `- [ ] ${f}\n`);

    fs.appendFileSync(progressPath, log);
    console.log(`✓ Weekly review logged for ${review.domain}`);
}

// Usage
logWeeklyReview({
    weekOf: new Date(),
    domain: 'development/tech/dsa',
    achievements: [
        'Completed 5 DP problems',
        'Understood memoization pattern'
    ],
    challenges: [
        'Still struggling with 2D DP',
        'Time complexity analysis slow'
    ],
    nextWeekFocus: [
        'Focus on 2D DP problems',
        'Review Big-O notation'
    ]
});
```

# AUTOMATION

## Auto-Update Digest from Progress
```typescript
// Extract latest entries from progress.md and update digest.md
function syncProgressToDigest(domain: string) {
    const progressPath = `domains/${domain}/progress.md`;
    const digestPath = `domains/${domain}/digest.md`;

    const progress = fs.readFileSync(progressPath, 'utf-8');

    // Extract latest week
    const latestWeek = extractLatestWeek(progress);

    // Update digest with summary
    updateDigestSummary(digestPath, latestWeek);
}

function extractLatestWeek(progressContent: string) {
    const weekRegex = /## Week of ([\d-]+)([\s\S]*?)(?=## Week of|$)/g;
    const matches = [...progressContent.matchAll(weekRegex)];

    if (matches.length === 0) return null;

    const latest = matches[matches.length - 1];
    return {
        date: latest[1],
        content: latest[2]
    };
}
```

## Scheduled Progress Snapshots
```bash
#!/bin/bash
# snapshot-progress.sh - Run weekly via cron

SNAPSHOT_DIR="domains/personal/health/fitness/calisthenics/snapshots"
mkdir -p "$SNAPSHOT_DIR"

WEEK=$(date +%Y-W%V)
SNAPSHOT_FILE="$SNAPSHOT_DIR/$WEEK.md"

# Copy current week from progress
grep -A 20 "## Week of $(date +%Y-%m-%d)" progress.md > "$SNAPSHOT_FILE"

echo "✓ Snapshot saved: $SNAPSHOT_FILE"
```

# UPDATE PATTERNS

## Mark Goals Complete
```typescript
function markGoalComplete(goalPath: string, goalText: string) {
    let content = fs.readFileSync(goalPath, 'utf-8');

    // Change [ ] to [x]
    content = content.replace(
        new RegExp(`- \\[ \\] ${goalText}`, 'g'),
        `- [x] ${goalText}`
    );

    // Add completion date
    const date = new Date().toISOString().split('T')[0];
    content = content.replace(
        new RegExp(`(- \\[x\\] ${goalText})`),
        `$1 - Completed: ${date}`
    );

    fs.writeFileSync(goalPath, content);
    console.log(`✓ Marked complete: ${goalText}`);
}
```

## Add New Goal
```typescript
function addGoal(domain: string, goal: string, quarter: string) {
    const goalsPath = `domains/${domain}/goals/context.md`;
    let content = fs.readFileSync(goalsPath, 'utf-8');

    // Find quarter section
    const quarterSection = `# ${quarter.toUpperCase()} QUARTER GOALS`;
    const newGoal = `- [ ] ${goal}\n`;

    content = content.replace(
        new RegExp(`${quarterSection}\n`),
        `${quarterSection}\n${newGoal}`
    );

    fs.writeFileSync(goalsPath, content);
    console.log(`✓ Added goal: ${goal}`);
}
```

# NOTES
- Update `last_updated` frontmatter when modifying files
- Keep digests concise (update only current status)
- Archive old progress entries monthly
- Use consistent date formats

# RELATED FUNCTIONS
- `workout-log.md` - Log specific workouts
- `metrics-calculate.md` - Calculate progress metrics
- `weekly-review.md` - Structured weekly reviews
