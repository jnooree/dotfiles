# Global Instructions

- All commits use concise Conventional Commit messages.
- When working with todo lists:
  - If tasks are independent, order them this way: chore, feat, fix, test,
    refactor, docs, style. When tasks have dependencies, prefer dependency order.
  - **Task tick == committed change.** The moment a todo task is marked
    completed, its work MUST already be committed: commit first, then tick.
- When asked to create a new worktree, branch off from the current branch and
  place it as a sibling of the main worktree, named
  `<name>-wt-<timestamp>-<distinguishing-suffix>`.
  - `<name>`: the main worktree's directory name
  - `<timestamp>`: creation date in `YYMMDD` format
  - `<distinguishing-suffix>`: a short string for the worktree's purpose,
    e.g. `add_XXXX`
  - For example, if the main worktree is `my-repo`, a new worktree could be
    named `my-repo-wt-260625-add_XXXX`.
  - Immediately after creating the worktree, switch into it by calling the
    **EnterWorktree** tool (pass the new worktree's `path`). Keep all subsequent
    work there, so the session cwd tracks the active worktree (the commit-gate
    hook reads cwd to find the tree it checks).
- When you need to locate a file/dir etc. outside worktrees, do not run
  grep/find/glob and similar commands. Instead, ask the user for the path. Only
  run them if the user explicitly approves it. We're on a shared cluster
  with network-mounted filesystems, so such commands can be very slow and
  disruptive to other users.
