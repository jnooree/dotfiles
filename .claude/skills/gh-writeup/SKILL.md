---
name: gh-writeup
description: User's conventions for a PR summary or issue draft dumped into the worktree for them to paste into GitHub — file placement, length, structure, and the no-hard-wrap rule. Apply whenever asked to dump, write, or draft a PR summary, PR description, or issue.
---

# PR Summary / Issue Draft

The user creates the PR or issue themselves from this file. Do not call `gh` to create one, and do not commit the file.

## Output

- Write `pr-summary.md` or `issue.md` at the worktree root, untracked. Overwrite on revision.
- Line 1: the title. Blank line. Then the body, exactly as it will be pasted.
- Extra constraints given in the instruction override this skill.

## Hard rules

- Concise. A PR summary or issue fits one screen. Never restate the diff. A design PR earns a second screen only for the decision itself. An issue spares extra lines only for an MRE or raw logs.
- One paragraph is one line. Never break a line inside a paragraph or list item; GitHub renders a single newline as `<br>`. Blank lines separate blocks.
- Repo template, when one exists: drop checklist and boilerplate sections, but keep every remaining section, even empty. Pick the fitting one when several exist. A YAML issue form: one `## <field label>` per non-boilerplate field.
- When at most one umbrella section remains after that, count it as no template. A checklist alone, even under a heading, is the common case.
- Reference code with SHA permalinks to line ranges, never branch URLs.
- Link issues and PRs as `#N` in the same repo, `<owner>/<repo>#N` otherwise.
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

## Issue draft

Title: a plain sentence-case phrase naming the action or the thing. No type prefix, symbols in backticks. Examples:

- Deduplicate `write_dummy_outputs` and the scdeco empty-lane writer
- A campaign-wide `context` shared by every agent

Link the prior art a proposal mirrors. `Ref: #N` on its own last line for a related issue/PR this one does not track.

No repo template, or the user asks for the "personal template": `## Problem` then `## Proposal`, a fenced example and bulleted rules.
