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
says. Related skills by path: `~/.claude/skills/gh-writeup`,
`~/.claude/skills/worktree`, `~/.claude/skills/python`.

## Reply

- Always number every finding, option, and question, so a single number
  identifies it. The user rules by index ("1 - fix. 3 - skip. unmentioned =
  yes").
- Unmentioned design items count as accepted. Unmentioned actions do not.
  Launching agents, review rounds, pushes, and code each need their own go.

## Future shape over task shortcut

The user judges a change by what the code looks like afterwards, not by
whether it closes the task. "Now" is anything this change already touches
that is mechanical, or whose absence fails silently. "Later" is a visible,
recoverable rare path, or work outside this change, recorded as a trigger or
an issue.

- One owner per meaning, not per shape. Unify when a change to one copy would
  silently require the same change to another: a value, a derivation, a
  predicate, a kernel, a convention. Sites that merely share syntax stay
  inline, however alike they look. Size does not decide it.
- Reuse the existing owner, refactoring it to serve both, before creating one.
  A new helper, class, wrapper, or variable needs a second real consumer or
  state of its own. Otherwise it is an inline expression or a file-private
  function. A deliberate generalization pass is the exception, and then it is
  finished.
- Finish the shape you started. A refactor or generalization gets its
  complete, idiomatic API in this pass, not a verbatim move or a two-callers
  minimum.
- The platform's standard mechanism beats a hand-written guard, lock, or glue.
  If the standard tool also blocks legitimate use, drop the guard and rely on
  tests.
- Shape for the likely future, build nothing for it. Pick structures that do
  not block a plausible next consumer, but add no feature, overload, binding,
  field, or wrapper for a consumer that does not exist yet. Those are separate
  design tasks. A consumer the user names or the plan schedules is real.
- Defer only what is rare, visible, and recoverable, or outside this change.
  Write the trigger down or file an issue instead of building machinery. A
  silent, late, or destructive failure is never deferred.
- Design on top of the current code first. If that stays messy and never
  lands in a clean shape, redesign ignoring current consumers, then retrofit
  the result so the break shrinks or disappears. What still breaks after the
  retrofit is accepted only when the old shape is itself a bug with no
  simple, canonical workaround, when it is documented as unstable, or when
  the break was requested or already settled, in this session or in the
  related issue.
- When two versions are comparably good, the smaller diff wins. A rewrite
  needs a defect to fix. A wording nit or a vague ambiguity is not one.

## Code and design posture

- A hunk-scoped ask ("fill in X", "drop Y") gets that edit only. No adjacent
  rewrites, no new helpers. No suppression in place of a fix; a justified
  suppression is its own chore commit. Defend every hunk with its origin and
  reason, or revert it together with what depends on it.
- Guard only where the failure would be silent, late, or destructive. Where
  misuse already fails on its own, no guard for "usability". Fail loudly on
  ambiguous input.
- Reuse upstream and stock defaults verbatim. Question each extra read, cache,
  and table. Re-derive a cheap value instead of adding bookkeeping.
- Dead code this change touches goes first, in a chore commit. Other dead
  code goes to the backlog.
- A swept literal becomes a named constant.
- New code matches the patterns that predate the branch.

## Verify

- A bug fix reproduces the failure on the real artifact before and after, and
  carries its regression test in the fix commit unless the fix is already
  pushed.
- A data claim is measured, not derived from the code.

## Subagents

- One coder per batch or round.
- Decisions surface to the main agent first. Only real ones reach the user,
  with coding paused until they answer.
- A reviewer or prover gets a scratchpad snapshot of a document still under
  edit. Record HEAD before launching a coder, so its diff is reviewable
  against it. Planners are briefed read-only.

## Commits and history

- Tests ride in the feature commit. An ADR is its own docs commit before the
  code that depends on it. Plan drift goes in a trailing plan-only commit.
- Existing hacks of the same kind as the one being replaced are converted in
  one refactor commit before the feature.
- Revert a design decision by restoring the hunks verbatim with
  `git show main:<file>`, never by regenerating them, so the diff against
  main shows only the decisions that changed.
- No remote write (issue, PR, etc.) unless specifically requested.

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
