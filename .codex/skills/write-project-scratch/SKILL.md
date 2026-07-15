---
name: write-project-scratch
description: Create, inspect, and update project- and branch-scoped Neovim Snacks scratch buffers. Use when the user explicitly asks Codex to save content to a scratch buffer, create a project scratch, update a named scratch, or resolve a scratch write conflict.
---

# Write Project Scratch

Use the bundled client through the Neovim instance hosting the Sidekick session:

```sh
python3 "${CODEX_HOME:-$HOME/.codex}/skills/write-project-scratch/scripts/scratch.py" COMMAND
```

The client interface is:

```text
scratch.py list [--cwd PATH]
scratch.py read --name NAME [--ft markdown] [--count 1] [--cwd PATH]
scratch.py write --name NAME [--ft markdown] [--count 1] [--cwd PATH] [--file PATH] [--force]
```

## Workflow

1. Use `list --cwd WORKSPACE` before updating an existing scratch to recover its exact name, filetype, and count.
2. When creating a scratch without a user-supplied name, choose a concise human-readable title from the content.
3. Use `write --name NAME --cwd WORKSPACE --file INPUT`. Omit `--file` only when stdin can carry the content byte-for-byte without shell interpolation.
4. Preserve the requested content exactly. Do not add timestamps, attribution, headings, or commentary unless requested.
5. Report the resulting scratch name and whether it was created or updated.

Markdown and count `1` are the defaults. Pass `--ft` or `--count` when creating another filetype or targeting a numbered scratch.

## Conflicts

A write exits with status `4` when the matching scratch has unsaved edits. Report the conflict, then:

1. Run `read` with the same identity to retrieve the live buffer content.
2. Merge the live and proposed content without dropping either set of edits.
3. Retry the merged content with `write --force`.

Use `--force` only after reading and preserving the live edits. Ask the user when a safe semantic merge is unclear.

## Failures

Do not bypass the client or write directly to Snacks' data directory. The client first tries `$NVIM`, then the session-scoped Sidekick rendezvous so persistent Codex sessions survive a Neovim restart. If both are unavailable, report that the hosting Neovim instance is unavailable.
