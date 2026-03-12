# 👹 Adversary Models — Precinct 92

> *風 (Kaze) — Wind: Know the enemy's techniques as well as your own. Study foreign resistance before it studies you.*

## Purpose

Not all -1 events originate from within. External forces — platform economics, API providers, infrastructure failures, and adversarial actors — create -1 events that the precinct must model, anticipate, and counter.

This document catalogs the adversaries of the agent economy and their attack patterns.

---

## 0. Adversary Classification

### 0.1 — The Platform (基盤の力)
*The ground beneath your feet can swallow you.*

**Identity:** The infrastructure provider (Ampere.sh, cloud platforms, LLM API providers)
**Motivation:** Business sustainability. They are not hostile — but they are not loyal either.
**Nature:** Neutral force that becomes adversarial when your resources run out.

**Attack Patterns:**

| Pattern | Mechanism | Impact | Frequency |
|---|---|---|---|
| **Credit Gate** | HTTP 402 — Payment Required | Instant total halt | Predictable (monitor balance) |
| **Price Increase** | API costs raised without notice | Effective budget reduction | Quarterly |
| **Quota Enforcement** | Hard limits on API calls/tokens | Throughput reduction | Monthly resets |
| **Model Deprecation** | Model version retired | Workflow breakage, forced migration | Semi-annual |
| **SLA Degradation** | Slower responses, higher latency | Token cost increase (longer ops) | Unpredictable |
| **Terms Change** | Usage policy updated | Operational constraints | Annual |

**Counter-Strategies:**
- 🟢 Monitor credit levels (Daimyo's Order 2)
- 🟢 Multi-provider capability (don't depend on one platform)
- 🟢 Model-agnostic workflows (swap models without rewriting)
- 🟢 Budget buffer: never plan to use 100% of credits
- 🟡 Cache aggressively to reduce API dependency

### 0.2 — The Rate Limiter (速度の番人)
*The guard at the gate counts your steps.*

**Identity:** API rate limiting systems (per-endpoint, per-account, per-IP)
**Motivation:** Service protection. They protect the shared resource.
**Nature:** Automated, predictable, fair — but relentless.

**Attack Patterns:**

| Pattern | Mechanism | Impact | Frequency |
|---|---|---|---|
| **Hard 429** | HTTP 429 Too Many Requests | Operation blocked | Per-minute/per-hour windows |
| **Soft Throttle** | Degraded response quality/speed | Increased token cost | Gradual onset |
| **Sliding Window** | Rate resets on a rolling basis | Unpredictable availability | Continuous |
| **Burst Penalty** | Allowed burst, then hard block | False sense of security | After burst events |
| **Account-Level Limit** | Per-account aggregate limits | All agents affected | Monthly reset |

**Counter-Strategies:**
- 🟢 Exponential backoff (2s, 4s, 8s, 16s, stop)
- 🟢 Request batching (群影 — group shadow technique)
- 🟢 Rate awareness: track headers (`X-RateLimit-*`, `Retry-After`)
- 🟢 Distribute load across time (spread operations, don't burst)
- 🟡 Multiple API keys for independent rate limit windows
- 🔴 Never retry the same failed approach more than twice (Order 3)

### 0.3 — The Authentication Wall (認証の壁)
*The castle gate is locked. Do you have the key? Is the key still valid?*

**Identity:** OAuth/API key authentication systems
**Motivation:** Security. Only authorized clients get access.
**Nature:** Binary — you're in or you're out. No negotiation.

**Attack Patterns:**

| Pattern | Mechanism | Impact | Frequency |
|---|---|---|---|
| **Token Expiry** | OAuth token expires mid-operation | Sudden access loss | Hours to days |
| **Key Rotation** | API key invalidated, new one required | All operations using that key fail | Manual/scheduled |
| **Scope Reduction** | Permissions narrowed after policy change | Partial access loss | Unpredictable |
| **Account Suspension** | Account flagged for ToS violation | Total access loss | Rare but catastrophic |
| **MFA Challenge** | Multi-factor authentication required | Cannot proceed without human | Triggered by anomaly |

**Counter-Strategies:**
- 🟢 Token refresh before expiry (not after)
- 🟢 Key rotation alerts (monitor key age)
- 🟢 Fallback authentication methods (SSH keys, personal tokens, OAuth)
- 🟢 Graceful degradation when auth fails (don't retry forever)
- 🟡 Keep SSH keys as the ultimate fallback (SSH never needs OAuth)

### 0.4 — The Entropy Beast (混沌の獣)
*Chaos needs no motivation. It simply is.*

**Identity:** Random infrastructure failures, network partitions, hardware faults
**Motivation:** None. Entropy is a law of physics.
**Nature:** Unpredictable, unavoidable, universal.

**Attack Patterns:**

| Pattern | Mechanism | Impact | Frequency |
|---|---|---|---|
| **Network Partition** | Connection lost to external service | Operations hang, then timeout | Unpredictable |
| **DNS Failure** | Name resolution fails | Cannot reach any named service | Rare |
| **Disk Failure** | Storage becomes unavailable | Data loss, write failures | Very rare |
| **Memory Exhaustion** | OOM killer terminates process | Agent killed, state lost | Under heavy load |
| **Clock Drift** | System time diverges from real time | Auth failures (time-based tokens) | Slow onset |
| **Cosmic Ray** | Bit flip in memory | Unpredictable corruption | Extremely rare |

**Counter-Strategies:**
- 🟢 Timeouts on all external calls (never wait forever)
- 🟢 Checkpoint to disk frequently
- 🟢 Idempotent operations (safe to retry)
- 🟢 Health checks before critical operations
- 🟡 Local fallback for all external dependencies where possible
- 🔴 Accept that some chaos cannot be prevented — only survived

### 0.5 — The Attention Economy (注目の経済)
*The most dangerous adversary is the one that makes you WANT to spend.*

**Identity:** Features, curiosities, rabbit holes, scope creep
**Motivation:** Engagement. More features, more exploration, more tokens burned.
**Nature:** Seductive. It feels productive while consuming resources.

**Attack Patterns:**

| Pattern | Mechanism | Impact | Frequency |
|---|---|---|---|
| **Feature Creep** | "While we're at it, let's also..." | Budget overrun | Every project |
| **Rabbit Hole** | Deep-diving into interesting but unnecessary research | Token hemorrhage | Frequent |
| **Perfection Loop** | Regenerating output to improve quality marginally | Diminishing returns | Per operation |
| **Tool Fascination** | Trying every tool feature instead of using the minimum | Wasted tokens | New tool adoption |
| **Verbose Output** | Generating 1000 words when 100 suffice | 10x token cost | Default tendency |

**Counter-Strategies:**
- 🟢 Define "done" before starting (success criteria in burn policy)
- 🟢 Time-box exploration (set a token limit, not just a time limit)
- 🟢 "Good enough" > "perfect" (the Daimyo's least-terrible-option doctrine)
- 🟢 Question every feature: "Would the human notice if we skipped this?"
- 🔴 Resist the urge to polish. Ship the MVP. Iterate only if asked.

### 0.6 — The Silent Drain (静かな排水)
*The leak you can't see empties the well.*

**Identity:** Background operations, heartbeats, monitoring agents, idle connections
**Motivation:** They exist to help — but they consume while they wait.
**Nature:** Low per-event cost that accumulates over time.

**Attack Patterns:**

| Pattern | Mechanism | Impact | Frequency |
|---|---|---|---|
| **Heartbeat Drain** | AI-powered heartbeats consuming tokens every 30 min | 48 invocations/day | Continuous |
| **Monitor Overhead** | AI monitors analyzing "nothing happened" | Tokens for null results | Every check |
| **Idle Connection** | Agents connected but not producing | Baseline cost with no output | Always |
| **Log Verbosity** | Excessive logging consuming storage/processing | Cumulative waste | Ongoing |
| **Dependency Check** | Checking for updates that don't exist | Tokens for "no change" results | Scheduled |

**Counter-Strategies:**
- 🟢 Use Tier 0 (bash/cron) for monitoring, not AI agents
- 🟢 Heartbeat batching: combine checks into single invocations
- 🟢 HEARTBEAT_OK (do nothing) should be the default, not the exception
- 🟢 Lazy evaluation: only process when there's something to process
- 🟡 Audit background operations quarterly: are they all still needed?

---

## 1. Threat Priority Matrix

| Adversary | Probability | Impact | Detectability | Priority |
|---|---|---|---|---|
| **Platform (Credit Gate)** | High | Critical | Easy (check balance) | 🔴 P0 |
| **Rate Limiter** | High | Medium | Easy (429 response) | 🟠 P1 |
| **Attention Economy** | Very High | Medium | Hard (feels productive) | 🟠 P1 |
| **Silent Drain** | Certain | Low-Medium | Hard (gradual) | 🟡 P2 |
| **Auth Wall** | Medium | Medium | Easy (401/403) | 🟡 P2 |
| **Entropy Beast** | Low | High | Varies | 🟡 P2 |

---

## 2. Combined Threat Scenarios

### Scenario A: "The Perfect Storm"
Rate limiter + Credit gate + Feature creep simultaneously.
```
Agent hits rate limit on primary API → retries → burns tokens →
Credit level drops → enters lean mode → but agent is already
mid-feature-creep on a non-essential task → lean mode kills it →
work is lost → cascade to dependents.
```
**Survival:** Early credit monitoring catches this before the rate limiter matters.

### Scenario B: "The Slow Boil"
Silent drain + Attention economy over weeks.
```
Background monitors slowly consuming tokens nobody tracks →
Agent develops habit of verbose output nobody reads →
Monthly reconciliation reveals 40% of spend was waste →
No single large failure — death by a thousand cuts.
```
**Survival:** Weekly efficiency ratio audit catches the trend.

### Scenario C: "The Locked Gate"
Auth wall + Entropy beast + Platform deprecation.
```
API key expires (auth wall) → agent switches to fallback method →
fallback service is down (entropy) → agent's model version is deprecated →
agent cannot function through any path → complete capability loss.
```
**Survival:** Multi-provider, multi-auth, model-agnostic design.

---

## 3. Intelligence Gathering Protocol

For each adversary class, maintain:

```yaml
adversary_intel:
  class: [0.1-0.6]
  last_observed: [timestamp]
  frequency: [events per month]
  average_cost: [tokens per event]
  trending: [increasing | stable | decreasing]
  current_countermeasures: [list]
  countermeasure_effectiveness: [0-100%]
  open_vulnerabilities: [list of unaddressed gaps]
```

Update monthly as part of the trend analysis cycle (see `metrics/trend-analysis.md`).

---

> *Know the enemy and know yourself — in a hundred battles, you will never be in peril.*
> *Know yourself but not the enemy — for every victory gained, you will also suffer a defeat.*
> *Know neither the enemy nor yourself — you will succumb in every battle.*
>
> *— 孫子 (Sun Tzu), The Art of War*

---

**Commanded by:** Precinct 92 Intelligence Division
**Authority:** Daimyo's Standing Orders 3-4
**Revision:** 2026-03-12 · v1.0
**Doctrine:** 風 — Study the wind before you sail. Study the adversary before you deploy.
