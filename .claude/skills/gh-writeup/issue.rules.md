# Issue draft

Line 1 is the title. Blank line. Then the body, exactly as it will be pasted.

Title: a plain sentence-case phrase naming the action or the thing. No type prefix, symbols in backticks. Examples:

- Deduplicate `write_dummy_outputs` and the scdeco empty-lane writer
- A campaign-wide `context` shared by every agent

Cross-references between draft issues use `#<{i}-slug>` placeholders until the numbers exist. Link the prior art a proposal mirrors. `Ref: #N` on its own last line for a related issue/PR this one does not track.

No repo template, or the user asks for the "personal template": `## Problem`, then `## Proposal`, a fenced example and bulleted rules, then `## Validation`, bullets on how the change is proven.

Citing a comment or review point: a quote reply. GitHub only builds it in the web UI, so write it by hand. `> ` on every quoted line, the original markdown kept, then the attribution line. The login and permalink are `user.login` and `html_url` of the comment from `gh api`.

The quote is verbatim. Every departure is marked in square brackets, as in print: `*[...]*` for a cut, "[O]ne" for a changed letter, `[sic]` after an error kept from the original, "[that is]" for a gloss supplied.

```
> <quoted lines, verbatim>
> - <a list item stays a list item>

_Originally posted by @<login> in <html_url>_
```
