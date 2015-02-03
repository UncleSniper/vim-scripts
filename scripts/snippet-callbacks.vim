let s:resPattern = '^\t*\%(public\|protected\|private\) static final String '
let s:resPattern .= 'RES_[A-Z0-9]\+_[A-Z0-9]\+ \+= "[^".]\+\.[^".]\+\.\([^".]\+\)\.[^".]\+";$'

function! JavaSnippetGetPrevResourceMethod()
	let lnr = line('.')
	if lnr > 1
		let lst = matchlist(getline(lnr - 1), s:resPattern)
		if len(lst)
			return get(lst, 1)
		endif
	endif
	return '<method>'
endfunction
