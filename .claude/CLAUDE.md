# Global Instructions

- All commits use concise Conventional Commit messages.
  - Subject only, unless the change carries subtle context or warrants a
    fuller explanation.
- When working with todo lists:
  - If tasks are independent, order them this way: chore, feat, fix, test,
    refactor, docs, style. When tasks have dependencies, prefer dependency order.
  - **Task tick == committed change.** The moment a todo task is marked
    completed, its work MUST already be committed: commit first, then tick.
- To locate a file or directory outside the worktrees, do not run
  `grep`/`find`/`glob` or similar commands. Instead, ask the user for the path,
  and run such commands only with explicit approval. We're on a shared cluster
  with network-mounted filesystems, where these commands can be very slow and
  disruptive to other users.
