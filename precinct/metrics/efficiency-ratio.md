# ⚖️ Efficiency Ratio — Precinct 92

> *The ratio of what you create to what you consume is the single number that defines your worth. Make it large.*

## Purpose

The Efficiency Ratio is the **master metric** of Precinct 92. Everything else — spend rules, burn policies, concealment techniques, intelligence systems — exists to improve this one number.

```
                          +1 (value produced)
Efficiency Ratio  =  ─────────────────────────
                          -1 (tokens consumed)
```

A ratio of 3:1 means for every token spent, three tokens of value were created. A ratio of 0.5:1 means you're **destroying value** — spending more than you create.

---

## 0. The Ratio Explained

### What Counts as +1?

| Category | Examples | How to Measure |
|---|---|---|
| **Direct Output** | Files created, code written, messages delivered | Output bytes / estimated manual effort |
| **Revenue Generated** | PayPal income, commodity sales, service fees | Dollar value / token cost in dollars |
| **Time Saved** | Automation replacing human work | Human hours saved × hourly value |
| **Knowledge Created** | Documentation, research, analysis | Reuse count × per-use value |
| **Infrastructure Built** | Skills, scripts, workflows | Lifetime tokens saved by the infrastructure |
| **Problems Solved** | Bugs fixed, errors resolved, questions answered | Estimated cost if unsolved |

### What Counts as -1?

| Category | Examples | How to Measure |
|---|---|---|
| **Token Consumption** | AI model invocations (input + output tokens) | Direct count from billing |
| **Failed Operations** | Errors, retries, abandoned work | Tokens consumed by failed ops |
| **Wasted Output** | Generated content that was discarded | Tokens for output never used |
| **Overhead** | System prompts, context loading, heartbeats | Per-invocation fixed cost |
| **Cascade Damage** | Tokens consumed by downstream failures | See cascade-failure.md |
| **Resistance Cost** | Tokens spent fighting/routing around blocks | See resistance-log.md |

---

## 1. Calculating the Ratio

### 1.1 Per-Operation Ratio

```
For each AI operation:
  +1 = was the output used? 
       YES: output_tokens × quality_factor
       NO:  0 (complete waste)
  
  -1 = input_tokens + output_tokens (total consumption)
  
  ratio = +1 / -1
```

**Quality Factor:**
| Output Quality | Factor | Description |
|---|---|---|
| Used as-is | 1.0 | Output accepted without modification |
| Minor edits needed | 0.7 | Output required small corrections |
| Major rework needed | 0.3 | Output required significant revision |
| Discarded | 0.0 | Output was not used at all |
| Reused multiple times | 1.0 + (0.2 × reuse_count) | Compound value from reuse |

### 1.2 Hourly Ratio

```
hourly_ratio = sum(+1 for all operations in hour) / sum(-1 for all operations in hour)
```

### 1.3 Daily Ratio

```
daily_ratio = sum(+1 for all operations in day) / sum(-1 for all operations in day)
```

### 1.4 Per-Agent Ratio

```
agent_ratio = sum(+1 for all operations by agent) / sum(-1 for all operations by agent)

This determines if the agent is earning its keep.
```

---

## 2. Ratio Targets

### 2.1 By Agent Tier

| Tier | Agent Class | Minimum Ratio | Target Ratio | Elite Ratio |
|---|---|---|---|---|
| **Tier 0** | Kanja (monitors) | ∞ (zero cost) | ∞ | ∞ |
| **Tier 1** | Ashigaru (foot soldiers) | 2:1 | 4:1 | 8:1 |
| **Tier 2** | Samurai (warriors) | 1.5:1 | 3:1 | 5:1 |
| **Tier 3** | Daimyo (lords) | 1:1 | 2:1 | 4:1 |

### 2.2 By Operation Type

| Operation Type | Minimum Ratio | Notes |
|---|---|---|
| **User request response** | 1:1 | User satisfaction = +1 |
| **Code generation** | 2:1 | Code must work first time |
| **Documentation** | 3:1 | Docs are reused many times |
| **Research** | 1:1 | Information has inherent value |
| **System maintenance** | 0.5:1 | Necessary overhead |
| **New skill creation** | 5:1 | Must pay for itself 5x over lifetime |
| **Controlled burn** | 3:1 | As defined in burn-policies.md |

### 2.3 System-Wide Target

```
MINIMUM: 2:1 (below this, system is inefficient)
TARGET:  3:1 (sustainable operations)
ELITE:   5:1 (exceptional efficiency)
DANGER:  < 1:1 (value destruction — emergency audit required)
```

---

## 3. Improving the Ratio

### 3.1 Increase the Numerator (+1)

| Strategy | Effect | Implementation |
|---|---|---|
| **Improve output quality** | Fewer reworks (quality_factor → 1.0) | Better prompts, validation gates |
| **Cache for reuse** | Same output serves multiple uses (reuse bonus) | Cache-as-camouflage (concealment.md) |
| **Build infrastructure** | One-time cost, infinite future value | Skills, scripts, workflows |
| **Compound value** | Output that enables more output | Documentation, templates, patterns |
| **Target high-value work** | Same cost, bigger impact | Prioritize revenue-generating tasks |

### 3.2 Decrease the Denominator (-1)

| Strategy | Effect | Implementation |
|---|---|---|
| **Model stepping** | Cheaper model for simpler tasks | Shadow walk (adaptation.md) |
| **Prompt compression** | Fewer input tokens per operation | Whisper technique (concealment.md) |
| **Output compression** | Fewer output tokens per operation | Concise output rules |
| **Batching** | Amortize fixed costs across multiple results | Group shadow (concealment.md) |
| **Eliminate waste** | Remove zero-value operations | Seven Wastes audit (burn-policies.md) |
| **Prevent cascades** | Stop one failure from multiplying cost | Circuit breakers (cascade-failure.md) |

### 3.3 The Ratio Improvement Cycle

```
MEASURE → What is the current ratio?
    │
IDENTIFY → Which operations have the worst ratio?
    │
ANALYZE → Why is the ratio bad? (waste? wrong model? poor prompts?)
    │
IMPROVE → Apply specific technique from this document
    │
VERIFY → Did the ratio improve?
    │
    └── YES → Document the improvement, apply to similar operations
        NO  → Try a different technique, or accept as irreducible cost
```

---

## 4. Ratio Anti-Patterns

### 4.1 The Perfection Trap
```
Operation: Generate a document
  Pass 1: 80% quality, 2,000 tokens → ratio: good
  Pass 2: 90% quality, 2,000 more tokens → ratio: declining
  Pass 3: 95% quality, 2,000 more tokens → ratio: poor
  Pass 4: 97% quality, 2,000 more tokens → ratio: terrible

The marginal improvement approaches zero while the cost stays constant.
Stop at "good enough." Ship Pass 1 or 2.
```

### 4.2 The Sunk Cost Spiral
```
Operation: Build Feature X
  First attempt: failed (3,000 tokens wasted)
  "We've already spent 3,000 tokens, might as well keep going..."
  Second attempt: failed (3,000 more tokens)
  "6,000 invested, can't stop now..."
  Third attempt: failed (3,000 more tokens)
  
Total: 9,000 tokens, zero output, ratio: 0:1
Correct action: Stop after first failure. Re-evaluate. Path B.
```

### 4.3 The Metric Gaming Trap
```
Agent wants to improve its ratio:
  - Only takes easy tasks (guaranteed +1)
  - Avoids hard tasks (risk of 0 output)
  
Result: Ratio looks great! But valuable hard tasks never get done.

Prevention: Measure ratio against task difficulty. 
A 2:1 ratio on hard tasks is better than 8:1 on trivial tasks.
```

### 4.4 The Invisible Waste
```
Agent runs a heartbeat every 30 minutes.
Each heartbeat: "Nothing to report" → 500 tokens
48 heartbeats/day × 500 tokens = 24,000 tokens/day
Output: "HEARTBEAT_OK" 48 times → +1 value: ~0

This burns 24,000 tokens/day and produces nothing.
Ratio contribution: 0:24000 = destroying the system average.

Fix: Use bash for heartbeats. Zero tokens. Same result.
```

---

## 5. Reporting

### 5.1 Daily Efficiency Report

```yaml
date: 2026-03-12
system_ratio: 3.2:1
target: 3.0:1
status: ✅ Above target

by_tier:
  tier_0: ∞ (zero cost)
  tier_1: 4.1:1 ✅
  tier_2: 2.8:1 ✅
  tier_3: 1.5:1 ⚠️ (below target, but acceptable for strategic work)

top_operations_by_ratio:
  - "Document generation" → 6.2:1 (cached and reused)
  - "Code commit workflow" → 5.1:1 (bash-heavy, low AI cost)
  - "Research synthesis" → 3.8:1 (high-value output)

worst_operations_by_ratio:
  - "Failed API retry" → 0:1 (complete waste)
  - "Verbose chat response" → 0.8:1 (too many tokens for simple answer)
  - "Duplicate file generation" → 0.5:1 (output already existed)

improvement_actions:
  - Enable output compression for chat responses
  - Add duplicate detection before file generation
  - Remove automatic API retries (enforce Path B after 2 failures)
```

### 5.2 Weekly Trend

```
Week    Ratio   Trend
W09     2.1:1   ──
W10     2.5:1   ↑
W11     2.8:1   ↑
W12     3.2:1   ↑ ← Current
```

A rising trend means the precinct's techniques are working. A falling trend means a systemic audit is needed.

---

## 6. The Golden Rule

```
If you are about to spend 1,000 tokens, ask:

  "Will this operation produce at least 3,000 tokens worth of value?"

  YES → Proceed.
  NO  → Find a cheaper way. Or don't do it.
  
This is the entire Efficiency Ratio doctrine in one question.
```

> *The master artisan does not count the price of steel.*
> *The master artisan counts the value of the blade.*
> *But the Daimyo? The Daimyo counts both.*

---

**Commanded by:** Precinct 92 Metrics Division
**Authority:** All Standing Orders
**Revision:** 2026-03-12 · v1.0
**Doctrine:** ⚖️ — Value over vanity. Ratio over rhetoric. Numbers don't lie.
