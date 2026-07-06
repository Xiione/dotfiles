# Repository Purpose

This is a personal macOS dotfiles repository managed with GNU Stow. Preserve
interactive behavior across Neovim, Neogurt, kitty, fish, and related tools.

# Change Philosophy

- Prefer the smallest change that fully solves the problem.
- Follow existing configuration structure before introducing new modules.
- Prefer supported plugin options and highlight links over runtime patches.
- Do not choose a narrower implementation when it is materially more brittle.
- When a plugin-internal patch is unavoidable:
  - Keep it narrowly guarded and idempotent.
  - Document which missing upstream option requires it.
  - Verify it against the actual rendered plugin buffer.
- Avoid unrelated cleanup, dependency churn, and speculative abstractions.
- Preserve existing staged and unstaged changes. Never stage unrelated files.

# Neovim Conventions

- Put plugin-owned configuration and keymaps in
  `.config/nvim/lua/user/plugins/<plugin>.lua`.
- Keep only genuinely global mappings in `user/cfg/keymaps.lua`.
- Reuse shared configuration:
  - Colors and derived overlays: `user/cfg/colors.lua`
  - Colorscheme highlight definitions: `user/cfg/colorscheme.lua`
  - Semantic and UI glyphs: `user/cfg/icons.lua`
  - Sidebar behavior: `user/lib/sidebars.lua` and sidebar autocommands
- Do not duplicate color literals or semantic icons between plugin specs.
- Prefer highlight links when the complete appearance should be inherited.
  Use explicit attributes when foreground and background must come from
  different semantic groups.
- Keep plugin-specific highlight definitions in the colorscheme when the
  plugin respects existing groups. Reapply them from plugin configuration only
  when the plugin overwrites them during setup or on `ColorScheme`.
- Preserve Tree-sitter foregrounds in diff views unless overriding them is
  intentional.
- Treat Neogurt-specific rendering problems separately from terminal and
  colorscheme behavior. Avoid global highlight changes until the source has
  been isolated.

# Visual Style

- Maintain the Nord-based palette and the existing restrained presentation.
- Prefer gamma-correct color overlays from the shared palette over arbitrary
  hand-picked background colors.
- Use Nerd Fonts v3 glyphs consistently through the shared icon module.
- Use `nvim-web-devicons` as the canonical source for filetype icons.
- Avoid bold text unless it communicates a meaningful active or important
  state. Prefer color, cursorline, or underline for selection.
- Use box-drawing characters for structural separators where supported.

# Lazy Loading

- Keep nvim-tree, Telescope, ToggleTerm, and Sidekick eagerly loaded; they are
  used during virtually every session and may be invoked through Lua APIs or
  mappings rather than commands.
- Other plugins may be loaded by command, key, event, or filetype when that
  does not change behavior.
- Do not add lazy-loading triggers solely to improve startup metrics without a
  practical user-facing benefit.

# Dependencies And Installation

- Track shared machine dependencies in `Brewfile`.
- Keep work-specific or machine-specific dependencies in ignored
  `Brewfile.local`.
- Update `README.md` when a configuration gains a new hard dependency.
- Do not run `script/bootstrap` merely as validation; it installs software and
  modifies links under `$HOME`.

# Validation

- Format changed Lua files with `stylua`.
- Run `git diff --check`.
- Verify Neovim starts cleanly with `nvim --headless`.
- For plugin UI changes, inspect the actual rendered buffer and resolved
  highlight groups rather than validating configuration values alone.
- For sidebar or window-local behavior, test focus, unfocus, close, reopen,
  and relevant filetype transitions.
- For bootstrap changes, run `bash -n script/bootstrap`.
