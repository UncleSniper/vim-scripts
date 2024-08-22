function! SetupGoScripts()
	if len(glob('*_test.go', 1, 1))
		setl makeprg=go\ test
	else
		setl makeprg=go\ build
	endif
endfunction

au BufRead,BufNewFile *.go call SetupGoScripts()
