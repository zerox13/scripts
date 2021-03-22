#!/bin/bash

#Auther: Abdulsalam Aldahir

BOLD="$(tput bold 2>/dev/null || echo '')"
GREY="$(tput setaf 0 2>/dev/null || echo '')"
UNDERLINE="$(tput smul 2>/dev/null || echo '')"
RED="$(tput setaf 1 2>/dev/null || echo '')"
GREEN="$(tput setaf 2 2>/dev/null || echo '')"
YELLOW="$(tput setaf 3 2>/dev/null || echo '')"
BLUE="$(tput setaf 4 2>/dev/null || echo '')"
MAGENTA="$(tput setaf 5 2>/dev/null || echo '')"
NO_COLOR="$(tput sgr0 2>/dev/null || echo '')"



printHelp(){
	echo "Usage:"
	echo -e "\t./setup <option>"
	echo "OPTIONS:"
	echo -e "\tall\t Setup everything"
	echo -e "\tgeneral\t Setup the common dotfiles (tmux, bashrc, zsh, aliases, functions)"
	echo -e "\tvim\t Setup only vim"
	echo -e "\ti3\t Setup only i3"
	echo -e "\tvscode\t Setup only vscode"
	echo -e "\thelp\t Prints this menu"
}

# === Some help functions for error handling ==== 
info() {
  printf "%s\n" "${BOLD}${GREY}>${NO_COLOR} $*"
}

warn() {
  printf "%s\n" "${YELLOW}! $*${NO_COLOR}"
}

error() {
  printf "%s\n" "${RED}x $*${NO_COLOR}" >&2
}

completed() {
  printf "%s\n" "${GREEN}✓${NO_COLOR} $*"
}


# ------------------------------------------------

setupVim () {
	info "Setting vim up ..."
	[[ ! -d "../.vim/bundle/Vundle.vim/" ]] &&
		git clone https://github.com/VundleVim/Vundle.vim.git ../.vim/bundle/Vundle.vim &&
		vim +PluginInstall +qall && 
		completed "cloned Vundle, and plugins should be installed!" &&
		info " You might need to run PluginInstall in Vim"
	
	# Linking the vimrc file
	ln -f ~/dotfiles/.vimrc ~/.vimrc &&
		completed "Vim is set up"
}

setupI3(){
	info "Setting i3 up ..."
	[[ `which i3` == *i3 ]] &&
		ln -f ~/dotfiles/i3/config ~/.config/i3 &&
		ln -f ~/dotfiles/i3/i3blocks ~/.config/i3 &&
		completed "i3 is set up"

	which i3 1> /dev/null && 
	ln -f ~/dotfiles/i3/config ~/.config/i3 &&
	ln -f ~/dotfiles/i3/i3blocks ~/.config/i3 &&
	completed "i3 is set up"
}

setupVscode(){
	info "Setting vscode up ..."
	vscodePath=""
	#TODO: Set the path of vscode setting on linux
	[ "$OSTYPE" == "linux-gnu"* ] && vscodePath="/home/dv18/dv18aar/.config/Code/User"
	# Mac OSX
	[ "$OSTYPE" == "darwin"* ] && vscodePath="/Users/abdulsalamaldahir/Library/Application\ Support/Code/User"

	ln -f ~/dotfiles/vscode/settings.json $vscodePath
}

generalSetup(){
	info "General Setup is going on ..."
	#Handle general settings
	ln -f ~/dotfiles/.tmux.conf ~/.tmux.conf
	ln -f ~/dotfiles/.bashrc ~/.bashrc
	ln -f ~/dotfiles/.functions ~/.functions
	ln -f ~/dotfiles/.aliases ~/.aliases
	ln -f ~/dotfiles/.ghci ~/.ghci
	ln -f ~/dotfiles/starship.toml ~/.config/starship.toml


	which zsh 1> /dev/null && ln -f ~/dotfiles/.zshrc ~/.zshrc &&
	completed "zsh is set up"

	! which starship 1> /dev/null &&
	warn "Install starshell?"
}

 #setupVim
 #printHelp


 [ $# != 1 ] && printHelp && exit 0 

 case $1 in 
	 all) generalSetup && setupVim;;
	 general) generalSetup;;
	 vim) setupVim;;
	 i3) setupI3;;
	 vscode) setupVscode;;
	 help) printHelp;;
 esac

