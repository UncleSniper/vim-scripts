function! SetupCPPScripts()
	if len(glob('project.properties'))
		setl makeprg=xake
	endif
endfunction

au BufRead,BufNewFile *.cpp call SetupCPPScripts()
au BufRead,BufNewFile *.hpp call SetupCPPScripts()
au BufRead,BufNewFile *.cxx call SetupCPPScripts()
au BufRead,BufNewFile *.hxx call SetupCPPScripts()
