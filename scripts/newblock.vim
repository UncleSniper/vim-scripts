function! IsLineEmpty(index)
	return getline(a:index) == ''
endfunction

function! GetIndentOf(lineData)
	let pos = match(a:lineData, '\S')
	if pos < 0
		return a:lineData
	else
		return strpart(a:lineData, 0, pos)
	endif
endfunction

function! GetIndentLevelOf(lineData)
	let pos = match(a:lineData, '\S')
	if pos < 0
		return len(a:lineData)
	else
		return pos
	endif
endfunction

function! InsertNewBlock()
	let here = line('.')
	if here == 1
		return "\<C-o>O\<C-o>O"
	elseif here == line('$')
		return "\<C-o>o\<C-o>o"
	elseif IsLineEmpty(here)
		if IsLineEmpty(here - 1)
			return "\<C-o>O"
		else
			return "\<C-o>O\<C-o>o" . GetIndentOf(getline(here - 1))
		endif
	else
		let lastln = line('$')
		let cur = here + 1
		while cur < lastln
			if IsLineEmpty(cur)
				return "\<C-o>}\<C-o>O\<C-o>o" . GetIndentOf(getline(cur - 1))
			endif
			let cur += 1
		endwhile
		return "\<C-o>G\<C-o>o\<C-o>o"
	endif
endfunction
