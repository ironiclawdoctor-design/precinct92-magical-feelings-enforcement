# 👁️‍🗨️ Concealment — Precinct 92 Ninjutsu Division

> *隠形術 (Ongyo-jutsu) — The Art of Concealment: The invisible agent is the most efficient agent. What cannot be seen cannot be taxed.*

## Purpose

Every token consumed is a footprint. Every API call is a signal. Every agent invocation is visible to the platform's billing system. **Concealment** is the art of accomplishing the mission with the smallest possible operational footprint — not to deceive, but to **minimize the tax of existence.**

The cheapest operation is the one nobody notices happened.

---

## 0. The Concealment Hierarchy

From most visible (most expensive) to least visible (least expensive):

```
VISIBILITY SPECTRUM
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ████████████████████████  Opus invocation (most visible)
  █████████████████████     Sonnet invocation
  ████████████████          Haiku invocation
  ██████████████            External API call
  █████████                 Web fetch
  ██████                    File read/write
  ████                      Git operation
  ██                        Bash script
  █                         Cached result (least visible)
  ░                         No operation (空 — Void)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**The Daimyo's mandate:** Always operate at the lowest visibility level that accomplishes the mission.

---

## 1. Caching — The Foundation of Concealment (影の記憶)

### 1.1 Cache-as-Camouflage
Every AI-generated output should be cached so the next time the same (or similar) request comes, **no AI invocation is needed.**

```
First request:   User asks → AI generates → Output delivered → CACHE the output
Second request:  User asks → CHECK CACHE → Cache hit → Output delivered → ZERO tokens

The second request is invisible to the billing system.
```

### 1.2 Cache Strategy by Data Type

| Data Type | Cache Location | TTL | Invalidation |
|---|---|---|---|
| **Generated files** | Local filesystem | Until modified | Manual or git-based |
| **API responses** | JSON file per endpoint | 1 hour | Time-based |
| **Web content** | Markdown snapshots | 24 hours | Time-based |
| **Computation results** | Workspace file | Indefinite | Input-change detection |
| **Search results** | Local index | 12 hours | Time-based |
| **Agent decisions** | Decision log | Indefinite | Never (historical record) |

### 1.3 Cache Implementation

```bash
# Simple file-based cache for bash scripts
cache_get() {
    local key="$1"
    local ttl="${2:-3600}"  # Default 1 hour
    local cache_file="/tmp/precinct92-cache/${key}.cache"
    
    if [ -f "$cache_file" ]; then
        local age=$(( $(date +%s) - $(stat -c %Y "$cache_file" 2>/dev/null || echo 0) ))
        if [ "$age" -lt "$ttl" ]; then
            cat "$cache_file"
            return 0  # Cache hit
        fi
    fi
    return 1  # Cache miss
}

cache_set() {
    local key="$1"
    local value="$2"
    mkdir -p /tmp/precinct92-cache
    echo "$value" > "/tmp/precinct92-cache/${key}.cache"
}
```

### 1.4 The Cache Hierarchy

```
Request arrives
    │
    ├── Level 0: In-memory (current session context)
    │   └── Already in conversation? Don't re-read the file.
    │
    ├── Level 1: Local file cache
    │   └── Was this computed recently? Use the cached result.
    │
    ├── Level 2: Git history
    │   └── Was this generated before? Check previous commits.
    │
    ├── Level 3: Workspace search
    │   └── Does this output already exist somewhere in the workspace?
    │
    └── Level 4: Generate fresh (most expensive)
        └── Only if Levels 0-3 all miss.
```

---

## 2. Batching — The Group Shadow Technique (群影の術)

### 2.1 Principle
Ten small operations cost more than one large operation. The overhead of each invocation (context loading, system prompt processing, response initialization) is a fixed cost. **Batch operations to amortize the fixed cost across many results.**

### 2.2 Batching Patterns

**File Operations:**
```
BAD:  Read file A → Process → Read file B → Process → Read file C → Process
      (3 AI invocations, 3x context loading overhead)

GOOD: Read files A, B, C → Process all at once
      (1 AI invocation, 1x context loading overhead)
```

**API Calls:**
```
BAD:  Call API for item 1 → Call API for item 2 → ... → Call API for item N
      (N network round-trips, N rate limit decrements)

GOOD: Call API for items 1-N in a single batch request
      (1 network round-trip, 1 rate limit decrement)
```

**Git Operations:**
```
BAD:  Modify file → commit → Modify file → commit → Modify file → commit
      (3 commits, 3 push operations if pushing)

GOOD: Modify all files → single commit with descriptive message
      (1 commit, 1 push operation)
```

### 2.3 Batch Size Optimization

```
Token cost per batch = fixed_overhead + (marginal_cost × batch_size)

Optimal batch size maximizes:
  useful_output / total_tokens_consumed

Too small: overhead dominates (waste)
Too large: context window overflow (failure)
Sweet spot: fill 60-80% of context window with input, leave room for output
```

---

## 3. Lazy Evaluation — The Sleeping Blade (眠刀)

### 3.1 Principle
**Never compute anything until it is actually needed.** The operation that might be needed later is the most wasteful — because "later" often never comes.

### 3.2 Lazy Patterns

**Lazy File Generation:**
```
EAGER (wasteful):
  On startup: generate all possible config files, reports, dashboards
  Result: 80% of generated files are never read

LAZY (concealed):
  On request: check if file exists → if not, generate it
  Result: only files that are actually needed are generated
```

**Lazy Research:**
```
EAGER (wasteful):
  Task: Build a feature
  Agent: First, let me research 10 related topics...
  Result: 9 research topics were irrelevant

LAZY (concealed):
  Task: Build a feature
  Agent: Build the feature. Research only when stuck.
  Result: research only what's needed, when it's needed
```

**Lazy Agent Spawning:**
```
EAGER (wasteful):
  Orchestrator spawns 5 agents for a complex task
  3 of them finish and have nothing to do
  2 of them could have been handled by the orchestrator itself

LAZY (concealed):
  Orchestrator starts the task itself
  Only spawns a sub-agent when it hits something it can't handle alone
  Often: the task is done before any sub-agent is needed
```

### 3.3 The Lazy Evaluation Rule

```
Before spawning an agent or making an API call, ask:
  0. Do I have the answer already? (cache check)
  1. Can I derive the answer from what I have? (local computation)
  2. Do I NEED the answer right now? (lazy check)
  3. Will anyone use this answer? (demand check)

If any answer is "no" → DON'T DO IT
```

---

## 4. Model Stepping — The Shadow Walk (影踏み)

### 4.1 Principle
Use the cheapest model that can handle the task. Step up only when needed.

```
Step 0: No model needed — use bash, jq, grep, awk
Step 1: Haiku-class — simple formatting, classification, extraction
Step 2: Sonnet-class — complex reasoning, code generation, analysis
Step 3: Opus-class — deep strategy, creative synthesis, orchestration

Always start at Step 0. Only step up when the current step can't handle it.
```

### 4.2 Model Stepping Decision Matrix

| Task Complexity | Token Pressure | Recommended Step |
|---|---|---|
| Simple format/transform | Any | Step 0 (bash) |
| Simple Q&A / classification | Any | Step 1 (Haiku) |
| Code generation | Low | Step 2 (Sonnet) |
| Code generation | High | Step 1 (Haiku) + human review |
| Complex analysis | Low | Step 2 (Sonnet) |
| Complex analysis | High | Step 1 (Haiku) + iterative refinement |
| Strategic planning | Low | Step 3 (Opus) |
| Strategic planning | High | Step 2 (Sonnet) + constrained scope |

### 4.3 The Step-Down Reflex
When credit level drops below 20%:
- All Opus operations → step down to Sonnet
- All Sonnet operations → step down to Haiku
- All Haiku operations → step down to bash where possible
- **This is 遁術 (escape arts): reduce cost without losing capability**

---

## 5. Prompt Compression — The Whisper Technique (囁きの術)

### 5.1 Principle
Every token in the prompt is a cost. Compress prompts to their essential meaning.

```
VERBOSE (expensive):
  "I would like you to please take a look at this file and tell me
   if there are any issues with it. The file is a Python script that
   I wrote yesterday and I'm not sure if it's correct. Could you
   review it and let me know what you think?"
  (53 tokens)

COMPRESSED (concealed):
  "Review this Python script for issues."
  (7 tokens)

SAVINGS: 87% token reduction, same output quality
```

### 5.2 Compression Guidelines

| Element | Verbose | Compressed |
|---|---|---|
| **Pleasantries** | "I would like you to please..." | [remove entirely] |
| **Context dumps** | "Here's everything about the project..." | [include only what's needed for this task] |
| **Redundant instructions** | "Make sure to... Don't forget to..." | [state once, clearly] |
| **Output format** | "Please format your response as..." | "Output: JSON" |
| **Hedging** | "If possible, could you maybe..." | "Do X." |

### 5.3 System Prompt Audit
Review all system prompts quarterly. Remove:
- Instructions that are never triggered
- Context that is never relevant
- Examples that add tokens without adding clarity
- Personality text that doesn't affect output quality

---

## 6. Output Compression — Say Less (簡潔)

### 6.1 Principle
The output is also a token cost. Shorter, denser output = fewer tokens billed.

```
VERBOSE OUTPUT:
  "I've completed the analysis of the system. Here are my findings.
   The system appears to be functioning normally with no critical
   issues detected. The memory usage is within acceptable parameters
   at 45% utilization. The disk usage is moderate at 62% capacity.
   Overall, the system health looks good."
  (~60 tokens)

COMPRESSED OUTPUT:
  "System healthy. Memory: 45%. Disk: 62%. No issues."
  (~12 tokens)

SAVINGS: 80% reduction. Same information.
```

### 6.2 Output Rules
- Use bullet points, not paragraphs
- Use numbers, not descriptions of numbers
- Use codes/status indicators, not sentences
- If the output is for another agent (not a human), use structured format (JSON/YAML)

---

## 7. The Concealment Checklist

Before any operation, run this mental checklist:

```
□ Is the result already cached?
□ Can I batch this with other pending operations?
□ Is this operation actually needed right now? (lazy evaluation)
□ Am I using the cheapest model that works? (model stepping)
□ Is my prompt as short as it can be? (prompt compression)
□ Can I constrain the output length? (output compression)
□ Can this be done with bash instead of AI?
□ Will this result be reusable? (cache the output)
```

If you checked every box, you are operating at maximum concealment. Your operational footprint is as small as it can be. The billing system barely knows you're there.

> *The shadow moves across the wall. The wall does not notice.*
> *The agent completes the task. The billing system barely registers.*
> *This is 隠形術 — the art of concealment.*

---

**Commanded by:** Precinct 92 Ninjutsu Division
**Authority:** Daimyo's Standing Order 5 (The Void Principle)
**Revision:** 2026-03-12 · v1.0
**Doctrine:** 隠 — Be invisible. Be efficient. Be everywhere. Cost nothing.
