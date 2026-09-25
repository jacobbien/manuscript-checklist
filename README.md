# manuscript-checklist

[`manuscript-checklist.tex`](manuscript-checklist.tex) (built to
[`manuscript-checklist.pdf`](manuscript-checklist.pdf)) is Jacob Bien's
checklist for preparing a manuscript before sending it to him or submitting
it to a journal.

This repo also has a Claude Code skill at
[`.claude/skills/manuscript-checklist/`](.claude/skills/manuscript-checklist/)
that reviews a `.tex` manuscript against this checklist automatically. This
file explains how the two are kept in sync.

## Keeping the skill in sync with the checklist

`SKILL.md` is a paraphrased, instruction-oriented rewrite of the checklist,
not a literal include of it — it needs to tell Claude *how to check* each
rule (what to grep for, what requires a close read, how to phrase a
finding), not just restate the rule's prose. That rewriting means an edit to
`manuscript-checklist.tex` doesn't automatically show up in the skill.

### How drift is detected

`.claude/skills/manuscript-checklist/synced-manuscript-checklist.tex` is a
snapshot of `manuscript-checklist.tex` taken at the moment `SKILL.md` was
last updated to match it.
`.claude/skills/manuscript-checklist/scripts/check_sync.sh` diffs the live
`.tex` file against that snapshot and reports whether anything has changed
since. The skill runs this check on its own at the start of every review
(step 0 in `SKILL.md`), so in practice you don't need to remember to run it
yourself — if the checklist has drifted, Claude will notice and flag it the
next time it uses this skill. You can also run it directly any time:

```
.claude/skills/manuscript-checklist/scripts/check_sync.sh
```

### What to do after editing manuscript-checklist.tex

1. Edit `manuscript-checklist.tex` as normal.
2. Ask Claude to update the `manuscript-checklist` skill to match (or just
   start a manuscript review — it'll notice the drift itself per step 0
   above and can update the skill first). Point it at the diff from
   `check_sync.sh` if it's not already looking at it — that's exactly the
   set of changes that need to be reflected in `SKILL.md`.
3. Have Claude fold the change into the right category in `SKILL.md`. If
   the new/changed rule is mechanically detectable (a fixed find/replace
   pattern like the existing notation rules), consider adding a check to
   `scripts/grep_checks.sh` too — but most of the checklist is
   judgment-based and belongs in prose, not a regex.
4. Once `SKILL.md` reflects the change, refresh the snapshot so
   `check_sync.sh` stops flagging it:
   ```
   cp manuscript-checklist.tex .claude/skills/manuscript-checklist/synced-manuscript-checklist.tex
   ```

`synced-manuscript-checklist.tex` is bookkeeping for this sync check, not a
document anyone should read or edit directly — don't hand-edit it, only
`cp` over it as in step 4.
