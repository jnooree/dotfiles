#!/bin/bash

set -euo pipefail

IFS=$'\t' read -r MODEL EFFORT CTX RL5 RL7 DUR < <(
	jq -r '
	[
		(.model.display_name // "?"),
		(.effort.level // "(no effort)"),
		((.context_window.used_percentage // 0) * 10 | round / 10),
		((.rate_limits.five_hour.used_percentage // 0) * 10 | round / 10),
		((.rate_limits.seven_day.used_percentage // 0) * 10 | round / 10),
		(.cost.total_duration_ms // 0)
	] | map(tostring) | join("\t")'
)

CAVEMAN_SL="$(
	jq -r '.plugins["caveman@caveman"][0].installPath' ~/.claude/plugins/installed_plugins.json
)/src/hooks/caveman-statusline.sh"

CYAN=$'\033[36m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
RESET=$'\033[0m'

function _floor() {
	echo "${1%.*}"
}

function pick_color_pct() {
	local n color

	n="$(_floor "$1")"
	if [[ $n -ge 90 ]]; then
		color="$RED"
	elif [[ $n -ge 70 ]]; then
		color="$YELLOW"
	else
		color="$GREEN"
	fi

	echo -n "$color"
}

function fmt_dur() {
	local ms="$1" s

	if [[ -z "$ms" ]]; then
		printf ''
		return
	fi

	s="$(($(_floor "$ms") / 1000))"
	if [[ $s -ge 3600 ]]; then
		printf '%dh%dm' $((s / 3600)) $(((s % 3600) / 60))
	elif [[ $s -ge 60 ]]; then
		printf '%dm%ds' $((s / 60)) $((s % 60))
	else
		printf '%ds' "$s"
	fi
}

# model + effort + caveman
model_line="${CYAN}[${MODEL} · ${EFFORT}]${RESET}"

caveman="$("$CAVEMAN_SL" </dev/null 2>/dev/null || true)"
if [[ -n $caveman ]]; then
	model_line="${model_line} | ${caveman}"
fi

# context bar + duration
bar_color="$(pick_color_pct "$CTX")"
dur="$(fmt_dur "$DUR")"
nfill=$(($(_floor "$CTX") / 10))
nempty=$((10 - nfill))
printf -v ctx_fill "%${nfill}s"
printf -v ctx_pad "%${nempty}s"
ctx_bar="${bar_color}${ctx_fill// /█}${ctx_pad// /░}${RESET} ${CTX}% [${dur}]"

# rate limits
sess_color="$(pick_color_pct "$RL5")"
week_color="$(pick_color_pct "$RL7")"
rate_limits="5h ${sess_color}${RL5}%${RESET} | 7d ${week_color}${RL7}%${RESET}"

echo -e "$model_line"
echo -e "${ctx_bar} | ${rate_limits}"
