#!/usr/bin/env bash
# Mechanical, regex-detectable candidates for the LaTeX notation rules in the
# manuscript checklist. This is a FIRST PASS ONLY: every hit is a candidate
# to verify by eye, not a confirmed violation (LaTeX is too irregular for
# these regexes to be exact -- e.g. a "log(" inside \verb{} or a comment
# should be ignored, and some hits will be false positives). Run this before
# the close read described in SKILL.md, and fold genuine hits into the report
# under the matching checklist category.
#
# Usage: scripts/grep_checks.sh file1.tex [file2.tex ...]

set -euo pipefail

if [ "$#" -eq 0 ]; then
  echo "Usage: $0 file1.tex [file2.tex ...]" >&2
  exit 1
fi

section () {
  echo
  echo "=== $1 ==="
}

for f in "$@"; do
  echo "############################################"
  echo "# $f"
  echo "############################################"

  section "Literal '||' instead of \\| (norms)"
  grep -noE '\|\|[^|]*\|\|' "$f" || echo "  (none found)"

  section "Literal '<<' or '>>' instead of \\ll / \\gg"
  grep -noE '(<<|>>)' "$f" || echo "  (none found)"

  section "Literal '<x, y>' angle-bracket inner products instead of \\langle ... \\rangle"
  grep -noE '<[A-Za-z0-9]+ *, *[A-Za-z0-9]+>' "$f" || echo "  (none found)"

  section "'diag(' not written as \\mathrm{diag} / \\diag"
  grep -noE '[^a-zA-Z\\]diag\(' "$f" || echo "  (none found)"

  section "'log(' not written as \\log"
  grep -noE '[^a-zA-Z\\]log\(' "$f" || echo "  (none found)"

  section "'Equation (12)' style phrasing (should be 'Equation 12' or '(12)')"
  grep -noE 'Equation[ ~]*\([0-9]' "$f" || echo "  (none found)"

  section "\\citep{} nested inside explicit parentheses (risk of double parens)"
  grep -noE '\([^()]*\\citep\{[^}]*\}[^()]*\)' "$f" || echo "  (none found)"

  section "Conditioning bar '|' inside math mode instead of \\mid"
  # NOTE: POSIX bracket expressions ([...]) treat backslash as a literal
  # character, not an escape -- to include ']' in a class it must be the
  # first character listed, e.g. []A-Za-z0-9)]. A '\]'/'\[' escape inside a
  # class silently breaks the whole class on BSD/macOS grep (though GNU grep
  # tolerates it), so avoid that pattern here even though it looks tempting.
  grep -noE '\$[^$]*[]A-Za-z0-9)][ ]?\|[ ]?[A-Za-z0-9([][^$]*\$' "$f" || echo "  (none found)"

  echo
done
