function! DoFlexiPLBindings()
	let cygwinInitiator = '[1;5n'
	for initiator in [cygwinInitiator]
		let pfx = 'imap <buffer> ' . initiator
		exec pfx . 'o •'
		exec pfx . '> →'
		exec pfx . '\ λ'
	endfor
endfunction
