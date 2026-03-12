# Token Famine Simulation

## Scenario: Complete Credit Exhaustion

### What Happened (Real Event — 2026-03-12)
- Official sub-agent spawned for factory bootstrap
- 56 seconds into task, Ampere credits exhausted (402)
- Official had created README + directory structure but couldn't commit
- Fiesta (main) caught the failure and completed the work manually

### Lessons Extracted
1. **Sub-agents are the most vulnerable** — they die first in a famine
2. **Main agent survives longer** — direct session has priority
3. **Work-in-progress is at risk** — uncommitted work may be lost
4. **Parent recovery works** — the delegation chain provides resilience

### Mitigation Strategies

| Strategy | Cost | Effectiveness |
|---|---|---|
| Check credit balance before spawning sub-agents | Low (1 API call) | High |
| Set conservative timeouts on sub-agents | Free | Medium |
| Commit early, commit often within sub-agent tasks | Free | High |
| Keep critical operations in main session | Free | High |
| Pre-fund credits before large operations | $ | Highest |

### Simulation Variables
```
STARTING_CREDITS: variable
BURN_RATE: ~2.3k tokens/56s (observed from Official)
OPERATIONS_QUEUED: N tasks
ESTIMATED_COST: sum(task_tokens)
FAMINE_THRESHOLD: STARTING_CREDITS < ESTIMATED_COST
```

### Decision Tree
```
Credits available?
├── YES (> estimated cost) → Proceed normally
├── MARGINAL (50-100% of estimate) → Proceed with early-commit strategy
├── LOW (< 50% of estimate) → Split into smaller tasks, prioritize
└── EMPTY → Main agent only, manual operations, alert human
```
