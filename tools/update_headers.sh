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
      echo "// Version: <commit hash>"
      echo "// Last Updated: <date>"
      echo "// ========================================================="
      echo
      cat "$file"
    } > "$tmp"
    mv "$tmp" "$file"
  fi
}

# Stamp the three header lines (Path, Version, Last Updated)
stamp_header() {
  local file="$1"
  local rel_path="${file#./}"
  rel_path="${rel_path#configs/}"

  # Replace the three lines if present in the first ~12 lines
  # (keeps diffs tiny; avoids rewriting full headers)
  sedi "1,12s|^// Path: .*|// Path: ${rel_path}|g" "$file"
  sedi "1,12s|^// Version: .*|// Version: ${VERSION}|g" "$file"
  sedi "1,12s|^// Last Updated: .*|// Last Updated: ${DATE}|g" "$file"
}

# Walk all cfgs under configs/
while IFS= read -r -d '' f; do
  ensure_header "$f"
  stamp_header "$f"
done < <(find configs -type f -name '*.cfg' -print0)

echo "[update_headers] Updated headers for all configs/*.cfg with Version=${VERSION} Date=${DATE}"
