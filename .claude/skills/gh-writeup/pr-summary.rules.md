# PR summary

Line 1 is the title. Blank line. Then the body, exactly as it will be pasted.

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

Editing a posted PR body:

- Sync with the current PR body first from GitHub. The user occasionally edits the PR online, and the posted one is the authoritative version.
- Minimize diff. Change only what the request covers; everything else carries over verbatim.
- Two modes:
  - "redline" mode, the default: keep the previous content, wrap stale text in `~~`, and add the correction after **EDIT**:.
  - "rewrite" mode, on request: write the body fresh, carrying over whatever in the posted one still holds.
