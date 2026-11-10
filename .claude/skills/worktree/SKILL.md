---
name: worktree
description: User's git worktree conventions — when to create one, how to name its branch, and how to leave it. Apply whenever asked to create or enter a git worktree.
---

# Worktrees

"switch off" means a new branch in place. Create a worktree only on the
literal word "worktree" or "wt". If there is a worktree already for the
branch, enter that tree with **EnterWorktree** `path` instead of creating
one; from inside another worktree, **ExitWorktree** `keep` first.

`git wt`, called by the WorktreeCreate hook, owns placement and naming: it puts the worktree beside
the main checkout as `<main>-wt-<YYMMDD>-<suffix>`. Never run
`git worktree add` yourself; the hook does not fire for it.

To create one, call **EnterWorktree** with `name` set to the branch:

- The branch is `<type>/<slug>`, e.g. `feat/cli-logging`. The type follows
  the commit-type rule: what the change ships.
- A branch that already exists, locally or on a remote, is checked out as
  is, with its upstream set: name `feat/foo` to work on `origin/feat/foo`.
  Any other branch starts from the current HEAD.
- When the prompt names a starting point, prefix it with `<base>..`, e.g.
  `origin/main..feat/cli-logging`. The branch is then always created new
  from that base.
- Run `git fetch` first if a remote branch or base must be fresh.

Keep all subsequent work in the worktree, so the session cwd tracks it (the
commit-gate hook reads cwd to find the tree it checks).

Leaving: **ExitWorktree** is `keep` only. Worktrees are removed by hand, never
by the agent.
