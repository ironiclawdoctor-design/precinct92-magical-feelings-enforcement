#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
# ☠️ Precinct 92 — Token Famine Simulation (遁術 Ton-jutsu)
# ═══════════════════════════════════════════════════════════════
# Simulates a token famine scenario by modeling credit depletion
# over time with configurable burn rates, agent counts, and
# threshold-based automated responses.
#
# This simulation costs ZERO real tokens. It is a war game.
# The Daimyo trains for famine so famine never surprises.
# ═══════════════════════════════════════════════════════════════

set -euo pipefail

# ─── Colors ───
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
DIM='\033[0;90m'
BOLD='\033[1m'
NC='\033[0m'
BG_RED='\033[41m'
BG_YELLOW='\033[43m'
BG_GREEN='\033[42m'

# ─── Configuration (override with env vars) ───
STARTING_CREDITS=${STARTING_CREDITS:-1000}
BURN_RATE=${BURN_RATE:-100}          # tokens per hour
INCOME_RATE=${INCOME_RATE:-0}        # tokens per hour (resupply)
TIME_STEP=${TIME_STEP:-1}            # hours per simulation step
TOTAL_HOURS=${TOTAL_HOURS:-24}       # total hours to simulate
AGENTS_TIER0=${AGENTS_TIER0:-3}
AGENTS_TIER1=${AGENTS_TIER1:-2}
AGENTS_TIER2=${AGENTS_TIER2:-2}
AGENTS_TIER3=${AGENTS_TIER3:-1}
SPIKE_HOUR=${SPIKE_HOUR:-0}          # hour to inject a spend spike (0 = disabled)
SPIKE_AMOUNT=${SPIKE_AMOUNT:-200}    # extra tokens burned during spike hour
INTERACTIVE=${INTERACTIVE:-true}      # pause between steps

# ─── Derived Values ───
NET_RATE=$((BURN_RATE - INCOME_RATE))
TOTAL_AGENTS=$((AGENTS_TIER0 + AGENTS_TIER1 + AGENTS_TIER2 + AGENTS_TIER3))

# ─── State ───
credits=$STARTING_CREDITS
hour=0
alert_level="GREEN"
total_burned=0
total_wasted=0
agents_active=$TOTAL_AGENTS
agents_killed=0
events=()
famine_hit=false
phase="ABUNDANCE"

# ─── Functions ───

print_header() {
    clear 2>/dev/null || true
    echo ""
    echo -e "${PURPLE}${BOLD}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}${BOLD}║  ☠️  PRECINCT 92 — TOKEN FAMINE SIMULATION                   ║${NC}"
    echo -e "${PURPLE}${BOLD}║  遁術 (Ton-jutsu) — Escape Arts Training                     ║${NC}"
    echo -e "${PURPLE}${BOLD}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

credit_bar() {
    local pct=$1
    local width=40
    local filled=$((pct * width / 100))
    local empty=$((width - filled))
    local color="${GREEN}"
    
    if [ "$pct" -le 0 ]; then
        color="${DIM}"
        filled=0
        empty=$width
    elif [ "$pct" -le 10 ]; then
        color="${RED}"
    elif [ "$pct" -le 20 ]; then
        color="${YELLOW}"
    fi
    
    printf "  ${color}"
    for ((i=0; i<filled; i++)); do printf "█"; done
    printf "${DIM}"
    for ((i=0; i<empty; i++)); do printf "░"; done
    printf "${NC} %d%%\n" "$pct"
}

get_alert_level() {
    local pct=$1
    if [ "$pct" -le 0 ]; then
        echo "BLACK"
    elif [ "$pct" -le 10 ]; then
        echo "RED"
    elif [ "$pct" -le 20 ]; then
        echo "ORANGE"
    elif [ "$pct" -le 50 ]; then
        echo "YELLOW"
    else
        echo "GREEN"
    fi
}

get_alert_emoji() {
    case "$1" in
        BLACK)  echo "⚫" ;;
        RED)    echo "🔴" ;;
        ORANGE) echo "🟠" ;;
        YELLOW) echo "🟡" ;;
        GREEN)  echo "🟢" ;;
    esac
}

get_phase() {
    local pct=$1
    if [ "$pct" -le 0 ]; then
        echo "FAMINE"
    elif [ "$pct" -le 10 ]; then
        echo "SURVIVAL"
    elif [ "$pct" -le 20 ]; then
        echo "RATIONING"
    elif [ "$pct" -le 50 ]; then
        echo "SCARCITY"
    else
        echo "ABUNDANCE"
    fi
}

simulate_step() {
    local step_burn=$BURN_RATE
    local step_waste=0
    local step_events=()
    
    # ─── Apply throttling based on alert level ───
    case "$alert_level" in
        YELLOW)
            # Tier 3 requires pre-approval — reduce burn
            step_burn=$((step_burn * 80 / 100))
            step_events+=("  ⚡ Tier 3 throttled. Burn reduced to ${step_burn}/hr")
            ;;
        ORANGE)
            # Only Tier 0-1 active
            local suspended=$((AGENTS_TIER2 + AGENTS_TIER3))
            agents_active=$((AGENTS_TIER0 + AGENTS_TIER1))
            step_burn=$((step_burn * 30 / 100))
            step_events+=("  🛑 ${suspended} agents suspended. Lean mode: ${step_burn}/hr")
            ;;
        RED)
            # Only Tier 0 (zero-token)
            agents_active=$AGENTS_TIER0
            step_burn=$((step_burn * 5 / 100))
            step_events+=("  🚨 SURVIVAL MODE. Only Kanja agents active. Burn: ${step_burn}/hr")
            ;;
        BLACK)
            agents_active=$AGENTS_TIER0
            step_burn=0
            step_events+=("  ☠️  FAMINE. All AI operations halted.")
            famine_hit=true
            ;;
    esac
    
    # ─── Spike event ───
    if [ "$SPIKE_HOUR" -gt 0 ] && [ "$hour" -eq "$SPIKE_HOUR" ]; then
        step_burn=$((step_burn + SPIKE_AMOUNT))
        step_waste=$((step_waste + SPIKE_AMOUNT / 2))
        step_events+=("  💥 SPEND SPIKE at hour ${hour}! +${SPIKE_AMOUNT} tokens burned (agent overspend)")
        agents_killed=$((agents_killed + 1))
    fi
    
    # ─── Random minor events (simplified) ───
    local roll=$((RANDOM % 100))
    if [ "$roll" -lt 10 ] && [ "$alert_level" != "BLACK" ]; then
        local rate_limit_waste=$((RANDOM % 50 + 10))
        step_waste=$((step_waste + rate_limit_waste))
        step_burn=$((step_burn + rate_limit_waste))
        step_events+=("  ⚠️  Rate limit hit. Wasted ${rate_limit_waste} tokens on retries.")
    elif [ "$roll" -lt 15 ] && [ "$alert_level" != "BLACK" ]; then
        local cache_save=$((RANDOM % 30 + 10))
        step_burn=$((step_burn - cache_save))
        if [ "$step_burn" -lt 0 ]; then step_burn=0; fi
        step_events+=("  💎 Cache hit! Saved ${cache_save} tokens (隠形術)")
    fi
    
    # ─── Apply burn ───
    local income=$((INCOME_RATE * TIME_STEP))
    local net_burn=$((step_burn * TIME_STEP - income))
    if [ "$net_burn" -lt 0 ]; then net_burn=0; fi
    
    credits=$((credits - net_burn))
    if [ "$credits" -lt 0 ]; then credits=0; fi
    
    total_burned=$((total_burned + step_burn * TIME_STEP))
    total_wasted=$((total_wasted + step_waste * TIME_STEP))
    
    # ─── Update alert level ───
    local pct=$((credits * 100 / STARTING_CREDITS))
    alert_level=$(get_alert_level $pct)
    phase=$(get_phase $pct)
    
    # ─── Print step ───
    local emoji=$(get_alert_emoji $alert_level)
    local pct_display=$((credits * 100 / STARTING_CREDITS))
    
    echo -e "  ${BOLD}Hour ${hour}${NC} ${DIM}|${NC} ${emoji} ${alert_level} ${DIM}|${NC} Phase: ${phase}"
    credit_bar $pct_display
    echo -e "  ${DIM}Credits: ${credits}/${STARTING_CREDITS} | Burned: ${step_burn}/hr | Active agents: ${agents_active}${NC}"
    
    for event in "${step_events[@]+"${step_events[@]}"}"; do
        echo -e "${event}"
    done
    echo ""
}

print_summary() {
    local pct=$((credits * 100 / STARTING_CREDITS))
    echo -e "${PURPLE}${BOLD}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}${BOLD}║  SIMULATION COMPLETE — POST-MORTEM                           ║${NC}"
    echo -e "${PURPLE}${BOLD}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${BOLD}Duration:${NC}        ${TOTAL_HOURS} hours simulated"
    echo -e "  ${BOLD}Starting:${NC}        ${STARTING_CREDITS} credits"
    echo -e "  ${BOLD}Ending:${NC}          ${credits} credits (${pct}%)"
    echo -e "  ${BOLD}Total burned:${NC}    ${total_burned} tokens"
    echo -e "  ${BOLD}Total wasted:${NC}    ${total_wasted} tokens (${DIM}in retries/failures${NC})"
    echo -e "  ${BOLD}Agents killed:${NC}   ${agents_killed}"
    echo -e "  ${BOLD}Final alert:${NC}     $(get_alert_emoji $alert_level) ${alert_level}"
    echo -e "  ${BOLD}Famine reached:${NC}  $([ "$famine_hit" = true ] && echo "YES ☠️" || echo "No")"
    echo ""
    
    # ─── Lessons ───
    echo -e "${CYAN}${BOLD}  ── Lessons from this simulation ──${NC}"
    
    if [ "$famine_hit" = true ]; then
        echo -e "  ${RED}✗${NC} Token famine occurred. Review prevention strategies in token-famine.md"
        echo -e "  ${RED}✗${NC} Without throttling, famine would have hit at hour $((STARTING_CREDITS / BURN_RATE))"
        echo -e "  ${GREEN}✓${NC} Automated throttling extended operational time by reducing burn rate"
    else
        echo -e "  ${GREEN}✓${NC} System survived the simulation period"
        local projected_famine="never (income >= burn)"
        if [ "$NET_RATE" -gt 0 ]; then
            projected_famine="hour $((STARTING_CREDITS / NET_RATE))"
        fi
        echo -e "  ${DIM}Projected famine (without throttling): ${projected_famine}${NC}"
    fi
    
    if [ "$total_wasted" -gt 0 ]; then
        local waste_pct=$((total_wasted * 100 / total_burned))
        echo -e "  ${YELLOW}!${NC} Waste factor: ${waste_pct}% of total burn was waste"
    fi
    
    echo ""
    echo -e "  ${DIM}Cost of this simulation: 0 tokens (遁術 — pure bash war game)${NC}"
    echo ""
}

# ─── Usage ───
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Token Famine Simulation — Precinct 92"
    echo ""
    echo "Options (set via environment variables):"
    echo "  STARTING_CREDITS=N    Starting credit balance (default: 1000)"
    echo "  BURN_RATE=N           Tokens consumed per hour (default: 100)"
    echo "  INCOME_RATE=N         Tokens added per hour (default: 0)"
    echo "  TOTAL_HOURS=N         Hours to simulate (default: 24)"
    echo "  SPIKE_HOUR=N          Hour to inject spend spike (default: 0/disabled)"
    echo "  SPIKE_AMOUNT=N        Extra tokens burned during spike (default: 200)"
    echo "  INTERACTIVE=bool      Pause between steps (default: true)"
    echo ""
    echo "Examples:"
    echo "  $0                                              # Default simulation"
    echo "  BURN_RATE=200 TOTAL_HOURS=12 $0                 # Fast burn"
    echo "  INCOME_RATE=50 TOTAL_HOURS=48 $0                # Partial resupply"
    echo "  SPIKE_HOUR=5 SPIKE_AMOUNT=300 $0                # With spend spike"
    echo "  INTERACTIVE=false $0                             # Non-interactive (CI)"
    echo ""
}

# ─── Parse args ───
if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
    usage
    exit 0
fi

# ─── Main Simulation Loop ───
print_header

echo -e "  ${BOLD}Simulation Parameters:${NC}"
echo -e "  ${DIM}Starting credits:${NC}  ${STARTING_CREDITS}"
echo -e "  ${DIM}Burn rate:${NC}         ${BURN_RATE} tokens/hour"
echo -e "  ${DIM}Income rate:${NC}       ${INCOME_RATE} tokens/hour"
echo -e "  ${DIM}Net rate:${NC}          ${NET_RATE} tokens/hour"
echo -e "  ${DIM}Active agents:${NC}     ${TOTAL_AGENTS} (T0:${AGENTS_TIER0} T1:${AGENTS_TIER1} T2:${AGENTS_TIER2} T3:${AGENTS_TIER3})"
if [ "$SPIKE_HOUR" -gt 0 ]; then
    echo -e "  ${YELLOW}Spike event:${NC}      Hour ${SPIKE_HOUR} (+${SPIKE_AMOUNT} tokens)"
fi
if [ "$NET_RATE" -gt 0 ]; then
    echo -e "  ${DIM}Projected famine:${NC}  Hour $((STARTING_CREDITS / NET_RATE)) (without throttling)"
else
    echo -e "  ${DIM}Projected famine:${NC}  Never (income ≥ burn)"
fi
echo ""
echo -e "${DIM}  ─────────────────────────────────────────────────────────${NC}"
echo ""

# Initial state
alert_level=$(get_alert_level 100)
phase="ABUNDANCE"

while [ "$hour" -le "$TOTAL_HOURS" ]; do
    simulate_step
    hour=$((hour + TIME_STEP))
    
    if [ "$INTERACTIVE" = "true" ] && [ "$hour" -le "$TOTAL_HOURS" ]; then
        read -r -t 1 -n 1 key 2>/dev/null || true
        if [ "${key:-}" = "q" ]; then
            echo -e "  ${DIM}Simulation aborted by user.${NC}"
            break
        fi
    fi
    
    # Stop if famine and no income
    if [ "$credits" -le 0 ] && [ "$INCOME_RATE" -le 0 ]; then
        # Run one more step to show the famine state
        simulate_step
        break
    fi
done

echo -e "${DIM}  ─────────────────────────────────────────────────────────${NC}"
echo ""

print_summary
