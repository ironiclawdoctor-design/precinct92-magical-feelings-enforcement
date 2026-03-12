# 🔥 Burn Policies — Precinct 92

> *火術 (Ka-jutsu) — Fire Techniques: Not all -1 is bad. But every flame must be controlled.*

## Purpose

A controlled burn clears dead wood and makes room for new growth. An uncontrolled burn destroys the forest. This document defines **when spend is acceptable, when it is waste, and how to tell the difference.**

---

## 0. The Burn Paradox

To produce +1, you must spend -1. This is the inescapable cost of creation. The Daimyo does not seek to eliminate all spend — that would eliminate all production. The Daimyo seeks to **maximize the ratio of value produced to tokens consumed.**

> *The sword costs steel to forge. The steel is not wasted — it becomes the blade. But the shavings on the floor? Those are waste.*

---

## 1. Burn Classification

### 1.1 Controlled Burn (火術 — Ka-jutsu)
**Definition:** Planned, pre-approved spend with defined ROI expectations.

```
Characteristics:
  ✅ Budget allocated before work begins
  ✅ Success criteria defined
  ✅ Maximum burn amount capped
  ✅ Outcome measured against expectations
  ✅ Logged in burn ledger
```

**Examples:**
- Building a new skill package (invest tokens now, save tokens forever)
- Training a new agent workflow (spend once, reuse infinitely)
- Repository bootstrapping (one-time creation cost)
- Deep research for strategic decisions (information has compound value)

### 1.2 Operational Burn (日常 — Nichijō)
**Definition:** Routine token consumption that is the cost of doing business.

```
Characteristics:
  ✅ Within established budget tiers
  ✅ Produces expected output
  ✅ No special approval needed
  ✅ Tracked automatically by spend rules engine
```

**Examples:**
- Responding to user queries
- Running scheduled health checks
- Processing incoming messages
- Routine file operations with AI assistance

### 1.3 Waste Burn (無駄 — Muda)
**Definition:** Token consumption that produces no value or produces value that was already available.

```
Characteristics:
  ❌ Recomputing what was already computed
  ❌ Retrying failed approaches without modification
  ❌ Using a Tier 3 agent for a Tier 0 task
  ❌ Generating output that is immediately discarded
  ❌ Running AI where a bash script would suffice
```

**Examples:**
- Asking an AI to format JSON when `jq` exists
- Retrying a rate-limited API without backing off
- Regenerating a file that already exists unchanged
- Using Opus for a task Haiku could handle
- Polling in a loop instead of using push-based completion

### 1.4 Hemorrhage Burn (出血 — Shukketsu)
**Definition:** Uncontrolled, escalating spend with no mechanism to stop it.

```
Characteristics:
  🚨 No budget ceiling applied
  🚨 No success criteria defined
  🚨 Agent in a retry loop
  🚨 Cascading failures consuming tokens
  🚨 External resistance being fought instead of routed around
```

**Examples:**
- Agent retrying a dead API endpoint indefinitely
- Sub-agent spawning sub-agents without budget inheritance
- Infinite conversation loops between agents
- Fighting an authentication wall instead of finding Path B

---

## 2. The Decision Tree

When evaluating whether spend is acceptable, walk this tree:

```
START: Agent requests token spend
  │
  ├── Q0: Can this be done with ZERO tokens?
  │     YES → Do it with zero tokens. 空 (Void). Done.
  │     NO  → Continue.
  │
  ├── Q1: Has this exact computation been done before?
  │     YES → Use the cached result. 隠 (Concealment). Done.
  │     NO  → Continue.
  │
  ├── Q2: Can a LOWER-TIER agent handle this?
  │     YES → Delegate down. 変 (Adaptation). Continue from Q0 at lower tier.
  │     NO  → Continue.
  │
  ├── Q3: Is there a CLEAR +1 outcome expected?
  │     NO  → DENY. This is speculative waste. Log as Muda.
  │     YES → Continue.
  │
  ├── Q4: Is the expected +1 worth MORE than the -1 cost?
  │     NO  → DENY. Negative ROI. Log as Muda.
  │     YES → Continue.
  │
  ├── Q5: Is the agent WITHIN its budget tier?
  │     NO  → Requires escalation approval (see spend-rules.md).
  │     YES → Continue.
  │
  ├── Q6: Is this a FIRST attempt or a RETRY?
  │     RETRY → Was the approach modified? 
  │              NO  → DENY. Same approach twice = waste (Order 3).
  │              YES → APPROVE with caution flag.
  │     FIRST → APPROVE.
  │
  └── APPROVED: Execute, measure, log.
```

---

## 3. ROI Requirements

### 3.1 Minimum ROI by Burn Type

| Burn Type | Minimum ROI | Measurement Window |
|---|---|---|
| **Controlled Burn** | 3:1 (3 tokens of value per 1 spent) | 30 days |
| **Operational Burn** | 1:1 (break even) | Per invocation |
| **Training Burn** | 5:1 (must pay for itself 5x) | 90 days |
| **Emergency Burn** | N/A (measured post-hoc) | 7 days post-incident |

### 3.2 How to Measure ROI

**Direct Value:**
- Tokens saved by future cache hits from this computation
- Revenue generated from the output
- Human time saved (valued at equivalent token cost)

**Indirect Value:**
- Knowledge gained that prevents future -1 events
- Capability built that reduces future per-operation cost
- Infrastructure created that serves multiple future operations

**Anti-Value (these count as -1):**
- Output that requires human correction
- Output that another agent must redo
- Output that is never used
- Context tokens wasted on failed approaches

### 3.3 The Compound Value Test

A burn passes the compound value test if:

```python
def compound_value_test(burn):
    """A burn is justified if its output serves more than one purpose."""
    uses = count_future_uses(burn.output)
    if uses > 1:
        effective_cost = burn.tokens / uses
        return effective_cost < burn.value_per_use
    else:
        return burn.value > burn.tokens * 3  # Single-use requires 3x ROI
```

---

## 4. Controlled Burn Protocol

### 4.1 Pre-Approval Process

Before executing a controlled burn, the requesting agent must file:

```yaml
# Burn Request
burn_id: BURN-YYYY-MM-DD-NNN
requesting_agent: [agent name]
agent_tier: [0-4]
description: [what will be done]
expected_output: [specific deliverable]
token_estimate: [estimated tokens]
max_token_cap: [absolute maximum, will hard-stop if reached]
expected_roi: [X:1 ratio with justification]
success_criteria:
  - [measurable criterion 0]
  - [measurable criterion 1]
alternatives_considered:
  - [Path B option 0 — why rejected]
  - [Path B option 1 — why rejected]
approval: [pending/approved/denied]
approved_by: [orchestrator/daimyo/human]
```

### 4.2 During Burn

- **Checkpoint every 25%** of token budget consumed
- At each checkpoint: evaluate progress against success criteria
- If progress < 50% at the 50% budget checkpoint → escalate for review
- If progress < 25% at the 50% budget checkpoint → abort

### 4.3 Post-Burn Audit

Within 24 hours of burn completion:

```yaml
# Burn Report
burn_id: BURN-YYYY-MM-DD-NNN
actual_tokens: [tokens consumed]
success_criteria_met:
  - criterion_0: [yes/no + evidence]
  - criterion_1: [yes/no + evidence]
actual_roi: [calculated X:1]
variance: [% over/under estimate]
lessons_learned: [what to do differently]
reusable_outputs: [list of outputs that serve future operations]
classification: [controlled/operational/waste — honest assessment]
```

---

## 5. The Seven Wastes (七つの無駄)

Adapted from Toyota Production System's Seven Wastes for the agent economy:

| # | Waste | Agent Economy Equivalent | Prevention |
|---|---|---|---|
| 0 | **Overproduction** | Generating output nobody asked for | Only produce what's requested |
| 1 | **Waiting** | Agent idle while consuming heartbeat tokens | Use push-based, not poll-based |
| 2 | **Transport** | Passing data between agents unnecessarily | Direct routing, no intermediaries |
| 3 | **Over-processing** | Using Opus when Haiku suffices | Enforce tier-appropriate model selection |
| 4 | **Inventory** | Cached results never used | TTL on all caches, prune regularly |
| 5 | **Motion** | Redundant API calls for same data | Cache aggressively, batch requests |
| 6 | **Defects** | Output that requires rework | Validate before delivery, not after |

---

## 6. Emergency Burns

When system integrity is at stake, normal burn policies are suspended:

### Conditions for Emergency Burn
- Data loss imminent
- Security breach detected
- Critical infrastructure failing
- Human explicitly orders immediate action

### Emergency Burn Rules
0. **No pre-approval required** — act immediately
1. **Log everything** — more detail than normal, not less
2. **Minimum necessary force** — use the cheapest solution that works
3. **Post-incident audit within 24 hours** — every token accounted for
4. **Cannot be used retroactively** — you can't declare something an emergency after the fact to justify waste

---

## 7. The Void Principle (空の原則)

The ultimate burn policy: **the best burn is the one that never happens.**

Before any token is spent, ask:
- Does this output already exist somewhere?
- Can this be derived from existing outputs?
- Will anyone use this output?
- Is the human actually waiting for this?
- Would doing nothing be acceptable?

If the answer to any of these is "yes, doing nothing works" — then do nothing. The Void is not laziness. The Void is mastery. The operation that produces +1 without any -1 is the highest achievement in the precinct.

> *The master swordsman wins without drawing the blade.*
> *The master agent produces without burning tokens.*
> *This is 空 — the Void.*

---

**Enforced by:** Precinct 92 Burn Policy Division
**Authority:** Daimyo's Standing Order 4
**Revision:** 2026-03-12 · v1.0
**Doctrine:** 火 — Burn with purpose, never with abandon.
