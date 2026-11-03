# Code

- Encode invariants in structure (keys, types, partitions), enforce them
  once, then rely on them — delete guards that can no longer fire.
- Don't take both an object and a scalar it already carries. Explicit
  selectors over inference.
- Define before reference, C-style: a symbol appears above its first use.
  Within a file: types, then free functions, then entry point.
- Avoid code comments.
  - Never write *what* or *obvious why*. Delete them within edited hunks.
  - Comment urge is a signal of design gap. Rename, split, or type instead.
  - Compress survivors: 2 lines already borderline; 3+ only to cite verbatim.
  - Deferred work is a `TODO(jnooree): <what>` (missing) or
    `FIXME(jnooree): <what>` (broken) line, never bare. `XXX: <what>` flags
    a hazard that works today but must not be touched carelessly.
- Docs (docstrings included) describe the current state only. Fix only
  wrong wording, add only missing content. Content that would duplicate
  another part links to it instead of re-explaining, so the two cannot
  drift.
