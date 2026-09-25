#!/usr/bin/env bash
# Checks whether ../../manuscript-checklist.tex (the source of truth for
# this skill's rules) has changed since SKILL.md was last written to match
# it. Comparison is against synced-manuscript-checklist.tex, a snapshot of
# the tex file taken at the time SKILL.md was last updated -- see README.md
# for what to do when this reports drift.
#
# Usage: scripts/check_sync.sh
# Exit 0: in sync. Exit 2: out of sync (diff printed). Exit 1: setup problem.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
SNAPSHOT="$SKILL_DIR/synced-manuscript-checklist.tex"

REPO_ROOT="$(git -C "$SKILL_DIR" rev-parse --show-toplevel 2>/dev/null || true)"
if [ -z "$REPO_ROOT" ]; then
  echo "Couldn't locate the repo root from $SKILL_DIR (not in a git repo?)." >&2
  exit 1
fi
SOURCE_TEX="$REPO_ROOT/manuscript-checklist.tex"

if [ ! -f "$SOURCE_TEX" ]; then
  echo "Source file not found: $SOURCE_TEX" >&2
  exit 1
fi
if [ ! -f "$SNAPSHOT" ]; then
  echo "No snapshot found at $SNAPSHOT -- nothing to compare against." >&2
  exit 1
fi

if diff -q "$SNAPSHOT" "$SOURCE_TEX" > /dev/null; then
  echo "In sync: manuscript-checklist.tex matches the version SKILL.md was last written against."
  exit 0
else
  echo "OUT OF SYNC: manuscript-checklist.tex has changed since SKILL.md was last updated."
  echo "See README.md in this skill's directory for what to do next."
  echo
  echo "Diff (last-synced version -> current manuscript-checklist.tex):"
  diff -u "$SNAPSHOT" "$SOURCE_TEX" || true
  exit 2
fi
