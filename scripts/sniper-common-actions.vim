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

function! OpenFileInteractive()
	return ':vi ' . expand('%:h') . '/'
endfunction

function! MakeWrapper()
	if exists('b:makeFunc')
		if len(b:makeFunc)
			exec 'call ' . b:makeFunc . '()'
			return
		endif
	endif
	call RealMakeWrapper()
endfunction

function! RealMakeWrapper()
	if v:count
		exec 'make ' . v:count
	else
		make
	endif
	cwindow
endfunction

function! ShowBufferInOwnTab()
	let id = bufnr('%')
	let lno = line('.')
	let cno = col('.')
	tabe
	exec 'buf ' . id
	call setpos('.', [0, lno, cno, 0])
endfunction

let g:browserprg = 'chromium'

function! ShowURLInBrowser(url)
	echom 'URL: ' . a:url
	let cmd = shellescape(g:browserprg) . ' ' . shellescape(a:url)
	new
	setl buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap shellredir=>&
	exec 'read !' . cmd
	bwipeout
endfunction

function! CommandLineBackSegment()
	let cmd = getcmdline()
	let pos = getcmdpos()
	if pos > 1 && strpart(cmd, pos - 2, 1) == '/'
		let pos -= 1
	endif
	if pos >= 2
		let spos = strridx(cmd, '/', pos - 2)
		if spos >= 0
			call setcmdpos(spos + 2)
		endif
	endif
	return cmd
endfunction
