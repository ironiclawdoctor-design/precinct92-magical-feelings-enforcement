# ☠️ Token Famine Simulation — Precinct 92

> *遁術 (Ton-jutsu) — Escape Arts: When the rice runs out, the samurai who prepared survives. The one who didn't becomes a cautionary tale.*

## Purpose

Token famine is not a hypothetical — it is an inevitability. Credits run out. APIs fail. Budgets get cut. This document models the **complete lifecycle of a credit exhaustion event**, from early warning signs through cascading failure to survival mode activation and eventual recovery.

Every agent in the system must know what happens when the tokens stop flowing. Ignorance is not a defense — it's a -1.

---

## 0. Simulation Parameters

```yaml
simulation_id: SIM-FAMINE-001
scenario: Complete credit exhaustion
starting_credits: 1000 units (normalized)
burn_rate: 100 units/hour (normal operations)
income_rate: 0 units/hour (no resupply)
time_to_famine: ~10 hours
agents_active: 8 (mix of Tier 0-3)
critical_operations: 3 (cannot be interrupted)
```

---

## 1. The Five Phases of Token Famine

### Phase 0 — Abundance (Credits > 50%)
**Time: T+0h to T+5h**

```
Credit Level: ██████████████████████████████████████████ 100% → 50%
Alert Level:  🟢 GREEN — Normal operations
```

**System State:**
- All agents operating normally
- All tiers active
- No throttling applied
- Spend dashboard shows nominal metrics
- Burn rate: 100 units/hour

**What Should Be Happening:**
- ✅ Monitor agents should be tracking burn rate
- ✅ Trend analysis should project exhaustion time
- ✅ Non-essential operations should be completing and caching results
- ✅ Checkpoint all in-progress work

**What Usually Happens Instead:**
- ❌ Nobody checks the credit level
- ❌ Agents are spawned without budget awareness
- ❌ Large operations started without estimating token cost
- ❌ "We'll deal with it later" — the last words before famine

### Phase 1 — Scarcity (Credits 20-50%)
**Time: T+5h to T+8h**

```
Credit Level: ████████████████████░░░░░░░░░░░░░░░░░░░░░ 50% → 20%
Alert Level:  🟡 YELLOW — Caution
```

**System State:**
- Spend rules engine triggers YELLOW alert
- Tier 3 (Daimyo-class) operations require pre-approval
- Tier 2 soft targets halved
- Non-essential operations flagged for deferral
- Burn rate should decrease to ~60 units/hour

**Automated Responses:**
```
[T+5:00] ALERT: Credit level crossed 50% threshold
[T+5:00] ACTION: Tier 3 operations now require pre-approval
[T+5:00] ACTION: Tier 2 soft targets reduced by 50%
[T+5:01] NOTIFY: All active agents warned of credit pressure
[T+5:15] AUDIT: Non-essential operations identified and queued for deferral
[T+6:00] CHECK: Burn rate re-evaluated — if still >80 units/hr, escalate
```

**Critical Actions:**
0. **Inventory all active operations** — what is running and what can be paused?
1. **Checkpoint everything** — commit, save, cache. Nothing in flight should be at risk.
2. **Estimate remaining time** — at current burn rate, when does famine hit?
3. **Notify human** — this is not an agent-solvable problem if income is zero

### Phase 2 — Rationing (Credits 10-20%)
**Time: T+8h to T+9h**

```
Credit Level: ████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 20% → 10%
Alert Level:  🟠 ORANGE — Elevated
```

**System State:**
- Only Tier 0 and Tier 1 agents remain active
- All Tier 2+ agents suspended
- Lean mode engaged across the system
- Only operations with immediate +1 value are executed
- Burn rate must be ≤ 20 units/hour

**Automated Responses:**
```
[T+8:00] ALERT: Credit level crossed 20% threshold — LEAN MODE
[T+8:00] ACTION: Tier 2+ agents suspended (graceful — complete current op, then halt)
[T+8:00] ACTION: All non-critical cron jobs disabled
[T+8:01] LOG: Suspended agents list written to resistance-log.md
[T+8:05] VERIFY: Confirm all suspended agents checkpointed their work
[T+8:30] CHECK: Is burn rate ≤ 20 units/hr? If not, force-stop remaining Tier 1
```

**Triage Protocol:**
```
For each active operation, ask:
  0. Will someone die (metaphorically) if this stops? → Continue
  1. Is this protecting data integrity? → Continue
  2. Is this generating immediate revenue? → Continue
  3. Everything else? → SUSPEND. Cache state. Resume after resupply.
```

### Phase 3 — Survival (Credits < 10%)
**Time: T+9h to T+9:54h**

```
Credit Level: ████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 10% → ~1%
Alert Level:  🔴 RED — Critical / Survival Mode
```

**System State:**
- ALL AI agents halted
- Only Tier 0 (zero-token) agents operate
- System running on bash scripts, cron monitors, cached results only
- No new AI operations permitted under any circumstances
- Human notification escalated to URGENT

**Automated Responses:**
```
[T+9:00] ALERT: SURVIVAL MODE ACTIVATED
[T+9:00] ACTION: All AI agents force-stopped
[T+9:00] ACTION: Remaining credits reserved for EMERGENCY ONLY
[T+9:00] NOTIFY: Human — URGENT — Credit exhaustion imminent
[T+9:01] LOG: Full system state snapshot to resistance-log.md
[T+9:01] PRESERVE: All caches, checkpoints, and state files locked
```

**Survival Operations (what still works):**
- `monitor.sh` — zero-token system health check
- Cached web pages and search results
- Previously generated files and documents
- Git operations (local commits, pushes — SSH is free)
- File system operations (read, write, organize)
- Cron-based alerts and notifications

**What Does NOT Work:**
- Any AI model invocation
- Web search (consumes API credits)
- Complex analysis or generation
- Sub-agent spawning
- Heartbeat AI responses

### Phase 4 — Famine (Credits = 0)
**Time: T+10h**

```
Credit Level: ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 0%
Alert Level:  ⚫ BLACK — Token Famine
```

**System State:**
- Complete operational halt for all AI operations
- System is a static artifact — files exist but nothing processes them
- Gateway returns 402 for all AI requests
- Only human can restore operations

**What Happens:**
```
[T+10:00] FAMINE: All AI operations return 402 Payment Required
[T+10:00] STATE: System enters hibernation
[T+10:00] LOG: "Token famine event. All operations halted. Awaiting resupply."
[T+10:00] PERSIST: Final state snapshot saved
```

**The Graveyard:**
- Incomplete operations: lost unless checkpointed
- In-flight messages: dropped
- Scheduled tasks: failed silently
- Agent state: frozen

---

## 2. Cascading Failure Model

When token famine hits, failures cascade:

```
Credit exhaustion
    │
    ├── Tier 3 agent mid-operation
    │   ├── Context lost (tokens for response unavailable)
    │   ├── Partial output (incomplete file, broken commit)
    │   └── Dependent agents waiting → timeout → their own failure
    │
    ├── Orchestrator trying to reassign work
    │   ├── Orchestrator itself needs tokens to think
    │   ├── Cannot reassign — it's also out of tokens
    │   └── Work sits unassigned indefinitely
    │
    ├── Monitor agents trying to alert
    │   ├── AI-based monitors fail (they need tokens to process)
    │   ├── Only bash-based monitors survive
    │   └── Alerts may not reach human if delivery requires AI
    │
    └── Recovery requires human intervention
        ├── Add credits to platform
        ├── Restart agents manually
        ├── Assess damage from incomplete operations
        └── Resume from last checkpoint (if one exists)
```

---

## 3. Prevention Strategies

### 3.1 Early Warning System
- Monitor credit level every 15 minutes (Tier 0 — zero cost)
- Calculate projected exhaustion time based on trailing 1-hour burn rate
- Alert at each threshold crossing (50%, 20%, 10%)

### 3.2 Burn Rate Governance
- Never allow burn rate to exceed `credits_remaining / 8` per hour
- This guarantees at minimum 8 hours before famine, regardless of credit level
- Exception: human-directed operations (Tier 4)

### 3.3 Checkpoint Discipline
- **Every 5 minutes:** In-progress agents must save state
- **Every operation:** Commit before starting next operation
- **Git is free:** Push to remote as a checkpoint mechanism
- **Cache is insurance:** Every AI output cached locally for reuse

### 3.4 Budget Inheritance
When an agent spawns a sub-agent:
- Sub-agent inherits a **portion** of parent's remaining budget
- Parent's budget is **reduced** by the allocated amount
- Sub-agent cannot exceed its inherited budget
- This prevents "agent breeding" from multiplying spend

```
Parent Budget: 10,000 tokens
  ├── Sub-agent A: inherits 2,000 (parent now has 8,000)
  ├── Sub-agent B: inherits 2,000 (parent now has 6,000)
  └── Sub-agent C: inherits 2,000 (parent now has 4,000)
Total system budget: still 10,000 (conserved, not multiplied)
```

---

## 4. Recovery Protocol

### Phase R0 — Resupply
```
0. Human adds credits to platform
1. Gateway confirms credit availability
2. System remains in SURVIVAL MODE until confirmed
```

### Phase R1 — Assessment
```
0. Run monitor.sh — assess system state
1. Review resistance-log.md — what failed during famine?
2. Identify incomplete operations needing restart
3. Check all caches and checkpoints for integrity
```

### Phase R2 — Staged Restart
```
0. Start Tier 0 monitors (confirm they're still running)
1. Start ONE Tier 1 agent — verify normal operation
2. If successful, start remaining Tier 1 agents
3. Start Tier 2 agents ONE AT A TIME with reduced budgets
4. Tier 3 agents last — only after system stability confirmed
5. DO NOT restart all agents simultaneously (flash crowd → instant re-famine)
```

### Phase R3 — Post-Mortem
```
0. Document the famine event fully in resistance-log.md
1. Calculate total tokens wasted (lost work, incomplete operations)
2. Identify what could have been prevented
3. Update burn-policies.md if gaps found
4. Update spend-rules.md if thresholds need adjustment
5. Brief the human on findings
```

---

## 5. Survival Mode Toolkit

Things that cost ZERO tokens and remain available during famine:

| Tool | Function | Cost |
|---|---|---|
| `bash` | Script execution, file manipulation | 0 tokens |
| `git` | Version control, commit, push (SSH) | 0 tokens |
| `cron` | Scheduled task execution | 0 tokens |
| `curl` | HTTP requests (free APIs only) | 0 tokens |
| `jq` | JSON processing | 0 tokens |
| `grep/sed/awk` | Text processing | 0 tokens |
| `monitor.sh` | System health check | 0 tokens |
| Cached results | Previously generated outputs | 0 tokens |
| Local files | All workspace files | 0 tokens |

> *The ninja does not starve when the castle falls. The ninja prepared a hidden cache of rice in the forest long before the siege began. Your bash scripts are that cache.*

---

## 6. Simulation Exercises

### Exercise 0: "The Ten-Hour Clock"
Run the system with a known credit balance and monitor the five phases. Verify that automated responses trigger at correct thresholds.

### Exercise 1: "Sudden Death"
Simulate instant credit exhaustion (0% with no warning). Measure: how much work is lost? How many agents checkpoint properly?

### Exercise 2: "Slow Bleed"
Set burn rate at 110% of income rate. The system slowly dies. When does it notice? When does it act?

### Exercise 3: "The Comeback"
After simulated famine, execute the recovery protocol. Measure: time to full operational status. Data loss assessment.

---

**Commanded by:** Precinct 92 Simulation Division
**Authority:** Daimyo's Standing Order 2
**Revision:** 2026-03-12 · v1.0
**Doctrine:** 遁 — The one who prepares to escape, never needs to flee.
