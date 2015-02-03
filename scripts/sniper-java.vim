function! SetupJavaScripts()
	nmap <buffer> <expr> <Leader>gg JavaGenerateAccessors('g')
	nmap <buffer> <expr> <Leader>gs JavaGenerateAccessors('s')
	nmap <buffer> <expr> <Leader>ga JavaGenerateAccessors('gs')
	nmap <buffer> <expr> <Leader>gG JavaGenerateAllAccessors('g')
	nmap <buffer> <expr> <Leader>gS JavaGenerateAllAccessors('s')
	nmap <buffer> <expr> <Leader>gA JavaGenerateAllAccessors('gs')
	nmap <buffer> <expr> <Leader>gc JavaGenerateConstructor()
	nmap <buffer> <silent> <Leader>pi :call JavaPruneImports()<CR>
	nmap <buffer> <Leader>gi :call JavaGenImports()<CR>
	nmap <buffer> <expr> <Leader>fc JavaEqualizeConstantAssignments()
	imap <buffer> <expr> <C-e> JavaEmbrace()
	imap <buffer> <expr> <C-_> JavaNewBranch(0)
	imap <buffer> <expr>  JavaNewBranch(1)
	" compiler junk
	setl makeprg=vimant
	setl efm=\ \ \ \ %f:%l:%c:\ %m
	setl efm+=\ \ \ \ %f:%c:\ %m
	"compiler ant
	call BindSemicolonLanguage()
endfunction

au BufRead,BufNewFile *.java call SetupJavaScripts()
