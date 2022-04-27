#!/bin/zsh

##########
# System #
##########

function is_mac() {
	cmd=$(command -v uname)

	if [[ -z ${cmd} ]]; then
		return 1
	else
		# dynamically redefines the function definition to avoid recomputing
		if ${cmd} | grep Darwin 1>/dev/null; then
			is_mac() { return 0; }
		else
			is_mac() { return 1; }
		fi
	fi
}

############
# Archives #
############

ex() {
	case $1 in
	*.tar.bz2) tar xjf $1 ;;
	*.tar.gz) tar xzf $1 ;;
	*.bz2) bunzip2 $1 ;;
	*.gz) gunzip $1 ;;
	*.tar) tar xf $1 ;;
	*.tbz2) tar xjf $1 ;;
	*.tgz) tar xzf $1 ;;
	*.zip) unzip $1 ;;
	*.7z) 7z x $1 ;;  # require p7zip
	*.rar) 7z x $1 ;; # require p7zip
	*.iso) 7z x $1 ;; # require p7zip
	*.Z) uncompress $1 ;;
	*) echo "'$1' cannot be extracted" ;;
	esac
}

extract() {
	for file in "$@"; do
		if [ -f $file ]; then
			ex $file
		else
			echo "'$file' is not a valid file"
		fi
	done
}

mkextract() {
	for file in "$@"; do
		if [ -f $file ]; then
			local filename=${file%\.*}
			mkdir -p $filename
			cp $file $filename
			cd $filename
			ex $file
			rm -f $file
			cd -
		else
			echo "'$1' is not a valid file"
		fi
	done
}

compress() {
	local DATE="$(date +%Y%m%d-%H%M%S)"
	tar cvzf "$DATE.tar.gz" "$@"
}

# Creates an archive from given directory
function mktar() { tar cvf "${1%%/}.tar" "${1%%/}/"; }
function mktgz() { tar cvzf "${1%%/}.tar.gz" "${1%%/}/"; }
function mktbz() { tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }

# In some cases some zip files are "corrupted"
# https://huit.re/MMnBu4uG
function recover_archive() { jar xvf "$1"; }

##########
# Images #
##########

imgsize() {
	local width=$(identify -format "%w" "$1") >/dev/null
	local height=$(identify -format "%h" "$1") >/dev/null
	echo -e "Size of $1: $width*$height"
}

imgresize() {
	local filename=${1%\.*}
	local extension="${1##*.}"
	local separator="_"
	if [ ! -z $3 ]; then
		local finalName="$filename.$extension"
	else
		local finalName="$filename$separator$2.$extension"
	fi
	convert $1 -quality 100 -resize $2 $finalName
	echo "$finalName resized to $2"
}

imgresizeall() {
	for f in *.${1}; do
		if [ ! -z $3 ]; then
			imgresize "$f" ${2} t
		else
			imgresize "$f" ${2}
		fi
	done
}

imgoptimize() {
	local filename=${1%\.*}
	local extension="${1##*.}"
	local separator="_"
	local suffix="optimized"
	local finalName="$filename$separator$suffix.$extension"
	convert $1 -strip -interlace Plane -quality 85% $finalName
	echo "$finalName created"
}

Imgoptimize() {
	local filename=${1%\.*}
	local extension="${1##*.}"
	local separator="_"
	local suffix="optimized"
	local convert $1 -strip -interlace Plane -quality 85% $1
	echo "$1 created"
}

imgoptimizeall() {
	for f in *.${1}; do
		imgoptimize "$f"
	done
}

Imgoptimizeall() {
	for f in *.${1}; do
		Imgoptimize "$f"
	done
}

imgtojpg() {
	for file in "$@"; do
		local filename=${file%\.*}
		convert -quality 100 $file "${filename}.jpg"
	done
}

imgtowebp() {
	for file in "$@"; do
		local filename=${file%\.*}
		cwebp -q 100 $file -o $(basename ${filename}).webp
	done
}

imgdirtowebp() {
	input_dir="$1"
	quality="$2"

	if [[ -z "$input_dir" ]]; then
		input_dir=$(pwd)
	fi

	if [[ -z "$quality" ]]; then
		quality=70
	fi

	for FILE in $input_dir/*(jpg|jpeg|tif|tiff|png); do
		cwebp $FILE -q $quality -progress -o ${FILE%.*}.webp
		rm -f $FILE
	done
}

#######
# Git #
#######

gtrm() {
	git tag -d $1

	if [ ! -z "$2" ]; then
		git push $2 :refs/tags/$1
	else
		git push origin :refs/tags/$1
	fi
}

githeat() {
	$DOTFILES/bash/scripts/heatmap.sh
}

function bye-bye-branches() {
	git fetch -p && for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do git branch -D "${branch}"; done
}

#######
# SSH #
#######

ssh-create() {
	if [ ! -z "$1" ]; then
		ssh-keygen -f $HOME/.ssh/$1 -t rsa -N '' -C "$1"
		chmod 700 $HOME/.ssh/$1*
	fi
}

########
# Misc #
########

matrix() {
	local lines=$(tput lines)
	cols=$(tput cols)

	awkscript='
    {
        letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"
        lines=$1
        random_col=$3
        c=$4
        letter=substr(letters,c,1)
        cols[random_col]=0;
        for (col in cols) {
            line=cols[col];
            cols[col]=cols[col]+1;
            printf "\033[%s;%sH\033[2;32m%s", line, col, letter;
            printf "\033[%s;%sH\033[1;37m%s\033[0;0H", cols[col], col, letter;
            if (cols[col] >= lines) {
                cols[col]=0;
            }
		}
	}
	'

	echo -e "\e[1;40m"
	clear

	while :; do
		echo $lines $cols $(($RANDOM % $cols)) $(($RANDOM % 72))
		sleep 0.05
	done | awk "$awkscript"
}

pipes() {
	$DOTFILES/bash/scripts/pipes.sh
}

smedia() {
	$DOTFILES/bash/scripts/smedia.sh $@
}

# Useful when there are two computers connected to the same monitor
# Changes the input source for LG display to HDMI 2
# For some reason, HDMI 2 is detected as DVI 2 input ¯\_(ツ)_/¯
# @see https://github.com/kfix/ddcctl
switch_display_input() {
	local DISPLAY_NUM=1
	local DVI2_INPUT_NUM=4
	$DOTFILES/bash/scripts/ddcctl -d $DISPLAY_NUM -i $DVI2_INPUT_NUM
}

switch_display_input_linux() {
	local DISPLAY_NUM=1
	local DVI2_INPUT_NUM=4
	local input_source_address=0x60
	local HDMI_2_value=18
	local monitor_id=dev:/dev/i2c-3
	sudo ddccontrol -r $input_source_address -w $HDMI_2_value $monitor_id
}

promptspeed() {
	for i in $(seq 1 10); do /usr/bin/time zsh -i -c exit; done
}

historystat() {
	history 0 | awk '{print $2}' | sort | uniq -c | sort -n -r | head
}

pom() {
	local -r HOURS=${1:?}
	local -r MINUTES=${2:-0}
	local -r POMODORO_DURATION=${3:-25}

	echo "(($HOURS * 60) + $MINUTES) / $POMODORO_DURATION" | bc
}

jrnl() {
	cd "$JRNL" && vim +Jrnl
}

back() {
	for file in "$@"; do
		cp "$file" "$file".bak
	done
}

calcul() {
	bc -l <<<"$@"
}

########
# Find #
########

# Finding files and directories
function ff() { find . -type f -name "*$1*"; }
function fd() { find . -type d -name "*$1*"; }

########
# Tmux #
########

function tmux-restore() {
	if [[ -n $1 ]]; then
		local setup_file="$HOME/.tmux/$1.proj"

		if [[ -e ${setup_file} ]]; then
			$(command -v tmux) new-session "tmux $2 source-file $setup_file"
		else
			printf "\nNo such file \"$setup_file\".\nListing existing files:\n\n"
			ls -1 ~/.tmux/*.proj
			return 1
		fi
	else
		echo "Usage: tmux-restore my-js-setup <optional command>"
		return 1
	fi
}

#########
# Files #
#########

mkcd() {
	local dir="$*"
	local mkdir -p "$dir" && cd "$dir"
}

mkcp() {
	local dir="$2"
	local tmp="$2"
	tmp="${tmp: -1}"
	[ "$tmp" != "/" ] && dir="$(dirname "$2")"
	[ -d "$dir" ] ||
		mkdir -p "$dir" &&
		cp -r "$@"
}

mkmv() {
	local dir="$2"
	local tmp="$2"
	tmp="${tmp: -1}"
	[ "$tmp" != "/" ] && dir="$(dirname "$2")"
	[ -d "$dir" ] ||
		mkdir -p "$dir" &&
		mv "$@"
}

#make a directory and go on it
function mkcd() { mkdir -p "$@" && eval cd "\"\$$#\""; }

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() { tree -aC -I '.git' --dirsfirst "$@" | less -FRNX; }

# Trims whitespace
# Source: https://unix.stackexchange.com/questions/102008/how-do-i-trim-leading-and-trailing-whitespace-from-each-line-of-some-output
function trimWS() { awk '{$1=$1};1'; }

# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null >/dev/null 2>&1; then
		local arg=-sbh
	else
		local arg=-sh
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@"
	else
		du $arg .[^.]* *
	fi
}

# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o() {
	if [ $# -eq 0 ]; then
		open .
	else
		open "$@"
	fi
}

######################
# Network & Internet #
######################

ports() {
	sudo netstat -tulpn | grep LISTEN | fzf
}

# --restrict-filenames replace special characters like spaces in filenames.
ydlp() {
	if; then
		youtube-dl --restrict-filenames -f 22 -o "%(autonumber)s-%(title)s.%(ext)s" "$1"
	else
		echo "You need to specify a playlist url as argument"
	fi
}

ydl() {
	if [ ! -z $1 ]; then
		youtube-dl --restrict-filenames -f 22 -o "%(title)s.%(ext)s" "$1"
	else
		echo "You need to specify a video url as argument"
	fi
}

tiny() {
	local URL=${1:?}
	curl -s "http://tinyurl.com/api-create.php?url=$1"
}

py_serve() {
	local -r PORT=${1:-8888}
	python2 -m SimpleHTTPServer "$PORT"
}

duckduckgo() {
	lynx -vikeys -accept_all_cookies "https://lite.duckduckgo.com/lite/?q=$@"
}

wikipedia() {
	lynx -vikeys -accept_all_cookies "https://en.wikipedia.org/wiki?search=$@"
}

cheat() {
	curl cheat.sh/$1
}

# Find which program is using a port, works in reverse as well
# Eg. `snitch 8080` or `snitch node`
function snitch() {
	if is_mac; then
		lsof -nPi | grep "$1" | tail -n 2
	else
		netstat -tulpn | grep "$1" | tail -n 2
	fi
}
# Kill the program using a specified port
# Eg. `snatch 8080`
function snatch() { kill -9 "$(netstat -tulpn 2>/dev/null | grep "$1" | awk '{print $7}' | cut -d / -f 1)"; }

function look_for_process() {
	local ps_name=$1
	ps aux | ack "${ps_name}"
}

alias lfp='look_for_process'

function wgett() { wget -r -nH --no-parent --reject='index.html*' "$@"; }

#######
# VIM #
#######

# open man page in vim
vman() {
	if [ $# -eq 0 ]; then
		echo "What manual page do you want?"
	elif man -w "$@" >/dev/null; then
		nvim -c "SuperMan $*"
	fi
}

vinfo() {
	vim -c "Vinfo $1" -c 'silent only'
}

vimgolf() {
	local ID=$1
	local key=$2
	if [ -z $2 ]; then
		key=$VIM_GOLF_KEY
	fi
	docker run --rm --net=host -it -e "key=[$VIM_GOLF_KEY]" kramos/vimgolf "$ID"
}

# Heh.
function _lolvim() {
	_msg="THIS AIN'T VIM, BUDDY"
	cowsay $_msg 2>/dev/null || echo $_msg
}
function :wq() {
	_lolvim
}
function :qa() {
	_lolvim
}

#########
# Audio #
#########

wav2flac() {
	for file in "$@"; do
		local filename=${file%\.*}
		local extension="${file##*.}"
		ffmpeg -i "$filename.wav" -af aformat=s32:176000 "$filename.flac"
	done
}

rmwav2flac() {
	for file in "$@"; do
		local filename=${file%\.*}
		local extension="${file##*.}"
		ffmpeg -i "$filename.wav" -af aformat=s32:176000 "$filename.flac"
		rm -f $file
	done
}

################
# Lazy Loading #
################

# Lazy load env variables, as those were adding 2 seconds to the shell startup time...
# @see https://frederic-hemberger.de/articles/speed-up-initial-zsh-startup-with-lazy-loading/
function tizen() {
	# Execute only once
	unfunction "$0"
	if ! command -v tizen >/dev/null; then
		export PATH=$PATH:${TIZEN_STUFF_PATH}
	fi

	# Else execute command with provided args
	$0 "$@"

	echo "tizen fn called"

	return 0
}

function sdb() {
	unfunction "$0"
	if ! command -v sdb >/dev/null; then
		export PATH=$PATH:${TIZEN_STUFF_PATH}
	fi

	$0 "$@"

	return 0
}

# check if I need to lazy load ruby also
function rbenv() {
	unfunction "$0"
	if ! command -v rbenv >/dev/null; then
		export PATH=$PATH:${RBENV_PATH}
	fi

	$0 "$@"

	return 0
}

function jenv() {
	unfunction "$0"
	if ! command -v jenv > /dev/null; then
		export PATH=$PATH:${JENV_PATH}
	fi

	$0 "$@"

	return 0
}

# function go() {
# 	unfunction "$0"
# 	if [[ -x "$(command -v go)" ]]; then
# 		GO_WHICH=$(brew --prefix golang)

# 		export GOPATH="${HOME}/.go"
# 		export GOROOT="${GO_WHICH}/libexec"
# 		export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
# 	fi

# 	$0 "$@"

# 	return 0
# }
