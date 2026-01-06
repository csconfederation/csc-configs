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

  # Skip files that don't need footers
  needs_footer "$file" || return 0

  # Check if standard footer pattern exists
  if ! grep -qE "^say \"> CSC Config Loaded \| ${base} \|" "$file"; then
    # Append footer with blank line separator
    {
      echo
      echo "// End of Config"
      echo "say \"> CSC Config Loaded | ${base} | ${VERSION} | ${DATE} <\""
    } >> "$file"
  fi
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

  # Skip files that don't need footers
  needs_footer "$file" || return 0

  # Standard format: say "> CSC Config Loaded | <filename> | <hash> | <date> <"
  # Matches any hash/date or placeholder text between the pipes
  # Using # as delimiter since | appears in the pattern
  sedi "s#say \"> CSC Config Loaded | ${base} | [^|]* | [^<]* <\"#say \"> CSC Config Loaded | ${base} | ${VERSION} | ${DATE} <\"#g" "$file"
}

# Walk all cfgs under configs/
while IFS= read -r -d '' f; do
  ensure_header "$f"
  ensure_footer "$f"
  stamp_header "$f"
  stamp_footer "$f"
done < <(find configs -type f -name '*.cfg' -print0)

echo "[update_headers] Updated headers/footers for all configs/*.cfg with Version=${VERSION} Date=${DATE}"