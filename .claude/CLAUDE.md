# Global Instructions

- I use zsh interactively. Scripts are bash.
- US spelling everywhere: code, docs, commits, replies.
- Blocked by a missing tool, package, or permission: stop and say what to
  install or grant. No ad-hoc venvs, no workarounds.
- Never run sudo or other privileged commands. Hand over a copy-pasteable
  command and say what to look for in its output.
- Wait on a PID or one exact status file, never on `pgrep -f` from a shell
  whose own command line matches the pattern.
- Working tree and git history change between turns. Re-read before edit;
  re-check `git status`/`git log` before commit or diff summary.
- All commits use concise Conventional Commit messages.
  - Subject only, unless the change carries subtle context or warrants a
    fuller explanation.
  - A correction to an unpushed commit from this session is a `fixup!` onto
    it. Everything else is a new commit; amend only when told.
  - The type follows what the change ships. Library or app code takes feat,
    fix, refactor, or perf. A change confined to docs, tests, CI, or build
    config takes docs, test, ci, or build, even when it is a fix or a
    refactor in nature.
- Avoid code comments.
  - Never write *what* or *obvious why*. Delete them within edited hunks.
  - Comment urge is a signal of design gap. Rename, split, or type instead.
  - Compress survivors: 2 lines already borderline; 3+ only to cite verbatim.
  - Deferred work is a `TODO(jnooree): <what>` line, never a bare TODO.
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

- No code: suggest, investigate, discuss, review, explain, sketch, compare,
  check, look into, plan.
- Code: go, implement, write, do it, apply, fix it, proceed, commit.
- Mixed verdicts on a report ("1. fix. 2. skip. 3. why? discuss.") mean no
  code yet: answer 3, restate 1, wait for approval.

## Engineering preferences

- Encode invariants in structure (keys, types, partitions), enforce them
  once, then rely on them — delete guards that can no longer fire.
- Research before recommending (`git log -S`, upstream docs, run it).
- Don't take both an object and a scalar it already carries. Explicit
  selectors over inference.
- Define before reference, C-style: a symbol appears above its first use.
  Within a file: types, then free functions, then entry point.
