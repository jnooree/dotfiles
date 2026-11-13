---
paths:
  - "**/*.py"
---

# Python conventions

## Imports

- All imports stay at module level, top of file, unconditionally.
  - No `try`/`except ImportError` fallback imports.
  - No conditional (`if ...:`) imports.
- `csv` is banned. Always use `pandas`.
- Only deviate when the user explicitly instructs otherwise.

## Idioms

- A counter that advances by a fixed step is `itertools.count(start, step)`,
  never a variable bumped with `+= step`.
- Grouping values under a key is a `collections.defaultdict`, never
  `.setdefault(key, []).append(value)`.
- A record with fixed fields is a type, never a dict with literal keys: a
  `dataclass`, a `pydantic` model, a `NamedTuple`, or a similar typed
  record. The exception is a dict that a library API requires (e.g.,
  pandas), built only to satisfy that call.

## Tests

- Format-only code, such as a QOL `__repr__`, gets no test.
