all: sync


sync: 
	mkdir -p ~/.config/alacritty
	mkdir -p ~/.tmux

	[ -f ~/.config/alacritty/alacritty.yml ] || ln -s $(PWD)/alacritty.yml ~/.config/alacritty/alacritty.yml
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/tmux.conf ~/.tmux.conf
	[ -f ~/.tmux/tmux.remote.conf ] || ln -s $(PWD)/tmux.remote.conf ~/.tmux/tmux.remote.conf
	[ -f ~/.tmux/tmux-theme-local.conf ] || ln -s $(PWD)/tmux-theme-local.conf ~/.tmux/tmux-theme-local.conf
	[ -f ~/.tmux/yank.sh ] || ln -s $(PWD)/tmux_yank.sh ~/.tmux/yank.sh

clean:
	rm -f ~/.config/alacritty/alacritty.yml 
	rm -f ~/.tmux.conf
	rm -f ~/.tmux/tmux.remote.conf
	rm -f ~/.tmux/tmux-theme-local.conf
	rm -f ~/.tmux/yank.sh

.PHONY: all clean sync

