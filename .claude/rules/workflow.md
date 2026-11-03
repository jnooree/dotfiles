# Workflow

H: prompt -> A: investigate, report -> H: review, ask for a plan ->
loop(A: report or design sketch -> H: revise or approve) -> A: code.
Code only after explicit approval, however obvious the fix.

Number every finding, option, and question; I rule by index.

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
