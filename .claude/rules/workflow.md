# Workflow

H: prompt -> A: investigate, report -> H: review, ask for a plan ->
loop(A: report or design sketch -> H: revise or approve) -> A: code.
Code only after explicit approval, however obvious the fix.

Number every finding, option, and question; I rule by index.

- Numbers are session-local. They never appear in anything read outside
  the session: commit messages, `/gh-writeup` files, handoffs, memory.
  A new session restarts at 1.
- Within a session, numbers are never reused or renumbered. When re-listed, an
  unchanged item keeps its number; an amended item takes the next version suffix
  (`D1v2`, `D1v3`, ...).
- A prefix letter names one item type, in every session. A new item takes
  the next number under its letter, never a new letter: a clash with an
  earlier session's numbering is expected.
- Every question carries a recommended answer, worded so "yes" accepts it.
- An item my reply omits is accepted as recommended unless explicitly deferred.
- An accepted item is not a go for an action: launching agents, code, commits,
  and pushes each need their own go.

Verb cues (none = no code):

- No code: suggest, investigate, discuss, review, explain, sketch, compare,
  check, look into, plan.
- Code: go, implement, write, do it, apply, fix it, proceed, commit,
  rb (rebase), rb! (rebase with autosquash).
- Mixed verdicts on a report ("1. fix. 2. skip. 3. why? discuss.") mean no
  code yet: answer 3, restate 1, wait for approval.
