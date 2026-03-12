# 🏯 Spend Rules Engine — Precinct 92

> *地 (Chi) — Earth: Know your baseline. These are the immovable laws of the precinct.*

## Purpose

Every token is a weapon. Every wasted token is a weapon dropped on the battlefield. The Spend Rules Engine defines **who may spend, how much, and under what authority.** No agent operates outside these walls.

---

## 0. Foundational Principle

**All spend is -1 until proven +1.**

Every token consumed is guilty until the output justifies the cost. The burden of proof is on the operation, not the enforcer. The Daimyo does not apologize for auditing.

---

## 1. Agent Classification & Token Budgets

Agents are classified by their operational tier. Each tier has a **hard ceiling** (cannot exceed) and a **soft target** (should not exceed without justification).

### Tier 0 — Kanja (間者) Shadow Agents
> *The cheapest agent is the one that consumes no tokens at all.*

| Parameter | Value |
|---|---|
| **Role** | Monitors, watchers, cron scripts, bash observers |
| **Token Budget (per invocation)** | 0 tokens (non-AI) |
| **Hard Ceiling (daily)** | 0 AI tokens; unlimited compute cycles |
| **Examples** | `monitor.sh`, cron health checks, file watchers |
| **Escalation Trigger** | N/A — these don't spend |

### Tier 1 — Ashigaru (足軽) Foot Soldiers
> *Light infantry. Get in, execute, get out.*

| Parameter | Value |
|---|---|
| **Role** | Single-purpose agents, formatters, validators, simple transforms |
| **Token Budget (per invocation)** | ≤ 2,000 tokens |
| **Hard Ceiling (daily)** | 50,000 tokens |
| **Soft Target (daily)** | 20,000 tokens |
| **Model Restriction** | Haiku-class or equivalent only |
| **Examples** | Lint checks, file reorganization, simple Q&A |
| **Escalation Trigger** | > 3 consecutive invocations without +1 output |

### Tier 2 — Samurai (侍) Warriors
> *Skilled operatives. They earn their spend.*

| Parameter | Value |
|---|---|
| **Role** | Multi-step agents, code generators, research agents, content creators |
| **Token Budget (per invocation)** | ≤ 15,000 tokens |
| **Hard Ceiling (daily)** | 300,000 tokens |
| **Soft Target (daily)** | 150,000 tokens |
| **Model Restriction** | Sonnet-class or equivalent |
| **Examples** | Skill builders, repo scaffolding, document synthesis |
| **Escalation Trigger** | > 5 invocations exceeding soft target without measurable output |

### Tier 3 — Daimyo (大名) Lords
> *Strategic operations. The heaviest weapons in the arsenal.*

| Parameter | Value |
|---|---|
| **Role** | Complex orchestration, deep analysis, multi-agent coordination, creative synthesis |
| **Token Budget (per invocation)** | ≤ 50,000 tokens |
| **Hard Ceiling (daily)** | 1,000,000 tokens |
| **Soft Target (daily)** | 500,000 tokens |
| **Model Restriction** | Opus-class permitted |
| **Examples** | Full project builds, strategic planning, orchestrated deployments |
| **Escalation Trigger** | Any single invocation > 30,000 tokens without pre-approval |

### Tier 4 — Shōgun (将軍) Supreme Command
> *Reserved for the human. No agent may claim this tier.*

| Parameter | Value |
|---|---|
| **Role** | Human-directed operations with no budget constraint |
| **Token Budget** | Unlimited (human judgment) |
| **Hard Ceiling** | Platform credit balance |
| **Escalation Trigger** | N/A — human is the final authority |

---

## 2. Escalation Thresholds

When an agent approaches or exceeds its budget, the following escalation cascade activates:

### Level 0 — Awareness (80% of soft target)
```
Action: Log warning to spend-dashboard
Visibility: Agent internal only
Response: Agent should self-optimize remaining budget
```

### Level 1 — Caution (100% of soft target)
```
Action: Log alert + notify orchestrator
Visibility: Orchestrator + metrics dashboard
Response: Agent must justify continued spend or enter lean mode
Lean Mode: Reduce output quality, skip non-essential operations
```

### Level 2 — Restriction (80% of hard ceiling)
```
Action: Throttle agent — insert delays between operations
Visibility: All system monitors
Response: 500ms delay injected per API call
         Agent must complete current task and halt new work
```

### Level 3 — Enforcement (100% of hard ceiling)
```
Action: Hard stop. Agent is killed.
Visibility: Resistance log entry created
Response: No further tokens allocated until next budget cycle
         Orchestrator reassigns incomplete work to lower-tier agent
```

### Level 4 — Breach (hard ceiling exceeded due to race condition)
```
Action: Post-mortem investigation
Visibility: Daimyo direct review
Response: Agent configuration audited
         Budget for next cycle reduced by 50%
         Root cause documented in resistance-log.md
```

---

## 3. Automatic Throttling Rules

### 3.1 Idle Decay
If an agent has been allocated budget but produces no +1 output for **10 consecutive minutes**, its remaining budget is reduced by 25% every 5 minutes until it either produces output or is terminated.

### 3.2 Failure Cascade Throttle
If an agent's last **3 operations** all resulted in errors or empty output:
- Immediately reduce remaining budget by 50%
- Insert 2-second delay between operations
- Log to resistance-log.md as internal failure event

### 3.3 Foreign Resistance Throttle
When an external API returns rate-limit (429) or auth failure (401/403):
- **First occurrence:** Log, apply Path B (水術 — find alternate route)
- **Second occurrence (same endpoint):** Back off exponentially (2s, 4s, 8s, 16s...)
- **Third occurrence:** Abandon this path entirely. Mark endpoint as hostile in resistance log.
- **Never retry the same failed approach more than twice.** (Daimyo's Order 3)

### 3.4 Credit-Level Throttling
System-wide throttling based on remaining platform credits:

| Credit Level | System Response |
|---|---|
| **> 50%** | 🟢 Normal operations. All tiers active. |
| **20-50%** | 🟡 Caution. Tier 3 requires pre-approval. Tier 2 soft targets halved. |
| **10-20%** | 🟠 Lean mode. Only Tier 0-1 agents active. Tier 2+ suspended. |
| **< 10%** | 🔴 Survival mode. Only Tier 0 (zero-token) agents operate. All AI agents halted. |
| **0%** | ⚫ Token famine. All halt. Await resupply. |

---

## 4. Budget Cycle

### Daily Reset
- Budgets reset at **00:00 UTC** each day
- Unspent budget does **not** roll over (use it or lose it — but don't waste it)
- Overspend from previous day is **deducted** from next day's allocation

### Weekly Review
- Every 7 days: audit all agents against their tier budgets
- Agents consistently under soft target → eligible for tier promotion
- Agents consistently over soft target → flagged for tier demotion or optimization

### Monthly Reconciliation
- Compare total -1 spend against total +1 production
- If efficiency ratio < 2:1 → mandatory system-wide optimization sprint
- If efficiency ratio > 5:1 → Daimyo commendation. Budget may be increased.

---

## 5. Exemptions

### 5.1 Controlled Burns (火術)
Pre-approved strategic spend that exceeds normal budgets. Must be logged in `burn-policies.md` with:
- Expected ROI
- Maximum burn amount
- Success criteria
- Actual outcome (post-burn)

### 5.2 Emergency Operations
When system integrity is threatened (data loss, security breach, critical failure):
- All budget limits temporarily suspended
- Emergency flag set in metrics dashboard
- Post-incident audit mandatory within 24 hours

### 5.3 Human Override
The Shōgun (human) may override any budget rule at any time. This is the one power no agent may question. Log it, don't fight it.

---

## 6. Enforcement Mechanisms

```
┌─────────────────────────────────────────────┐
│           SPEND RULES ENGINE                │
│                                             │
│  Agent Request ──→ [Budget Check]           │
│                        │                    │
│                  ┌─────┴─────┐              │
│                  │ Within    │ Over         │
│                  │ budget?   │ budget?      │
│                  ▼           ▼              │
│              APPROVE     [Escalation]       │
│                              │              │
│                    ┌─────────┴────────┐     │
│                    │ Which level?     │     │
│                    ▼    ▼    ▼    ▼   │     │
│                   L0   L1   L2   L3  L4    │
│                   log  alert throttle kill  │
│                                  review    │
│                                             │
│  All events ──→ spend-dashboard.md          │
│  Violations ──→ resistance-log.md           │
└─────────────────────────────────────────────┘
```

---

## 7. Path B Mandate

Every rule in this document must have a Path B. If an agent cannot operate within its budget, **it does not fight the constraint — it reframes the problem.**

- Can't afford Opus? Use Sonnet.
- Can't afford Sonnet? Use Haiku.
- Can't afford Haiku? Use a bash script.
- Can't afford compute? Use a cached result.
- Can't afford anything? **The operation wasn't necessary.**

This is 空 (Kū) — the Void. The operation that never needed to happen is the cheapest operation of all.

---

**Enforced by:** Precinct 92 Spend Rules Engine
**Authority:** Daimyo's Standing Orders 0-5
**Revision:** 2026-03-12 · v1.0
**Doctrine:** 忍 — Endure. Conceal. Enforce.
