#!/usr/bin/env bash
set -euo pipefail

coverage_file="${1:-coverage/lcov.info}"
minimum="${COVERAGE_MINIMUM:-80}"

result=$(awk -F: '
  /^SF:/ {
    file=$2
    include=(file ~ /^lib\/core\/crypto\// ||
      file ~ /^lib\/core\/security\/(vault_session|clipboard_guard)\.dart$/ ||
      file ~ /^lib\/features\/backup\/data\/backup_service\.dart$/ ||
      file ~ /^lib\/features\/breach_check\/data\/breach_service\.dart$/ ||
      file ~ /^lib\/features\/dashboard\/domain\/password_health\.dart$/ ||
      file ~ /^lib\/features\/generator\/domain\/password_generator\.dart$/ ||
      file ~ /^lib\/features\/vault\/data\/vault_repository\.dart$/ ||
      file ~ /^lib\/features\/vault\/domain\/vault_entry\.dart$/)
  }
  include && /^LF:/ { total += $2 }
  include && /^LH:/ { covered += $2 }
  END {
    if (total == 0) exit 2
    printf "%.2f %d %d", 100 * covered / total, covered, total
  }
' "$coverage_file")

read -r percent covered total <<<"$result"
printf 'Security/domain line coverage: %s%% (%s/%s), required: %s%%\n' \
  "$percent" "$covered" "$total" "$minimum"

awk -v actual="$percent" -v required="$minimum" 'BEGIN { exit(actual + 0 < required + 0) }'
