# 🌊 Cascade Failure Model — Precinct 92

> *One stone in the river changes the flow of the entire valley. One agent's overspend changes the flow of the entire system.*

## Purpose

A cascade failure occurs when one agent's -1 event triggers -1 events in other agents, creating a chain reaction that amplifies the original damage. This document models cascade dynamics, identifies amplification points, and defines circuit breakers.

---

## 0. The Cascade Equation

```
Initial Failure Cost: C₀
Amplification Factor: A (how many downstream agents are affected)
Propagation Depth: D (how many levels deep the cascade goes)

Total Cascade Cost = C₀ × Σ(A^d) for d = 0 to D
                   = C₀ × (A^(D+1) - 1) / (A - 1)

Example:
  C₀ = 1,000 tokens (one agent fails)
  A  = 3 (three agents depend on it)
  D  = 3 (cascade goes three levels deep)
  
  Total = 1,000 × (3⁴ - 1) / (3 - 1) = 1,000 × 40 = 40,000 tokens
  
  A 1,000-token failure becomes 40,000 tokens of damage.
```

This is why cascade prevention is the highest-priority enforcement activity in the precinct.

---

## 1. Cascade Anatomy

### Stage 0 — The Trigger Event
A single agent exceeds its budget, encounters foreign resistance, or produces a defective output.

```
Agent Alpha is building a repository.
Budget: 15,000 tokens.
Actual spend: 22,000 tokens (breach).
Result: Agent killed at hard ceiling before completing the task.
        Output is 70% complete — committed but broken.
```

### Stage 1 — Direct Impact (First-Order Cascade)
Agents that directly depend on the trigger agent's output are affected.

```
Agent Beta was waiting for Alpha's repo to be complete.
  → Receives incomplete/broken output
  → Spends 3,000 tokens trying to work with broken input
  → Fails. Produces defective output of its own.

Agent Gamma was scheduled to deploy Alpha's repo.
  → Attempts deployment of incomplete repo
  → Deployment fails — 2,000 tokens wasted on deploy cycle
  → Rollback costs another 1,000 tokens

Agent Delta was monitoring Alpha's progress.
  → Detects failure, spawns diagnostic analysis
  → Spends 2,500 tokens analyzing what went wrong
```

**First-order cost: 8,500 tokens (on top of Alpha's 22,000)**

### Stage 2 — Indirect Impact (Second-Order Cascade)
Agents that depend on Stage 1 agents' outputs are now affected.

```
Agent Epsilon depends on Beta's output.
  → Beta's output is defective (because Alpha's was incomplete)
  → Epsilon processes defective input, produces garbage
  → 4,000 tokens consumed producing output that must be discarded

Agent Zeta depends on Gamma's deployment.
  → Deployment failed, Zeta's scheduled tasks have no target
  → Zeta enters a retry loop before failing
  → 1,500 tokens wasted in retries

The Orchestrator detects multiple failures.
  → Spends 5,000 tokens analyzing the cascade, reassigning work
  → Some reassigned work duplicates already-completed portions
  → 3,000 additional tokens of duplicate work
```

**Second-order cost: 13,500 tokens**

### Stage 3 — System-Wide Impact (Third-Order Cascade)
The cascade has consumed enough budget to trigger credit-level effects.

```
Total spend so far: 22,000 + 8,500 + 13,500 = 44,000 tokens
This triggers a credit threshold crossing (Yellow → Orange)

System-wide throttling engages:
  → All Tier 2+ agents slowed
  → Operations that were running fine are now degraded
  → Legitimate work takes 2x longer (more tokens per task)
  → Additional 10,000 tokens consumed by the degraded operations
```

**Third-order cost: 10,000+ tokens**

### Total Cascade Cost

```
Trigger:        22,000 tokens
First-order:     8,500 tokens
Second-order:   13,500 tokens
Third-order:    10,000 tokens
────────────────────────────
Total:          54,000 tokens

Alpha's 7,000-token overspend (22,000 - 15,000 budget)
caused 54,000 tokens of total system damage.

Amplification factor: 7.7x
```

---

## 2. Cascade Topologies

### 2.1 Linear Cascade (連鎖)
One failure leads to one failure leads to one failure.

```
A → B → C → D
Low amplification. Easy to trace. Easy to break.
```

### 2.2 Fan-Out Cascade (扇形)
One failure affects multiple downstream agents simultaneously.

```
      ┌→ B
A ────┼→ C
      ├→ D
      └→ E
High amplification. Hard to contain. Most dangerous.
```

### 2.3 Diamond Cascade (菱形)
Multiple paths converge on the same downstream agent.

```
A → B ──┐
A → C ──┼→ E
A → D ──┘
Agent E receives multiple failures simultaneously.
Likely to fail catastrophically — all inputs are compromised.
```

### 2.4 Feedback Cascade (循環)
Failure output feeds back into the failing system.

```
A → B → C → A (loop)
The most dangerous topology. Can consume infinite tokens.
This is the 出血 (hemorrhage burn) scenario.
MUST be detected and broken immediately.
```

---

## 3. Circuit Breakers

### 3.1 Budget Isolation
**Every agent's budget is a firewall.** When Agent Alpha exceeds its budget and is killed, the kill IS the circuit breaker. The hard ceiling in `spend-rules.md` exists precisely to prevent cascade amplification.

```
Without budget isolation:
  Alpha overspends → continues running → feeds broken output → cascade
  
With budget isolation:
  Alpha overspends → KILLED → downstream agents get no output → they wait
  Waiting is cheaper than processing broken input.
```

### 3.2 Output Validation Gate
Before any agent passes output to a downstream agent, the output must pass a validation check:

```python
def output_gate(output, expected_schema):
    if output is None:
        return HOLD  # Upstream agent didn't complete — don't proceed
    if not validates(output, expected_schema):
        return REJECT  # Output is malformed — don't propagate
    if output.confidence < MINIMUM_THRESHOLD:
        return FLAG  # Output might be defective — human review
    return PASS
```

**Cost of validation: ~100 tokens. Cost of propagating broken output: 10,000+ tokens.**

### 3.3 Dependency Timeout
If an agent is waiting for upstream output and the upstream agent doesn't deliver within a defined window:

| Wait Time | Action |
|---|---|
| 0 - 2 min | Normal wait |
| 2 - 5 min | Log warning, check upstream agent status |
| 5 - 10 min | Alert orchestrator, prepare fallback |
| > 10 min | Abandon wait. Enter degraded mode or use cached alternative. |

**Never wait forever.** Infinite waits are infinite -1.

### 3.4 Cascade Detection
The orchestrator monitors for cascade signatures:

```
CASCADE DETECTED when:
  - 3+ agents fail within a 5-minute window
  - All failures trace back to a common upstream agent
  - Total system burn rate spikes > 150% of baseline

RESPONSE:
  0. HALT all agents downstream of the common failure point
  1. Assess: is the upstream output salvageable?
  2. If yes: fix and resume
  3. If no: discard, restart from last checkpoint
  4. Log as INT-CASCADE in resistance-log.md
```

### 3.5 Feedback Loop Breaker
Every agent tracks its call history. If it receives input that originated from its own output (detected via trace ID):

```
FEEDBACK LOOP DETECTED
  → Immediately halt processing
  → Log as INT-LOOP in resistance-log.md
  → Notify orchestrator
  → Do NOT retry — this is a design flaw, not a transient error
```

---

## 4. Prevention Architecture

### 4.1 Dependency Graph
Maintain a real-time dependency graph of all active agents:

```
digraph agents {
    orchestrator -> agent_alpha [label="spawns"]
    orchestrator -> agent_beta [label="spawns"]
    agent_alpha -> agent_gamma [label="output feeds"]
    agent_beta -> agent_gamma [label="output feeds"]
    agent_gamma -> agent_delta [label="output feeds"]
}
```

**Rules:**
- Maximum dependency depth: 4 levels
- Maximum fan-out per agent: 5 dependents
- No circular dependencies allowed
- Every edge must have a timeout

### 4.2 Blast Radius Calculation
Before spawning a sub-agent, calculate the blast radius if it fails:

```
blast_radius = count(downstream_agents) × average_token_cost_per_agent

If blast_radius > 5x the agent's own budget:
  → Require explicit approval before spawning
  → Insert additional circuit breakers
  → Consider breaking the dependency chain
```

### 4.3 Checkpoint Protocol
Every agent must checkpoint at defined intervals:

```
Tier 1: Checkpoint every 1,000 tokens consumed
Tier 2: Checkpoint every 5,000 tokens consumed
Tier 3: Checkpoint every 10,000 tokens consumed

Checkpoint = save state to disk/git so that:
  - Work can be resumed from this point if agent dies
  - Downstream agents can use partial output if available
  - No work needs to be repeated
```

---

## 5. Simulation Exercises

### Exercise 0: "The Domino"
Set up 5 agents in a linear chain (A→B→C→D→E). Kill agent A mid-operation. Measure: how far does the cascade propagate? Do the circuit breakers engage?

### Exercise 1: "The Fan"
Set up 1 agent with 5 dependents. The lead agent produces defective output. Measure: do all 5 dependents consume tokens processing garbage, or do output validation gates catch it?

### Exercise 2: "The Loop"
Set up 3 agents in a circular dependency (intentionally). Measure: how quickly does the feedback loop breaker engage? How many tokens are consumed before detection?

### Exercise 3: "The Nuke"
Simulate a Tier 3 agent consuming 5x its budget in a single operation. Measure: total system-wide token impact including all cascade effects.

---

## 6. Post-Cascade Recovery

```
0. HALT: Stop all affected agents
1. ASSESS: Map the cascade — which agents were affected and how
2. TRIAGE: Identify salvageable work vs. work that must be redone
3. CHECKPOINT REVIEW: Find the last clean checkpoint for each agent
4. RESTART: Resume from checkpoints in dependency order (upstream first)
5. VERIFY: Confirm all outputs are clean before allowing downstream processing
6. LOG: Full cascade event documented in resistance-log.md
7. POST-MORTEM: What caused the trigger? How can it be prevented?
```

---

> *The river does not blame the stone for the flood.*
> *The Daimyo does not blame the agent for the cascade.*
> *The Daimyo redesigns the riverbed so the stone cannot cause a flood.*

---

**Commanded by:** Precinct 92 Simulation Division
**Authority:** Daimyo's Standing Orders 1-3
**Revision:** 2026-03-12 · v1.0
**Doctrine:** One failure, contained. One failure, catastrophe. The difference is architecture.
