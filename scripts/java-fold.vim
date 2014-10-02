function! JavaFoldDoc()
	let start = 1
	while 1
		call cursor(start, 1)
		let spos = search('/\*\*', 'cW')
		if spos == 0
			break
		endif
		let epos = search('\*/', 'cW')
		if epos == 0
			let start += 1
			break
		endif
		execute spos . ',' . epos . 'fold'
		let start = epos + 1
	endwhile
endfunction

function! JavaFoldMethods()
	let regex  = '\v^\s+'             " preamble
	let regex .= '%(<\w+>\s+){0,3}'   " visibility, static, final
	let regex .= '%(\w|[<>[\]])+\s+'  " return type
	let regex .= '\w+\s*'             " method name
	let regex .= '\([^\)]*\)'         " method parameters
	let regex .= '%(\w|\s|\{)+$'      " postamble
	let start = 1
	while 1
		call cursor(start, 1)
		let spos = search(regex, 'cW')
		if spos == 0
			break
		endif
		let content = getline(spos)
		let white = match(content, '\S')
		let epos = search('^' . strpart(content, 0, white) . '}$', 'cW')
		if epos == 0
			let start += 1
			break
		endif
		execute spos . ',' . epos . 'fold'
		let start = epos + 1
	endwhile
endfunction

function! JavaFold()
	call JavaFoldDoc()
	call JavaFoldMethods()
endfunction
