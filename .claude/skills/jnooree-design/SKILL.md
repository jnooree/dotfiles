---
name: jnooree-design
description: >-
  jnooree's design round: frame, ground, sketch, decide, settle, plan, audit.
  Use for /jnooree-design, "design decisions", "suggest a shape", "sketch the
  refactor", "got a review", "want a review", or "review this".
---

# jnooree design round

The rubric a shape is judged by is `design.md` beside this file; read it
first, this skill is the procedure around it. Read `subagents.md` before the
first launch. Numbering runs through the whole round: facts F1.., decisions
D1.., hunks H1... Numbering follows `~/.claude/rules/workflow.md`.

This skill has three modes:

1. Design mode, the default: the full procedure.
2. Review mode, "want a review":
   a. Review the diff against the base the user names, else the merge base
      with the base branch, through the working tree.
   b. Grade findings by `~/.claude/rules/review.md` and verify each.
   c. (PR only) Then read the PR context (description, comments, reviews),
      optionally go back to a–b once, and grade and verify any new finding
      the same way.
   d. Continue in follow-up mode.
      (PR only) Step 3 lists first the findings the context refutes, each
      with the passage, for the user to restore, and the round ends in
      `pr-review.md` per `/gh-writeup` without the unrestored ones.
3. Follow-up mode, "got a review": Steps 2, 3, 6, then Steps 7 and 8 when
   a ruling changes code. In Step 3: decisions by tier, blockers first,
   each tagged with its tier, the rescaled one of `subagents.md` on a
   repeat review. One per blocker or optional; one for all nits. A review
   from GitHub ends, after the last pass, in `pr-reply.md` per `/gh-writeup`.

In Claude Code, `/pstack:<name>` is user-only, so the Skill tool refuses it.
Run it by reading `<pstack>/skills/<name>/SKILL.md` and following it, as
`<pstack>/docs/harness/claude-code.md` prescribes; read that adapter once per
session first. `<pstack>` is the `installPath` of `pstack@cursor-plugins` in
`~/.claude/plugins/installed_plugins.json`.

## 1. Frame

- Restate the change in one line with its scope boundary.
- The user's hint ("I'm pretty sure", "I suspect", "I'm leaning toward") is
  a claim for Step 2, not a ruling.

## 2. Ground

Report numbered facts, each with its source: path, commit, command, doc URL,
or measurement. Cover:

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

- Invoke `/mattpocock-skills:grilling`.
- An omitted decision is accepted per `~/.claude/rules/workflow.md`.
  Earlier rulings hold.
- Facts are yours to find; decisions are the user's. "find it first",
  "verify", "better or worse?", "do we even need X?" ask for facts: answer
  with evidence, then re-ask.
- Pushback against a ruling needs a repro or prior art. The user's pushback
  asks for facts.

## 4. Sketch, on request

- The shape as an artifact that fits one screen: header or API block, ERD,
  tree, table, per-commit diff. Never a prose description of a shape.
- Screen it against the rubric and the red flags in `/pstack:architect`.
  A shape new to the repo gets two whole-shape candidates, compared on
  interface depth and diff size.
- Co-editing: when the user edits the artifact (`TODO(claude)` markers,
  HTML comments in a plan), answer each marker in place and change nothing
  else.
- Iterations are versioned (v2, v3); earlier versions stay in the
  scratchpad.

## 5. Converge, on request

Each launch here needs its own go: a fresh reviewer on the artifact,
identical prompt per round and blind when designs are compared; a prover for
math; a comparison table against the old design with row ids. Converged when
a round finds no defect.

## 6. Settle

- One re-list of every decision by number, split by destination: this
  change, other repo, issues, replies, backlog. Never repeated afterwards.
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

## 7. Plan and code

- The ruling on the last open decision is the go for plan mode. If plan is
  skipped by the ruling, give the plan inline once and continue as if it
  were approved.
- When the ruling did not skip the plan and there is no plan-mode tool
  (Codex), give it inline and wait for approval.
- A plan rejection is a late input: fold it and resubmit; it does not reopen
  the round.
- Plan approval is go, including every launch the plan lists.

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
