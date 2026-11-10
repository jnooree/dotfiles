---
name: gh-writeup
description: User's conventions for a PR summary, issue draft, PR review reply, or PR review dumped into the worktree for them to paste into GitHub — file placement, length, structure, commit references, and the no-hard-wrap rule. Apply whenever asked to dump, write, or draft a PR summary, PR description, issue, reply to a PR review, or review of a PR, or to post a drafted review.
---

# GitHub write-ups

The user creates the PR or issue, or posts the reply, themselves from this file. Do not call `gh` to create or post one, and do not commit the file. The one exception is Posting in `pr-review.rules.md`.

Read the rules below, then `<name>.rules.md` beside this file, where `<name>.md` is the output file under Output.

## Output

- Write `pr-summary.md`, `issue.md`, `pr-reply.md`, or `pr-review.md` at the worktree root, untracked. Overwrite on revision, except `pr-reply.md` and `pr-review.md`, where new rounds are appended after `---`.
- Extra constraints given in the instruction override this skill, except the submit ban under Posting.

## Hard rules

- Concise. A PR summary or issue fits one screen. Never restate the diff. A design PR earns a second screen only for the decision itself. An issue spares extra lines only for an MRE or raw logs.
- One paragraph is one line. Never break a line inside a paragraph or list item; GitHub renders a single newline as `<br>`. Blank lines separate blocks.
- Reference code with SHA permalinks to line ranges, never branch URLs.
- Link issues and PRs as `#N` in the same repo, `<owner>/<repo>#N` otherwise. Commits are bare SHAs, `<owner>/<repo>@<sha>` across repos. Never put any of these in backticks, because that stops GitHub from auto-linking them.
- English unless instructed otherwise.

## Templates

Shared by issue draft and PR summary.

- Repo template, when one exists: drop checklist and boilerplate sections, but keep every remaining section, even empty. Pick the fitting one when several exist. A YAML issue form: one `## <field label>` per non-boilerplate field.
- When at most one umbrella section remains after that, count it as no template. A checklist alone, even under a heading, is the common case.

## Point blocks

Shared by PR reply and PR review.

- `<tag>` is a short tag that tells apart points on the same or nearby lines. A point with no line gets the tag alone.
- The line after `<verdict>` or `<tier>` is at most 80 characters, not counting markup.
- `<discussion>`: single-sentence bullets, never more than 3, the fewer the better; a single bullet is written as a plain paragraph. Add one only when the line above would exceed its limit, or on the trigger the kind names.
