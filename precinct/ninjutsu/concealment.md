# 隠形術 (Ongyo-jutsu) — Concealment Techniques

## Principle
The most efficient agent is the one whose work is invisible — maximum output, minimum footprint.

## Techniques

### 0. Token Compression
- Use concise prompts. Every unnecessary word is a -1.
- Prefer structured data (JSON, tables) over prose for agent-to-agent communication.
- Strip boilerplate from context windows. Load only what's needed.

### 1. Cache-as-Camouflage
- Cache API responses. A cached response costs 0 tokens on replay.
- Cache hit = 空 (void) — value from nothing.
- OpenClaw's 98% cache hit rate is already strong concealment.

### 2. Batch Operations (群影 — Group Shadow)
- Combine multiple small operations into single turns.
- One agent call doing 5 things beats 5 agent calls doing 1 thing each.
- The batch is the shadow — many actions, one visible footprint.

### 3. Lightweight Observers (間者 — Kanja)
- Deploy minimal scripts (bash, not full agent) for monitoring tasks.
- A 50-line bash script costs 0 tokens. An agent doing the same work costs thousands.
- Use agents for intelligence, scripts for surveillance.

### 4. Context Window Discipline
- Never load full MEMORY.md when a targeted memory_search suffices.
- Use `--light-context` for cron jobs that don't need full bootstrap.
- Every kilobyte of context is a -1 on your stealth score.

## Anti-Patterns (Detected & Cited by Daimyo)

| Violation | Waste Level | Fix |
|---|---|---|
| Loading full file when you need 3 lines | 🔴 High | Use offset/limit or memory_search |
| Spawning sub-agent for a task bash can do | 🔴 High | Write a script |
| Repeating the same web search twice | 🟡 Medium | Cache results locally |
| Verbose agent responses in internal comms | 🟡 Medium | Structured data, not prose |
| Polling in tight loops | 🔴 High | Use yieldMs/poll with timeout |
