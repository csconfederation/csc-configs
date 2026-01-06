#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

RED=$'\e[31m'; GREEN=$'\e[32m'; YELLOW=$'\e[33m'; RESET=$'\e[0m'

failures=0
offenders=()

# Files that MUST have a footer echo
# Only config.cfg is excluded (MatchZy plugin config, no say output needed)
needs_footer() {
  local rel="$1"
  case "$rel" in
    */cfg/MatchZy/config.cfg)
      return 1 ;;  # skip - plugin config, no console output
    *)
      return 0 ;;  # enforce on all other .cfg files
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

  # Footer checks (only for files that need footers)
  if needs_footer "$rel"; then
    # Footer echo must use standard format with filename
    # Expected: say "> CSC Config Loaded | <filename> | <hash> | <date> <"
    if ! tail -n 5 "$f" | grep -qE "^say \"> CSC Config Loaded \| ${base} \|"; then
      echo "${RED}[lint] Missing or malformed footer 'say' line:${RESET} $rel"
      echo "       Expected: say \"> CSC Config Loaded | ${base} | <hash> | <date> <\""
      failures=$((failures+1)); offenders+=("$rel")
    else
      # Header/footer version consistency check
      header_version="$(head -n 12 "$f" | grep -E '^// Version:' | sed 's|^// Version:[[:space:]]*||')"
      # Extract version from footer: say "> CSC Config Loaded | file.cfg | VERSION | DATE <"
      footer_line="$(tail -n 5 "$f" | grep -E "^say \"> CSC Config Loaded \| ${base} \|" | head -n 1)"
      footer_version="$(echo "$footer_line" | sed -E "s|.*\| ${base} \| ([^ |]+) \|.*|\1|")"

      if [[ -n "$header_version" && -n "$footer_version" && "$header_version" != "$footer_version" ]]; then
        echo "${RED}[lint] Header/footer version mismatch:${RESET} $rel"
        echo "       Header: ${header_version}  Footer: ${footer_version}"
        failures=$((failures+1)); offenders+=("$rel")
      fi
    fi
  fi
}

while IFS= read -r -d '' f; do
  check_file "$f"
done < <(find configs -type f -name '*.cfg' -print0)

if (( failures > 0 )); then
  echo
  echo "${RED}[lint] ${failures} problem(s) found in ${#offenders[@]} file(s).${RESET}"
  exit 1
fi

echo "${GREEN}[lint] All configs passed.${RESET}"