---
name: pr-automerge
description: >-
  User's ship sequence for a finished branch: verify, autosquash-rebase,
  verify again, push, post the PR summary, wait for CI and Bugbot, merge.
  Only for /pr-automerge or the literal word "automerge".
disable-model-invocation: true
---

# PR automerge

The request is the go for every step below, the push and the merge
included. Steps run in order. An unexpected failure ends the sequence
with a report; a later "automerge" starts over.

1. Verify: the repo's own check commands (test, lint, build), plus the
   verifications run earlier in the session. Report per
   `~/.claude/rules/verify.md`.
2. `git fetch`, then
   `GIT_SEQUENCE_EDITOR=true git rebase --autosquash origin/<base>`.
3. Step 1 again, on the rebased tree.
4. Push: `git push -u origin <branch>` on the first push, with
   `--force-with-lease --force-if-includes` when the push is not a
   fast-forward. Then push every other repo whose commits the PR summary
   will cite, autosquashing its fixups as in step 2.
5. PR summary per `/gh-writeup`, then its Posting.
6. `gh pr checks --watch --fail-fast` in the background. When it returns,
   list the checks again: a check named `Cursor Bugbot` means Bugbot is
   active, so watch once more until it finishes. Green is `success` for
   every check; Bugbot's `neutral` means findings or a PR too large to
   review. Anything else ends the sequence, and Bugbot findings are then a
   received review.
7. Count the commits over the merge base: one is `gh pr merge --squash`,
   more are `gh pr merge --merge`. Never `--delete-branch`; the branch is
   the user's. The reply ends with the PR URL.
