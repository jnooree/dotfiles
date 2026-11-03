# Design rubric

`~/.claude/rules/code.md`, expanded. The user judges a change by what the
code looks like afterwards, not by whether it closes the task. "Now" is
anything this change touches that is mechanical or whose absence fails
silently. "Later" is only what is rare, visible, and recoverable, or work
outside this change; it is written down as a trigger or an issue, never
built as machinery. In review, a break of any rule below is a blocker.

- New code matches the patterns that predate the branch, extrapolated for
  plausible future consumers.
- Refactoring finishes the shape this pass, no verbatim move
  (`/pstack:principle-redesign-from-first-principles`). A remaining break is
  accepted only when the old shape is a bug with no canonical workaround, is
  documented unstable, or was settled.
- Alike sites: one owner per meaning, not per shape. Shared syntax stays
  inline. `/pstack:principle-foundational-thinking`.
- A helper, wrapper, field, or variable needs a second real consumer or own
  state, else inline. A consumer the user names or the plan schedules is
  real. `/pstack:principle-minimize-reader-load`,
  `/pstack:principle-model-the-domain`.
- A guard, lock, or glue is the platform's mechanism, else none. Guard only
  where failure would be silent, late, or destructive.
  `/pstack:principle-boundary-discipline`, `/pstack:principle-fix-root-causes`.
- A read, cache, or table: stock defaults verbatim; re-derive a cheap value
  instead of bookkeeping.
- Comparable versions: the smaller diff. A rewrite needs a defect; a wording
  nit is not one. `/pstack:principle-laziness-protocol`.
- No suppression in place of a fix; a justified one is its own chore commit.
- Dead code this change touches: chore commit first,
  `/pstack:principle-subtract-before-you-add`. Other dead code: backlog.
- A swept literal becomes a named constant.
