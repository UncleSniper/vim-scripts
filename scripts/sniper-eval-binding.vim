function! SniperEvalSelection(evalFunc)
	let result = SniperEvalString(split(getreg('"'), "\n", 1), a:evalFunc)
	call append(line('$'), result)
endfunction

function! SniperEvalFile(evalFunc)
	if exists('b:lastEvaluatedLine')
		let lastLine = b:lastEvaluatedLine
	else
		let lastLine = 0
	endif
	let lines = []
	for lnr in range(lastLine + 1, line('$'))
		call add(lines, getline(lnr))
	endfor
	let result = SniperEvalString(lines, a:evalFunc)
	call append(line('$'), result)
	let b:lastEvaluatedLine = line('$')
endfunction

function! SniperEvalString(code, evalFunc)
	if len(a:evalFunc)
		let evalFunc = a:evalFunc
	else
		if exists('b:evalFunc')
			let evalFunc = b:evalFunc
		else
			echoerr 'No evaluator selected.'
			return
		endif
	endif
	if !len(a:code) || (len(a:code) == 1 && !len(get(a:code, 0)))
		echoerr 'Nothing to evaluate.'
		return []
	endif
	let result = call(evalFunc, [a:code])
	if exists('b:evalFilter') && len(b:evalFilter)
		let filtered = []
		for line in result
			call add(filtered, call(b:evalFilter, [line]))
		endfor
		let result = filtered
	endif
	return result
endfunction

function! SniperOpenConsole(side, height, name, syntax, evaluator, filter)
	exec (a:side == 'bottom' ? 'botright ' : 'topleft ') . a:height . ' new'
	setl wfw noswf buftype=nofile bufhidden=wipe
	setl nowrap foldcolumn=0 foldmethod=manual
	setl nofoldenable nobuflisted nospell
	if len(a:syntax)
		exec 'setl ft=' . a:syntax
	endif
	iabc <buffer>
	let b:evalFunc = a:evaluator
	let b:evalFilter = a:filter
	exec 'file ' . a:name
	imap <buffer> <silent> <BSlash><CR> <Esc>:silent call SniperEvalFile('')<CR>Go
	imap <buffer> <C-Q> <Esc><C-W><C-Q>
	imap <buffer> <C-]> <Esc><C-W>oi
endfunction

function! SniperDefaultEvalFilter(line)
	return '>> ' . a:line
endfunction

vmap <silent> <Leader>X ""y:silent call SniperEvalSelection('')<CR>
nmap <silent> <Leader>X :silent call SniperEvalFile('')<CR>
