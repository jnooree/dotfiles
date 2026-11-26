---
name: jnooree-design
description: >-
  jnooree's design round: frame, ground, decide, sketch, settle, plan, audit.
  Use for /jnooree-design, "design decisions", "suggest a shape", "sketch the
  refactor", "got a review", "want a review", "review this", or
  "issue discussion".
---

# jnooree design round

The rubric a shape is judged by is `design.md` beside this file; read it
first, this skill is the procedure around it. Read `subagents.md` before the
first launch. Numbering runs through the whole round: facts F1.., decisions
D1.., hunks H1... Numbering follows `~/.claude/rules/workflow.md`.
Co-editing: when the user edits an artifact (`TODO(claude)` markers, HTML
comments in a plan), answer each marker in place and change nothing else.

This skill has four modes:

1. Design mode, the default: the full procedure.
2. Review mode, "want a review":
   a. Review the diff against the base the user names, else the merge base
      with the base branch, through the working tree.
   b. Grade findings by `~/.claude/rules/review.md` and verify each.
   c. (PR review) Then read the PR context (description, comments, reviews),
      run Step 1, optionally go back to a–b once, and grade and verify any
      new finding the same way.
   d. Continue in follow-up mode.
      (PR review) Step 3 lists first the findings the context refutes, each
      with the passage, for the user to restore, and the round ends in
      rulings and, on request, in `pr-review.md` per `/gh-writeup` without
      the unrestored ones.
3. Follow-up mode, "got a review": Steps 2, 3, 6, then Steps 7 and 8 when
   a ruling changes code. In Step 3: decisions by tier, blockers first,
   each tagged with its tier, the rescaled one of `subagents.md` on a
   repeat review. One per blocker or optional; one for all nits. A review
   from GitHub ends in rulings and, on request, in `pr-reply.md` per
   `/gh-writeup`.
4. Issue discussion mode, "discussion on #N": follow `discussion.md` beside
   this file. It replaces Steps 1-8.

In Claude Code, `/pstack:<name>` is user-only, so the Skill tool refuses it.
Run it by reading `<pstack>/skills/<name>/SKILL.md` and following it, as
`<pstack>/docs/harness/claude-code.md` prescribes; read that adapter once per
session first. `<pstack>` is the `installPath` of `pstack@cursor-plugins` in
`~/.claude/plugins/installed_plugins.json`.

## 1. Frame

- Restate the change in one line with its scope boundary.
- (PR review) The restatement is instead the PR summary: Motivation,
  Approach, Changes, one sentence each. Changes carries the boundary.
- The user's hint ("I'm pretty sure", "I suspect", "I'm leaning toward") is
  a claim for Step 2, not a ruling.

Exit: the change is restated with its boundary, and every hint is a claim.

## 2. Ground

Report numbered facts, each with its source: path, commit, command, doc URL,
or measurement. The list is its own section of the reply. Cover:

- Owner and precedent predating the branch: what already does this, or the
  search that shows nothing does.
- Consumers, counted, with how downstream reads or writes the thing. A fixed
  set of consumers means no general mechanism; a named likely consumer lets
  a symbol earn its place.
- History: `/pstack:why`, `/pstack:how`. Regression or intent; introduced on
  the branch or predating it. Invoking the round is the go for the agents
  these launch.
- Canonical behavior: how the stock tool or an established library does it.
- Cost, measured when the shape has one: row counts, file counts, codegen,
  timing. Run it, never derive it.
- The hint: confirmed or refuted, with the evidence.

Exit: the hint has a verdict and every new symbol has a prior-art line.

## 3. Decide

- Invoke `/mattpocock-skills:grilling`. Its first round ends the reply
  that reports Step 2.
- Invoke `/mattpocock-skills:domain-modeling` when the repo has a
  `GLOSSARY.md`, `GLOSSARY-MAP.md`, or `docs/adr/`. Its glossary and ADR
  edits are decisions here and land in Step 7, never inline.
- An omitted decision is accepted per `~/.claude/rules/workflow.md`.
  Earlier rulings hold.
- Facts are yours to find; decisions are the user's. "find it first",
  "verify", "better or worse?", "do we even need X?" ask for facts: answer
  with evidence, then re-ask.
- Pushback against a ruling needs a repro or prior art. The user's pushback
  asks for facts.

Exit: no decision open.

## 4-5. Sketch and converge, on request

Until the user asks for a sketch, a shape is a decision in Step 3. The
request is the go for Step 4 of `sketch.md` beside this file. Step 5 runs
on its own request. The sketch returns to Step 3 for its ruling.

## 6. Settle

- One re-list of every decision by number, split by destination: this
  change, other repo, issues, replies, backlog. Its own section of the
  reply, never repeated afterwards.
- Every deferral has a destination. A regression or gap found during
  the round is fixed in this change, as its own fix commit placed first.
- Sequencing contract: commit order, ADR first, the droppable change last,
  fixup or forward, who edits what, when the tree must compile, who
  verifies. The plan lists these, so plan approval is their go.
- One coder per plan carries every commit in order. When the coder's
  brief would be longer than or comparable to the change itself, the plan
  says no coder instead. More coders only on the user's request.
- The plan opens with every subagent launch it makes, the audit reviewer
  included when the plan carries the audit line.
- Audit line: the plan ends with `**Audit**: fresh reviewer on the diff
  against <HEAD before the first code pass>`. The sha is captured in the
  first plan and copied verbatim into every rerun plan. Omit the line only
  when the user ruled out the audit during the round.

Exit: every decision has a destination.

## 7. Plan and code

- The ruling on the last open decision is the go for plan mode. If plan is
  skipped by the ruling, give the plan inline once and continue as if it
  were approved.
- When the ruling did not skip the plan and there is no plan-mode tool
  (Codex), give it inline and wait for approval.
- A plan rejection is a late input: fold it and resubmit; it does not reopen
  the round.
- Plan approval is go, including every launch the plan lists.

Exit: the plan, carrying the audit line unless ruled out, is approved, or
given inline when skipped, and its commits are in the tree.

## 8. Audit, after code

- One reply: the postmortem, then the audit report when the plan carries
  the audit line.
- Audit report: "want a review" against the sha the line names, done by a
  blind, fresh subagent. Never brief the round's reasoning, rejected
  alternatives, or your own findings.
- A ruling that changes code reruns Steps 7 and 8, until a pass changes
  no code.
- A sequencing ruling by the user (plan skipped, coder count, audit ruled
  out) holds for every rerun in the round until the user changes it.
  A no-coder the plan chose by brief length is re-decided per plan.

Exit: an audit pass changes no code and the user accepts the report. In
design mode, when not on the base branch, write `pr-summary.md` per
`/gh-writeup`.
