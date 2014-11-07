function! CleanUpWhitespace()
	let keys = ''
	call cursor(1, 1)
	while 1
		let pos = search('^[ \t]\+$', 'W')
		if pos == 0
			break
		endif
		let keys .= pos . 'G0' . len(getline(pos)) . 'x'
	endwhile
	return keys
endfunction
