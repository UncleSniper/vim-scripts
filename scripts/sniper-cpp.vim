let g:xakeprg = 'xake'

function! SetupCPPScripts()
	if len(glob('project.properties'))
		exec 'setl makeprg=' . g:xakeprg
	endif
	ab <buffer> viod void
endfunction

au BufRead,BufNewFile *.cpp call SetupCPPScripts()
au BufRead,BufNewFile *.hpp call SetupCPPScripts()
au BufRead,BufNewFile *.cxx call SetupCPPScripts()
au BufRead,BufNewFile *.hxx call SetupCPPScripts()
