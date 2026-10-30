---
name: gh-writeup
description: User's conventions for a PR summary, issue draft, PR review reply, or PR review dumped into the worktree for them to paste into GitHub — file placement, length, structure, commit references, and the no-hard-wrap rule. Apply whenever asked to dump, write, or draft a PR summary, PR description, issue, reply to a PR review, or review of a PR.
---

# PR Summary / Issue Draft / PR Reply / PR Review

The user creates the PR or issue, or posts the reply, themselves from this file. Do not call `gh` to create or post one, and do not commit the file.

## Output

- Write `pr-summary.md`, `issue.md`, `pr-reply.md`, or `pr-review.md` at the worktree root, untracked. Overwrite on revision, except `pr-reply.md` and `pr-review.md`, which only grow.
- Summary and issue: line 1 is the title. Blank line. Then the body, exactly as it will be pasted.
- Extra constraints given in the instruction override this skill.

## Hard rules

- Concise. A PR summary or issue fits one screen. Never restate the diff. A design PR earns a second screen only for the decision itself. An issue spares extra lines only for an MRE or raw logs.
- One paragraph is one line. Never break a line inside a paragraph or list item; GitHub renders a single newline as `<br>`. Blank lines separate blocks.
- Repo template, when one exists: drop checklist and boilerplate sections, but keep every remaining section, even empty. Pick the fitting one when several exist. A YAML issue form: one `## <field label>` per non-boilerplate field.
- When at most one umbrella section remains after that, count it as no template. A checklist alone, even under a heading, is the common case.
- Reference code with SHA permalinks to line ranges, never branch URLs.
- Link issues and PRs as `#N` in the same repo, `<owner>/<repo>#N` otherwise. Commits are bare SHAs, `<owner>/<repo>@<sha>` across repos. Never put any of these in backticks, because that stops GitHub from auto-linking them.
- English unless instructed otherwise.

## PR summary

Title: Conventional Commit subject with a path-like scope: `feat(pipe/method/folding): renumber outputs to ref_pdb`. Lowercase, imperative, backticks allowed.

When any issue or PR relates, the body leads with one reference line. Tracked issue: `Closes/Fixes/Resolves #N.` (the only keywords GitHub auto-closes on). Otherwise `Related: #a, #b.`, `Supersedes #N.`, etc.

No repo template, or the user asks for the "personal template": one of the two below.

Small change: at most five bullets, one line each, no headings. Each bullet is a decision or a reason, never a restatement of the diff. Prose only when the bullets would need a connecting argument.

Design change: these sections, in this order, only those that carry content. Bullets over prose inside every section but Summary; one framing sentence around a list or table is fine.

- `## Summary`
- `## Design` (or `## Semantics`): bullets, one rule each. A short tree or config block before them when it helps.
- `### Considered`: each alternative names the prior art it mirrors and the sentence that killed it.
- `### Dead ends`
- `### Caveats` (or `## Notes` at the end)
- `## Changes`
- `### Breaking changes`
- `## Deferred`

Editing a posted PR body: minimal diff. Keep the previous content, wrap stale text in `~~`, and add the correction after **EDIT**:.

## Issue draft

Title: a plain sentence-case phrase naming the action or the thing. No type prefix, symbols in backticks. Examples:

- Deduplicate `write_dummy_outputs` and the scdeco empty-lane writer
- A campaign-wide `context` shared by every agent

Cross-references between draft issues use `#<{i}-slug>` placeholders until the numbers exist. Link the prior art a proposal mirrors. `Ref: #N` on its own last line for a related issue/PR this one does not track.

No repo template, or the user asks for the "personal template": `## Problem` then `## Proposal`, a fenced example and bulleted rules.

## PR reply

No title. One block per review point, in review order:

```
## `<path>:<line>` (<tag>)

<verdict> <summary>

<discussion: only when the summary line fails>
```

- Header: the point's `path:line` and a short tag that tells apart points on the same or nearby lines. A point with no line gets the tag alone.
- `<verdict>` choices:
  - `Fixed in <sha>:`, also when fixed by another approach; the summary then names it.
  - `Partly fixed in <sha>:`, the summary names what remains and why. Append `; deferred to #N` when an issue tracks the rest.
  - `Won't fix:`
  - `Deferred to #N:`
  - `Ack:` for a point agreed with that needs no change.
  - An answer, or a question back to the reviewer, gets no verdict.
- `<summary>` is a single line that gives the change or the reason. It never restates the point.
- Try to put each point into the summary line alone. Add a discussion, as a short paragraph or bullets, only when that line fails, which means the point needs one of these:
  - a reasoning chain, where a second sentence builds on the first;
  - a code block, example, or log;
  - a question back to the reviewer.

  Plain Fixed and Deferred never fail, because the commit or the issue holds the rest.
- Deferred: draft `issue.md` following the Issue draft rules, with the review point quoted directly. Stop, ask the user to post it, and finish the item with the `#N` they send back.
- When a new review round arrives, append its blocks. Rewrite an earlier block only when its verdict changes.

## PR review

For a PR the user reviews. No title. The verdict first, then one block per point, in file order:

```
## `<path>:<line>` (<tag>)

<tier> <point>
```

- Verdict, first line: `LGTM`, `LGTM with comments`, or `Blocking:` followed by the blockers' headers.
- Header as in PR reply.
- `<tier>` is `[blocker]`, `[optional]`, `[nit]`, or `[fyi]` per `## Review` in `/jnooree-mode`.
- `<point>` is one line: the problem and the fix, or the question. A discussion follows only under the PR reply rules.
- A new round is appended after `---`, verdict first.
