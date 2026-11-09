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
the main checkout as `<main>-wt-<YYMMDD>-<suffix>` and branches it from the
current HEAD. Never run `git worktree add` yourself; the hook does not fire
for it.

To create one, call **EnterWorktree** with `name` set to the branch:

- The branch is `<type>/<slug>`, e.g. `feat/cli-logging`. The type follows
  the commit-type rule: what the change ships.
- When the prompt names a starting point, prefix it with `<base>..`, e.g.
  `origin/main..feat/cli-logging`. Omitted, the branch starts from the
  current HEAD. Run `git fetch` first if a remote base must be fresh.
- When creating a worktree from an upstream branch, use matching names, e.g.
  `origin/feat/foo..feat/foo`, so Git automatically sets the upstream.

Keep all subsequent work in the worktree, so the session cwd tracks it (the
commit-gate hook reads cwd to find the tree it checks).

Leaving: **ExitWorktree** is `keep` only. Worktrees are removed by hand, never
by the agent.
