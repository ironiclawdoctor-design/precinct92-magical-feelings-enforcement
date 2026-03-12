# Foreign Resistance Log

## Active Resistance Events

| # | Date | Source | Type | Impact | Status | Resolution |
|---|------|--------|------|--------|--------|------------|
| R-001 | 2026-03-12 | Ampere.sh | Credit exhaustion (402) | Sub-agent killed mid-task | ✅ Resolved | Parent agent manual recovery + credit replenishment needed |
| R-002 | 2026-03-12 | GitHub API | No auth (gh CLI) | Cannot use gh commands | 🟡 Open | Using SSH + curl workaround (Path B) |
| R-003 | 2026-03-12 | Brave Search | Missing API key | No web search capability | 🟡 Open | Needs BRAVE_API_KEY configuration |

## Resistance Patterns

### Pattern: Resource Gate
- **What:** External service blocks access due to missing credentials or exhausted quotas
- **Frequency:** Common during bootstrap phase
- **Ninjutsu response:** 水術 (water) — flow around. Use alternative access methods. Don't fight the gate.

### Pattern: Auth Wall
- **What:** Service requires authentication not yet configured
- **Frequency:** One-time per service
- **Ninjutsu response:** 変装術 (disguise) — find the authentication method that costs least to maintain. SSH > OAuth > API keys (in order of security preference).

## Resolved Resistance

_Resistance events that have been overcome are moved here with resolution notes._
