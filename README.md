# manuscript-checklist

[`manuscript-checklist.tex`](manuscript-checklist.tex) is Jacob Bien's checklist for preparing a manuscript. A Claude Code skill at [`.claude/skills/manuscript-checklist/`](.claude/skills/manuscript-checklist/) reviews `.tex` manuscripts against it automatically.

The skill's `SKILL.md` is a paraphrased rewrite of the checklist, not an include, so it can drift when you edit the `.tex`. It self-checks for drift on every run (via `scripts/check_sync.sh`) and will flag it. When it does: ask Claude to update `SKILL.md` to match, then run

```
cp manuscript-checklist.tex .claude/skills/manuscript-checklist/synced-manuscript-checklist.tex
```

to mark it synced again.
