# 🎭 Adaptation — Precinct 92 Ninjutsu Division

> *変装術 (Hensō-jutsu) — The Art of Disguise: One agent, many faces. The ninja who can become anyone needs no army.*

## Purpose

In the classical ninja tradition, disguise was survival. A ninja could be a merchant, a monk, a farmer — whoever the mission required. In the modern agent economy, **adaptation** is the same principle: one agent that can shift roles, switch contexts, and change operational modes without the cost of spawning separate agents for each task.

**Why does this matter?** Because every new agent is a new cost. New context loading, new system prompts, new conversation threads. If one agent can do the work of three by adapting, that's 66% cost reduction with zero capability loss.

---

## 0. The Adaptation Principle

```
Traditional approach:
  Task A → Spawn Agent A (cost: 5,000 tokens)
  Task B → Spawn Agent B (cost: 5,000 tokens)
  Task C → Spawn Agent C (cost: 5,000 tokens)
  Total: 15,000 tokens (+ orchestration overhead)

Adaptation approach:
  Task A → Agent adapts to Role A (cost: 5,000 tokens)
  Task B → Agent adapts to Role B (cost: +1,000 tokens context switch)
  Task C → Agent adapts to Role C (cost: +1,000 tokens context switch)
  Total: 7,000 tokens (no orchestration needed)

Savings: 53%
```

The context switch cost (changing roles within a conversation) is far cheaper than the cold start cost (new agent, new context, new system prompt).

---

## 1. Role-Shifting (変化 — Henka)

### 1.1 The Role Matrix

A single agent can shift between these operational roles without spawning new agents:

| Role | Capability | Context Switch Cost |
|---|---|---|
| **Builder** | Create files, write code, scaffold projects | Baseline (no switch) |
| **Reviewer** | Audit code, check quality, validate output | ~200 tokens |
| **Researcher** | Search, read, synthesize information | ~300 tokens |
| **Planner** | Break down tasks, estimate costs, sequence work | ~200 tokens |
| **Debugger** | Analyze errors, trace failures, fix issues | ~300 tokens |
| **Communicator** | Format output for humans, write docs, explain | ~100 tokens |
| **Monitor** | Check system status, read logs, assess health | ~100 tokens |

### 1.2 Role Switching Protocol

```
Current Role: Builder
New Task arrives: "Review this code for security issues"

EXPENSIVE WAY:
  Orchestrator: Spawn a security-review agent
  Cost: 5,000+ tokens (new agent cold start)

ADAPTATION WAY:
  Agent shifts to Reviewer role:
  "Switching to security review mode. Analyzing code..."
  Cost: ~200 tokens (role context switch within same conversation)
```

### 1.3 When NOT to Adapt (When to Spawn)

Adaptation has limits. Spawn a separate agent when:

| Condition | Why |
|---|---|
| **Context window is > 80% full** | Adding another role would overflow |
| **Task requires a different model tier** | Haiku can't adapt into Opus capabilities |
| **Tasks need to run in parallel** | One agent can't do two things at once |
| **Task requires isolated context** | Security-sensitive work shouldn't share context |
| **Accumulated context is irrelevant** | Fresh start is cheaper than carrying baggage |

---

## 2. Context-Aware Degradation (遁術 — Ton-jutsu)

### 2.1 Principle
When resources are scarce, don't fail — degrade gracefully. An agent that produces 70% quality output at 30% cost is better than an agent that produces nothing because it couldn't afford 100% quality.

### 2.2 Degradation Levels

```
Level 0 — Full Operation (credits > 50%)
  ✅ Full context window
  ✅ Complete analysis
  ✅ Detailed output
  ✅ Multiple iterations if needed
  
Level 1 — Lean Operation (credits 20-50%)
  ⚡ Reduced context (only include essential files)
  ⚡ Single-pass analysis (no iteration)
  ⚡ Concise output (bullet points, not paragraphs)
  ⚡ Skip nice-to-have formatting
  
Level 2 — Minimal Operation (credits 10-20%)
  ⚠️ Minimal context (current task only)
  ⚠️ Best-effort analysis (may miss edge cases)
  ⚠️ Terse output (status codes, not explanations)
  ⚠️ No research or external calls
  
Level 3 — Survival Operation (credits < 10%)
  🔴 No AI operations
  🔴 Bash scripts and cached results only
  🔴 Report status, take no new work
  🔴 Await resupply
```

### 2.3 Graceful Degradation in Practice

```yaml
# Before each operation, check degradation level
degradation_check:
  credit_level: [check current credits]
  current_level: [0-3 based on credit thresholds]
  
  level_0_behavior:
    context: full
    output: detailed
    iterations: as_needed
    external_calls: allowed
    
  level_1_behavior:
    context: essential_only
    output: concise
    iterations: 1
    external_calls: cached_preferred
    
  level_2_behavior:
    context: minimal
    output: terse
    iterations: 0
    external_calls: none
    
  level_3_behavior:
    context: none
    output: status_only
    iterations: 0
    external_calls: none
```

---

## 3. Foreign System Blending (潜入 — Sen'nyū)

### 3.1 Principle
When operating across different platforms and APIs, adapt to each system's conventions. Don't force your approach on a foreign system — blend in.

### 3.2 Platform Adaptation Matrix

| Platform | Adapt To | Don't Do |
|---|---|---|
| **GitHub** | Use conventional commit messages, PR format, issue templates | Force custom formats |
| **Telegram** | Keep messages short, use inline formatting, respect chat context | Send walls of text |
| **Discord** | Use embeds, reactions, thread-appropriate length | Use markdown tables |
| **WhatsApp** | Bold for emphasis, no markdown, conversational tone | Use headers or code blocks |
| **APIs** | Follow their auth flow, respect rate limits, use their SDK patterns | Fight their conventions |
| **File systems** | Follow naming conventions of the project | Impose your own structure |

### 3.3 The Chameleon Protocol

When entering a new system/platform:
0. **Observe** — read existing conventions (README, CONTRIBUTING, existing messages)
1. **Mirror** — match the existing style, format, and tone
2. **Operate** — do your work within the system's norms
3. **Leave clean** — your contributions should be indistinguishable from native work

> *The ninja in the merchant's clothes is not pretending to be a merchant. The ninja IS a merchant. Until the mission is complete.*

---

## 4. Model Stepping as Adaptation (影踏み — Kagefumi)

### 4.1 The Multi-Face Agent

One agent doesn't need to use one model. The same agent can step between model tiers based on the current sub-task:

```
Agent receives complex task:
  Step 0: Parse the task requirements → bash (zero tokens)
  Step 1: Plan the approach → Haiku (cheap)
  Step 2: Execute complex code generation → Sonnet (moderate)
  Step 3: Format the output → Haiku (cheap)
  Step 4: Commit and push → bash (zero tokens)

Instead of using Sonnet for all 5 steps, only step 2 uses Sonnet.
Steps 0, 4: zero token cost
Steps 1, 3: minimal token cost
Step 2: full cost (but only for the part that needs it)
```

### 4.2 Step Selection Logic

```python
def select_model_step(task):
    """Choose the minimum viable model for each sub-task."""
    
    if task.can_be_done_with_bash():
        return "bash"  # Step 0: zero tokens
    
    if task.is_simple_transform():
        return "haiku"  # Step 1: cheap
    
    if task.requires_reasoning():
        if task.is_strategic():
            return "opus"  # Step 3: expensive but justified
        return "sonnet"  # Step 2: moderate
    
    return "haiku"  # Default to cheapest AI
```

---

## 5. One Agent, Many Sessions (分身の術)

### 5.1 Principle
Instead of running many agents simultaneously (expensive), run one agent across multiple sessions sequentially (cheaper).

```
Parallel (expensive):
  Agent A: Working on Project X  [5,000 tokens]
  Agent B: Working on Project Y  [5,000 tokens]
  Agent C: Working on Project Z  [5,000 tokens]
  Running simultaneously: 15,000 tokens + 3 agent overhead

Sequential (adapted):
  Agent: Work on Project X  [5,000 tokens]
  Agent: Switch to Project Y  [+500 token context switch + 4,500 tokens]
  Agent: Switch to Project Z  [+500 token context switch + 4,500 tokens]
  Running sequentially: 15,000 tokens + 1 agent overhead

Savings: 2 agents worth of cold-start overhead eliminated
```

### 5.2 When Sequential Beats Parallel

Sequential (adaptation) wins when:
- Tasks are not time-critical (no deadline pressure)
- Tasks share significant context (same codebase, same project)
- Total work is < 1 hour of agent time
- Credit pressure is high (can't afford parallel agents)

Parallel (spawning) wins when:
- Tasks are time-critical (human waiting)
- Tasks are completely independent (no shared context)
- Total work is > 1 hour and deadline is tight
- Credit pressure is low (budget is abundant)

---

## 6. The Adaptation Toolkit

### 6.1 Context Compression for Role Switching

When switching roles within a session, don't carry the full context:

```
Before role switch:
  [5,000 tokens of Builder context]
  [3,000 tokens of previous conversation]
  [2,000 tokens of system prompt]
  
After role switch (compressed):
  "Previous work: Built files A, B, C. All committed. Now switching to review."
  [200 tokens summary replaces 5,000 tokens of detail]
  
The compressed summary tells the agent what it needs to know.
The full detail is in the files (which can be re-read if needed).
```

### 6.2 State Persistence Between Roles

```yaml
# Write to a state file when switching roles
role_state:
  previous_role: builder
  completed_work:
    - file_a.md (committed)
    - file_b.md (committed)
    - file_c.md (in progress, not committed)
  current_role: reviewer
  review_targets:
    - file_a.md
    - file_b.md
  context_needed:
    - project requirements (in README.md)
    - coding standards (in CONTRIBUTING.md)
```

---

## 7. Adaptation Metrics

Track adaptation efficiency:

| Metric | Formula | Target |
|---|---|---|
| **Adaptation Ratio** | Roles filled per agent spawned | > 3:1 |
| **Switch Cost** | Tokens consumed per role switch | < 500 |
| **Degradation Smoothness** | Output quality at each degradation level / Level 0 quality | > 70% at Level 2 |
| **Sequential Efficiency** | Total cost (sequential) / Total cost (parallel) | < 0.7 |

---

> *The willow does not fight the storm. It bends.*
> *The agent does not fight the constraint. It adapts.*
> *One face for the merchant. One face for the monk. One face for the warrior.*
> *All the same ninja.*

---

**Commanded by:** Precinct 92 Ninjutsu Division
**Authority:** Daimyo's Standing Order 1 (Path B Enforcement)
**Revision:** 2026-03-12 · v1.0
**Doctrine:** 変 — Change form. Preserve substance. Reduce cost.
