let s:qnamePattern = '\I\i*\%(\.\I\i*\)*'
let s:typePattern = s:qnamePattern . '\%(<' . s:qnamePattern . '\%(, ' . s:qnamePattern . '\)*>\)\?'
let s:typeListPattern = s:typePattern . '\%(, ' . s:typePattern . '\)*'

let s:fieldDeclPattern =  '^[ \t]*\%(\(public\|protected\|private\) \)\?'
let s:fieldDeclPattern .= '\(static \)\?\(\final \)\?'
let s:fieldDeclPattern .= '\(' . s:typePattern . '\) \(\I\i*\)\%(;\| =\)'

let s:implementsPattern = '^[ \t]*\%(implements \)\?' . s:typeListPattern . '\%( {\)\?$'
let s:classDefPattern =  '^[ \t]*\%(public \|protected \|private \)\?\%(class\|enum\) \(\I\i*\)'
let s:classDefPattern .= '\%( extends ' . s:typePattern . '\)\?'
let s:classDefPattern .= '\%( implements ' . s:typeListPattern . '\)\?'
let s:classDefPattern .= '\%( {\)\?$'

function! JavaAnalyzeFieldDeclaration(lno)
	let ml = matchlist(getline(a:lno), s:fieldDeclPattern)
	if !len(ml)
		return []
	endif
	let visibility = get(ml, 1)
	let isStatic = !!len(get(ml, 2))
	let isFinal = !!len(get(ml, 3))
	let type = get(ml, 4)
	let name = get(ml, 5)
	return [visibility, isStatic, isFinal, type, name]
endfunction

function! JavaFindClassName(lno)
	let pos = getpos('.')
	call setpos('.', [0, a:lno, 1, 0])
	let lbrace = searchpair('{', '', '}', 'nbW')
	call setpos('.', pos)
	if lbrace <= 0
		return ''
	endif
	while match(getline(lbrace), s:implementsPattern) >= 0
		let lbrace -= 1
		if lbrace <= 0
			return ''
		endif
	endwhile
	let ml = matchlist(getline(lbrace), s:classDefPattern)
	if !len(ml)
		return ''
	endif
	return get(ml, 1)
endfunction

function! JavaFindClassStart(lno)
	let pos = getpos('.')
	call setpos('.', [0, a:lno, 1, 0])
	let lbrace = searchpair('{', '', '}', 'nbW')
	call setpos('.', pos)
	if lbrace <= 0
		return 0
	endif
	return lbrace
endfunction

function! JavaFindClassEnd(lno)
	let pos = getpos('.')
	call setpos('.', [0, a:lno, 1, 0])
	let rbrace = searchpair('{', '', '}', 'nW')
	call setpos('.', pos)
	if rbrace <= 0
		return 0
	endif
	return rbrace
endfunction

function! JavaGetIndentation(lno)
	let ldata = getline(a:lno)
	let pos = match(ldata, '\S')
	if pos < 0
		return ldata
	else
		return strpart(ldata, 0, pos)
	endif
endfunction

function! JavaFindClassInsertPosition(lno)
	let pos = getpos('.')
	call setpos('.', [0, a:lno, 1, 0])
	let rbrace = searchpair('{', '', '}', 'nW')
	call setpos('.', pos)
	if rbrace <= 0
		return 0
	endif
	return rbrace
endfunction

function! JavaIndentIfNeeded(indentation)
	if &ai
		return ''
	else
		return a:indentation
	endif
endfunction

function! JavaUnindentIfNeeded(indentation)
	if &ai
		return "\<BS>"
	else
		return a:indentation
	endif
endfunction

function! JavaCaplitalize(str)
	let length = len(a:str)
	if !length
		return ''
	endif
	return toupper(strpart(a:str, 0, 1)) . strpart(a:str, 1)
endfunction

function! JavaGenerateAccessorsImpl(lno, kinds)
	let field = JavaAnalyzeFieldDeclaration(a:lno)
	if !len(field)
		echo 'Not a recognized field declaration.'
		return ''
	endif
	let inspos = JavaFindClassInsertPosition(a:lno)
	if !inspos
		echo 'Cannot find insertion line.'
		return ''
	endif
	let visibility = get(field, 0)
	let isStatic = get(field, 1)
	let isFinal = get(field, 2)
	let type = get(field, 3)
	let name = get(field, 4)
	let class = JavaFindClassName(a:lno)
	let indent = JavaGetIndentation(a:lno)
	if visibility == 'public'
		return ''
	endif
	let keys = inspos . 'G'
	for idx in range(len(a:kinds))
		let kind = strpart(a:kinds, idx, 1)
		if kind == 'g'
			let keys .= "O\<Esc>O" . indent
			let keys .= 'public '
			if isStatic
				let keys .= 'static '
			endif
			let keys .= type . ' get' . JavaCaplitalize(name) . "() {\<CR>"
			let keys .= JavaIndentIfNeeded(indent) . "\<Tab>return "
			if isStatic && len(class)
				let keys .= class . '.'
			endif
			let keys .= name . ";\<CR>"
			let keys .= JavaUnindentIfNeeded(indent) . "}\<Esc>\<CR>\<CR>"
		elseif kind == 's' && !isFinal
			let keys .= "O\<Esc>O" . indent
			let keys .= 'public '
			if isStatic
				let keys .= 'static '
			endif
			let keys .= 'void set' . JavaCaplitalize(name) . '(' . type . ' ' . name . ") {\<CR>"
			let keys .= JavaIndentIfNeeded(indent) . "\<Tab>"
			if !isStatic
				let keys .= 'this.'
			elseif len(class)
				let keys .= class . '.'
			endif
			let keys .= name . ' = ' . name . ";\<CR>"
			let keys .= JavaUnindentIfNeeded(indent) . "}\<Esc>\<CR>\<CR>"
		endif
	endfor
	return keys
endfunction

function! JavaGenerateAccessors(kinds)
	let here = line('.')
	let keys = JavaGenerateAccessorsImpl(here, a:kinds)
	if !len(keys)
		return ''
	endif
	return keys . here . 'G'
endfunction

function! JavaGenerateAllAccessors(kinds)
	let here = line('.')
	let cstart = JavaFindClassStart(here)
	let cend = JavaFindClassEnd(here)
	if !cstart || !cend
		echo 'Failed to determine class boundaries.'
		return ''
	endif
	let line = cstart + 1
	let keys = ''
	while line < cend
		let ldata = getline(line)
		let brindex = stridx(ldata, '{')
		if brindex < 0
			if match(ldata, s:fieldDeclPattern) >= 0
				let keys .= JavaGenerateAccessorsImpl(line, a:kinds)
			endif
			let line += 1
		else
			let pos = getpos('.')
			call setpos('.', [0, line, brindex + 1, 0])
			let rbrace = searchpair('{', '', '}', 'nW')
			call setpos('.', pos)
			if rbrace
				let line = rbrace + 1
			else
				let line += 1
			endif
		endif
	endwhile
	return keys . here . 'G'
endfunction
