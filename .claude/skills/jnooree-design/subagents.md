# Subagents

- Record HEAD before launching a coder, so its diff is reviewable against it.
- Coder model: always a fresh agent, not a fork. When the main agent runs on
  Fable, `opus xhigh`; otherwise the parent model with default effort.
- Decisions surface to the main agent first. Only real ones reach the user,
  with coding paused until they answer.
- A reviewer or prover gets a scratchpad snapshot of a document still under
  edit. Planners are briefed read-only.
- Repeated reviews of one artifact or diff (Step 5 rounds, Step 8 reruns):
  the reviewer stays blind; you rescale each later finding to the tiers the
  first review set, so a like finding keeps a like tier. Later reviewers
  promote their most severe finding to blocker as blockers run out. Tag the
  reviewer's tier when it differs.
