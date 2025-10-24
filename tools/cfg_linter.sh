#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

RED=$'\e[31m'; GREEN=$'\e[32m'; YELLOW=$'\e[33m'; RESET=$'\e[0m'

failures=0
offenders=()

# Files that SHOULD have a footer echo
# (MatchZy/config.cfg is allowed to have it or not; live_override.cfg should have it.)
# Files that SHOULD have a footer echo
require_footer_echo() {
  local rel="$1"
  case "$rel" in
    */cfg/server.cfg|*/cfg/gamemode_competitive_server.cfg|*/cfg/MatchZy/warmup.cfg)
      return 0 ;;  # enforce
    *)
      return 1 ;;  # skip check
  esac
}

check_file() {
  local f="$1"
  local rel="${f#./}"
  local base="$(basename "$f")"

  # Header presence
  if ! head -n 6 "$f" | grep -qE '^//[[:space:]]*=+'; then
    echo "${RED}[lint] Missing header delimiter:${RESET} $rel"
    failures=$((failures+1)); offenders+=("$rel")
  fi

  # Path line present and does NOT start with "configs/"
  if ! head -n 12 "$f" | grep -qE '^// Path:'; then
    echo "${RED}[lint] Missing Path line in header:${RESET} $rel"
    failures=$((failures+1)); offenders+=("$rel")
  else
    path_line="$(head -n 12 "$f" | grep -E '^// Path:' | sed 's|^// Path:[[:space:]]*||')"
    if [[ "$path_line" == configs/* ]]; then
      echo "${RED}[lint] Path should not start with 'configs/':${RESET} $rel  (found: $path_line)"
      failures=$((failures+1)); offenders+=("$rel")
    fi
  fi

  # Version/Date placeholders must exist (will be stamped by update_headers.sh)
  if ! head -n 12 "$f" | grep -qE '^// Version:'; then
    echo "${RED}[lint] Missing Version line in header:${RESET} $rel"
    failures=$((failures+1)); offenders+=("$rel")
  fi
  if ! head -n 12 "$f" | grep -qE '^// Last Updated:'; then
    echo "${RED}[lint] Missing Last Updated line in header:${RESET} $rel"
    failures=$((failures+1)); offenders+=("$rel")
  fi

  # No legacy banlist references
  if grep -qiE 'banned[_-](user|ip)\.cfg|writeid|writeip' "$f"; then
    echo "${RED}[lint] Found legacy banlist references (banned_user/banned_ip, writeid/writeip):${RESET} $rel"
    failures=$((failures+1)); offenders+=("$rel")
  fi

  # Footer echo must include the actual filename (for applicable files)
  if require_footer_echo "$rel"; then
    if ! tail -n 15 "$f" | grep -qE "^say \"> CSC Config Loaded \| ${base//\//\\/} \|"; then
      echo "${RED}[lint] Footer 'say' must include filename:${RESET} $rel  (expected to reference '$base')"
      failures=$((failures+1)); offenders+=("$rel")
    fi
  fi
}

while IFS= read -r -d '' f; do
  check_file "$f"
done < <(find configs -type f -name '*.cfg' -print0)

if (( failures > 0 )); then
  echo
  echo "${RED}[lint] ${failures} problem(s) found.${RESET}"
  exit 1
fi

echo "${GREEN}[lint] All configs passed.${RESET}"
