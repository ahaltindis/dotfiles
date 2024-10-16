UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S), Linux)
	os := linux
endif
ifeq ($(UNAME_S), Darwin)
	os := macos
endif

all: sync

sync: 
	mkdir -p ~/.config/alacritty
	mkdir -p ~/.config/fish
	mkdir -p ~/.config/nvim
	mkdir -p ~/.tmux

	[ -f ~/.config/alacritty/alacritty.toml ] || ln -s $(PWD)/alacritty.toml ~/.config/alacritty/alacritty.toml
	[ -f ~/.config/alacritty/alacritty.os.toml ] || ln -s $(PWD)/alacritty.$(os).toml ~/.config/alacritty/alacritty.os.toml
	[ -f ~/.config/fish/config.fish ] || ln -s $(PWD)/config.fish ~/.config/fish/config.fish
	[ -f ~/.config/nvim/init.lua ] || ln -s $(PWD)/init.lua ~/.config/nvim/init.lua
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/tmux.conf ~/.tmux.conf
	[ -f ~/.tmux/tmux.remote.conf ] || ln -s $(PWD)/tmux.remote.conf ~/.tmux/tmux.remote.conf

clean:
	rm -f ~/.config/alacritty/alacritty.{yml,toml}
	rm -f ~/.config/alacritty/alacritty.os.toml
	rm -f ~/.config/nvim/init.lua
	rm -f ~/.tmux.conf
	rm -f ~/.tmux/tmux.remote.conf

.PHONY: all clean sync

