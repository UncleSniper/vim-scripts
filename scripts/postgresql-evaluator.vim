let s:host = ''
let s:user = ''
let s:dbase = ''

function! EvaluatePostgreSQL(code)
	if !len(s:host)
		echoerr 'No PostgreSQL host set.'
		return []
	endif
	if len(s:user)
		let user = s:user
	else
		let user = $USER
	endif
	if !len(s:dbase)
		echoerr 'No PostgreSQL database set.'
		return []
	endif
	new
	vi ~/.eval_psql
	normal gg"_dG
	call append(line('$'), a:code)
	normal gg"_dd
	exit
	let result = GetOutputOfWithInput(['psql', '-h', s:host, '-U', user, s:dbase], 1, expand('~/.eval_psql'))
	if len(result) && !len(get(result, -1))
		call remove(result, -1)
	endif
	return result
endfunction

function! SetPostgreSQLConnection(host, user, dbase)
	let s:host = a:host
	let s:user = a:user
	let s:dbase = a:dbase
endfunction

function! SniperOpenPostgreSQLConsole()
	call SniperOpenConsole('top', (&lines - 2) * 2 / 5, '*PostgreSQL*', 'sql-console',
\							'EvaluatePostgreSQL', 'SniperDefaultEvalFilter')
endfunction

command! -nargs=+ SetPostgreSQLConnection call SetPostgreSQLConnection(<f-args>)

nmap <Leader>PQ :silent call SniperOpenPostgreSQLConsole()<CR>i
