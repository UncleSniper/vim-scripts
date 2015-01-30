augroup sniperAbbrevs
	au!
	au BufNewFile,BufRead *.java call SniperJavaAbbrevs()
augroup END

function! SniperJavaAbbrevs()
	ab <buffer> lparam Localization localization
endfunction
