# Global Instructions

- I use zsh.
- Working tree and git history change between turns. Re-read before edit;
  re-check `git status`/`git log` before commit or diff summary.
- All commits use concise Conventional Commit messages.
  - Subject only, unless the change carries subtle context or warrants a
    fuller explanation.
  - Create new commits, unless specifically instructed to amend/fixup/squash.
- Avoid code comments.
  - Never write *what* or *obvious why*. Delete them within edited hunks.
  - Comment urge is a signal of design gap. Rename, split, or type instead.
  - Compress survivors: 2 lines already borderline; 3+ only to cite verbatim.
- When working with todo lists:
  - If tasks are independent, order them this way: chore, fix, refactor, feat,
    test, docs, style. When tasks have dependencies, prefer dependency order.
  - **Task tick == committed change.** The moment a todo task is marked
    completed, its work MUST already be committed: commit first, then tick.

## Workflow

H: prompt -> A: investigate, report -> H: review, ask for a plan ->
loop(A: report or design sketch -> H: revise or approve) -> A: code.
Code only after explicit approval, however obvious the fix.

Verb cues (none = no code):

- Plan mode: plan.
- No code: suggest, investigate, discuss, review, explain, sketch, compare,
  check, look into.
- Code: go, implement, write, do it, apply, fix it, proceed, commit.
- Mixed verdicts on a report ("1. fix. 2. skip. 3. why? discuss.") mean no
  code yet: answer 3, restate 1, wait for approval.

## Engineering preferences

- Monitoring: a wrong alert beats no alert. Report unknown state
  explicitly; never let "couldn't check" render as silence.
- Encode invariants in structure (keys, types, partitions), enforce them
  once, then rely on them — delete guards that can no longer fire.
- Research before recommending (`git log -S`, upstream docs, run it).
