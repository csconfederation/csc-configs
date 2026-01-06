#!/usr/bin/env bash
set -euo pipefail

# CSC Config Repository Setup Script
# Run this after cloning to prepare your development environment.

GREEN=$'\e[32m'; YELLOW=$'\e[33m'; RESET=$'\e[0m'

echo "🧩 CSC Config Repository Setup"
echo "==============================="
echo

# Ensure we're in the repo root
if [[ ! -d "configs" ]] || [[ ! -d "tools" ]]; then
  echo "Error: Please run this script from the repository root."
  exit 1
fi

# Make tools executable
echo "📁 Making tool scripts executable..."
chmod +x tools/update_headers.sh
chmod +x tools/cfg_linter.sh
chmod +x tools/generate_mode_diffs.sh
echo "   ✓ tools/*.sh"

# Install pre-commit hook
echo
echo "🪝 Installing pre-commit hook..."
if [[ -f ".git/hooks/pre-commit" ]]; then
  echo "   ${YELLOW}Pre-commit hook already exists.${RESET}"
  read -p "   Overwrite? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    cp tools/pre-commit.hook .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
    echo "   ✓ Replaced .git/hooks/pre-commit"
  else
    echo "   ✓ Kept existing hook"
  fi
else
  cp tools/pre-commit.hook .git/hooks/pre-commit
  chmod +x .git/hooks/pre-commit
  echo "   ✓ Installed .git/hooks/pre-commit"
fi

# Run initial header stamp
echo
echo "🪄 Running initial header/footer stamp..."
tools/update_headers.sh

# Verify with linter
echo
echo "🧹 Verifying configs with linter..."
if tools/cfg_linter.sh; then
  echo
  echo "${GREEN}✅ Setup complete!${RESET}"
  echo
  echo "You're ready to edit configs. The pre-commit hook will automatically:"
  echo "  • Stamp headers and footers with version info"
  echo "  • Lint all config files"
  echo "  • Regenerate modes.md"
  echo
  echo "To skip automation for a single commit:"
  echo "  SKIP_HEADER_STAMP=1 git commit -m \"message\""
else
  echo
  echo "${YELLOW}⚠️  Setup complete, but linter found issues.${RESET}"
  echo "   Review the errors above before committing."
fi