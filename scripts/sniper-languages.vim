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
au BufRead,BufNewFile *.lisp set nolisp
let lisp_rainbow = 1
