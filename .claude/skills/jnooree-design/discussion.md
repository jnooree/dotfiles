# Issue discussion

"discussion on #N". This file is the whole procedure; it borrows from
`SKILL.md` only the steps it names. The round ends in rulings, and in
`issue-<N>-discussion.md` on request. Author points are P1.., in the
author's order; your suggestions are S1...

## 1. Frame

- Read the issue and every comment. List every decision the author asks
  for: a change, a choice, or an answer. Asks on one subject that one
  ruling would settle are one P. The user's own comments are earlier
  positions: context, never a P.
- Each P is one sentence in the author's terms.
- Under it, the author's words behind that P are block-quoted verbatim,
  with corrections and cuts marked visibly, at most 3 lines for each
  related segment. Each segment carries its location: the heading, if one
  exists, and the paragraph number.
- The list is its own section of the reply, with no assessment in it.

Exit: every ask in the issue and in the author's comments falls under a P.

## 2. Ground

`SKILL.md` Step 2's report, each fact naming the P it bears on. Cover:

- A verdict on each claim in the quoted words: confirmed, refuted, or not
  verifiable.
- The gap in the current implementation, searched for yourself. A behavior
  change shows it by an observed failure: a repro, a scenario that was run
  and failed, or a real session. A refactor, naming included, shows it by
  a cited inconsistency or DX cost. An anticipated need or a constructed
  counterexample shows nothing.
- The repo each change belongs in.
- Related issues and PRs, open and closed, here and in the upstream and
  downstream repos.
- "Owner and precedent", "History", and "The hint", from the `SKILL.md`
  Step 2 list.

Exit: the hint has a verdict, and every P has a verdict on each quoted
claim, a repo, a gap result, and a precedent and a related-issue line, or
the search that found none.

## 3. Decide

`SKILL.md` Step 3, without domain modeling. Define in one clause, at first
use, each term a question depends on.

### 3a. Classify

Grilling's first round, which ends the first reply: one question per P,
labeled with its P. The recommended answer is every class whose test
holds, each citing the F behind it. When no test holds, the answer is
"(unclassified)" and the user decides.

| Test | Class | The author gets |
|---|---|---|
| The change belongs in another repo | `redirect` | that repo, and what lands there before here |
| It waits on a decision made elsewhere | `hold` | what it waits on |
| The current implementation already does it | `exists` | the path |
| Evidence contradicts the claim | `refuted` | the evidence |
| The choice is another person's | `delegate` | who decides |
| Step 2 found the gap | `gap` | a proposal |
| A change is proposed and Step 2 found no gap | `validate` | a request for a scenario or real failure |

### 3b. Accepted gap

A later grilling round, opened only for a P the user ruled `gap`, once per
gap: `Problem`, `Proposal`, `Validation`, each one line with its label as
the `<verdict>`, plus `<discussion>`, per `/gh-writeup`'s Point blocks.

- Every line carries its origin: a P for the author's, a D for the user's
  decision, an S for yours.
- Put each S to the user as a question. Adopted, or offered to the author
  as an option, it becomes a D; found to restate the author, it amends that
  P; otherwise it is dropped.
- Facts a Proposal needs come from the rest of the `SKILL.md` Step 2 list.

## 4. Settle

Starts with no S open.

- The re-list of `SKILL.md` Step 6, carrying every P once with its ruled
  classes.
- On request, `issue-<N>-discussion.md` per `/gh-writeup`, or a `gap` as
  `issue.md` with its three labels as the sections.
