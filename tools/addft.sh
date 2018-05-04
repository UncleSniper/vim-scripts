#!/bin/bash

myname="$(basename -- "${BASH_SOURCE-${0}}")"

if [ $# != 3 ]; then
	echo "Usage: $myname <script-name> <extension> <filetype>" >&2
	exit 1
fi

ftdetect=~/.vim/ftdetect
script="$ftdetect/$1.vim"

mkdir -pv -- "$ftdetect" || exit 1
if [ -e "$script" ]; then
	if [ -d "$script" ]; then
		echo "$myname: $script exists, but is a directory" >&2
		exit 1
	else
		echo "$myname: $script exists, here are the previous contents for reference:" >&2
		echo "==== snip ====" >&2
		cat -- "$script" >&2
		echo "==== snap ====" >&2
	fi
fi

echo "au BufNewFile,BufRead *.$2 setl filetype=$3" >"$script"
