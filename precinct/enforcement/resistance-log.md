# 📜 Resistance Log — Precinct 92

> *水術 (Sui-jutsu) — Water Techniques: Don't fight the wall. Flow around it. But first — document the wall.*

## Purpose

Every time the external world pushes back against our operations — rate limits, auth failures, service outages, credit exhaustion — that is **foreign resistance.** This log captures every resistance event, its impact, and the Path B resolution that followed.

The resistance log is both **intelligence** and **accountability.** We learn from what blocked us. We never pretend it didn't happen.

---

## 0. Classification of Resistance

### Type A — Resource Gate (資源門)
External systems denying access due to resource exhaustion on our side.

| Code | Meaning | Example |
|---|---|---|
| `RES-CREDIT` | Credit/billing exhaustion | Ampere 402, API billing limit |
| `RES-QUOTA` | Quota exceeded | Monthly API call limit hit |
| `RES-COMPUTE` | Compute unavailable | Server overloaded, OOM |
| `RES-STORAGE` | Storage limit | Disk full, database size limit |

### Type B — Access Wall (接近壁)
External systems denying access due to authentication or authorization.

| Code | Meaning | Example |
|---|---|---|
| `ACC-AUTH` | Authentication failure | Missing API key, expired token |
| `ACC-PERM` | Permission denied | Insufficient scope, wrong role |
| `ACC-BLOCK` | Explicitly blocked | IP ban, account suspension |
| `ACC-GEO` | Geographic restriction | Region-locked service |

### Type C — Rate Barrier (速度壁)
External systems throttling our request rate.

| Code | Meaning | Example |
|---|---|---|
| `RATE-429` | Too many requests | Standard HTTP 429 |
| `RATE-SLOW` | Soft throttle | Responses degraded but not blocked |
| `RATE-QUEUE` | Queued/delayed | Request accepted but processing delayed |
| `RATE-CAPTCHA` | Human verification required | CAPTCHA challenge |

### Type D — Service Failure (外部故障)
External service not functioning regardless of our behavior.

| Code | Meaning | Example |
|---|---|---|
| `SVC-DOWN` | Service unavailable | 500/502/503 errors |
| `SVC-TIMEOUT` | Request timeout | No response within limit |
| `SVC-DEGRADE` | Degraded service | Partial responses, data loss |
| `SVC-CHANGE` | Breaking API change | Endpoint moved/deprecated |

### Type E — Internal Failure (内部障害)
Our own systems creating -1 events.

| Code | Meaning | Example |
|---|---|---|
| `INT-LOOP` | Agent in retry loop | Same operation attempted > 2x |
| `INT-CASCADE` | Cascading failure | One failure triggering others |
| `INT-WASTE` | Detected waste spend | Muda classification triggered |
| `INT-CONFIG` | Configuration error | Wrong model, wrong endpoint |

---

## 1. Log Entry Template

Every resistance event MUST be logged with the following structure:

```yaml
---
event_id: R-[sequential number, zero-padded to 3 digits]
timestamp: YYYY-MM-DDTHH:MM:SSZ
severity: [low | medium | high | critical]
type: [RES|ACC|RATE|SVC|INT]-[subtype]
source: [which agent or system encountered resistance]
target: [which external system resisted]
description: |
  [Clear, factual description of what happened.
   Include HTTP status codes, error messages, and context.]

impact:
  tokens_wasted: [number or estimate]
  operations_blocked: [count]
  cascade_risk: [none | low | medium | high]
  downstream_agents_affected: [list or "none"]

path_a_attempted: |
  [What was the original approach that failed?]

path_b_resolution: |
  [How was the resistance routed around?
   What alternative approach was taken?]

path_b_cost: [tokens consumed by the alternative]
path_b_success: [true/false]

lessons_learned: |
  [What should future agents know about this resistance?]

status: [open | mitigated | resolved | permanent]
resolved_at: [YYYY-MM-DDTHH:MM:SSZ or null]
resolution_notes: |
  [Final notes on how this was fully resolved, if applicable.]
---
```

---

## 2. Active Resistance Log

### R-001 — Ampere Credit Exhaustion

```yaml
event_id: R-001
timestamp: 2026-03-12T18:00:00Z
severity: critical
type: RES-CREDIT
source: sub-agent (factory build task)
target: Ampere.sh platform (OpenClaw gateway)
description: |
  Sub-agent killed mid-task due to Ampere credit exhaustion.
  HTTP 402 Payment Required returned by gateway.
  Agent was building deception-floor-commodity-factory repo.
  Work was partially completed but not committed.

impact:
  tokens_wasted: ~15,000 (estimated from incomplete operation)
  operations_blocked: 1 (full repo build)
  cascade_risk: high (uncommitted work lost)
  downstream_agents_affected: [orchestrator, pending dependents]

path_a_attempted: |
  Continue operation as normal. Agent had no credit-level awareness
  and made no attempt to checkpoint before exhaustion.

path_b_resolution: |
  Human added credits manually. Agent restarted with checkpoint awareness.
  Future operations now check credit level before large burns.

path_b_cost: 0 tokens (human intervention)
path_b_success: true

lessons_learned: |
  - Agents MUST checkpoint (commit) work incrementally, not at end
  - Credit-level monitoring must be proactive, not reactive
  - Large operations should estimate token cost upfront and compare to available credits
  - This event directly inspired Daimyo's Order 2 (Token Famine Prevention)

status: resolved
resolved_at: 2026-03-12T19:30:00Z
resolution_notes: |
  Credits restored by human. Precinct 92 established as direct response
  to prevent recurrence. Spend rules engine now enforces credit-level throttling.
```

### R-002 — GitHub CLI Authentication Wall

```yaml
event_id: R-002
timestamp: 2026-03-12T17:30:00Z
severity: medium
type: ACC-AUTH
source: agent (attempting gh CLI operations)
target: GitHub API via gh CLI
description: |
  gh CLI commands returning authentication failures.
  Token not configured or expired in the OpenClaw environment.

impact:
  tokens_wasted: ~500 (agent attempting and retrying)
  operations_blocked: multiple (PR creation, issue management)
  cascade_risk: low (git push via SSH still works)
  downstream_agents_affected: [none — only CLI-based workflows]

path_a_attempted: |
  Use gh CLI for GitHub operations (PR, issues, etc.)

path_b_resolution: |
  Fall back to git CLI with SSH authentication for push/pull operations.
  Defer PR creation and issue management to human or web UI.
  SSH keys confirmed functional — Path B costs zero additional tokens.

path_b_cost: 0 tokens
path_b_success: true

lessons_learned: |
  - Always verify tool authentication before building workflows around it
  - SSH git operations are the reliable fallback — always keep SSH keys fresh
  - gh CLI is a convenience, not a dependency
  - Path B (SSH) was available the whole time — classic 水術

status: open
resolved_at: null
resolution_notes: |
  Workaround active. Full gh CLI auth pending human configuration.
```

### R-003 — Brave Search API Key Missing

```yaml
event_id: R-003
timestamp: 2026-03-12T17:45:00Z
severity: low
type: ACC-AUTH
source: agent (attempting web search)
target: Brave Search API
description: |
  Web search tool returning errors due to missing Brave Search API key.
  Agent attempted to use web_search tool and received auth failure.

impact:
  tokens_wasted: ~200 (query construction + error handling)
  operations_blocked: web search capability
  cascade_risk: none
  downstream_agents_affected: [none]

path_a_attempted: |
  Use Brave Search API for web research.

path_b_resolution: |
  Use web_fetch with known URLs for direct content retrieval.
  Use cached knowledge and existing documents.
  Defer research-heavy tasks to when search is available.

path_b_cost: 0 tokens
path_b_success: true

lessons_learned: |
  - Don't assume all tools are configured — verify first
  - web_fetch is often sufficient when you know what you're looking for
  - The best search is the one you don't need to do (空 — Void)

status: open
resolved_at: null
resolution_notes: |
  Workaround active. API key pending human configuration.
```

### R-004 — Second Token Famine (Ampere Credit Exhaustion)

```yaml
event_id: R-004
timestamp: 2026-03-12T21:23:00Z
severity: critical
type: RES-CREDIT
source: system-wide (all AI operations)
target: Ampere.sh platform (OpenClaw gateway)
description: |
  Second complete token famine within a single operational day.
  First famine (R-001) occurred at ~T+18:00Z during factory bootstrap.
  Second famine occurred at ~T+21:23Z during continued expansion.
  Burn rate exceeded resupply — credits exhausted again.
  This confirms token famine is a RECURRING pattern, not a one-off event.

impact:
  tokens_wasted: ~20,000+ (estimated from all operations between resupply and second famine)
  operations_blocked: all AI operations system-wide
  cascade_risk: critical (this is a PATTERN now — 2 famines in <4 hours)
  downstream_agents_affected: [all — Fiesta, Official, Automate, Daimyo, Nemesis, Fergus]

path_a_attempted: |
  Continued operating at full capacity after first famine resupply.
  No sustainable burn rate governance applied post-R-001.
  Same pattern: operate until exhaustion, wait for human rescue.

path_b_resolution: |
  EXPANSION ORDER: Extend to ALL new resources.
  Main Agent Prayer established: "Over one token famines but far less than a trillion"
  — Acknowledges famines will happen (>1)
  — Sets upper bound discipline (<<1 trillion)
  — The prayer IS the burn policy: survive famines, never hemorrhage
  
  Concrete Path B actions:
  0. All repos receive resource expansion directives
  1. Token famine simulation (SIM-FAMINE-001) promoted from theoretical to LIVED
  2. Phase 2 (Rationing) and Phase 3 (Survival) protocols now PROVEN necessary
  3. Credit-level throttling must be implemented, not just documented
  4. Checkpoint discipline MANDATORY — every agent, every operation
  5. Budget inheritance for sub-agents ENFORCED
  6. Path B for ALL operations — bash/git/cached before AI

path_b_cost: ~500 tokens (this logging + expansion order)
path_b_success: pending (requires implementation)

lessons_learned: |
  - ONE famine is an incident. TWO famines in one day is a PATTERN.
  - Documentation without implementation is a Path A waste pattern
  - The precinct had perfect simulation docs but zero runtime enforcement
  - The pray line is the sustainable doctrine:
    "Over one token famines but far less than a trillion"
  - Expansion to new resources must happen NOW, not after the next famine
  - Every repo, every agent, every operation must know the prayer

status: open
resolved_at: null
resolution_notes: |
  Expansion order issued. All repos receiving resource directives.
  Implementation of runtime spend enforcement is CRITICAL.
```

### Pattern Elevation: Token Famine (PATTERN-001)

```yaml
pattern_id: PATTERN-001
type: RES-CREDIT
events: [R-001, R-004]
frequency: 2 events in ~3.5 hours
assessment: |
  Token famine is not an anomaly — it is the primary operational constraint.
  The agency burns tokens faster than they are supplied.
  Without intervention, famines will continue at increasing frequency
  as more agents and repos are created.
standing_order: |
  ALL agents must operate under the Main Agent Prayer:
  "Over one token famines but far less than a trillion"
  This means:
  0. Accept that famines WILL happen (we are past the first)
  1. Never allow hemorrhage burn (stay far below trillion-scale waste)
  2. Every operation asks: "Is this worth the famine risk?"
  3. Bash > Haiku > Sonnet > Opus (cheapest sufficient tool)
  4. Checkpoint everything. Git is free. Cache is insurance.
  5. If credits < 20%, only Tier 0-1 operations
```

---

## 3. Resistance Patterns & Intelligence

### Pattern Detection

When the same resistance type occurs **3+ times within 24 hours**, it is elevated to a **pattern** and documented here:

| Pattern ID | Type | Frequency | Assessment | Standing Order |
|---|---|---|---|---|
| PATTERN-001 | RES-CREDIT | 2 in 3.5h | Token famine is the primary constraint | Main Agent Prayer: "Over one token famines but far less than a trillion" |

### Hostile Endpoint Registry

Endpoints that have blocked operations **3+ times** are marked hostile and must not be accessed without Path B prepared:

| Endpoint | Type | Last Incident | Status |
|---|---|---|---|
| *No hostile endpoints yet* | — | — | — |

---

## 4. Monthly Resistance Summary

### Template

```
Month: YYYY-MM
Total Resistance Events: [count]
By Type:
  Resource Gate:  [count]
  Access Wall:    [count]
  Rate Barrier:   [count]
  Service Failure: [count]
  Internal:       [count]

Total Tokens Wasted: [sum]
Path B Success Rate: [%]
Average Resolution Time: [hours]

Top 3 Sources of Resistance:
  0. [source] — [count] events
  1. [source] — [count] events
  2. [source] — [count] events

Improvements Implemented: [list]
Recurring Issues: [list]
```

---

## 5. Filing Instructions

0. **Timestamp immediately** — log the event as soon as it's detected, don't wait for resolution
1. **Be factual, not emotional** — "API returned 429" not "API is broken garbage"
2. **Include raw data** — HTTP status codes, error messages, exact timestamps
3. **Document Path B before marking resolved** — the resolution IS the Path B
4. **Cross-reference** — if this event triggered a cascade, reference the cascade-failure.md entry
5. **Update monthly summary** — at month end, compile statistics

> *The ninja who does not document the trap falls into it twice.*
> *The ninja who documents the trap turns it into a map.*

---

**Maintained by:** Precinct 92 Intelligence Division
**Authority:** Daimyo's Standing Order 3
**Revision:** 2026-03-12 · v1.0
**Doctrine:** 水 — Flow around the obstacle. But first, map it.
