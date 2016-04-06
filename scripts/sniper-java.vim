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
	imap <buffer> <expr> <C-f> JavaNewBranch(1)
	nmap <buffer> K :call JavaLookupAPIDoc()<CR>
	" compiler junk
	setl makeprg=vimant
	setl efm=\ \ \ \ %f:%l:%c:\ %m
	setl efm+=\ \ \ \ %f:%c:\ %m
	"compiler ant
	call BindSemicolonLanguage()
endfunction

function! JavaLookupAPIDoc()
	let wrd = expand('<cword>')
	if !len(wrd)
		echo 'No name under cursor.'
		return
	endif
	let lstf = expand('~/.vim/javatypes.lst')
	if !len(glob(lstf))
		let candidates = []
	else
		let candidates = GetOutputOf(['grep', '-E', '\.' . wrd . '$', lstf], 1)
	endif
	if !len(candidates)
		echo "No match for '" . wrd . "'."
		return
	endif
	if len(candidates) == 1
		let cls = get(candidates, 0)
	else
		let idx = 1
		let choices = '&0 <none>'
		for cnd in candidates
			let choices .= "\n&" . idx . ' ' . cnd
			let idx += 1
		endfor
		let chosen = confirm('', choices, 1) - 1
		if !chosen
			echo 'Nevermind, then.'
			return
		endif
		let cls = get(candidates, chosen - 1)
	endif
	let tail = substitute(cls, '\.', '/', 'g')
	call ShowURLInBrowser('http://docs.oracle.com/javase/6/docs/api/' . tail . '.html')
endfunction

au BufRead,BufNewFile *.java call SetupJavaScripts()
