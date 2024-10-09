dotfiles
========

Some configuration files for my system.

## Installation

### Font
Neovim needs a nerd font to be able to look nice.

Currenty using `GeistMono Nerd Font` which can be downloaded from here:
https://www.nerdfonts.com/font-downloads

Alacritty is configured to use `GeistMono NF` version.


Download and install SF Mono for Alacritty in MacOS:
https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg

Install latest pre-built Alacritty version from Github:
https://github.com/alacritty/alacritty/releases

Install Homebrew:
https://brew.sh/

Install brew packages:
```
brew bundle
```

Run make to sync configurations to system
```
make
```

Set fish as default shell
```
echo /usr/local/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish

```

### My Daily Usage
- Open new Alacritty instance.
- Enter to tmux via `cmd+a` shortcut of Alacritty while in the shell.
- Open new Alacritty window for remote connection via `cmd+n`.
- SSH into remote server.
- Enter to tmux via `cmd+a` shortcut of Alacritty while in the shell.
- Switch between Alacritty windows using MacOS shortcut `` cmd+` ``.

### Handy stuff

Generate Brewfile:
```
brew bundle dump
```

Disable firefox exiting full screen with ESC:
```
Go to about:config

search for browser.fullscreen.exit_on_escape

set to false
```
