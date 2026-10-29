---
name: jnooree-design
description: >-
  jnooree's design round: frame, ground, sketch, decide, settle, plan, audit.
  Use for /jnooree-design, "design decisions", "suggest a shape", "sketch the
  refactor", or "got a review".
---

# jnooree design round

The rubric a shape is judged by is `## Design` in `/jnooree-mode`. Invoke it
first; this skill is the procedure around it. Numbering runs through
the whole round: facts F1.., decisions D1.., hunks H1... A number is never
reused or renumbered. A settled or amended item keeps its number when re-listed.

"got a review" runs Steps 2, 3, 6 only. Findings ranked most severe first, each
with where the fix goes and a recommended action. A finding that changes a shape
opens the full design round.

`/pstack:<name>` is user-only, so the Skill tool refuses it. Run it by
reading `<pstack>/skills/<name>/SKILL.md` and following it, as
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
- Facts are yours to find; decisions are the user's. "find it first",
  "verify", "better or worse?", "do we even need X?" ask for facts: answer
  with evidence, then re-ask.
- Items deferred in words stay open. Earlier rulings hold. An amendment to
  a settled item is recorded under its number.
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

Each launch needs its own go: a fresh reviewer on the artifact, identical
prompt per round and blind when designs are compared; a prover for math; a
comparison table against the old design with row ids. Converged when a
round finds no defect.

## 6. Settle

- One re-list of every decision by number, split by destination: this
  change, other repo, issues, replies, backlog. Never repeated afterwards.
- Every deferral has a destination. A regression or gap found during
  the round is fixed in this change, as its own fix commit placed first.
- Sequencing contract: commit order, ADR first, the droppable change last,
  fixup or forward, who edits what, when the tree must compile, who
  verifies, coder subagents per chunk when the change is large, and the
  fresh reviewer after code (Step 8). The plan lists these, so plan approval
  is their go.

## 7. Plan and code

The ruling on the last open decision is the go for the plan. Plan mode, no
further go. A plan rejection is a late input: fold it and resubmit; it does
not reopen the round. Plan approval is go.

## 8. Audit, after code

One reply: the postmortem, then the reviewer's findings as "got a review.
verdict?" (Steps 2, 3, 6), each verified yourself first. A ruling that
changes code reruns Steps 7 and 8, until an audit changes no code.
