# PR reply

No title. The headline first, when the review has one, then one block per review point, in review order.

```
<headline: only when the review has a summary comment>

## `<path>:<line>` (<tag>)

<verdict> <summary>

<discussion: only on overflow or a question back>
```

- Headline: one or two friendly sentences to the reviewer that answer the summary comment: the round's outcome and the response to its main ask. Never a per-point recap, and no verdict.
- Header: the point's `path:line` and `<tag>`.
- `<verdict>` choices:
  - `Fixed in <sha>:`, also when fixed by another approach; the summary then names it.
  - `Partly fixed in <sha>:`, the summary names what remains and why. Append `; deferred to #N` when an issue tracks the rest.
  - `Won't fix:`
  - `Deferred to #N:`
  - `Ack:` for a point agreed with that needs no change.
  - An answer, or a question back to the reviewer, gets no verdict.
- `<summary>` gives the change or the reason. It never restates the point.
- Discussion: also when the point asks the reviewer a question. Plain Fixed and Deferred get no discussion: stick to the limit.
- No code block, example, or log: that content belongs in a commit or an issue. A same-repo permalink takes the other-repo form in `SKILL.md`, so it stays a link.
- Deferred: draft `issue.md` per `issue.rules.md`, with the review point cited as a quote reply. Stop, ask the user to post it, and finish the item with the `#N` they send back.
- A point whose verdict changes after its round was written gets a new block under the same header in the current round. Earlier blocks are never edited.
