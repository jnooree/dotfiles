# Global Instructions

- All commits use concise Conventional Commit messages.
  - Subject only, unless the change carries subtle context or warrants a
    fuller explanation.
  - Create new commits, unless specifically instructed to amend/fixup/squash.
- Avoid code comments. Delete comments explaining *what*.
- When working with todo lists:
  - If tasks are independent, order them this way: chore, feat, fix, test,
    refactor, docs, style. When tasks have dependencies, prefer dependency order.
  - **Task tick == committed change.** The moment a todo task is marked
    completed, its work MUST already be committed: commit first, then tick.
