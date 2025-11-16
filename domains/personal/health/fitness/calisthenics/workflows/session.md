---
scope: personal
topic: calisthenics_session_workflow
priority: medium
last_updated: [UPDATE_AS_NEEDED]
tags: [calisthenics, session, workflow]
---
# PURPOSE
Workout session guidance. Loaded only with `session` or `workout` tags.

# PRE-WORKOUT
1. Review today's planned exercises (from `context.md`)
2. Check recovery status (sleep, soreness, stress)
3. Adjust load if needed (deload 10-20% if under-recovered)

# WARM-UP
- General: [5-10 min cardio, joint mobility]
- Specific: [warm-up sets for main exercises]

# MAIN WORKOUT
Follow program in `context.md`:
1. Primary exercise: [work up to working sets]
2. Secondary exercises: [prescribed volume]
3. Skill work: [if programmed]

# LOAD PROGRESSION
- If hit all reps with RIR 1-2: consider load increase next session
- If failed reps or RIR 4+: maintain or reduce load
- If deload week: reduce load by 30-40%

# POST-WORKOUT
1. Cool down: [stretching, breathing]
2. Log session in `progress.md` (sets, reps, load, notes)
3. Update `digest.md` if significant changes (PRs, program adjustments)

# NOTES FOR AGENT
When user says "I'm going to train" or "starting workout":
1. Ask about recovery status
2. Suggest any load adjustments based on context
3. Remind of key focus for today
4. After session: prompt to log results
