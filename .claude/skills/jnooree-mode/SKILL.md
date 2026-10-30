---
name: jnooree-mode
description: >-
  jnooree's engineering preferences expanded: what code looks like after a
  change, how a claim about it is backed, and how it lands. Use for jnooree,
  /jnooree-mode, or requests to work in his style.
---

# jnooree mode

`## Engineering preferences` in `~/.claude/CLAUDE.md`, expanded.

## Design

The user judges a change by what the code looks like afterwards, not by
whether it closes the task. "Now" is anything this change touches that is
mechanical or whose absence fails silently. "Later" is only what is rare,
visible, and recoverable, or work outside this change; it is written down as
a trigger or an issue, never built as machinery.

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

## Verify

- `/pstack:principle-prove-it-works`: the real artifact, rendered output,
  measured data. Never a proxy, a build log, or a derivation from the code.
- Every number and choice names its source. An unmeasured number is never
  reported as a measurement.
- A bug fix reproduces before and after.

## Review

Reviews follow Google's code review guide. A review, given or received,
grades every point into one tier:

- Blocker: a correctness bug, a silent, late, or destructive failure, or a
  break of `## Design` or of a settled decision. Resolved before merge, by a
  fix or by evidence that it is not one.
- Optional: an improvement the reviewer would make but does not require.
  The author decides each one.
- Nit: any other change the reviewer would make. Never blocks; the author
  may decline it in one line.
- FYI: a note or a pointer; no change asked.

Approve once every blocker is resolved; the guide's standard applies
otherwise.

## Subagents

- One coder per batch or round. Record HEAD before launching it, so its
  diff is reviewable against it.
- Decisions surface to the main agent first. Only real ones reach the user,
  with coding paused until they answer.
- A reviewer or prover gets a scratchpad snapshot of a document still under
  edit. Planners are briefed read-only.

## Commits and history

- Tests ride in the commit they cover, unless the fix is already pushed.
- An ADR is its own docs commit before the code that depends on it. A
  committed ADR is never edited except by a fixup; a change is a new ADR
  that supersedes it. Plan drift goes in a trailing plan-only commit.
- Existing hacks of the same kind as the one being replaced are converted in
  one refactor commit before the feature.
- Revert a design decision by restoring the hunks verbatim with
  `git show main:<file>`, never by regenerating them, so the diff against
  main shows only the decisions that changed.
- An issue draft starts with a search of the open issues. A duplicate becomes
  a comment on the existing one.

## Changelog and docs

- Changelog only when asked. With no repo rules, an entry follows Keep a
  Changelog, as a Debian-style short heads-up pointer for users, relative to
  main, for user-visible changes only. Commit placement follows the request.
- Docs describe the current state only. Fix only wrong wording, add only
  missing content. Content that would duplicate another part links to it
  instead of re-explaining, so the two cannot drift.

## Memory and handoff

- A memory holds nothing recoverable from code, comments, or git, nothing
  whose root cause is fixed, and no duplicate of a global preference.
- Deferred work goes in one backlog per repo, grouped by area. That is the
  repo's backlog file when it has one, else a single backlog memory. Never a
  per-topic memory or a plan file. Delete an item when it lands; nothing is
  marked done.
- A handoff is a concise initiator prompt for the next agent that does not
  restate memory.
- Bookkeeping (backlog updates, handoff notes, stale cleanup) waits until the
  task is settled. A note to self mid-task goes in a scratch file, never in a
  question to the user.
