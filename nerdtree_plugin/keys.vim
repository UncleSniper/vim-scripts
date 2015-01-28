function! s:addmap(key, callback, help)
	call NERDTreeAddKeyMap({
\		'key': a:key,
\		'callback': a:callback,
\		'quickhelpText': a:help,
\		'override': 1
\	})
endfunction

call s:addmap(';', 'US_NERDTreeManyDown', 'Jump down many nodes')
call s:addmap(',', 'US_NERDTreeManyUp', 'Jump up many nodes')
call s:addmap('<', 'US_NERDTreeOpenLeft', 'Open file in left split')
call s:addmap('>', 'US_NERDTreeOpenRight', 'Open file in right split')

function! US_NERDTreeManyDown()
	normal 5j
endfunction

function! US_NERDTreeManyUp()
	normal 5k
endfunction

function! US_NERDTreeOpenLeft()
	exec "normal 2\<C-w>w1\<C-w>wo\<BSlash>d"
endfunction

function! US_NERDTreeOpenRight()
	exec "normal 3\<C-w>w1\<C-w>wo\<BSlash>d"
endfunction
