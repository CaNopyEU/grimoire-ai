---
scope: function
category: analysis
priority: medium
tags: [metrics, analysis, statistics]
---
# PURPOSE
Calculate performance metrics from progress data (volume, PRs, trends, etc.)

# WHEN TO USE
- Weekly/monthly progress reviews
- Detecting plateaus or overtraining
- Planning deloads or program changes
- Comparing training cycles

# USAGE

## 1. Calculate Training Volume
```typescript
interface VolumeMetrics {
    totalSets: number;
    totalReps: number;
    totalVolume: number; // sets × reps × load
    volumeByExercise: Record<string, number>;
}

function calculateWeeklyVolume(workouts: WorkoutRow[]): VolumeMetrics {
    let totalSets = 0;
    let totalReps = 0;
    let totalVolume = 0;
    const volumeByExercise: Record<string, number> = {};

    for (const w of workouts) {
        const load = parseLoad(w.load);
        const volume = w.sets * w.reps * load;

        totalSets += w.sets;
        totalReps += w.sets * w.reps;
        totalVolume += volume;

        volumeByExercise[w.exercise] = (volumeByExercise[w.exercise] || 0) + volume;
    }

    return { totalSets, totalReps, totalVolume, volumeByExercise };
}

function parseLoad(loadStr: string): number {
    if (loadStr === 'BW' || loadStr === 'bodyweight') return 80; // estimate
    return parseFloat(loadStr.replace(/[^0-9.]/g, ''));
}
```

## 2. Track Progress Over Time
```typescript
function calculateProgressRate(
    currentLoad: number,
    previousLoad: number,
    weeks: number
): {
    absolute: number;
    percentage: number;
    perWeek: number;
} {
    const absolute = currentLoad - previousLoad;
    const percentage = ((currentLoad / previousLoad) - 1) * 100;
    const perWeek = absolute / weeks;

    return { absolute, percentage, perWeek };
}

// Usage
const progress = calculateProgressRate(
    17.5, // current: +17.5kg
    10,   // 8 weeks ago: +10kg
    8     // weeks
);

console.log(`Progress: +${progress.absolute}kg (${progress.percentage.toFixed(1)}%)`);
console.log(`Rate: +${progress.perWeek.toFixed(2)}kg/week`);
// Output: Progress: +7.5kg (75.0%)
//         Rate: +0.94kg/week
```

## 3. Detect Personal Records
```typescript
interface PersonalRecord {
    exercise: string;
    metric: 'load' | 'reps' | 'volume';
    value: number;
    date: Date;
    previous?: number;
}

function findPRs(
    currentWorkouts: WorkoutRow[],
    historicalData: WorkoutRow[]
): PersonalRecord[] {
    const prs: PersonalRecord[] = [];

    for (const current of currentWorkouts) {
        const historical = historicalData.filter(h => h.exercise === current.exercise);

        // Check load PR
        const maxHistoricalLoad = Math.max(...historical.map(h => parseLoad(h.load)));
        const currentLoad = parseLoad(current.load);

        if (currentLoad > maxHistoricalLoad) {
            prs.push({
                exercise: current.exercise,
                metric: 'load',
                value: currentLoad,
                date: new Date(current.date),
                previous: maxHistoricalLoad
            });
        }

        // Check volume PR (sets × reps)
        const maxHistoricalVolume = Math.max(...historical.map(h => h.sets * h.reps));
        const currentVolume = current.sets * current.reps;

        if (currentVolume > maxHistoricalVolume) {
            prs.push({
                exercise: current.exercise,
                metric: 'volume',
                value: currentVolume,
                date: new Date(current.date),
                previous: maxHistoricalVolume
            });
        }
    }

    return prs;
}
```

## 4. Calculate Learning Metrics
```typescript
interface LearningMetrics {
    problemsSolved: number;
    averageTime: number;
    byDifficulty: Record<string, number>;
    byTopic: Record<string, number>;
    improvementRate: number;
}

function calculateDSAMetrics(problems: ProblemSolved[]): LearningMetrics {
    const byDifficulty: Record<string, number> = {};
    const byTopic: Record<string, number> = {};
    let totalTime = 0;

    for (const p of problems) {
        byDifficulty[p.difficulty] = (byDifficulty[p.difficulty] || 0) + 1;
        byTopic[p.topic] = (byTopic[p.topic] || 0) + 1;
        totalTime += p.timeTaken;
    }

    const averageTime = totalTime / problems.length;

    // Calculate improvement (time reduction over period)
    const firstHalf = problems.slice(0, Math.floor(problems.length / 2));
    const secondHalf = problems.slice(Math.floor(problems.length / 2));

    const avgFirst = firstHalf.reduce((sum, p) => sum + p.timeTaken, 0) / firstHalf.length;
    const avgSecond = secondHalf.reduce((sum, p) => sum + p.timeTaken, 0) / secondHalf.length;

    const improvementRate = ((avgFirst - avgSecond) / avgFirst) * 100;

    return {
        problemsSolved: problems.length,
        averageTime,
        byDifficulty,
        byTopic,
        improvementRate
    };
}
```

## 5. Trend Analysis
```typescript
function calculateTrend(dataPoints: { date: Date; value: number }[]) {
    // Simple linear regression
    const n = dataPoints.length;
    let sumX = 0, sumY = 0, sumXY = 0, sumXX = 0;

    dataPoints.forEach((point, i) => {
        sumX += i;
        sumY += point.value;
        sumXY += i * point.value;
        sumXX += i * i;
    });

    const slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);
    const intercept = (sumY - slope * sumX) / n;

    const trend = slope > 0 ? 'increasing' :
                  slope < 0 ? 'decreasing' : 'stable';

    return { slope, intercept, trend };
}

// Usage: Detect plateau
const loadProgression = [
    { date: new Date('2024-01-01'), value: 10 },
    { date: new Date('2024-02-01'), value: 12.5 },
    { date: new Date('2024-03-01'), value: 15 },
    { date: new Date('2024-04-01'), value: 15 }, // plateau?
    { date: new Date('2024-05-01'), value: 15 }
];

const trend = calculateTrend(loadProgression);
if (Math.abs(trend.slope) < 0.1) {
    console.log('⚠️  Plateau detected - consider deload or program change');
}
```

# VISUALIZATION

## Generate Markdown Table
```typescript
function generateMetricsTable(metrics: VolumeMetrics): string {
    let table = '| Exercise | Total Volume | Sets | Reps |\n';
    table += '|----------|--------------|------|------|\n';

    for (const [exercise, volume] of Object.entries(metrics.volumeByExercise)) {
        table += `| ${exercise} | ${volume} | - | - |\n`;
    }

    table += `\n**Total**: ${metrics.totalVolume} (${metrics.totalSets} sets, ${metrics.totalReps} reps)\n`;

    return table;
}
```

## ASCII Chart (Simple)
```typescript
function generateVolumeChart(weeklyVolumes: number[]): string {
    const max = Math.max(...weeklyVolumes);
    const scale = 50 / max;

    let chart = 'Weekly Volume Trend:\n';
    weeklyVolumes.forEach((vol, i) => {
        const bars = Math.round(vol * scale);
        chart += `Week ${i + 1}: ${'█'.repeat(bars)} ${vol}\n`;
    });

    return chart;
}

// Output:
// Weekly Volume Trend:
// Week 1: ████████████████████████████ 2800
// Week 2: ██████████████████████████████████ 3400
// Week 3: ████████████████████████████████ 3200
```

# EXPORT

## Save Metrics Report
```typescript
function generateMetricsReport(
    volume: VolumeMetrics,
    prs: PersonalRecord[],
    trend: { slope: number; trend: string }
) {
    const reportPath = `reports/metrics-${new Date().toISOString().split('T')[0]}.md`;

    let report = `# Metrics Report - ${new Date().toLocaleDateString()}\n\n`;
    report += `## Volume\n${generateMetricsTable(volume)}\n\n`;
    report += `## Personal Records\n`;

    if (prs.length > 0) {
        prs.forEach(pr => {
            report += `- ${pr.exercise}: ${pr.value}${pr.metric === 'load' ? 'kg' : ' reps'} `;
            report += `(prev: ${pr.previous || 'N/A'})\n`;
        });
    } else {
        report += 'No PRs this period.\n';
    }

    report += `\n## Trend\n- Direction: ${trend.trend}\n- Rate: ${trend.slope.toFixed(2)}/week\n`;

    fs.writeFileSync(reportPath, report);
    console.log(`✓ Report saved: ${reportPath}`);
}
```

# NOTES
- Calculate metrics weekly and monthly
- Track both absolute and relative progress
- Watch for plateaus (slope near 0)
- Consider external factors (sleep, stress, nutrition)
- Use metrics to inform program adjustments

# RELATED FUNCTIONS
- `progress-update.md` - Update tracking data
- `workout-log.md` - Source data for metrics
- `weekly-plan.md` - Use metrics to adjust planning
