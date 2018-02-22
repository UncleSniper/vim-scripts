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

function! JavaEmbrace()
	let here = line('.')
	let ldata = getline(here)
	let level = GetIndentLevelOf(ldata)
	if !level
		return ''
	endif
	let topln = here
	while topln > 1
		if GetIndentLevelOf(getline(topln - 1)) < level
			break
		endif
		let topln -= 1
	endwhile
	let bottomln = here
	let lastln = line('$')
	while bottomln < lastln
		if GetIndentLevelOf(getline(bottomln + 1)) < level
			break
		endif
		let bottomln += 1
	endwhile
	let column = get(getpos('.'), 2)
	let braceIndent = repeat("\t", level - 1)
	if topln == 1
		let keys = "\<Esc>ggO\<Esc>i" . braceIndent . "{\<Del>\<Esc>"
		let here += 1
		let bottomln += 1
	else
		let keys = "\<Esc>" . (topln - 1) . "GA {\<Del>\<Esc>"
	endif
	let keys .= bottomln . "Go\<Esc>i" . braceIndent . "}\<Esc>"
	let keys .= here . 'G'
	if column > len(ldata)
		let keys .= 'A'
	else
		let keys .= '0'
		if column > 1
			let keys .= (column - 1) . 'li'
		endif
	endif
	return keys
endfunction

function! s:IsKeyword(lnr, keyword)
	return match(getline(a:lnr), '^\t*' . a:keyword . '\>') >= 0
endfunction

function! JavaNewBranch(isCatch)
	let here = line('.')
	let level = GetIndentLevelOf(getline(here))
	if s:IsKeyword(here, 'case') || s:IsKeyword(here, 'default')
		return s:NewSwitchBranch(here, a:isCatch)
	endif
	while here > 1
		let nlvl = GetIndentLevelOf(getline(here))
		if nlvl < level - 1
			break
		elseif nlvl == level - 1
			if s:IsKeyword(here, 'case') || s:IsKeyword(here, 'default')
				return s:NewSwitchBranch(here, a:isCatch)
			elseif s:IsKeyword(here, 'if') || s:IsKeyword(here, 'else')
				return s:NewIfBranch(here, a:isCatch)
			endif
		endif
		let here -= 1
	endwhile
	return ''
endfunction

function! s:GetBranchBottom(oldBranchLine)
	let level = GetIndentLevelOf(getline(a:oldBranchLine))
	let bottomln = a:oldBranchLine
	let lastln = line('$')
	while bottomln < lastln
		if GetIndentLevelOf(getline(bottomln + 1)) < level
			break
		endif
		let bottomln += 1
	endwhile
	return bottomln
endfunction

function! s:NewSwitchBranch(oldBranchLine, isCatch)
	let level = GetIndentLevelOf(getline(a:oldBranchLine))
	let bottomln = s:GetBranchBottom(a:oldBranchLine)
	let keys = "\<Esc>" . bottomln . "Go\<Esc>i" . repeat("\t", level)
	if a:isCatch
		return keys . "def\<Tab>"
	else
		return keys . "cas\<Tab>"
	endif
endfunction

function! s:NewIfBranch(oldBranchLine, isCatch)
	let level = GetIndentLevelOf(getline(a:oldBranchLine))
	let bottomln = s:GetBranchBottom(a:oldBranchLine)
	let keys = "\<Esc>" . bottomln . "Go\<Esc>i" . repeat("\t", level)
	if a:isCatch
		return keys . "else\<CR>\<Tab>"
	else
		return keys . "else if\<Tab>"
	endif
endfunction

let s:sourceFilePrefixes = [
\	'^src/main/java/',
\	'^src/test/java/',
\	'^src/'
\]

function! JavaGuessPackage()
	let fn = expand('%:h')
	for pfx in s:sourceFilePrefixes
		let short = substitute(fn, pfx, '', '')
		if short != fn
			let fn = short
			break
		endif
	endfor
	return substitute(fn, '/', '.', 'g')
endfunction
