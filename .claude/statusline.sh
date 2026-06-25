#!/bin/bash

set -euo pipefail

IFS=$'\t' read -r MODEL EFFORT CTX DUR RL5 RM5 RL7 RM7 < <(
	jq -r '
	def xround1: (. // 0) * 10 | round / 10;
	[
		(.model.display_name // "?"),
		(.effort.level // "(no effort)"),
		(.context_window.used_percentage | xround1),
		(.cost.total_duration_ms // 0),
		(.rate_limits.five_hour.used_percentage | xround1),
		(.rate_limits.five_hour.resets_at // 0),
		(.rate_limits.seven_day.used_percentage | xround1),
		(.rate_limits.seven_day.resets_at // 0)
	] | @tsv'
)

CAVEMAN_SL="$(
	jq -r '.plugins["caveman@caveman"][0].installPath' \
		~/.claude/plugins/installed_plugins.json
)/src/hooks/caveman-statusline.sh"

CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'
DIM='\033[2m'

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

	echo "$color"
}

function fmt_dur() {
	local s="$1"

	if [[ -z $s ]]; then
		printf '?'
		return
	elif [[ $s -le 0 ]]; then
		printf '0s'
		return
	fi

	if [[ $s -ge 86400 ]]; then
		printf '%dd %dh' $((s / 86400)) $(((s % 86400) / 3600))
	elif [[ $s -ge 3600 ]]; then
		printf '%dh %dm' $((s / 3600)) $(((s % 3600) / 60))
	elif [[ $s -ge 60 ]]; then
		printf '%dm %ds' $((s / 60)) $((s % 60))
	else
		printf '%ds' "$s"
	fi
}

function fmt_epoch_delta() {
	local epoch="$1" now

	epoch="$(_floor "$epoch")"
	if [[ -z $epoch || $epoch -le 0 ]]; then
		printf '?'
		return
	fi

	now="$(date +%s)"
	fmt_dur "$((epoch - now))"
}

function fmt_epoch() {
	local epoch="$1"

	epoch="$(_floor "$epoch")"
	if [[ -z $epoch || $epoch -le 0 ]]; then
		printf '?'
		return
	fi

	date -d "@$epoch" '+%a %-I:%M %p'
}

# model + effort + caveman
model_line="${CYAN}[${MODEL} · ${EFFORT}]${RESET}"

caveman="$("$CAVEMAN_SL" </dev/null 2>/dev/null || true)"
if [[ -n $caveman ]]; then
	model_line="${model_line} ${caveman}"
fi

# context bar + duration
bar_color="$(pick_color_pct "$CTX")"
dur="$(fmt_dur $(($(_floor "$DUR") / 1000)))"
nfill=$(($(_floor "$CTX") / 10))
nempty=$((10 - nfill))
printf -v ctx_fill "%${nfill}s"
printf -v ctx_pad "%${nempty}s"
ctx_bar="${bar_color}${ctx_fill// /█}${ctx_pad// /░}${RESET}\
 ${CTX}%\
 ${DIM}[${dur}]${RESET}"

# rate limits
sess_color="$(pick_color_pct "$RL5")"
week_color="$(pick_color_pct "$RL7")"
rm5="resets in $(fmt_epoch_delta "$RM5")"
rm7="resets $(fmt_epoch "$RM7")"
rate_limits="5h ${sess_color}${RL5}%${RESET} ${DIM}[${rm5}]${RESET}\
 | 7d ${week_color}${RL7}%${RESET} ${DIM}[${rm7}]${RESET}"

echo -e "$model_line"
echo -e "${ctx_bar} | ${rate_limits}"
