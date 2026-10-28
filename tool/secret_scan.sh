#!/usr/bin/env bash
set -euo pipefail

pattern='gh[opsu]_[A-Za-z0-9]{20,}|BEGIN (RSA|OPENSSH|EC) PRIVATE KEY|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{30,}'
if git grep -IEn "$pattern" -- . ':(exclude)tool/secret_scan.sh'; then
  printf '%s\n' 'Potential credential material found in tracked files.' >&2
  exit 1
fi
printf '%s\n' 'Tracked-file secret scan passed.'
