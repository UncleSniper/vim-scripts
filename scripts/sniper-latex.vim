function! SetupLatexScripts()
	setl makeprg=./build
endfunction

au BufRead,BufNewFile *.tex call SetupLatexScripts()
