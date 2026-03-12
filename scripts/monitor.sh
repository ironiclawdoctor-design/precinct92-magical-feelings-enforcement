#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
# 🏯 Precinct 92 — System Monitor (間者 Kanja)
# ═══════════════════════════════════════════════════════════════
# Zero-token system health check.
# This script costs NOTHING to run. Pure bash. Pure concealment.
# Run manually or via cron — the Daimyo's cheapest intelligence.
# ═══════════════════════════════════════════════════════════════

set -euo pipefail

# ─── Configuration ───
PRECINCT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
METRICS_DIR="${PRECINCT_DIR}/precinct/metrics"
CACHE_DIR="/tmp/precinct92-cache"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
DATE_SHORT=$(date -u +"%Y-%m-%d %H:%M UTC")

# Thresholds
MEM_WARN=70
MEM_CRIT=85
DISK_WARN=75
DISK_CRIT=90
LOAD_WARN_FACTOR=2  # multiplied by CPU count
PROC_WARN=500

# Colors
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
DIM='\033[0;90m'
BOLD='\033[1m'
NC='\033[0m'

# ─── Helper Functions ───
status_icon() {
    local value=$1 warn=$2 crit=$3
    if [ "$value" -ge "$crit" ]; then
        echo -e "${RED}🔴 CRITICAL${NC}"
    elif [ "$value" -ge "$warn" ]; then
        echo -e "${YELLOW}🟡 WARNING${NC}"
    else
        echo -e "${GREEN}🟢 NOMINAL${NC}"
    fi
}

bar_graph() {
    local value=$1 max=${2:-100} width=${3:-30}
    local filled=$((value * width / max))
    local empty=$((width - filled))
    local color="${GREEN}"
    
    if [ "$value" -ge 85 ]; then color="${RED}"
    elif [ "$value" -ge 70 ]; then color="${YELLOW}"
    fi
    
    printf "${color}"
    printf '█%.0s' $(seq 1 $filled 2>/dev/null) || true
    printf "${DIM}"
    printf '░%.0s' $(seq 1 $empty 2>/dev/null) || true
    printf "${NC} %d%%" "$value"
}

# ─── Gather Data ───

# Memory
MEM_TOTAL=$(free -m | awk '/Mem:/{print $2}')
MEM_USED=$(free -m | awk '/Mem:/{print $3}')
MEM_AVAILABLE=$(free -m | awk '/Mem:/{print $7}')
MEM_PERCENT=$((MEM_USED * 100 / MEM_TOTAL))

# Swap
SWAP_TOTAL=$(free -m | awk '/Swap:/{print $2}')
SWAP_USED=$(free -m | awk '/Swap:/{print $3}')
if [ "$SWAP_TOTAL" -gt 0 ]; then
    SWAP_PERCENT=$((SWAP_USED * 100 / SWAP_TOTAL))
else
    SWAP_PERCENT=0
fi

# Disk
DISK_PERCENT=$(df / | awk 'NR==2{print $5}' | tr -d '%')
DISK_TOTAL=$(df -h / | awk 'NR==2{print $2}')
DISK_USED=$(df -h / | awk 'NR==2{print $3}')
DISK_AVAIL=$(df -h / | awk 'NR==2{print $4}')

# CPU / Load
CPU_COUNT=$(nproc 2>/dev/null || echo 1)
LOAD_1=$(cat /proc/loadavg | awk '{print $1}')
LOAD_5=$(cat /proc/loadavg | awk '{print $2}')
LOAD_15=$(cat /proc/loadavg | awk '{print $3}')
LOAD_WARN=$((CPU_COUNT * LOAD_WARN_FACTOR))

# Processes
PROC_COUNT=$(ps aux | wc -l)

# Uptime
UPTIME=$(uptime -p 2>/dev/null || uptime | sed 's/.*up /up /' | sed 's/,.*//')

# Git status (in precinct repo)
GIT_STATUS="clean"
GIT_BRANCH="unknown"
if [ -d "${PRECINCT_DIR}/.git" ]; then
    cd "${PRECINCT_DIR}"
    GIT_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
    if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
        GIT_STATUS="dirty (uncommitted changes)"
    fi
    GIT_AHEAD=$(git rev-list --count HEAD@{upstream}..HEAD 2>/dev/null || echo "?")
    GIT_BEHIND=$(git rev-list --count HEAD..HEAD@{upstream} 2>/dev/null || echo "?")
fi

# ─── Determine Alert Level ───
ALERT_LEVEL="GREEN"
ALERT_EMOJI="🟢"

if [ "$MEM_PERCENT" -ge "$MEM_CRIT" ] || [ "$DISK_PERCENT" -ge "$DISK_CRIT" ]; then
    ALERT_LEVEL="RED"
    ALERT_EMOJI="🔴"
elif [ "$MEM_PERCENT" -ge "$MEM_WARN" ] || [ "$DISK_PERCENT" -ge "$DISK_WARN" ]; then
    ALERT_LEVEL="YELLOW"
    ALERT_EMOJI="🟡"
fi

# ─── Output Report ───
echo ""
echo -e "${PURPLE}${BOLD}┌─────────────────────────────────────────────────────────────┐${NC}"
echo -e "${PURPLE}${BOLD}│  🏯 PRECINCT 92 — SYSTEM MONITOR REPORT                    │${NC}"
echo -e "${PURPLE}${BOLD}│  間者 (Kanja) — Zero-Token Intelligence                     │${NC}"
echo -e "${PURPLE}${BOLD}└─────────────────────────────────────────────────────────────┘${NC}"
echo ""
echo -e "  ${DIM}Timestamp:${NC}  ${DATE_SHORT}"
echo -e "  ${DIM}Uptime:${NC}     ${UPTIME}"
echo -e "  ${DIM}Alert:${NC}      ${ALERT_EMOJI} ${ALERT_LEVEL}"
echo ""

# Memory
echo -e "${CYAN}${BOLD}  ── Memory ──${NC}"
echo -e "  Used:      $(bar_graph $MEM_PERCENT)  (${MEM_USED}M / ${MEM_TOTAL}M)"
echo -e "  Available: ${MEM_AVAILABLE}M"
echo -e "  Status:    $(status_icon $MEM_PERCENT $MEM_WARN $MEM_CRIT)"
if [ "$SWAP_TOTAL" -gt 0 ]; then
    echo -e "  Swap:      $(bar_graph $SWAP_PERCENT)  (${SWAP_USED}M / ${SWAP_TOTAL}M)"
fi
echo ""

# Disk
echo -e "${CYAN}${BOLD}  ── Disk (/) ──${NC}"
echo -e "  Used:      $(bar_graph $DISK_PERCENT)  (${DISK_USED} / ${DISK_TOTAL})"
echo -e "  Available: ${DISK_AVAIL}"
echo -e "  Status:    $(status_icon $DISK_PERCENT $DISK_WARN $DISK_CRIT)"
echo ""

# CPU / Load
echo -e "${CYAN}${BOLD}  ── CPU / Load ──${NC}"
echo -e "  CPUs:      ${CPU_COUNT}"
echo -e "  Load:      ${LOAD_1} (1m)  ${LOAD_5} (5m)  ${LOAD_15} (15m)"
echo -e "  Threshold: ${LOAD_WARN} (${CPU_COUNT} cores × ${LOAD_WARN_FACTOR})"
echo -e "  Processes: ${PROC_COUNT}"
echo ""

# Git
echo -e "${CYAN}${BOLD}  ── Repository ──${NC}"
echo -e "  Branch:    ${GIT_BRANCH}"
echo -e "  Status:    ${GIT_STATUS}"
if [ "${GIT_AHEAD}" != "?" ]; then
    echo -e "  Ahead:     ${GIT_AHEAD} commits"
    echo -e "  Behind:    ${GIT_BEHIND} commits"
fi
echo ""

# Workspace
echo -e "${CYAN}${BOLD}  ── Precinct Workspace ──${NC}"
ENFORCEMENT_FILES=$(find "${PRECINCT_DIR}/precinct/enforcement" -name "*.md" 2>/dev/null | wc -l)
SIMULATION_FILES=$(find "${PRECINCT_DIR}/precinct/simulation" -name "*.md" 2>/dev/null | wc -l)
NINJUTSU_FILES=$(find "${PRECINCT_DIR}/precinct/ninjutsu" -name "*.md" 2>/dev/null | wc -l)
METRICS_FILES=$(find "${PRECINCT_DIR}/precinct/metrics" -name "*.md" 2>/dev/null | wc -l)
echo -e "  Enforcement: ${ENFORCEMENT_FILES} files"
echo -e "  Simulation:  ${SIMULATION_FILES} files"
echo -e "  Ninjutsu:    ${NINJUTSU_FILES} files"
echo -e "  Metrics:     ${METRICS_FILES} files"
echo ""

# Cache
echo -e "${CYAN}${BOLD}  ── Cache (隠形術) ──${NC}"
if [ -d "$CACHE_DIR" ]; then
    CACHE_FILES=$(find "$CACHE_DIR" -type f 2>/dev/null | wc -l)
    CACHE_SIZE=$(du -sh "$CACHE_DIR" 2>/dev/null | awk '{print $1}')
    echo -e "  Files:     ${CACHE_FILES}"
    echo -e "  Size:      ${CACHE_SIZE}"
else
    echo -e "  ${DIM}No cache directory. Create with: mkdir -p ${CACHE_DIR}${NC}"
fi
echo ""

# Summary
echo -e "${PURPLE}${BOLD}┌─────────────────────────────────────────────────────────────┐${NC}"
echo -e "${PURPLE}${BOLD}│  Summary                                                    │${NC}"
echo -e "${PURPLE}${BOLD}└─────────────────────────────────────────────────────────────┘${NC}"
echo -e "  ${ALERT_EMOJI} System: ${ALERT_LEVEL} | Mem: ${MEM_PERCENT}% | Disk: ${DISK_PERCENT}% | Load: ${LOAD_1}"
echo -e "  ${DIM}Cost of this report: 0 tokens (間者 — pure bash intelligence)${NC}"
echo ""

# ─── Log to file ───
mkdir -p "${CACHE_DIR}"
LOG_FILE="${CACHE_DIR}/monitor-$(date -u +%Y%m%d).log"
echo "${TIMESTAMP} | ${ALERT_LEVEL} | mem=${MEM_PERCENT}% disk=${DISK_PERCENT}% load=${LOAD_1} procs=${PROC_COUNT}" >> "$LOG_FILE"

# ─── Exit code based on alert level ───
case "$ALERT_LEVEL" in
    RED)    exit 2 ;;
    YELLOW) exit 1 ;;
    *)      exit 0 ;;
esac
