# 📊 Spend Dashboard — Precinct 92

> *地 (Chi) — Earth: You cannot manage what you cannot measure. The dashboard is your ground truth.*

## Purpose

The Spend Dashboard is the precinct's central nervous system for -1 visibility. It provides **real-time awareness** of token consumption, credit levels, agent activity, and system health. Every metric has a purpose. Every visualization has an enforcement action behind it.

---

## 0. Dashboard Layout

```
┌─────────────────────────────────────────────────────────────────┐
│  🏯 PRECINCT 92 — SPEND DASHBOARD                    🟢 GREEN  │
│  Last updated: 2026-03-12T21:00:00Z                            │
├──────────────────────┬──────────────────────────────────────────┤
│  CREDIT LEVEL        │  BURN RATE                              │
│  ██████████░░░░ 52%  │  75 tok/hr (↓ from 90)                 │
│  Projected famine:   │  24h avg: 82 tok/hr                    │
│  ~62 hours           │  Trend: declining ✅                     │
├──────────────────────┼──────────────────────────────────────────┤
│  ACTIVE AGENTS       │  EFFICIENCY RATIO                       │
│  Tier 0: 3 (Kanja)  │  Current: 3.2:1 (+1/-1)                │
│  Tier 1: 2 (Ashig.) │  Target:  3.0:1 ✅                      │
│  Tier 2: 1 (Samurai) │  7-day avg: 2.8:1                      │
│  Tier 3: 0 (Daimyo) │  Trend: improving ✅                     │
├──────────────────────┼──────────────────────────────────────────┤
│  WASTE FACTOR        │  RESISTANCE INDEX                       │
│  Current: 4.2%      │  Open events: 2                         │
│  Target: <5% ✅      │  Resolved today: 1                      │
│  Trend: stable       │  Hostile endpoints: 0                   │
├──────────────────────┴──────────────────────────────────────────┤
│  RECENT ALERTS                                                  │
│  21:00  🟢 Hourly pulse — all nominal                          │
│  20:15  🟡 Tier 2 agent approached soft target (82%)           │
│  19:30  🟢 R-001 resolved — credits restored                   │
│  18:00  🔴 R-001 — Credit exhaustion event                      │
├─────────────────────────────────────────────────────────────────┤
│  SPEND TIMELINE (last 24h)                                      │
│  ▁▁▂▂▃▃▄▅▅▆▅▅▄▃▃▂▂▁▁▁▂▃▃▃                                    │
│  00  03  06  09  12  15  18  21                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 1. Key Metrics — What to Track

### 1.1 Primary Metrics (always visible)

| Metric | Source | Update Frequency | Visualization |
|---|---|---|---|
| **Credit Level** | Platform billing API / balance check | Every 15 minutes | Gauge (%) + trend arrow |
| **Burn Rate** | Token consumption / time | Continuous (hourly aggregate) | Number + sparkline |
| **Efficiency Ratio** | +1 output events / -1 token spend | Per operation (rolling average) | Ratio + target comparison |
| **Active Agents** | Agent registry | Real-time | Count by tier |
| **Alert Level** | Derived from credit level + anomalies | Real-time | Color-coded status |

### 1.2 Secondary Metrics (expandable panels)

| Metric | Source | Update Frequency | Visualization |
|---|---|---|---|
| **Waste Factor** | Failed operations / total operations | Hourly | Percentage + threshold line |
| **Stealth Score** | Useful output bytes / tokens consumed | Per operation | Ratio (higher = better) |
| **Resistance Index** | Open resistance events / resolved events | On change | Count + trend |
| **Cascade Risk** | Dependency graph analysis | Hourly | Low/Med/High indicator |
| **Budget Utilization** | Per-tier spend / per-tier budget | Daily | Stacked bar per tier |

### 1.3 Derived Metrics (computed from primary/secondary)

| Metric | Formula | Purpose |
|---|---|---|
| **Time to Famine** | `credit_remaining / burn_rate` | How long until ⚫ BLACK |
| **Cost per Operation** | `total_tokens / operation_count` | Is each operation getting cheaper? |
| **Peak Hour** | `hour with highest burn_rate` | When do we spend the most? |
| **Recovery Rate** | `resistance_resolved / resistance_total` | Are we getting better at handling resistance? |
| **Budget Headroom** | `(hard_ceiling - actual_spend) / hard_ceiling` | How close are we to limits? |

---

## 2. Visualizations

### 2.1 Credit Gauge

```
                    ██████████░░░░░░░░░░
CREDIT LEVEL:       ■■■■■■■■■■□□□□□□□□□□  52%
                    ^         ^    ^    ^
                    0%       20%  50%  100%
                    ⚫        🔴   🟡   🟢
```

- Color transitions at threshold crossings
- Projected exhaustion time shown below
- History sparkline (last 7 days)

### 2.2 Burn Rate Timeline

```
Tokens/hr
  120 │              ▄
  100 │        ▄▄    █▄
   80 │    ▄▄  ██  ▄ ██▄▄
   60 │  ▄ ██▄ ██▄ █ ████
   40 │▄ █ ████████ █ ████
   20 │█ █ ████████ █ ████
    0 ├─┴─┴─┴──┴──┴─┴─┴──┴──
      00  04  08  12  16  20  24
```

- 24-hour rolling window
- Overlay: budget thresholds as horizontal lines
- Anomaly markers: ⚠️ at any spike > 2σ

### 2.3 Efficiency Ratio Trend

```
Ratio
  5.0 │                    Target range
  4.0 │  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─
  3.0 │        ╱─╲    ╱──╱ ← current
  2.0 │──╲  ╱─╱   ╲╱─╱
  1.0 │   ╲╱
  0.0 ├──┴──┴──┴──┴──┴──┴──┴
     -7d  -6d  -5d  -4d  -3d  -2d  -1d  now
```

- 7-day rolling window
- Target line at 3.0:1
- Color: green above target, red below

### 2.4 Agent Activity Heatmap

```
        00  04  08  12  16  20
Tier 0  ░░░░░░░░░░░░░░░░░░░░░░░░  (always running)
Tier 1  ░░░░░░░░████████████░░░░  (business hours)
Tier 2  ░░░░░░░░░░██████░░░░░░░░  (peak hours only)
Tier 3  ░░░░░░░░░░░░██░░░░░░░░░░  (rare, targeted)

░ = idle   █ = active
```

---

## 3. Alert Thresholds

### 3.1 Credit Level Alerts

| Threshold | Alert Level | Dashboard Color | Automated Action |
|---|---|---|---|
| **> 50%** | 🟢 GREEN | Green | None |
| **20-50%** | 🟡 YELLOW | Yellow | Log warning, notify orchestrator |
| **10-20%** | 🟠 ORANGE | Orange | Lean mode, Tier 2+ suspended |
| **< 10%** | 🔴 RED | Red/pulsing | Survival mode, AI agents halted |
| **= 0%** | ⚫ BLACK | Dark/static | Total halt |

### 3.2 Burn Rate Alerts

| Condition | Alert | Action |
|---|---|---|
| Burn rate > 2x 24h average | ⚠️ Spike detected | Investigate source |
| Burn rate increasing for 3+ hours | ⚠️ Acceleration detected | Review active agents |
| Burn rate > `credits / 8` per hour | 🔴 Unsustainable rate | Force throttling |
| Burn rate = 0 for 2+ hours during business hours | ⚠️ Silence detected | Check if agents are stuck |

### 3.3 Efficiency Alerts

| Condition | Alert | Action |
|---|---|---|
| Efficiency < 1:1 for any hour | 🔴 Negative ROI | Immediate audit |
| Efficiency declining 3+ days | 🟡 Degradation trend | Weekly review |
| Waste factor > 10% | 🟠 Chronic waste | Systemic optimization |
| Single operation > 10,000 tokens with no output | 🔴 Black hole | Kill agent, investigate |

---

## 4. Dashboard Data Sources

### 4.1 Data Collection Points

```
Source                  → Collector              → Dashboard
─────────────────────────────────────────────────────────────
Platform billing API    → Credit level monitor   → Credit gauge
Agent token counters    → Spend sentinel         → Burn rate
Operation outcomes      → Outcome classifier     → Efficiency ratio
Process list            → Agent registry         → Active agents
resistance-log.md       → Resistance parser      → Resistance index
System resources        → monitor.sh (Kanja)     → Resource panel
```

### 4.2 Storage

```
/precinct92/metrics/
├── credit-history.jsonl      # One line per credit check
├── burn-rate-hourly.jsonl    # Hourly aggregated burn rates
├── efficiency-daily.jsonl    # Daily efficiency ratios
├── agent-activity.jsonl      # Agent start/stop/spend events
├── alerts.jsonl              # All alerts with timestamps
└── dashboard-state.json      # Current dashboard snapshot
```

Each JSONL entry:
```json
{"ts":"2026-03-12T21:00:00Z","metric":"credit_level","value":52,"unit":"percent"}
{"ts":"2026-03-12T21:00:00Z","metric":"burn_rate","value":75,"unit":"tokens_per_hour"}
```

---

## 5. Dashboard Access

### 5.1 Live Dashboard
The `index.html` at the repository root serves as the live dashboard. It reads from the metrics data files and renders the visualizations in a dark-themed Japanese aesthetic.

### 5.2 CLI Dashboard
```bash
# Quick dashboard from the command line
./scripts/monitor.sh

# Output: compact text version of the dashboard
```

### 5.3 Chat Dashboard
When an agent or human asks "what's the spend status?", generate a compact text dashboard:
```
🏯 Precinct 92 Status
Credits: 52% (🟢) | Burn: 75/hr (↓) | Efficiency: 3.2:1 (✅)
Agents: 6 active | Alerts: 0 new | Resistance: 2 open
Forecast: ~62 hours to famine at current rate
```

---

## 6. Dashboard Maintenance

- **Hourly:** Automated pulse updates all metrics
- **Daily:** Compile daily summary, archive previous day's data
- **Weekly:** Generate trend report, update visualizations
- **Monthly:** Archive monthly data, reset counters, generate monthly report
- **Quarterly:** Review all metrics for relevance, add/remove as needed

> *The general who stares at an empty map loses the battle.*
> *The Daimyo who stares at an empty dashboard loses the budget.*
> *Populate the dashboard. Trust the dashboard. Enforce by the dashboard.*

---

**Commanded by:** Precinct 92 Metrics Division
**Authority:** All Standing Orders
**Revision:** 2026-03-12 · v1.0
**Doctrine:** 地 — Ground truth. Measured reality. No illusions.
