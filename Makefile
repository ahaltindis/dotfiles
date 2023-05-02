all: sync


sync: 
	mkdir -p ~/.config/alacritty

	[ -f ~/.config/alacritty/alacritty.yml ] || ln -s $(PWD)/alacritty.yml ~/.config/alacritty/alacritty.yml
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/tmux.conf ~/.tmux.conf

clean:
	rm -f ~/.config/alacritty/alacritty.yml 
	rm -f ~/.tmux.conf

.PHONY: all clean sync

