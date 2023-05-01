all: sync


sync: 
	mkdir -p ~/.config/alacritty

	[ -f ~/.config/alacritty/alacritty.yml ] || ln -s $(PWD)/alacritty.yml ~/.config/alacritty/alacritty.yml

clean:
	rm -f ~/.config/alacritty/alacritty.yml 

.PHONY: all clean sync

