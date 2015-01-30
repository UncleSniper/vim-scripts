let s:constPattern = '^\t*\%(public\|protected\|private\) static final \w\+ \w\+ \+= \S.*;$'

function! JavaIsClassConstant(data)
	return match(a:data, s:constPattern) >= 0
endfunction

function! JavaEqualizeConstantAssignments()
	let orilnr = line('.')
	if !JavaIsClassConstant(getline(orilnr))
		return ''
	endif
	let topln = orilnr - 1
	while topln > 0
		if !JavaIsClassConstant(getline(topln))
			break
		endif
		let topln -= 1
	endwhile
	let bottomln = orilnr + 1
	let lastln = line('$')
	while bottomln <= lastln
		if !JavaIsClassConstant(getline(bottomln))
			break
		endif
		let bottomln += 1
	endwhile
	let topln += 1
	let bottomln -= 1
	let maxpos = 0
	for lnr in range(topln, bottomln)
		let pos = match(getline(lnr), '=')
		if pos > maxpos
			let maxpos = pos
		endif
	endfor
	let column = get(getpos('.'), 2)
	let keys = ''
	for lnr in range(topln, bottomln)
		let pos = match(getline(lnr), '=')
		if pos < maxpos
			let keys .= lnr . 'G0f=i' . repeat(' ', maxpos - pos) . "\<Esc>"
		endif
	endfor
	let keys .= orilnr . 'G0'
	if column > 1
		let keys .= (column - 1) . 'l'
	endif
	return keys
endfunction
