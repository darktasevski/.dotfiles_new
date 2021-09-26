#! /bin/bash
# From https://www.askapache.com/linux/rxvt-xresources/

function aa_256() {
	local o= i= x=$(tput op) cols=$(tput cols) y= oo= yy=
	y=$(printf %$(($cols - 6))s)
	yy=${y// /=}
	for i in {0..256}; do
		o=00${i}
		oo=$(echo -en "setaf ${i}\nsetab ${i}\n" | tput -S)
		echo -e "${o:${#o}-3:3} ${oo}${yy}${x}"
	done
}

# Color escape codes @see http://misc.flogisoft.com/bash/tip_colors_and_formatting
# Use \033 instead of \e. Workes better across platforms
# \e works in PS1 prompts, but not other places
c_X_reset_all='\033[0m' #stop code for color escape
# c_X_bold='\033[21m'
# c_X_reset_bold='\033[21m'
c_green='\033[01;32m'
c_blue='\033[01;34m'
c_pink='\033[01;35m'
c_dark_grey='\033[90m'

c_dark_yellow='\033[38;5;178m'
c_dark_red='\033[38;5;196m'

function green() {
	echo -n -e "${c_green}$*${c_X_reset_all}"
}

function blue() {
	echo -n -e "${c_blue}$*${c_X_reset_all}"
}

function pink() {
	echo -n -e "${c_pink}$*${c_X_reset_all}"
}

function dark_grey() {
	echo -n -e "${c_dark_grey}$*${c_X_reset_all}"
}

function dark_yellow() {
	echo -n -e "${c_dark_yellow}$*${c_X_reset_all}"
}

function dark_red() {
	echo -n -e "${c_dark_red}$*${c_X_reset_all}"
}
