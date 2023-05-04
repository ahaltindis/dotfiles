all: sync


sync: 
	mkdir -p ~/.config/alacritty
	mkdir -p ~/.tmux

	[ -f ~/.config/alacritty/alacritty.yml ] || ln -s $(PWD)/alacritty.yml ~/.config/alacritty/alacritty.yml
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/tmux.conf ~/.tmux.conf
	[ -f ~/.tmux/tmux.remote.conf ] || ln -s $(PWD)/tmux.remote.conf ~/.tmux/tmux.remote.conf

clean:
	rm -f ~/.config/alacritty/alacritty.yml 
	rm -f ~/.tmux.conf
	rm -f ~/.tmux/tmux.remote.conf

.PHONY: all clean sync

