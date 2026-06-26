---
name: worktree
description: User's git worktree creation conventions — naming, placement, and post-create switch. Apply whenever asked to create a new git worktree.
---

# Worktree Creation

When asked to create a new worktree:

- Branch off from the current branch.
- Place it as a sibling of the main worktree, named
  `<name>-wt-<timestamp>-<distinguishing-suffix>`.
  - `<name>`: the main worktree's directory name
  - `<timestamp>`: creation date in `YYMMDD` format
  - `<distinguishing-suffix>`: a short string describing the worktree's
    purpose, e.g. `add_XXXX`
  - Example: if the main worktree is `my-repo`, a new worktree could be named
    `my-repo-wt-260625-add_XXXX`.
- Immediately after creating the worktree, switch into it by calling the
  **EnterWorktree** tool (pass the new worktree's `path`). Keep all subsequent
  work there, so the session cwd tracks the active worktree (the commit-gate
  hook reads cwd to find the tree it checks).
