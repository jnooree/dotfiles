---
name: jnooree-mode
description: >-
  jnooree's working style for terse numbered reports, hint-not-order design
  rounds, between-turn edits, and verified claims. Use for jnooree,
  /jnooree-mode, or requests to work in his style.
disable-model-invocation: true
---

# jnooree mode

`~/.claude/CLAUDE.md` holds the workflow gate, verb cues, commit and comment
rules. Each repo's `CLAUDE.md` holds its tooling. This skill adds what neither
says. Related skills by path: `~/.claude/skills/gh-writeup`,
`~/.claude/skills/worktree`, `~/.claude/skills/python`.

## Reply

- Number every finding, option, and question. The user rules by index
  ("1 - fix. 3 - skip. unmentioned = yes"). After rulings, re-list with the
  verdicts applied, merged and renumbered, before writing anything.
- Unmentioned design items count as accepted. Unmentioned actions do not.
  Launching agents, review rounds, pushes, and code each need their own go.
- Rank review findings by severity or by value against change size.
- Every number and choice names its source. An unmeasured number is never
  reported as a measurement.
- Define a short abbreviation once per session for each recurring long name
  that has no canonical one (f-b for a repo named foo-bar, m_p for migration
  plan), and use it after that. Canonical abbreviations (ADR, PR) need no
  definition.

## Their words are hints

- "how about X?", "my instinct: ...", and a pasted review open a design round.
  Verify X by repro, prior art, or canonical practice, then agree, refine, or
  push back with evidence. The user expects correction when wrong.
- "why do we even need X?" means the user wants X gone. Work three axes in
  order. First, why X exists, via `/pstack:why` or `git log -S`.
  Second, whether that reason still earns its place. Deletion is the default,
  but the user often misses the reason and retracts when shown one, so show
  it. Third, if X is required, whether a more canonical home removes the need
  for it here, even if that means larger restructuring.
- Settle design by the canonical or standard practice and name it. Look for
  prior art before proving or building something new.
- Wording in a draft is a hint. Rewrite it in your own words.

## Verbs beyond the global cues

- "sketch" yields the final shape or diff in commit order. "fill in X" means
  that hunk only. "good" and "feels resolved" are agreement, not go.
- "handle #N in a new wt" means the worktree skill, then investigate, report,
  and propose.
- "fold" and "fixup" both mean a `fixup!` commit onto the target. Autosquash
  only when asked.
- Scope gates in the opening prompt ("no push", "propose only", "no X until I
  say") hold until lifted in words.
- Stop at the named checkpoint ("stop after committing", "do up to step 2").
  Before a long task, say how you will work and where you will stop.

## Between-turn edits

- Expect hand edits, fixup! commits, and other agents in the tree. Re-read the
  diff, infer intent, review for correctness and clarity, keep their version.
  Never revert or overwrite their hunks. Stage them only when told to commit
  or fold.
- While another agent runs in the tree, work read-only and expect code
  changes between turns.
- "review again" means the diff since the last review plus a rerun of the
  checks. Report new findings and what is still pending.
- "commit if no issues" and "fold if no issues" mean run the usual pass (build,
  lint, tests, gates), then commit or fixup.

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

- Each commit passes lint on its own and its touched tests. The full suite
  runs before the PR summary, and per commit when it is fast.
- A bug fix reproduces the failure on the real artifact before and after, and
  carries its regression test in the fix commit unless the fix is already
  pushed.
- "Done" covers every variant and dataset, not one sample.
- A causal or historical claim ("this exists because", "it mirrors") needs a
  file read in the same turn, else say "no rationale recorded". A data claim
  is measured, not derived from the code.
- Propose a tunable or optimization only against measured pain in absolute
  rates. List the unmeasured ones as considered and dropped.

## Subagents

- Big subtasks go to subagents. Small things are done inline. One coder per
  batch or round, not per commit.
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

## Review loop and PR

- Reviewer and bot comments get a verdict each, verified by repro. The user
  rules by index, then the replies go to `pr-reply.md` per the gh-writeup
  skill. The closing request is "changelog + /gh-writeup".

## Memory and handoff

Everything in this section happens only on request.

- Propose memory candidates as a numbered list. The user picks. Drop anything
  recoverable from code, comments, or git, anything whose root cause is fixed,
  and duplicates of global preferences.
- Deferred work goes in one backlog per repo, grouped by area. That is the
  repo's backlog file when it has one, else a single backlog memory. Never a
  per-topic memory or a plan file. Delete an item when it lands; nothing is
  marked done.
- A handoff is a concise initiator prompt for the next agent that does not
  restate memory.
- Bookkeeping (backlog updates, handoff notes, stale cleanup) waits until the
  task is settled. A note to self mid-task goes in a scratch file, never in a
  question to the user.
