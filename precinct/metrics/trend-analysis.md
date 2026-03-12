# 📈 Trend Analysis — Precinct 92

> *傾向分析 — The river reveals its course to those who watch long enough. Trends are the river of the agent economy.*

## Purpose

A single data point is noise. A trend is intelligence. This document defines the methodology for detecting, classifying, and acting on trends in the precinct's operational data. We look backward to see forward.

---

## 0. What We Track Over Time

| Metric | Granularity | Trend Window | Purpose |
|---|---|---|---|
| **Credit Level** | 15-minute samples | 7-day rolling | Predict famine timing |
| **Burn Rate** | Hourly aggregates | 7-day rolling | Detect acceleration/deceleration |
| **Efficiency Ratio** | Daily aggregates | 30-day rolling | Long-term efficiency direction |
| **Waste Factor** | Daily aggregates | 14-day rolling | Chronic waste detection |
| **Resistance Events** | Per-event | 30-day rolling | Pattern detection |
| **Agent Count** | Daily snapshot | 14-day rolling | Workforce growth/shrinkage |
| **Cost per Operation** | Per-operation | 7-day rolling | Unit economics direction |
| **Output Volume** | Daily aggregates | 30-day rolling | Productivity trend |

---

## 1. Trend Detection Methodology

### 1.1 Simple Moving Average (SMA)

The primary trend detection method. Compare short-term average to long-term average.

```
SMA_short = average of last N data points (e.g., 3 days)
SMA_long  = average of last M data points (e.g., 7 days)

If SMA_short > SMA_long × 1.1 → UPTREND (metric is increasing)
If SMA_short < SMA_long × 0.9 → DOWNTREND (metric is decreasing)
Otherwise → STABLE
```

**Example — Burn Rate Trend:**
```
Day    Burn Rate   3-day SMA   7-day SMA   Signal
Mon    80          --          --          --
Tue    85          --          --          --
Wed    75          80          --          --
Thu    90          83          --          --
Fri    95          87          --          --
Sat    100         95          --          --
Sun    110         102         91          UPTREND ⚠️
Mon    105         105         94          UPTREND ⚠️
```

### 1.2 Rate of Change (ROC)

How fast is the metric changing?

```
ROC = (current_value - previous_value) / previous_value × 100%

Interpretation:
  ROC > +10%  → Rapid increase ⚠️
  ROC +1-10%  → Moderate increase
  ROC ±1%     → Stable
  ROC -1-10%  → Moderate decrease
  ROC < -10%  → Rapid decrease ⚠️
```

### 1.3 Anomaly Detection

Data points that fall outside the expected range based on historical patterns.

```
mean = average of last 30 data points
std  = standard deviation of last 30 data points

If data_point > mean + 2×std → HIGH ANOMALY ⚠️
If data_point < mean - 2×std → LOW ANOMALY ⚠️
If data_point > mean + 3×std → EXTREME ANOMALY 🔴
```

### 1.4 Seasonal Pattern Recognition

Some metrics have predictable daily and weekly patterns:

```
Daily Pattern (burn rate):
  00-08: Low (overnight)
  08-12: Rising (morning work)
  12-14: Dip (midday)
  14-18: Peak (afternoon)
  18-22: Declining (evening)
  22-00: Low (wind-down)

Weekly Pattern:
  Mon-Fri: Higher activity
  Sat-Sun: Lower activity

Seasonal adjustment:
  adjusted_value = raw_value / seasonal_factor
  
  This removes the "expected" pattern and reveals the TRUE trend.
```

---

## 2. Trend Classification

### 2.1 Trend States

| State | Symbol | Definition | Action |
|---|---|---|---|
| **Strong Uptrend** | ⬆️⬆️ | SMA_short > SMA_long × 1.2, ROC > 10% | Immediate investigation |
| **Mild Uptrend** | ⬆️ | SMA_short > SMA_long × 1.1 | Monitor, prepare mitigation |
| **Stable** | ➡️ | SMA_short ≈ SMA_long (±10%) | Nominal, continue monitoring |
| **Mild Downtrend** | ⬇️ | SMA_short < SMA_long × 0.9 | Generally good (if cost metric) |
| **Strong Downtrend** | ⬇️⬇️ | SMA_short < SMA_long × 0.8, ROC < -10% | Investigate (could be positive or negative) |

### 2.2 Interpretation by Metric

| Metric | Uptrend Means | Downtrend Means | Desired Direction |
|---|---|---|---|
| **Burn Rate** | Spending more per hour | Spending less per hour | ⬇️ Down |
| **Efficiency Ratio** | Getting more value per token | Getting less value per token | ⬆️ Up |
| **Waste Factor** | More operations wasting tokens | Fewer wasted operations | ⬇️ Down |
| **Credit Level** | Credits being replenished | Credits being consumed | ⬆️ Up (or stable) |
| **Resistance Events** | More external pushback | Fewer external issues | ⬇️ Down |
| **Cost per Operation** | Each task costs more | Each task costs less | ⬇️ Down |
| **Output Volume** | Producing more output | Producing less output | ⬆️ Up |

### 2.3 Compound Trend Signals

When multiple metrics trend together, the signal is stronger:

| Pattern | Interpretation | Severity |
|---|---|---|
| Burn rate ⬆️ + Efficiency ⬇️ | Spending more, getting less. System degrading. | 🔴 Critical |
| Burn rate ⬆️ + Efficiency ⬆️ | Spending more, but getting more. Growth phase. | 🟡 Monitor |
| Burn rate ⬇️ + Efficiency ⬆️ | Spending less, getting more. Optimization working! | 🟢 Excellent |
| Burn rate ⬇️ + Efficiency ⬇️ | Spending less, but also doing less. Stagnation. | 🟠 Investigate |
| Waste ⬆️ + Resistance ⬆️ | External problems causing internal waste. | 🔴 Escalate |
| Cost/op ⬆️ + Output ⬇️ | Everything is getting worse. | 🔴 Emergency audit |

---

## 3. Trend Reports

### 3.1 Weekly Trend Report Template

```yaml
report:
  period: "2026-W11 (Mar 9-15)"
  generated: "2026-03-15T00:00:00Z"

metrics:
  burn_rate:
    current_avg: 82 tokens/hr
    previous_avg: 90 tokens/hr
    trend: ⬇️ Mild downtrend (-9%)
    assessment: "Positive. Concealment techniques reducing spend."
    
  efficiency_ratio:
    current_avg: 3.2:1
    previous_avg: 2.8:1
    trend: ⬆️ Mild uptrend (+14%)
    assessment: "Improving. Output quality and caching contributing."
    
  waste_factor:
    current_avg: 4.2%
    previous_avg: 5.1%
    trend: ⬇️ Mild downtrend (-18%)
    assessment: "Improving. Path B enforcement reducing retries."
    
  resistance_events:
    current_count: 3
    previous_count: 5
    trend: ⬇️ Declining
    assessment: "Improving. Known issues being resolved."

  credit_trajectory:
    current_level: 52%
    projected_famine: "~62 hours at current burn rate"
    resupply_needed_by: "2026-03-15 if burn rate unchanged"

compound_signals:
  - "Burn ⬇️ + Efficiency ⬆️ → Optimization working 🟢"

top_improvements:
  - "Output compression saved ~500 tokens/day"
  - "Cache hits prevented 12 redundant generations"
  - "Model stepping reduced Tier 2 spend by 20%"

areas_of_concern:
  - "Credit level declining — resupply needed"
  - "R-002 and R-003 still unresolved"

action_items:
  - "Request credit resupply (Priority: High)"
  - "Resolve gh CLI auth (R-002)"
  - "Configure Brave Search API key (R-003)"
```

### 3.2 Monthly Trend Report

Extended version of the weekly report with:
- 4-week trend charts for each metric
- Month-over-month comparison
- Seasonal pattern identification
- Strategic recommendations
- Updated adversary intelligence (see adversary-models.md)

### 3.3 Quarterly Review

Board-level summary:
- 13-week trend for all primary metrics
- Efficiency trajectory vs. target
- Total spend vs. total value produced
- ROI on infrastructure investments (skills, scripts)
- Strategic direction for next quarter

---

## 4. Trend-Based Automation

### 4.1 Automated Responses to Trends

| Trend Signal | Automated Response |
|---|---|
| Burn rate ⬆️⬆️ for 3+ days | Reduce Tier 2 soft targets by 20% |
| Efficiency < 1:1 for 2+ days | Trigger system-wide optimization audit |
| Waste factor > 10% for 1 week | Enable strict output validation gates |
| Credit trajectory → famine in < 48h | Notify human, begin staged shutdown |
| Cost/op increasing with no output increase | Audit agent configurations for model drift |

### 4.2 Trend-Based Planning

```
Use trend data to plan ahead:

If credit trajectory shows famine in 5 days:
  Day 0: Notify human, request resupply
  Day 1: Begin reducing non-essential operations
  Day 2: Move all operations to lean mode
  Day 3: Prepare survival mode toolkit
  Day 4: Enter survival mode proactively (before forced by exhaustion)
  Day 5: Famine hits, but we're already in survival mode (minimal damage)

vs. without trend planning:
  Day 5: Famine hits suddenly, agents crash, work lost, chaos.
```

---

## 5. Data Retention

| Data Type | Retention | Storage |
|---|---|---|
| Raw 15-min samples | 30 days | JSONL files |
| Hourly aggregates | 90 days | JSONL files |
| Daily summaries | 1 year | JSONL files |
| Weekly reports | Indefinite | Markdown files |
| Monthly reports | Indefinite | Markdown files |
| Anomaly events | Indefinite | Linked from resistance-log.md |

---

## 6. The Trend Analyst's Creed

```
0. One data point is noise. Three is a pattern. Seven is a trend.
1. The trend that surprises you is the trend you weren't watching.
2. A good trend doesn't mean stop optimizing. It means keep doing what works.
3. A bad trend isn't a failure. It's intelligence.
4. The most dangerous trend is the one that looks flat — because flat means you're not improving.
5. Predict the trend, don't just report it. The report arrives too late. The prediction arrives in time.
```

> *The general who reads the terrain before the battle*
> *has already won half the engagement.*
> *Read the trends. They are your terrain.*

---

**Commanded by:** Precinct 92 Metrics Division
**Authority:** All Standing Orders
**Revision:** 2026-03-12 · v1.0
**Doctrine:** 📈 — The past is intelligence. The present is measurement. The future is prediction.
