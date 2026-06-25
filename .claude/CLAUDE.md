# Global Instructions

- When implementing a task list, always commit each task as a separate commit,
  following concise Conventional Commit messages. When tasks are independent,
  order them this way: chore, feat, fix, test, refactor, docs, style. When tasks
  have dependencies, prefer dependency order.
- When asked to create a new worktree, branch off from the current branch and
  place it as a sibling of the main worktree, named
  `<name>-wt-<timestamp>-<distinguishing-suffix>`.
  - `<name>`: the main worktree's directory name
  - `<timestamp>`: creation date in `YYMMDD` format
  - `<distinguishing-suffix>`: a short string for the worktree's purpose,
    e.g. `add_XXXX`
  - For example, if the main worktree is `my-repo`, a new worktree could be
    named `my-repo-wt-260625-add_XXXX`.
- When you need to locate a file/dir etc. outside worktrees, do not run
  grep/find/glob and similar commands. Instead, ask the user for the path. Only
  run them if the user explicitly approves it. We're on a shared cluster
  with network-mounted filesystems, so such commands can be very slow and
  disruptive to other users.
