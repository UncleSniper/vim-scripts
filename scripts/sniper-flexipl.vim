function! DoFlexiPLBindings()
	let cygwinInitiator = '[1;5n'
	let xtermInitiator = ''
	for initiator in [cygwinInitiator, xtermInitiator]
		let pfx = 'imap <buffer> ' . initiator
		exec pfx . 'o •'
		exec pfx . '> →'
		exec pfx . '\ λ'
	endfor
endfunction
