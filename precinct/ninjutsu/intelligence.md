# 諜報術 (Chōhō-jutsu) — Intelligence Gathering

## Principle
Know where -1 is happening before it becomes a hemorrhage. Detection is cheaper than repair.

## Intelligence Targets

### 0. Token Spend Patterns
- Track tokens per operation type
- Identify operations with high token cost / low value ratio
- Flag repeat offenders (operations that consistently waste)

### 1. Failure Cascades
- When one agent fails, what downstream costs does it trigger?
- Map dependency chains — where does a single -1 multiply?
- Example: Official's credit death → Fiesta manual recovery → 2x the total cost

### 2. Foreign Resistance Signals
- API rate limits approaching
- Authentication failures
- Timeout patterns
- Service degradation from external providers

### 3. Credit Level Intelligence
- Current Ampere balance
- Burn rate (credits/hour)
- Time-to-empty projection
- PayPal balance available for replenishment

## Early Warning System

| Alert Level | Condition | Action |
|---|---|---|
| 🟢 Green | Credits > 50%, no anomalies | Normal operations |
| 🟡 Yellow | Credits 20-50%, or unusual spend spike | Audit current operations, optimize |
| 🟠 Orange | Credits 10-20%, or foreign resistance detected | Enter lean mode, defer Tier 3+ ops |
| 🔴 Red | Credits < 10%, or multiple system failures | Survival mode, alert human |
| ⚫ Black | Credits exhausted | All agents halt except Fiesta main. Await resupply. |

## Collection Methods

- Heartbeat checks (passive, low cost)
- Script-based monitors (zero token cost)
- Post-operation logging (capture cost metadata)
- Cron-based periodic audits (scheduled, budgeted)

> 情報は最も安い武器である — Information is the cheapest weapon
