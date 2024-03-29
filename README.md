# dotfiles

My MacOS configuration files.


<img width="1470" alt="Screenshot 2023-11-13 at 2 04 49 PM" src="https://github.com/Xiione/dotfiles/assets/25933822/49c8574f-2fc4-4e99-a818-d48e1796732d">
<br/><br/>
<img width="1470" alt="Screenshot 2023-11-13 at 2 11 51 PM" src="https://github.com/Xiione/dotfiles/assets/25933822/aee1b4bb-c3db-4f61-9418-1845a24b13d2">
<br/><br/>
<img width="1470" alt="Screenshot 2023-11-13 at 2 19 10 PM" src="https://github.com/Xiione/dotfiles/assets/25933822/40a47364-1577-4331-ae7a-94b1ae5ca5b7">


- [kitty](https://sw.kovidgoyal.net/kitty/) (terminal emulator)
- [fish](https://fishshell.com/) (shell)
- [Neovim](https://neovim.io/) (editor)
- [Sioyek](https://sioyek.info/) (pdf viewer)
- [yabai](https://github.com/koekeishiya/yabai) (window manager)
  - Pasted from [FelixKratz/dotfiles](https://github.com/FelixKratz/dotfiles)
- [skhd](https://github.com/koekeishiya/skhd) (hotkey daemon)
  - Pasted from [SxC97/dotfiles](https://github.com/SxC97/dotfiles)
- [sketchybar](https://felixkratz.github.io/SketchyBar/) (status bar replacement)
  - Configuration installed from a separate repository ([here](https://github.com/Xiione/felixkratz-dotfiles))
<br/><br/>

Best effort to use [Nord](https://www.nordtheme.com/) wherever possible

### Installation
1. `brew install stow`
2. Clone this repository to your home directory
3. `cd dotfiles` (this repository)
4. `stow .`
6. Clone [felixkratz-dotfiles](https://github.com/Xiione/felixkratz-dotfiles)
7. `cd felixkratz-dotfiles/.config/sketchybar`
8. `stow -d . -t ~/dotfiles/.config/sketchybar .`
    - You may need to manually create the target directory as empty directories are not tracked
