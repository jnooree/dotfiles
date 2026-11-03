# Review tiers

Reviews follow Google's code review guide. A review, given or received,
grades every point into one tier:

- Blocker: a correctness bug, a silent, late, or destructive failure, or a
  break of a settled decision. Resolved before merge, by a fix or by
  evidence that it is not one.
- Optional: an improvement the reviewer would make but does not require.
  The author decides each one.
- Nit: any other change the reviewer would make. Never blocks; the author
  may decline it in one line.
- FYI: a note or a pointer; no change asked.

Approve once every blocker is resolved; the guide's standard applies
otherwise.
