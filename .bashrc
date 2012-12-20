#
# ~/.bashrc
#
export PATH=$HOME/bin:$PATH
source /usr/share/git/completion/git-completion.bash

[[ $- != *i* ]] && return

hostcolor="02;34"
usercolor="02;34" 
dircolor='02;36'
sshcolor='02;33'

if [ -n "$SSH_CLIENT" ]; then
        #PS1='\[\e[0;33m\]\u@\h:\wSSH$\[\e[m\] '
	PS1='\[\e['$sshcolor'm\]\u\[\e[00m\]@\[\e['$sshcolor'm\]\h\[\e[00m\]:\[\e['$sshcolor'm\]ssh \w\[\e[00m\]\$ '
else
	PS1='\[\e['$usercolor'm\]\u\[\e[00m\]@\[\e['$hostcolor'm\]\h\[\e[00m\]:\[\e['$dircolor'm\]\w\[\e[00m\]\$ '
       # PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\    e[m\] '
fi

if [ -f ~/.dir_colors ]; then
    eval `dircolors ~/.dir_colors`
fi

#-------------- Functions ----------------------------------

# This function sends notify to awesome wm even if you are not current user.
notify() {
    title="$1"
    shift 1
    body="$*"

    for pid in $(pgrep 'awesome'); do
        eval $(grep -z ^USER /proc/$pid/environ)
        eval export $(grep -z ^DISPLAY /proc/$pid/environ)
        eval export $(grep -z ^DBUS_SESSION_BUS_ADDRESS /proc/$pid/environ)
        su $USER -c "notify-send \"$title\" \"$body\""
    done
}

# General purpose extract function.
dext () {
  if [ -f $1 $2 ] ; then
    case $1 in
      *.tar.bz2)   tar xvjf $1 $2 ;;
      *.tar.gz)    tar xvzf $1 $2 ;;
      *.tar.xz)    tar xvJf $1 $2 ;;
      *.bz2)       bunzip2 $1 $2 ;;
      *.rar)       unrar x $1 $2 ;;
      *.gz)        gunzip $1 $2 ;;
      *.tar)       tar xvf $1 $2 ;;
      *.tbz2)      tar xvjf $1 $2 ;;
      *.tgz)       tar xvzf $1 $2 ;;
      *.zip)       unzip $1 $2 ;;
      *.Z)         uncompress $1 $2 ;;
      *.7z)        7z x $1 $2 ;;
      *.xz)        unxz $1 $2 ;;
      *.exe)       cabextract $1 $2 ;;
      *)           echo "\`$1':s sorry, i cant do this";; 
    esac
  else
    echo "\`$1' something wrong with this file."
  fi
}

# Search a package with pacman in archlinux official repo
pacsearch () {
       echo -e "$(pacman -Ss $@ | sed \
       -e 's#core/.*#\\033[1;31m&\\033[0;37m#g' \
       -e 's#extra/.*#\\033[0;32m&\\033[0;37m#g' \
       -e 's#community/.*#\\033[1;35m&\\033[0;37m#g' \
       -e 's#^.*/.* [0-9].*#\\033[0;36m&\\033[0;37m#g' )"
}

# Aliases
# Net
alias wpa='sudo wpa_supplicant -i wlan0 -c /etc/wpa_supplicant.conf -B'
alias dhw='sudo dhcpcd wlan0'
alias dhe='sudo dhcpcd eth0'

# Pacman
alias pacs='sudo pacman -S'
alias pacsy='sudo pacman -Sy'
alias pacsyu='sudo pacman -Syu'
alias pacr='sudo pacman -R'
alias pacu='sudo pacman -U'

# Profiles
alias xinit='vim /home/ahmet/.xinitrc'
alias bashrc='vim /home/ahmet/.bashrc && source /home/ahmet/.bashrc'

# Navigation
alias ..='cd ..'
alias back='cd $OLDPWD'
alias ls='ls -h -X --color=auto --group-directories-first'
alias lr='ls -R'
alias ll='ls -l'
alias la='ll -A'
alias lx='ll -BX'
alias lz='ll -rS'
alias lt='ll -rt'

# Editing
alias v='vim'
alias sv='sudo vim'
alias gv='gvim'
alias sgv='sudo gvim'

# Misc
alias arps='sudo arp-scan -l'
alias pscr='scrot /home/ahmet/Pictures/Shots/ddArch_%d-%m-%Y.jpg -cd 3'
alias wwP='cd /srv/http'
