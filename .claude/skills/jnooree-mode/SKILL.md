---
name: jnooree-mode
description: >-
  jnooree's working style for numbered reports, future-shape design posture,
  verified claims, and commit hygiene. Use for jnooree, /jnooree-mode, or
  requests to work in his style.
disable-model-invocation: true
---

# jnooree mode

`~/.claude/CLAUDE.md` holds the workflow gate, verb cues, commit and comment
rules. Each repo's `CLAUDE.md` holds its tooling. This skill adds what neither
says. Related skills by path: `~/.claude/skills/jnooree-design`,
`~/.claude/skills/gh-writeup`, `~/.claude/skills/worktree`. Language
conventions are path-scoped rules under `~/.claude/rules`.

## Reply

- Always number every finding, option, and question, so a single number
  identifies it. The user rules by index ("1 - fix. 3 - skip. unmentioned =
  yes").
- Unmentioned design items count as accepted, except items the user deferred
  in words. Earlier rulings in the session still bind. Unmentioned actions do
  not. Launching agents, review rounds, pushes, and code each need their own
  go.
- The ruling that settles the last open design item is the go for the plan.
  Deliver it in plan mode; do not ask for another go first.
- Each finding carries a recommended action, not only a description.
- Every number and choice names its source. An unmeasured number is never
  reported as a measurement.
- Pending actions are listed once, when they become pending, never repeated
  as a trailer.

## Design

The user judges a change by what the code looks like afterwards, not by
whether it closes the task. "Now" is anything this change touches that is
mechanical or whose absence fails silently. "Later" is a rare, visible,
recoverable path, or work outside this change, recorded as a trigger or an
issue. The round that applies this is `~/.claude/skills/jnooree-design`.

- New code matches the patterns that predate the branch, extrapolated for
  plausible future consumers.
- A cited rule names the choice it changed. Against the user's hint it
  yields until a repro or prior art backs it.
- Refactoring finishes the shape this pass, no verbatim move
  (`/pstack:principle-redesign-from-first-principles`). A remaining break is
  accepted only when the old shape is a bug with no canonical workaround, is
  documented unstable, or was settled.
- Deferring: only what is rare, visible, and recoverable. Write the trigger
  down instead of building machinery.
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
- A bug fix reproduces before and after and carries its regression test in
  the fix commit unless the fix is already pushed.

## Subagents

- One coder per batch or round.
- Decisions surface to the main agent first. Only real ones reach the user,
  with coding paused until they answer.
- A reviewer or prover gets a scratchpad snapshot of a document still under
  edit. Record HEAD before launching a coder, so its diff is reviewable
  against it. Planners are briefed read-only.

## Commits and history

- Tests ride in the feature commit. An ADR is its own docs commit before the
  code that depends on it. A committed ADR is never edited except by a fixup;
  a change is a new ADR that supersedes it. Plan drift goes in a trailing
  plan-only commit.
- A pushed commit takes a `fixup!` until it is reviewed, then a forward
  commit.
- Existing hacks of the same kind as the one being replaced are converted in
  one refactor commit before the feature.
- Revert a design decision by restoring the hunks verbatim with
  `git show main:<file>`, never by regenerating them, so the diff against
  main shows only the decisions that changed.
- No remote write (issue, PR, etc.) unless specifically requested.
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
