nmap <silent> <Leader>Gd :Gdiff<CR>
nmap <silent> <Leader>GD :Gdiff --cached<CR>
nmap <silent> <Leader>G? :Gpull<CR>
nmap <silent> <Leader>G! :Gpush<CR>

function! ShowGitStatus()
	call OpenInfoWindowHorizontal('top', 15, 'gitstatus')
	file *git-status*
	read !git status --porcelain
	normal 1Gdd0
	sort
	setl nomodifiable
	call BindGitStatusKeys()
endfunction

function! UpdateGitStatus()
	if bufname('%') != '*git-status*' || &modifiable
		echo 'Not a Git status buffer'
		return
	endif
	setl modifiable
	call UnbindGitStatusKeys()
	normal ggdG
	read !git status --porcelain
	normal 1Gdd0
	sort
	setl nomodifiable
	call BindGitStatusKeys()
endfunction

function! BindGitStatusKeys()
	nmap <buffer> a :call GitStatusAdd()<CR>
	nmap <buffer> A :call GitStatusAddAll()<CR>
	nmap <buffer> u :call GitStatusUndo()<CR>
	nmap <buffer> d :call GitStatusDiff(0)<CR>
	nmap <buffer> D :call GitStatusDiff(1)<CR>
	nmap <buffer> l :call GitStatusLog()<CR>
	nmap <buffer> c :call GitStatusCommit()<CR>
	nmap <buffer> q <C-w>q
endfunction

function! UnbindGitStatusKeys()
	nunmap <buffer> a
	nunmap <buffer> A
	nunmap <buffer> u
	nunmap <buffer> d
	nunmap <buffer> D
	nunmap <buffer> c
	nunmap <buffer> q
endfunction

let s:statusFilePattern = '\([^ "]\+\|"\%([^\\"]\|\\.\)*"\)'
let s:statusLinePattern = '^\(..\) ' . s:statusFilePattern . '\%( -> ' . s:statusFilePattern . '\)\?$'

function! GitStatusGetFile()
	let line = getline('.')
	let ml = matchlist(line, s:statusLinePattern)
	if !len(ml)
		return []
	endif
	let status = get(ml, 1)
	return [strpart(status, 0, 1), strpart(status, 1, 1), get(ml, 2), get(ml, 3)]
endfunction

function! GitStatusAdd()
	let line = GitStatusGetFile()
	if !len(line)
		echo 'Unrecognized status line.'
		return
	endif
	let [istat, wstat, oldfn, newfn] = line
	let status = istat . wstat
	if status == '??'
		let addee = oldfn
	elseif status == 'RM'
		let addee = newfn
	elseif status == 'AM' || status == 'MM' || status == ' M'
		let addee = oldfn
	else
		echo "Don't know what to add..."
		return
	endif
	exec 'silent !git add ' . addee
	call UpdateGitStatus()
endfunction

function! GitStatusAddAll()
	silent !git add .
	call UpdateGitStatus()
endfunction

function! GitStatusUndo()
	let line = GitStatusGetFile()
	if !len(line)
		echo 'Unrecognized status line.'
		return
	endif
	let [istat, wstat, oldfn, newfn] = line
	let status = istat . wstat
	if istat != ' ' && istat != '?'
		exec 'silent !git reset HEAD ' . oldfn
		call UpdateGitStatus()
	elseif wstat != ' ' && wstat != '?'
		if confirm("Really checkout '" . oldfn . "'?", "&No\n&Yes") - 1
			exec 'silent !git checkout -- ' . oldfn
			call UpdateGitStatus()
		endif
	else
		echo "Don't know what to undo..."
	endif
endfunction

function! GitStatusDiff(cached)
	let cmd = 'silent !git diff'
	if a:cached
		let cmd .= ' --cached'
	endif
	exec cmd
	redraw!
endfunction

function! GitStatusLog()
	exec 'silent !git log'
	redraw!
endfunction

function! GitStatusCommit()
	quit
	Gcommit
endfunction

nmap <silent> <Leader>GG :silent call ShowGitStatus()<CR>
