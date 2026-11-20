---
name: gh-writeup
description: User's conventions for a PR summary, issue draft, issue discussion, PR review reply, or PR review dumped into the worktree for them to paste into GitHub — file placement, length, structure, commit references, and the no-hard-wrap rule. Apply whenever asked to dump, write, or draft a PR summary, PR description, issue, issue discussion, reply to a PR review, or review of a PR, or to post a drafted review or PR summary.
---

# GitHub write-ups

The user creates the PR or issue, or posts the reply, themselves from this file. Do not call `gh` to create or post one, and do not commit the file. The exceptions are Posting in `pr-review.rules.md` and in `pr-summary.rules.md`.

Read the rules below, then `<name>.rules.md` beside this file, where `<name>.md` is the output file under Output. `issue-<N>-discussion.md` reads `issue-discussion.rules.md`.

## Output

- Write `pr-summary.md`, `issue.md`, `issue-<N>-discussion.md`, `pr-reply.md`, or `pr-review.md` at the worktree root, untracked. Overwrite on revision, except `issue-<N>-discussion.md`, `pr-reply.md`, and `pr-review.md`, where new rounds are appended after `---`.
- Extra constraints given in the instruction override this skill, except the submit ban under Posting.

## Hard rules

- Concise. A PR summary or issue fits one screen. Never restate the diff. A design PR earns a second screen only for the decision itself. An issue spares extra lines only for an MRE or raw logs.
- One paragraph is one line. Never break a line inside a paragraph or list item; GitHub renders a single newline as `<br>`. Blank lines separate blocks.
- A code reference is a permalink to a line range on the full 40-character SHA, never a branch URL.
  - Same repo: the bare URL at the end of the line, after all the prose of its paragraph or list item, a space between. Several follow in the order the prose cites them. GitHub swaps each for the code snippet where it stands, so one before the end splits the prose.
  - Other repo: a link inside the sentence, on the words that name the code, or `[<file>#L<start>-L<end>](<url>)` when none fit. It never renders as a snippet.
- A PR summary, review, or reply never permalinks the PR's own diff. A permalink is only for context outside the hunks.
- Link issues and PRs as `#N` in the same repo, `<owner>/<repo>#N` otherwise. Commits are bare SHAs, `<owner>/<repo>@<sha>` across repos. Never put any of these in backticks, because that stops GitHub from auto-linking them.
- English unless instructed otherwise.

## Templates

Shared by issue draft and PR summary.

- Repo template, when one exists: drop checklist and boilerplate sections, but keep every remaining section, even empty. Pick the fitting one when several exist. A YAML issue form: one `## <field label>` per non-boilerplate field.
- When at most one umbrella section remains after that, count it as no template. A checklist alone, even under a heading, is the common case.

## Point blocks

Shared by PR reply, PR review, and issue discussion.

- `<tag>` is a short tag that tells apart points on the same or nearby lines. A point with no line gets the tag alone.
- The line after `<verdict>` or `<tier>`, or the `<answer>` line, is at most 80 characters, not counting markup.
- `<discussion>`: single-sentence bullets, never more than 3, the fewer the better; a single bullet is written as a plain paragraph. Add one only when the line above would exceed its limit, or on the trigger the kind names.

### PR points

Shared by PR reply and PR review.

- The `## ` header is the anchor that locates the block. It is for the user only: never posted, by hand or per a kind's Posting.
- Inline points are points that anchor to no file, such as the PR description, the commit history, or a request in a review's summary comment.
  - One plain sentence first before the bullet points, that says why they are here, such as `One review item does not attach to a file, so it is presented here inline:`.
  - Each bullet is `- **<subject>**: ` followed by what a block's body line carries, the subject a short sentence-case name for what the point is about.
  - Its discussion nests under the bullet, even a single sentence.

## Quote replies

Shared by issue draft and issue discussion.

A quote reply cites a comment or review point from another issue or PR thread. GitHub only builds it in the web UI, so write it by hand. `> ` on every quoted line, the original markdown kept, then the attribution line. The login and permalink are `user.login` and `html_url` of the comment from `gh api`.

The quote is verbatim. Every departure is marked in square brackets, as in print: `*[...]*` for a cut, "[O]ne" for a changed letter, `[sic]` after an error kept from the original, "[that is]" for a gloss supplied.

```
> <quoted lines, verbatim>
> - <a list item stays a list item>

_Originally posted by @<login> in <html_url>_
```
