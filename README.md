# dotfiles

My MacOS configuration files.


<img width="1728" alt="Screenshot of desktop, vertical window split with Neogurt on left, Arc Browser open to dotfiles Github repo on right" src="https://github.com/user-attachments/assets/e501a4c7-023e-48f6-9f87-d2ceeb40bbde" />



- [Neogurt](https://github.com/williamhCode/neogurt) (native Neovim frontend)
- [Neovim](https://neovim.io/) (editor)
- [kitty](https://sw.kovidgoyal.net/kitty/) (terminal emulator)
- [fish](https://fishshell.com/) (shell)
- [Sioyek](https://sioyek.info/) (pdf viewer with vimtex sync)
- [yabai](https://github.com/koekeishiya/yabai) (window manager)
  - Pasted from [FelixKratz/dotfiles](https://github.com/FelixKratz/dotfiles)
- [skhd.zig](https://github.com/jackielii/skhd.zig) (hotkey daemon)
  - Pasted from [FelixKratz/dotfiles](https://github.com/FelixKratz/dotfiles)
- [sketchybar](https://felixkratz.github.io/SketchyBar/) (status bar replacement)
  - Modified from [FelixKratz/dotfiles](https://github.com/FelixKratz/dotfiles)
<br/><br/>

Best effort to use [Nord](https://www.nordtheme.com/) wherever possible

### Installation

1. Install [Homebrew](https://brew.sh/).
2. Clone this repository and run the bootstrap script:

   ```bash
   git clone https://github.com/Xiione/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ./script/bootstrap
   ```

3. Install [Oh My Fish](https://github.com/oh-my-fish/oh-my-fish),
   `bobthefish`, and the Nord theme.

The bootstrap installs missing dependencies from `Brewfile` with
`--no-upgrade`, never removes unlisted Homebrew software, and then links the
configuration with GNU Stow. It also installs `Brewfile.local` when that
ignored file exists.

Sioyek remains the preferred VimTeX viewer when installed, but its Homebrew
cask is deprecated and scheduled to be disabled on September 1, 2026. Install
it manually from [upstream](https://sioyek.info/) if desired. Without Sioyek,
VimTeX falls back to Zathura when available and otherwise disables external
PDF viewing.

### Homebrew maintenance

Check or explicitly upgrade the tracked dependencies with:

```bash
HOMEBREW_BUNDLE_NO_UPGRADE=1 brew bundle check --file Brewfile
brew bundle upgrade --file Brewfile
```

Put work-specific or machine-specific `brew`, `cask`, and `tap` entries in the
ignored `Brewfile.local`; the bootstrap discovers it automatically. Upgrade it
separately when desired:

```bash
brew bundle upgrade --file Brewfile.local
```

The `skhd-zig` tap recently migrated from a formula to a cask. If bootstrap
detects the legacy formula, perform the tap's documented one-time migration and
rerun it:

```bash
brew uninstall --formula jackielii/tap/skhd-zig
./script/bootstrap
```

The tracked Brewfile is intentionally curated rather than a full machine dump.
Do not use `brew bundle cleanup --force` unless removing every unlisted package
is intentional.
