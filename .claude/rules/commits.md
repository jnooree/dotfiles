# Commits

- Expect hand edits, fixup! commits, and other agents in the tree. Re-read
  before edit; re-check `git status`/`git log` before commit or diff
  summary. Never revert or overwrite another author's hunks. Stage them only
  when told to commit or fold.
- All commits use concise Conventional Commit messages.
  - Subject only, unless the change carries subtle context or warrants a
    fuller explanation.
  - A correction to an unpushed commit from this session, or a pushed one
    not yet reviewed, is a `fixup!` onto it. Everything else is a new
    commit; amend only when told.
  - The type follows what the change ships. Library or app code takes feat,
    fix, refactor, or perf. A change confined to docs, tests, CI, or build
    config takes docs, test, ci, or build, even when it is a fix or a
    refactor in nature.
- When working with todo lists:
  - If tasks are independent, order them this way: chore, fix, refactor, feat,
    test, docs, style. When tasks have dependencies, prefer dependency order.
  - **Task tick == committed change.** The moment a todo task is marked
    completed, its work MUST already be committed: commit first, then tick.
- Tests ride in the commit they cover, unless the fix is already pushed.
- An ADR is its own docs commit before the code that depends on it. A
  committed ADR is never edited except by a fixup; a change is a new ADR
  that supersedes it. Plan drift goes in a trailing plan-only commit.
- Existing hacks of the same kind as the one being replaced are converted in
  one refactor commit before the feature.
- Revert a design decision by restoring the hunks verbatim with
  `git show main:<file>`, never by regenerating them, so the diff against
  main shows only the decisions that changed.
- An issue draft starts with a search of the open issues. A duplicate becomes
  a comment on the existing one.
