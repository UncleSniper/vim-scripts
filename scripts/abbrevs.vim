augroup sniperAbbrevs
	au!
	au BufNewFile,BufRead *.java call SniperJavaAbbrevs()
	au BufNewFile,BufRead *.hpp call SniperCPPAbbrevs()
	au BufNewFile,BufRead *.cpp call SniperCPPAbbrevs()
	au BufNewFile,BufRead *.hxx call SniperCPPAbbrevs()
	au BufNewFile,BufRead *.cxx call SniperCPPAbbrevs()
augroup END

function! SniperJavaAbbrevs()
	iab <buffer> lparam Localization localization
endfunction

function! SniperCPPAbbrevs()
	iab <buffer> cosnt const
endfunction
