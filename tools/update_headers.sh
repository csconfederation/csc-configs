#!/usr/bin/env bash
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

VERSION="$(git rev-parse --short HEAD 2>/dev/null || echo UNKNOWN)"
DATE="$(date +"%Y-%m-%d")"

# Portable sed -i helper (GNU/BSD)
sedi() {
  if sed --version >/dev/null 2>&1; then
    sed -i "$@"
  else
    sed -i '' "$@"
  fi
}

# Check if file should have a footer (all except MatchZy/config.cfg)
needs_footer() {
  local file="$1"
  case "$file" in
    */MatchZy/config.cfg) return 1 ;;
    *) return 0 ;;
  esac
}

footer_label() {
  local mode="$1"
  local base="$2"
  if [[ "$base" == "live_override.cfg" ]]; then
    printf 'CSC %s is Live ' "$mode"
  else
    printf 'CSC %s Config Loaded' "$mode"
  fi
}

escape_regex() {
  printf '%s' "$1" | sed -e 's/[][\\.^$*+?(){}|]/\\&/g'
}

# Ensure a standard header exists; if missing, prepend one.
ensure_header() {
  local file="$1"
  local rel_path="${file#./}"
  rel_path="${rel_path#configs/}"

  # If the file doesn't already have our header delimiter, prepend a fresh header.
  if ! head -n 1 "$file" | grep -qE '^//[[:space:]]*=+'; then
    tmp="$(mktemp)"
    {
      echo "// ========================================================="
      echo "// CSC Config File"
      echo "// Path: ${rel_path}"
      echo "// Version: ${VERSION}"
      echo "// Last Updated: ${DATE}"
      echo "// ========================================================="
      echo
      cat "$file"
    } > "$tmp"
    mv "$tmp" "$file"
  fi
}

# Ensure a standard footer exists; if missing, append one.
ensure_footer() {
  local file="$1"
  local base="$(basename "$file")"
  local rel_path="${file#./}"
  rel_path="${rel_path#configs/}"
  local mode="${rel_path%%/*}"
  local footer_text
  footer_text="$(footer_label "$mode" "$base")"

  # Skip files that don't need footers
  needs_footer "$file" || return 0

  # Check if standard footer pattern exists
  if ! grep -qF "say \"> ${footer_text} | ${base} |" "$file"; then
    # Append footer with blank line separator
    {
      echo
      echo "// End of Config"
      echo "say \"> ${footer_text} | ${base} | ${VERSION} | ${DATE} <\""
    } >> "$file"
  fi
}

# Remove any existing footer blocks so we can re-stamp a single one.
normalize_footer() {
  local file="$1"
  local base="$(basename "$file")"

  # Skip files that don't need footers
  needs_footer "$file" || return 0

  local base_regex
  base_regex="$(escape_regex "$base")"
  local tmp
  tmp="$(mktemp)"

  awk -v base_re="$base_regex" '
    $0 == "// End of Config" { next }
    $0 ~ ("^say \"> CSC .* \\| " base_re " \\| .* <\"$") { next }
    { lines[NR] = $0 }
    $0 ~ /[^[:space:]]/ { last = NR }
    END {
      for (i = 1; i <= last; i++) print lines[i]
    }
  ' "$file" > "$tmp"

  mv "$tmp" "$file"
}

# Stamp the three header lines (Path, Version, Last Updated)
stamp_header() {
  local file="$1"
  local rel_path="${file#./}"
  rel_path="${rel_path#configs/}"

  # Replace the three lines if present in the first ~12 lines
  sedi "1,12s|^// Path: .*|// Path: ${rel_path}|g" "$file"
  sedi "1,12s|^// Version: .*|// Version: ${VERSION}|g" "$file"
  sedi "1,12s|^// Last Updated: .*|// Last Updated: ${DATE}|g" "$file"
}

# Stamp footer say lines with version info
stamp_footer() {
  local file="$1"
  local base="$(basename "$file")"
  local rel_path="${file#./}"
  rel_path="${rel_path#configs/}"
  local mode="${rel_path%%/*}"
  local footer_text
  footer_text="$(footer_label "$mode" "$base")"
  local base_regex
  base_regex="$(escape_regex "$base")"

  # Skip files that don't need footers
  needs_footer "$file" || return 0

  # live_override.cfg uses an "is Live" footer; everything else uses "Config Loaded".
  # Match any prior CSC footer format for this filename and re-stamp it.
  sedi -E "s#^say \"> CSC .* \\| ${base_regex} \\| .* <\"\$#say \"> ${footer_text} | ${base} | ${VERSION} | ${DATE} <\"#g" "$file"
}

# Walk all cfgs under configs/
while IFS= read -r -d '' f; do
  ensure_header "$f"
  normalize_footer "$f"
  ensure_footer "$f"
  stamp_header "$f"
  stamp_footer "$f"
done < <(find configs -type f -name '*.cfg' -print0)

echo "[update_headers] Updated headers/footers for all configs/*.cfg with Version=${VERSION} Date=${DATE}"
