# PR review

For a PR the user reviews. No title. The headline first, then one block per anchored point. A new round is appended after `---`, headline first.

```
<decision>: <comment>

<groups: only when several sites share a point>

<inline points: only when a point anchors to no file>

## `<path>:<start>-<end>` (<tag>)

<tier> <point>

<discussion: only on overflow or a code fence>
```

## Headline

- `<decision>` is one of `LGTM`, `LGTM with comments`, or `Blocking`. The user picks the GitHub verdict from this.
- `<comment>` is one or two friendly sentences to the author: what the PR does well and the main ask.
- `<groups>`: points that apply at several sites.
  - One plain sentence first that says what the list below is, such as `One point recurs at several sites, labeled below:`.
  - Each is `- **[<keyword>]**: <point>`, the keyword a short kebab-case name for the pattern, such as `xref` or `triple-quote`.
  - Overflow nests under the declaration as discussion bullets; a fence never does.
  - Every site is still its own block, written `<tier> **[<keyword>]**` plus only what is specific to that site, often nothing but a suggestion. Tiers may differ between sites.
- `<inline points>`: points with no file range to anchor to, such as the commit history or the PR description.
  - One plain sentence first that says why they are here, such as `One review item does not attach to a file, so it is presented here inline:`.
  - Each is a paragraph `**<subject>**: <tier> <point>`, the subject a short sentence-case name for what the point is about. Its discussion follows as in a block.

## Points

- Header: `<path>:<start>-<end>` is the whole range the comment anchors to, `<path>:<line>` for one line, `<path>` alone for a point on the whole file.
- `<tier>` is `[blocker]`, `[optional]`, `[nit]`, or `[FYI]` per `~/.claude/rules/review.md`.
- `<point>` is one line: the problem and the fix, or the question.
- `<discussion>`: also for a fenced block, such as a GitHub suggestion, code, or log, which on its own justifies one.

## Order

- By tier, blockers first, ties in file order. GitHub lists inline comments in posted order, so this is the author's reading order.
- Inline points stay in the headline, ordered by tier among themselves.
- The sites of a group stay adjacent, placed where the first site falls in the order, and within the group by tier then file order.
