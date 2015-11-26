function! GetOutputOf(argv, ignoreStatus)
	return GetOutputOfWithInput(a:argv, a:ignoreStatus, '')
endfunction

function! GetOutputOfWithInput(argv, ignoreStatus, stdinFile)
	let cmd = ''
	for word in a:argv
		if len(cmd)
			let cmd .= ' '
		endif
		let cmd .= shellescape(word)
	endfor
	new
	setl buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap shellredir=>&
	let cmd = 'read !' . cmd
	if len(a:stdinFile)
		let cmd .= ' <' . shellescape(a:stdinFile)
	endif
	if a:ignoreStatus
		let cmd = 'silent ' . cmd
	endif
	exec cmd
	let output = []
	for lnr in range(2, line('$'))
		call add(output, getline(lnr))
	endfor
	bwipeout
	return output
endfunction

function! GetGitTag()
	if len(GetOutputOf(['git', 'tag'], 0))
		return get(GetOutputOf(['git', 'describe', '--tags'], 0), 0)
	else
		return 'v0.1'
	endif
endfunction

function! OpenInfoWindowVertical(side, width, type)
	exec (a:side == 'right' ? 'botright' : 'topleft') . ' vertical ' . a:width . ' new'
	setl wfw noswf buftype=nofile bufhidden=wipe
	setl nowrap foldcolumn=0 foldmethod=manual
	setl nofoldenable nobuflisted nospell
	exec 'setl ft=' . a:type
	iabc <buffer>
endfunction

function! OpenInfoWindowHorizontal(side, height, type)
	exec (a:side == 'bottom' ? 'botright ' : 'topleft ') . a:height . ' new'
	setl wfw noswf buftype=nofile bufhidden=wipe
	setl nowrap foldcolumn=0 foldmethod=manual
	setl nofoldenable nobuflisted nospell
	exec 'setl ft=' . a:type
	iabc <buffer>
endfunction

function! EscapeFromSubstPattern(str)
	return escape(a:str, '$^*[]/\')
endfunction

function! EscapeFromSubstReplacement(str)
	return escape(a:str, '&/\')
endfunction

function! IsFuncref(object)
	return string(a:object) =~ "function('.*')"
endfunction
