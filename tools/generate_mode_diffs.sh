#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

OUT="modes.md"
MODES=("Match" "Scrim" "Combine" "Preseason")
FILES=(
  "cfg/server.cfg"
  "cfg/gamemode_competitive_server.cfg"
  "cfg/MatchZy/config.cfg"
  "cfg/MatchZy/live_override.cfg"
  "cfg/MatchZy/warmup.cfg" # optional
)

# Parse a cfg into key\tvalue pairs
parse_cfg() {
  # - Strip comments (lines starting with //, #, ;)
  # - Ignore exec/say lines
  # - Keep 'key value...' with first token as key
  awk '
    BEGIN{IGNORECASE=0}
    /^[[:space:]]*($|\/\/|#|;)/{next}
    /^[[:space:]]*(exec|say)\b/{next}
    {
      # trim leading spaces
      sub(/^[[:space:]]+/,"",$0)
      key=$1
      # value = rest of line after first token
      $1=""; sub(/^[[:space:]]+/,"",$0); val=$0
      # normalize interior spaces
      gsub(/[[:space:]]+$/,"",val)
      if (key ~ /^[A-Za-z0-9_\.]+$/) {
        print key "\t" val
      }
    }
  ' "$1" 2>/dev/null | sed 's/[[:space:]]\+$//'
}

# Read a mode/file into an associative array: arr[key]=value
declare -A MAP

get_key() { echo "$1|$2|$3"; } # mode|file|key

for mode in "${MODES[@]}"; do
  for f in "${FILES[@]}"; do
    rel="configs/${mode}/${f}"
    [[ -f "$rel" ]] || continue
    while IFS=$'\t' read -r k v; do
      MAP["$(get_key "$mode" "$f" "$k")"]="$v"
    done < <(parse_cfg "$rel")
  done
done

# Collect all (file,key) pairs across modes
declare -A ALL_KEYS
for mode in "${MODES[@]}"; do
  for f in "${FILES[@]}"; do
    for kv in "${!MAP[@]}"; do
      # kv = mode|file|key
      IFS='|' read -r m file key <<< "$kv"
      [[ "$m" == "$mode" ]] || continue
      [[ "$file" == "$f" ]] || continue
      ALL_KEYS["$file|$key"]=1
    done
  done
done

# Start output
{
  echo "# Mode Differences"
  echo
  echo "_Generated automatically. Shows only settings where at least one mode differs._"
  echo

  for f in "${FILES[@]}"; do
    any_diff=0
    # Build table rows where values differ between modes
    rows=()

    # Collect all keys used in this file
    for fk in "${!ALL_KEYS[@]}"; do
      IFS='|' read -r file key <<< "$fk"
      [[ "$file" == "$f" ]] || continue

      # Pull values per mode (blank if missing)
      declare -A V
      for mode in "${MODES[@]}"; do
        V["$mode"]="${MAP["$(get_key "$mode" "$f" "$key")"]:-}"
      done

      # Check if all equal
      same=1
      ref="${V[${MODES[0]}]}"
      for mode in "${MODES[@]}"; do
        [[ "${V[$mode]}" == "$ref" ]] || { same=0; break; }
      done

      if (( same == 0 )); then
        any_diff=1
        # escape pipes in values for markdown
        esc() { echo "${1//|/\\|}"; }
        rows+=("| \`$key\` | $(esc "${V[Match]}") | $(esc "${V[Scrim]}") | $(esc "${V[Combine]}") | $(esc "${V[Preseason]}") |")
      fi
    done

    if (( any_diff == 1 )); then
      echo "## ${f}"
      echo
      echo "| Setting | Match | Scrim | Combine | Preseason |"
      echo "|---|---|---|---|---|"
      IFS=$'\n' printf "%s\n" "${rows[@]}"
      echo
    fi
  done
} > "$OUT"

echo "[mode-diffs] Wrote ${OUT}"
