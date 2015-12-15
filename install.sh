#!/bin/bash

set -e
here="$(dirname -- "$(readlink -f -- "$0")")"
mkdir -p ~/.vim/{autoload,bundle,syntax}
wget https://github.com/tpope/vim-pathogen/raw/master/autoload/pathogen.vim -O ~/.vim/autoload/pathogen.vim
bash -- "$here/DEPEND"
ln -s -- "$here/snippets" ~/.vim/UltiSnips
ln -s -- "$here/snippets" ~/.vim/usnippets
ln -s -- "$here/genproject" ~/.vim
ln -s -- "$here/scripts" ~/.vim
for f in "$here/syntax"/*.vim; do
	ln -s -- "$f" ~/.vim/syntax
done
for f in "$here/nerdtree_plugin"/*.vim; do
	ln -s -- "$f" ~/.vim/bundle/nerdtree/nerdtree_plugin
done
ln -s -- "$here/vimrc" ~/.vim/sniper-vimrc.vim
touch ~/.vim/site-projects.vim
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
