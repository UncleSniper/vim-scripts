function! SetupJavaScripts()
	nmap <buffer> <expr> <Leader>gg JavaGenerateAccessors('g')
	nmap <buffer> <expr> <Leader>gs JavaGenerateAccessors('s')
	nmap <buffer> <expr> <Leader>ga JavaGenerateAccessors('gs')
	nmap <buffer> <expr> <Leader>gG JavaGenerateAllAccessors('g')
	nmap <buffer> <expr> <Leader>gS JavaGenerateAllAccessors('s')
	nmap <buffer> <expr> <Leader>gA JavaGenerateAllAccessors('gs')
	nmap <buffer> <expr> <Leader>gc JavaGenerateConstructor()
	nmap <buffer> <silent> <Leader>pi :call JavaPruneImports()<CR>
	" compiler junk
	setl makeprg=vimant
	setl efm=\ \ \ \ %f:%l:%c:\ %m
	"compiler ant
	nmap <buffer> <silent> <Leader>e :cn<CR>
endfunction

au BufRead,BufNewFile *.java call SetupJavaScripts()
