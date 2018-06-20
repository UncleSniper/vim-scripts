#!/bin/bash

set -e
here="$(dirname -- "$(readlink -f -- "$0")")"
mkdir -p ~/.vim/{autoload,bundle,syntax}
[ -f ~/.vim/autoload/pathogen.vim ] || wget https://github.com/tpope/vim-pathogen/raw/master/autoload/pathogen.vim -O ~/.vim/autoload/pathogen.vim
bash -- "$here/DEPEND"
[ -l ~/.vim/UltiSnips ] || ln -s -- "$here/snippets" ~/.vim/UltiSnips
[ -l ~/.vim/usnippets ] || ln -s -- "$here/snippets" ~/.vim/usnippets
[ -l ~/.vim/genproject ] || ln -s -- "$here/genproject" ~/.vim/genproject
[ -l ~/.vim/scripts ] || ln -s -- "$here/scripts" ~/.vim/scripts
for f in "$here/syntax"/*.vim; do
	[ -l ~/.vim/syntax/"$(basename -- "$f")" ] || ln -s -- "$f" ~/.vim/syntax
done
for f in "$here/nerdtree_plugin"/*.vim; do
	[ -l ~/.vim/bundle/nerdtree/nerdtree_plugin/"$(basename -- "$f")" ] || ln -s -- "$f" ~/.vim/bundle/nerdtree/nerdtree_plugin
done
[ -l ~/.vim/sniper-vimrc.vim ] || ln -s -- "$here/vimrc" ~/.vim/sniper-vimrc.vim
touch ~/.vim/site-projects.vim
if [ "$(test -f ~/.vimrc && head -1 ~/.vimrc)" != "runtime sniper-vimrc.vim" ]; then
cat >>~/.vimrc <<EOF
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
