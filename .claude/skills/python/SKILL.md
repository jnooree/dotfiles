---
name: python
description: User's Python conventions — apply whenever working with Python
---

# Python Conventions

## Imports

- All imports stay at module level, top of file, unconditionally.
  - No `try`/`except ImportError` fallback imports.
  - No conditional (`if ...:`) imports.
- Only deviate when the user explicitly instructs otherwise.

## Tests

- Format-only code, such as a QOL `__repr__`, gets no test.
