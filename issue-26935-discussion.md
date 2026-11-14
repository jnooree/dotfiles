Adding the headless CLI case: for worktrees created with `orca worktree create` on the server, neither placement setting can be changed by any client or command.

## CLI creates cannot reach the worktree placement settings

Please include `workspaceDir` and `nestWorkspaces` in the server-settable set.

- Setup: macOS desktop paired with a Linux host running Orca 1.4.258 (orcad 0.1.0+288ccfe2aeba). Changing Workspace Directory on the desktop leaves the server's `profile-state.db` at `~/orca/workspaces` with `nestWorkspaces: true`, and a CLI create still lands in `~/orca/workspaces/<repo>/<name>`.
- The desktop sends `nestWorkspaces` per request (https://github.com/stablyai/orca/blob/e9d5b35d64e2d5faa87f8c1d1971ee84a74f8178/src/shared/rpc-contract/worktree-create-params.ts#L69-L70), but nothing under `src/cli` passes it and `worktree create` has no flag for it, so creates from the CLI, agents, and orchestration workers always use the server's value.
- The per-repo base path (`orca project setup-update --worktree-base-path`) is the only reachable knob, and with nesting on it still resolves to `<base>/<repo>/<name>` (https://github.com/stablyai/orca/blob/e9d5b35d64e2d5faa87f8c1d1971ee84a74f8178/src/main/ipc/worktree-logic.ts#L84-L88), so a sibling layout such as `<parent>/<repo>-<name>` is unreachable on a headless host.

An `orca settings get/set` as proposed above would cover this; a `--nest`/`--no-nest` flag on `orca worktree create` would cover the second bullet alone.
