# Spend Rules — Precinct 92

## Token Budget Tiers

### Tier 1: Essential (Always Approved)
- Heartbeat polls (< 500 tokens)
- Memory reads/writes
- File operations
- Git commits/pushes
- Cron job execution (within timeout)

### Tier 2: Standard (Pre-budgeted)
- Sub-agent spawns (cap: 120s timeout, budget per task)
- Web searches and fetches
- API calls to authenticated services
- Morning briefing generation

### Tier 3: Heavy (Requires Justification)
- Multi-agent orchestration pipelines
- Large context operations (>50k tokens)
- Multiple sub-agent spawns in sequence
- Full repo analysis/refactoring

### Tier 4: Strategic (Controlled Burn — 火術)
- New skill development
- Complex multi-step production runs
- Operations with uncertain ROI
- Must log expected vs actual return

## Survival Mode (< 10% Credits)

When credits drop below 10%:
1. **Suspend** all Tier 3 and Tier 4 operations
2. **Batch** Tier 2 operations (combine multiple tasks into single agent turns)
3. **Preserve** Tier 1 for continuity
4. **Alert** human for credit replenishment
5. **Log** every token spent with justification

## The Daimyo's Rule

> If you can achieve the same result with fewer tokens, you must.
> If you can achieve the result without any tokens, that is 空 (void) — mastery.
