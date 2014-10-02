set bg=dark

runtime scripts/java-pruneimports.vim
runtime scripts/java-gencode.vim
runtime scripts/newblock.vim

imap <C-\> <Esc>
imap <C-@> <C-p>
au BufRead,BufNewFile *.tex nmap <C-]> :w<CR>:!./build<CR>
au BufRead,BufNewFile *.tex imap <C-f> <End>
au BufRead,BufNewFile *.grm setf aeon-grammar
au BufRead,BufNewFile *.mnl setf minal
au BufRead,BufNewFile *.json setf javascript
au BufRead,BufNewFile *.smot setf smoothtalk
au BufRead,BufNewFile *.fluid setf fluidity
au BufRead,BufNewFile *.dox setf doxygen
au BufRead,BufNewFile *.yamdl setf yamdl
au BufRead,BufNewFile *.ogdl setf ogdl
au BufRead,BufNewFile *.mogdl setf ogdl
au BufRead,BufNewFile *.ogdl-shipped setf ogdl
au BufRead,BufNewFile snakefile setf snake
au BufRead,BufNewFile *.snakefile setf snake

for tmp in range(1, 12)
	exec "nmap <F" . tmp . "> " . tmp . "gt"
	exec "imap <F" . tmp . "> <Esc>" . tmp . "gta"
endfor

nmap <C-s> :w<CR>
nmap <Leader>ns /\<TODO\><CR>
"nmap <Leader>sv :120vsp<CR><C-w>w:120vsp<CR><C-w>W
noremap <silent> <Leader><Leader> :BufExplorer<CR>
noremap <silent> <C-n> :bn<CR>
noremap <silent> <C-p> :bp<CR>
nmap <Leader>m :make<CR>

" gah
imap <C-l> l

imap <C-b> {<CR>}<C-o>O<Tab>
"imap <C-]> <C-o>}<C-o>O<CR><Tab>
imap <expr> <C-]> InsertNewBlock()
nmap <C-p> }<CR>
nmap <expr> <Leader>jg JavaGenerateAccessors('g')
nmap <expr> <Leader>js JavaGenerateAccessors('s')
nmap <expr> <Leader>ja JavaGenerateAccessors('gs')

set noea

au BufRead,BufNewFile *.lisp set nolisp
let lisp_rainbow = 1

au BufRead,BufNewFile /home/cloud/cshift/compcore/src/*.h imap <buffer> \p cshift_compcore_
au BufRead,BufNewFile /home/cloud/cshift/compcore/src/*.c imap <buffer> \p cshift_compcore_
au BufRead,BufNewFile /home/cloud/cshift/compcore/src/*.h imap <buffer> \c CSHIFT_COMPCORE_CONST
au BufRead,BufNewFile /home/cloud/cshift/compcore/src/*.c imap <buffer> \c CSHIFT_COMPCORE_CONST

au BufRead,BufNewFile *.java nmap <silent> <Leader>ji :call JavaPruneImports()<CR>

runtime! scripts/java-fold.vim
