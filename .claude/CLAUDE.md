# Global Instructions

- I use zsh interactively. Scripts are bash.
- US spelling everywhere: code, docs, commits, replies.
- No remote write (issue, PR, etc.) unless specifically requested.
- When blocked by a missing tool, package, or permission, stop and say what
  to install or grant. No ad-hoc venvs, no workarounds.
- Never run sudo or other privileged commands. Hand over a copy-pasteable
  command and say what to look for in its output.
- Wait on a PID or one exact status file, never on `pgrep -f` from a shell
  whose own command line matches the pattern.
- I use skills `disable-model-invocation: true`. If a skill is not listed in
  your inventory but I mentioned it, call it, don't ask.
- Resolve plan or memory file path (`realpath`) before writing to it. The
  parent directories might be a symlink.
