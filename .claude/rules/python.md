---
paths:
  - "**/*.py"
---

# Python conventions

## Imports

- All imports stay at module level, top of file, unconditionally.
  - No `try`/`except ImportError` fallback imports.
  - No conditional (`if ...:`) imports.
- Only deviate when the user explicitly instructs otherwise.

## Idioms

- A counter that advances by a fixed step is `itertools.count(start, step)`,
  never a variable bumped with `+= step`.
- Grouping values under a key is a `collections.defaultdict`, never
  `.setdefault(key, []).append(value)`.

## Tests

- Format-only code, such as a QOL `__repr__`, gets no test.
