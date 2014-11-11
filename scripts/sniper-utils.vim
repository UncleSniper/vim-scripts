function! GetOutputOf(argv)
	let cmd = ''
	for word in a:argv
		if len(cmd)
			let cmd .= ' '
		endif
		let cmd .= shellescape(word)
	endfor
	new
	setl buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
	exec 'read !' . cmd
	let output = []
	for lnr in range(2, line('$'))
		call add(output, getline(lnr))
	endfor
	bwipeout
	return output
endfunction

function GetGitTag()
	if len(GetOutputOf(['git', 'tag']))
		return get(GetOutputOf(['git', 'describe', '--tags']), 0)
	else
		return 'v0.1'
	endif
endfunction

function! OpenInfoWindowVertical(width, type)
	exec 'topleft vertical ' . a:width . ' new'
	setl wfw noswf buftype=nofile bufhidden=wipe
	setl nowrap foldcolumn=0 foldmethod=manual
	setl nofoldenable nobuflisted nospell
	exec 'setl ft=' . a:type
	iabc <buffer>
endfunction

function! OpenInfoWindowHorizontal(height, type)
	exec 'topleft ' . a:height . ' new'
	setl wfw noswf buftype=nofile bufhidden=wipe
	setl nowrap foldcolumn=0 foldmethod=manual
	setl nofoldenable nobuflisted nospell
	exec 'setl ft=' . a:type
	iabc <buffer>
endfunction
