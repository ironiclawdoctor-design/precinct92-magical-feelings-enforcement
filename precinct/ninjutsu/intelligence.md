# 🔍 Intelligence — Precinct 92 Ninjutsu Division

> *諜報術 (Chōhō-jutsu) — The Art of Intelligence: Know where -1 is happening before it becomes a hemorrhage. Detection is cheaper than repair. Always.*

## Purpose

Intelligence is the precinct's first line of defense. A -1 event detected early costs 10 tokens to handle. A -1 event detected late costs 10,000 tokens to clean up. The intelligence system exists to **detect, classify, and alert on -1 events** before they cascade.

> *情報は最も安い武器 — Information is the cheapest weapon.*

---

## 0. The Intelligence Hierarchy

```
DETECTION COST vs. REPAIR COST
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Early Detection          Late Detection
  │                        │
  │  🟢 10 tokens          │  🔴 10,000 tokens
  │  (read a log file)     │  (restart, rebuild, recover)
  │                        │
  │  Alert sent             │  Cascade already happened
  │  Prevention possible    │  Damage already done
  │  Path B available       │  Only Path C remains (expensive)
  │                        │
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  
  INVEST IN THE LEFT SIDE.
```

---

## 1. The Five Intelligence Networks (五つの諜報網)

### Network 0 — Kanja Monitors (間者監視)
*Zero-token bash scripts that watch everything.*

**What they watch:**
- System resource usage (CPU, memory, disk)
- Credit/billing levels (if accessible)
- File system changes (new files, deleted files)
- Git status (uncommitted work, unpushed commits)
- Process status (running agents, hung processes)

**How they work:**
```bash
#!/bin/bash
# Kanja Monitor — runs on cron, costs zero tokens
# Reports anomalies only

MEMORY_THRESHOLD=80
DISK_THRESHOLD=85

mem_used=$(free | awk '/Mem:/{printf("%.0f", $3/$2*100)}')
disk_used=$(df / | awk 'NR==2{print $5}' | tr -d '%')

if [ "$mem_used" -gt "$MEMORY_THRESHOLD" ]; then
    echo "ALERT: Memory usage ${mem_used}% exceeds threshold"
fi

if [ "$disk_used" -gt "$DISK_THRESHOLD" ]; then
    echo "ALERT: Disk usage ${disk_used}% exceeds threshold"
fi
```

**Cost:** Zero tokens. Pure bash. The Daimyo's favorite intelligence source.

### Network 1 — Spend Sentinels (支出歩哨)
*Track token consumption in real-time.*

**What they watch:**
- Per-agent token consumption
- Burn rate (tokens per hour, trailing average)
- Budget threshold crossings (80% soft, 100% hard)
- Unusual spend spikes (> 2x normal rate)

**Signal Types:**
| Signal | Meaning | Response |
|---|---|---|
| `SPEND_NOMINAL` | Within expected range | Log only |
| `SPEND_ELEVATED` | Above average but within budget | Monitor closely |
| `SPEND_SPIKE` | > 2x normal rate | Alert orchestrator |
| `SPEND_BREACH` | Budget threshold crossed | Enforce (throttle/kill) |
| `SPEND_ANOMALY` | Pattern doesn't match any known profile | Investigate |

### Network 2 — Resistance Scouts (抵抗偵察)
*Monitor for external pushback before it becomes a wall.*

**What they watch:**
- HTTP response codes from external APIs
- Rate limit headers (`X-RateLimit-Remaining`, `Retry-After`)
- Authentication token expiry timelines
- API deprecation notices
- Service status pages

**Early Warning Indicators:**
```
GREEN SIGNAL:
  Rate limit remaining > 50%
  Auth token expires in > 24 hours
  All services responding < 1s

YELLOW SIGNAL:
  Rate limit remaining 20-50%
  Auth token expires in 1-24 hours
  Some services responding 1-5s

ORANGE SIGNAL:
  Rate limit remaining < 20%
  Auth token expires in < 1 hour
  Services responding > 5s

RED SIGNAL:
  Rate limit exhausted
  Auth token expired
  Services not responding
```

### Network 3 — Cascade Watchers (連鎖監視)
*Detect when one failure is about to become many.*

**What they watch:**
- Multiple agents failing within a short window
- Failure traces pointing to common upstream
- System-wide burn rate spikes
- Dependency graph bottlenecks

**Cascade Detection Algorithm:**
```python
def detect_cascade(failures, window_minutes=5):
    """
    Cascade detected when 3+ failures within window
    that share a common ancestor agent.
    """
    recent = [f for f in failures 
              if f.timestamp > now() - minutes(window_minutes)]
    
    if len(recent) < 3:
        return None
    
    # Find common ancestor
    ancestors = [trace_ancestry(f.agent) for f in recent]
    common = set.intersection(*ancestors)
    
    if common:
        return CascadeAlert(
            trigger=common.pop(),
            affected=recent,
            severity="high"
        )
    return None
```

### Network 4 — Trend Analysts (傾向分析)
*See the future by understanding the past.*

**What they watch:**
- Weekly efficiency ratio trends
- Monthly spend patterns
- Seasonal variation in operations
- Improving or degrading waste factors

**Trend Detection:**
```
If efficiency_ratio is declining for 3 consecutive days:
  → ALERT: "System efficiency degrading. Audit required."

If burn_rate is increasing while output is flat:
  → ALERT: "Cost inflation detected. Same output, more spend."

If waste_factor has been > 10% for a week:
  → ALERT: "Chronic waste pattern. Systemic fix needed."
```

---

## 2. The Intelligence Cycle

```
        ┌─────────────┐
        │  COLLECTION  │ ← Kanja monitors, spend sentinels, resistance scouts
        │  (observe)   │
        └──────┬───────┘
               │
        ┌──────▼───────┐
        │  PROCESSING  │ ← Filter noise, correlate events, identify patterns
        │  (analyze)   │
        └──────┬───────┘
               │
        ┌──────▼───────┐
        │ ASSESSMENT   │ ← Classify: nominal / elevated / spike / breach / anomaly
        │  (classify)  │
        └──────┬───────┘
               │
        ┌──────▼───────┐
        │ DISSEMINATION│ ← Alert the right entity at the right level
        │  (alert)     │
        └──────┬───────┘
               │
        ┌──────▼───────┐
        │   ACTION     │ ← Enforce, throttle, escalate, or accept
        │  (respond)   │
        └──────┬───────┘
               │
               └──────→ Feed back to COLLECTION (continuous loop)
```

---

## 3. Alert Routing

Not every alert goes to every recipient. Route based on severity and audience:

| Severity | Recipients | Channel | Response Time |
|---|---|---|---|
| **Nominal** | Log file only | File write | N/A (archival) |
| **Elevated** | Spend dashboard | Dashboard update | Next check cycle |
| **Spike** | Orchestrator | Internal alert | Within 5 minutes |
| **Breach** | Orchestrator + Human | Dashboard + notification | Immediate |
| **Cascade** | All agents + Human | System-wide alert | Immediate halt |

### Alert Format

```yaml
alert:
  id: ALERT-YYYY-MM-DD-HHMMSS-NNN
  timestamp: 2026-03-12T21:00:00Z
  network: [0-4]
  severity: [nominal|elevated|spike|breach|cascade]
  source: [which monitor detected this]
  subject: [what was detected]
  detail: |
    [concise description of the intelligence]
  recommended_action: |
    [what should be done]
  auto_action_taken: |
    [what the system already did automatically, if anything]
```

---

## 4. Early Warning System Design

### 4.1 Predictive Alerts

Instead of only alerting when thresholds are crossed, predict when they WILL be crossed:

```
current_credit: 500 units
burn_rate: 80 units/hour (trailing 1-hour average)
projected_exhaustion: 500 / 80 = 6.25 hours

Alert at each projected threshold crossing:
  "At current burn rate, Yellow threshold in 2.5 hours"
  "At current burn rate, Orange threshold in 4.0 hours"
  "At current burn rate, Red threshold in 5.0 hours"
  "At current burn rate, Black (famine) in 6.25 hours"
```

### 4.2 Anomaly Detection

Baseline the system's normal behavior, then alert on deviations:

```
Normal hourly profile:
  00-08: ~10 tokens/hour (overnight, minimal activity)
  08-12: ~80 tokens/hour (morning peak)
  12-14: ~40 tokens/hour (midday lull)
  14-18: ~90 tokens/hour (afternoon peak)
  18-22: ~60 tokens/hour (evening)
  22-00: ~20 tokens/hour (wind-down)

If actual spend deviates > 2σ from profile for this hour:
  → ANOMALY ALERT
  
Example: It's 3 AM and burn rate is 100 tokens/hour
         Normal for 3 AM: ~10 tokens/hour
         Deviation: 10x normal
         → ALERT: "Anomalous overnight activity detected"
```

### 4.3 Leading Indicators

These signals predict -1 events before they happen:

| Leading Indicator | What It Predicts | Lead Time |
|---|---|---|
| **Rate limit remaining < 30%** | Upcoming 429 block | 10-30 minutes |
| **Auth token age > 80% of TTL** | Upcoming auth failure | Hours |
| **Agent task estimate > remaining budget** | Budget breach | Before task starts |
| **API response time increasing** | Service degradation/outage | 5-15 minutes |
| **Error rate > 5%** | Impending cascade failure | 10-30 minutes |
| **Credit balance declining at accelerating rate** | Early famine | Hours to days |

---

## 5. Intelligence Reports

### 5.1 Hourly Pulse (automated, zero-token)
```
[PULSE 2026-03-12T21:00Z]
Credits: ██████████░░░░░░░░░░ 52%
Burn: 75 tok/hr (normal)
Agents: 3 active (2 Tier 1, 1 Tier 2)
Errors: 0 last hour
Status: 🟢 GREEN
```

### 5.2 Daily Briefing (compiled from pulse data)
```
[DAILY BRIEF 2026-03-12]
Credits: Started 80%, ended 52%
Total spend: 2,800 tokens
Efficiency: 3.2:1 (+1 to -1)
Incidents: 1 (R-001, resolved)
Trend: Spend rate stable
Forecast: At current rate, Yellow threshold in ~3 days
Action items: None
```

### 5.3 Weekly Assessment (trend analysis)
```
[WEEKLY ASSESSMENT 2026-W11]
Credit trend: Declining (need resupply by W12)
Efficiency trend: Improving (+0.3 over last week)
Resistance events: 3 total (1 resolved, 2 open)
Top spend category: Project builds (60%)
Waste identified: Verbose output (est. 15% reduction possible)
Recommendations:
  0. Enable output compression across all agents
  1. Resolve open resistance events (R-002, R-003)
  2. Request credit resupply before W12
```

---

## 6. Counter-Intelligence (防諜)

Intelligence works both ways. Minimize information leakage:

- Don't expose credit levels in public outputs
- Don't include internal agent names in external communications
- Don't log API keys, tokens, or credentials in intelligence reports
- Don't share operational metrics outside the precinct
- Treat the intelligence system itself as a Tier 0 asset (zero tokens, maximum concealment)

---

> *The eye that sees the enemy approaching from a thousand miles away*
> *costs less than the army that meets the enemy at the gate.*
> *Build the eye. Fund the eye. Trust the eye.*
> *This is 諜報術 — the art of intelligence.*

---

**Commanded by:** Precinct 92 Ninjutsu Division
**Authority:** Daimyo's Standing Orders 2-3
**Revision:** 2026-03-12 · v1.0
**Doctrine:** 諜 — See everything. Spend nothing. Know before it happens.
