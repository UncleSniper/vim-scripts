#!/bin/bash

set -e

if [ $# = 0 ]; then
	dest=~
else
	dest="$1"
fi

here="$(dirname -- "$(readlink -f -- "${BASH_SOURCE-$0}")")"
mkdir -p "$dest"/.vim/{autoload,bundle,syntax}
[ -f "$dest"/.vim/autoload/pathogen.vim ] || wget https://github.com/tpope/vim-pathogen/raw/master/autoload/pathogen.vim -O "$dest"/.vim/autoload/pathogen.vim
bash -- "$here/DEPEND" "$dest"
[ -L "$dest"/.vim/UltiSnips ] || ln -s -- "$here/snippets" "$dest"/.vim/UltiSnips
[ -L "$dest"/.vim/usnippets ] || ln -s -- "$here/snippets" "$dest"/.vim/usnippets
[ -L "$dest"/.vim/genproject ] || ln -s -- "$here/genproject" "$dest"/.vim/genproject
[ -L "$dest"/.vim/scripts ] || ln -s -- "$here/scripts" "$dest"/.vim/scripts
for f in "$here/syntax"/*.vim; do
	[ -L "$dest"/.vim/syntax/"$(basename -- "$f")" ] || ln -s -- "$f" "$dest"/.vim/syntax
done
for f in "$here/nerdtree_plugin"/*.vim; do
	[ -L "$dest"/.vim/bundle/nerdtree/nerdtree_plugin/"$(basename -- "$f")" ] || ln -s -- "$f" "$dest"/.vim/bundle/nerdtree/nerdtree_plugin
done
[ -L "$dest"/.vim/sniper-vimrc.vim ] || ln -s -- "$here/vimrc" "$dest"/.vim/sniper-vimrc.vim
touch "$dest"/.vim/site-projects.vim
if [ "$(test -f "$dest"/.vimrc && head -1 "$dest"/.vimrc)" != "runtime sniper-vimrc.vim" ]; then
cat >>"$dest"/.vimrc <<EOF
runtime sniper-vimrc.vim
runtime site-projects.vim

"AddJavaPackagePrefix org.unclesniper
AddJavaProjectNameStrip j
"AddJavaProjectNameStrip jus

"ProvideJavaLibrary usson /home/$(whoami)/usson/dist
"ProvideJavaLibrary juslog /home/$(whoami)/juslog/dist
"ProvideJavaLibrary jogdl /home/$(whoami)/jogdl/dist
"ProvideJavaLibrary jprotostr /home/$(whoami)/jprotostr/dist
"ProvideJavaLibrary jusutils /home/$(whoami)/jutils/dist
"ProvideJavaLibrary jcmdwin /home/$(whoami)/jcmdwin/dist
EOF
fi
