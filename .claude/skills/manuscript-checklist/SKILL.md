---
name: manuscript-checklist
description: Review a LaTeX academic manuscript (statistics/ML paper, thesis chapter, or similar) against Jacob Bien's manuscript-preparation checklist before it goes to a coauthor, advisor, or journal. Covers writing consistency (capitalization conventions, "dataset" vs "data set", verb tense), capitalization of terminology and cross-references, LaTeX math/notation conventions (treating equations as part of a sentence, punctuation after display equations, not starting sentences with symbols, macros for repeated notation, \mathrm{diag}/\log/\langle\rangle/\gg\ll/\|\,\|/\mid, \left\right sizing, "Equation 12" vs "(12)" phrasing), citation style (\citep vs \citet, avoiding double parentheses with \citealt), grammar/spelling, logical flow (forward references, pointers back to earlier notation, preparing the reader for theorems, justifying technical claims), plagiarism/self-plagiarism, and multi-file tex structure for journal+arxiv submissions. Trigger this whenever the user asks to "check", "review", "proofread", or "clean up" a manuscript/paper/draft/tex file against the checklist, mentions sending a manuscript to Jacob, or asks something like "is this ready to send" / "did I follow the style guide" for a .tex document -- even if they don't name the checklist explicitly.
---

# Manuscript Checklist Review

This skill reviews a LaTeX manuscript against the checklist in
`manuscript-checklist.tex` (source of truth for the full prose of every
rule — read it if you want a rule's exact original wording or the footnote
about title-case tools). The point of the checklist is to catch the kind of
small, mechanical inconsistencies that are easy to miss when you're close to
your own writing but that an advisor will immediately trip over — so the
review should be genuinely close-reading the manuscript, not just pattern
matching.

## Workflow

0. **Check that this skill is still in sync with the checklist source.**
   Run `scripts/check_sync.sh`. This skill's rules are a paraphrased,
   instruction-oriented rewrite of `manuscript-checklist.tex`, not a literal
   include of it, so an edit to that file doesn't automatically update
   SKILL.md. If the script reports drift, mention it to the user and offer
   to update the skill (see the repo's root `README.md` for the exact
   steps) before or after doing the review, whichever they'd prefer — don't
   silently review against a stale checklist without saying so.

1. **Identify the target file(s).** If the project follows the
   `main-content.tex` / `main-journalname.tex` / `main-arxiv.tex` pattern
   described under "Structure of tex files" below, review the shared
   `main-content.tex` (and `supp-content.tex` if present) rather than the
   thin wrapper files — that's where the actual prose lives. If it's
   ambiguous which file(s) to review, ask the user rather than guessing.

2. **Run the mechanical first pass.**
   `scripts/grep_checks.sh <file1.tex> [file2.tex ...]` greps for the
   syntactic notation issues that are regex-detectable: literal `||`,
   `<<`/`>>`, `<x, y>` angle brackets, `diag(`/`log(` without a backslash,
   `Equation (12)` phrasing, `\citep{}` nested inside explicit parens, and
   `|` used as a conditioning bar inside math mode. Treat every hit as a
   **candidate**, not a confirmed violation — check each one by eye, since
   these regexes don't understand `\verb`, comments, or macro definitions
   and will produce some false positives (for example, a macro *definition*
   like `\newcommand{\xtr}{...}` isn't a violation, and code in a
   `verbatim`/`lstlisting` block showing the "wrong" way on purpose isn't
   either).

3. **Do a close read for everything else.** Most of the checklist can't be
   regexed because it depends on meaning and context. Read the manuscript
   start to finish (or the relevant section, if the user scoped the
   request) and check for the categories below. Where the checklist file
   itself gives the reasoning for a rule, carry that reasoning into how you
   judge borderline cases rather than applying the rule mechanically.

## Checklist categories to check

**Consistency** — Pick whichever convention the manuscript seems to favor
and flag every place it deviates, rather than asserting one convention is
required:
- Title/section/subsection capitalization: consistently "My Wonderful
  Title" or consistently "My wonderful title" throughout.
- "dataset" vs "data set" used consistently.
- Present vs past tense used consistently within the simulation-study and
  data-analysis sections.

**Capitalization**
- Terminology is lowercase unless it's named after a person: "elastic net"
  not "Elastic Net", but "Gaussian process" and "Wasserstein distance".
- Cross-references are capitalized when naming a specific numbered item
  ("in Section 3", "in Appendix A", "in Theorem 2") but lowercase when
  referring generically ("in the next section", "in the appendix").

**LaTeX equations and notation**
- Math is grammatically part of the sentence (you should be able to
  swap the expression for a word like "food" and the sentence still
  parses), and sentences don't start with a math symbol.
- A display equation is followed by a period or comma, and a colon
  precedes it only when the preceding text is itself a complete sentence
  (e.g. "We write this as follows:" is fine; "We write this as:" is not).
- Repeated bulky notation (e.g. `\mathcal X^{\text{train}}`) is captured in
  a macro rather than typed out every time.
- Notation conventions: `\mathrm{diag}` not `diag`; `\log` not `log`;
  single-letter math variables in text are typeset in math mode (`$p$` not
  `p`); `\langle x, y\rangle` not `<x, y>`; `\gg`/`\ll` not `>>`/`<<`; `\|x\|`
  not `||x||`; `\mid` not `|` for conditioning (`p(y \mid x)` not
  `p(y|x)`); `\left`/`\right` (or `\big`/`\Big`/`\bigg`/`\Bigg` for finer
  control) when parens/braces need to resize.
- Equations are referred to as "Equation 12" or "(12)", never
  "Equation (12)"; `\eqref{}` is used for the "(12)" form.

**Citations**
- `\citep{}` for a parenthetical citation (sentence reads fine without it),
  `\citet{}` when the citation is the grammatical subject of the sentence.
- No double parentheses — `\citealt{}` is used instead of `\citep{}` when
  the citation already sits inside parentheses, e.g. "(see, e.g.,
  \citealt{ESL})".

**Common sense** — Grammar and spelling throughout.

**Logical flow**
- Anything referred to as already-introduced actually was introduced
  earlier, from the reader's first-read perspective.
- Notation or facts used more than ~two paragraphs after they were
  introduced get an explicit pointer back (an equation number or section
  reference), e.g. "since $a+b=c$ (see Theorem 2)".
- The reader is prepared for a theorem before it's presented, and sections
  don't end abruptly on a theorem — they close with discussion or a
  transition.
- Every technical claim is backed by something: a reference to an earlier
  equation, a citation, a brief in-line reason, or (if the justification
  doesn't fit in a sentence or two) its own stated result with a proof in
  the appendix.

**Plagiarism / self-plagiarism** — No verbatim phrases from another source
(including the authors' own prior writing) without quotation and
attribution. This is most likely to surface in dataset descriptions and
related-work sections. This one requires judgment, not a mechanical check —
flag any passage that reads like it was lifted rather than written from
scratch (overly specific phrasing that doesn't match the surrounding
voice, sudden shifts in style) so the user can verify against the source
themselves; don't accuse without a specific passage to point to.

**Structure of tex files** — If the project is meant for both a journal and
arXiv, check that shared content lives in a `main-content.tex` (and
`supp-content.tex` for a supplement) that both `main-<journalname>.tex` and
`main-arxiv.tex` pull in via `\input{}`, rather than being duplicated across
files. This one is about the repo layout, not manuscript prose — check it
once per project, not per read-through.

## Reporting findings

Report in chat as a single list grouped by the categories above (skip
categories with no findings — don't pad the report by listing "no issues
found" for every heading). For each finding, give:

- **File:line** and a short quote of the actual text, so the user can jump
  straight to it.
- **The issue**, in a sentence.
- **A concrete fix** — the corrected text or LaTeX, not just "fix this."

Consistency findings (capitalization style, dataset vs data set, tense) are
the one category where you should report a summary rather than every single
instance: state which convention the manuscript predominantly uses and list
the specific lines that break from it, rather than repeating the same
observation once per occurrence.

If the manuscript is clean on some categories, it's fine — and more useful
— to say so briefly rather than staying silent, so the user knows those
categories were actually checked (e.g. "Citations: no issues — \citep/\citet
usage looks correct throughout").
