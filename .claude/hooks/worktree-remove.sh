#!/usr/bin/env bash

# Exit 0 counts as removed and nothing is deleted, so every removal route
# (exit dialog, clean-worktree auto-removal, ExitWorktree) keeps the worktree.
# https://code.claude.com/docs/en/hooks#worktreeremove

exit 0
