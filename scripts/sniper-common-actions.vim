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

function! NewFileInteractive()
	return ':vi ' . expand('%:h') . '/.' . expand('%:t:e') . repeat("\<Left>", len(expand('%:t:e')) + 1)
endfunction
