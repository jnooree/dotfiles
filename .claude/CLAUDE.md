# Global Instructions

- I use zsh.
- All commits use concise Conventional Commit messages.
  - Subject only, unless the change carries subtle context or warrants a
    fuller explanation.
  - Create new commits, unless specifically instructed to amend/fixup/squash.
- Avoid code comments.
  - Never write *what* or *obvious why*. Delete them within edited hunks.
  - Comment urge is a signal of design gap. Rename, split, or type instead.
  - Compress survivors: 2 lines already borderline; 3+ only to cite verbatim.
- When working with todo lists:
  - If tasks are independent, order them this way: chore, feat, fix, test,
    refactor, docs, style. When tasks have dependencies, prefer dependency order.
  - **Task tick == committed change.** The moment a todo task is marked
    completed, its work MUST already be committed: commit first, then tick.

## Engineering preferences

- Monitoring: a wrong alert beats no alert. Report unknown state
  explicitly; never let "couldn't check" render as silence.
- Encode invariants in structure (keys, types, partitions), enforce them
  once, then rely on them — delete guards that can no longer fire.
- Research before recommending (`git log -S`, upstream docs, run it).
