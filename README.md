# dotfiles

My MacOS configuration files.


<img width="1470" alt="image" src="https://github.com/user-attachments/assets/e68d5cf0-d412-4de6-b99c-fa2cb404bab8" />
<br/><br/>
<img width="1470" alt="image" src="https://github.com/user-attachments/assets/77ff669c-8bf7-4faf-89e9-37329907903f" />
<br/><br/>
<img width="1470" alt="image" src="https://github.com/user-attachments/assets/8afa0be9-f09a-4165-80c2-bdf343eda938" />



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
