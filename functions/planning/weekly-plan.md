---
scope: function
category: planning
priority: high
tags: [planning, schedule, weekly]
---
# PURPOSE
Create and adjust weekly schedules based on goals, constraints, and recovery

# WHEN TO USE
- Sunday evening planning for next week
- Mid-week adjustments when schedule changes
- After goal setting or priority shifts
- Coordinating multiple domains (training, work, learning)

# USAGE

## 1. Generate Weekly Template
```typescript
interface WeeklyPlan {
    weekOf: Date;
    workSessions: Session[];
    trainingSessions: Session[];
    learningSessions: Session[];
    personalTime: Session[];
    constraints: string[];
}

interface Session {
    day: string;
    timeBlock: string;
    activity: string;
    duration: number; // minutes
    priority: 'high' | 'medium' | 'low';
}

function generateWeeklyPlan(params: {
    weekOf: Date;
    trainingDays: number;
    learningHoursPerWeek: number;
    constraints: string[];
}): WeeklyPlan {
    const plan: WeeklyPlan = {
        weekOf: params.weekOf,
        workSessions: [],
        trainingSessions: [],
        learningSessions: [],
        personalTime: [],
        constraints: params.constraints
    };

    // Distribute training sessions
    const trainingDays = ['Monday', 'Wednesday', 'Friday'].slice(0, params.trainingDays);
    for (const day of trainingDays) {
        plan.trainingSessions.push({
            day,
            timeBlock: 'Evening (18:00-19:30)',
            activity: 'Calisthenics Training',
            duration: 90,
            priority: 'high'
        });
    }

    // Distribute learning sessions
    const learningMinutesPerDay = (params.learningHoursPerWeek * 60) / 5;
    ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'].forEach(day => {
        plan.learningSessions.push({
            day,
            timeBlock: 'Morning (7:00-8:00)',
            activity: 'DSA Practice',
            duration: learningMinutesPerDay,
            priority: 'medium'
        });
    });

    return plan;
}
```

## 2. Adjust for Constraints
```typescript
function adjustPlanForConstraints(
    plan: WeeklyPlan,
    constraints: { day: string; reason: string }[]
): WeeklyPlan {
    for (const constraint of constraints) {
        // Remove training from constrained day
        plan.trainingSessions = plan.trainingSessions.filter(
            s => s.day !== constraint.day
        );

        // Try to reschedule
        const alternativeDays = ['Tuesday', 'Thursday', 'Saturday']
            .filter(d => !plan.trainingSessions.some(s => s.day === d));

        if (alternativeDays.length > 0) {
            plan.trainingSessions.push({
                day: alternativeDays[0],
                timeBlock: 'Evening (18:00-19:30)',
                activity: 'Calisthenics Training (rescheduled)',
                duration: 90,
                priority: 'high'
            });
        }
    }

    return plan;
}

// Usage
let plan = generateWeeklyPlan({
    weekOf: new Date(),
    trainingDays: 3,
    learningHoursPerWeek: 5,
    constraints: []
});

plan = adjustPlanForConstraints(plan, [
    { day: 'Wednesday', reason: 'Important deadline' }
]);
```

## 3. Export to Schedule Context
```typescript
function exportPlanToSchedule(plan: WeeklyPlan) {
    const schedulePath = 'domains/personal/productivity/schedule/context.md';
    let content = fs.readFileSync(schedulePath, 'utf-8');

    // Generate schedule text
    let scheduleText = `# WEEKLY STRUCTURE\n## Week of ${plan.weekOf.toISOString().split('T')[0]}\n\n`;

    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    for (const day of days) {
        scheduleText += `## ${day}\n`;

        const daySessions = [
            ...plan.workSessions,
            ...plan.trainingSessions,
            ...plan.learningSessions,
            ...plan.personalTime
        ].filter(s => s.day === day);

        if (daySessions.length === 0) {
            scheduleText += '- Rest day / Flexible\n\n';
            continue;
        }

        daySessions
            .sort((a, b) => a.timeBlock.localeCompare(b.timeBlock))
            .forEach(s => {
                scheduleText += `- ${s.timeBlock}: ${s.activity} (${s.duration}min)\n`;
            });

        scheduleText += '\n';
    }

    // Replace weekly structure section
    content = content.replace(
        /# WEEKLY STRUCTURE\n[\s\S]*?(?=\n# |$)/,
        scheduleText
    );

    fs.writeFileSync(schedulePath, content);
    console.log('✓ Schedule updated');
}
```

## 4. CLI Interactive Planner
```bash
#!/bin/bash
# weekly-planner.sh

echo "Weekly Planner"
echo "=============="
read -p "Training days this week (2-4): " training_days
read -p "Learning hours per week: " learning_hours
read -p "Any constraints? (day:reason, or empty): " constraints

# Generate plan (call TypeScript function or create bash version)
cat > /tmp/weekly-plan.md <<EOF
# Week of $(date +%Y-%m-%d)

## Training Schedule
EOF

# Add training days
for i in $(seq 1 $training_days); do
    echo "- Training session $i" >> /tmp/weekly-plan.md
done

echo "✓ Plan created: /tmp/weekly-plan.md"
cat /tmp/weekly-plan.md
```

# OPTIMIZATION

## Balance Recovery
```typescript
function balanceRecovery(plan: WeeklyPlan): WeeklyPlan {
    const trainingDays = plan.trainingSessions.map(s => s.day);

    // Ensure at least 1 day between training sessions
    for (let i = 0; i < trainingDays.length - 1; i++) {
        const dayIndex = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
        const currentIdx = dayIndex.indexOf(trainingDays[i]);
        const nextIdx = dayIndex.indexOf(trainingDays[i + 1]);

        if (nextIdx - currentIdx < 2) {
            console.warn(`⚠️  Only ${nextIdx - currentIdx} day(s) between ${trainingDays[i]} and ${trainingDays[i + 1]}`);
            // Suggest adjustment
        }
    }

    return plan;
}
```

## Prioritize Based on Goals
```typescript
function prioritizeByGoals(plan: WeeklyPlan, goals: string[]): WeeklyPlan {
    // Adjust session priorities based on current goals
    for (const session of [...plan.trainingSessions, ...plan.learningSessions]) {
        if (goals.some(g => session.activity.includes(g))) {
            session.priority = 'high';
        }
    }

    return plan;
}
```

# REVIEW & ADJUST

## Weekly Review
```typescript
function reviewWeek(actualSessions: Session[], plannedSessions: Session[]) {
    const completed = actualSessions.length;
    const planned = plannedSessions.length;
    const completionRate = (completed / planned) * 100;

    console.log(`Week Review:`);
    console.log(`- Planned: ${planned} sessions`);
    console.log(`- Completed: ${completed} sessions`);
    console.log(`- Rate: ${completionRate.toFixed(0)}%`);

    // Identify missed sessions
    const missed = plannedSessions.filter(p =>
        !actualSessions.some(a => a.activity === p.activity && a.day === p.day)
    );

    if (missed.length > 0) {
        console.log(`\nMissed sessions:`);
        missed.forEach(m => console.log(`- ${m.day}: ${m.activity}`));
    }

    return { completionRate, missed };
}
```

# NOTES
- Plan Sunday evening for upcoming week
- Review Friday/Saturday for current week
- Adjust mid-week if constraints appear
- Consider energy levels (training after deadline = bad)
- Block deep work time first, fill rest around it

# RELATED FUNCTIONS
- `goal-review.md` - Align plan with goals
- `progress-update.md` - Track plan execution
- `recovery-check.md` - Ensure adequate recovery
