function! JavaIsImport(data)
	return match(a:data, '^import\s\+\h\w*\(\.\h\w*\)*\s*;\s*$') >= 0
endfunction

function! JavaIsPackageDeclaration(data)
	return match(a:data, '^package\s\+\h\w*\(\.\h\w*\)*\s*;\s*$') >= 0
endfunction

function! JavaHasImportForSimple(name)
	return search('^import\s\+\h\w*\(\.\h\w*\)\.\<' . EscapeFromSubstPattern(a:name) . '\>\s*;\s*$', 'cnw')
endfunction

function! JavaHasTypeDefinition(name)
	for lnr in range(1, line('$'))
		let l = JavaStripStrings(getline(lnr))
		if match(l, '\<\%(class\|enum\) ' . EscapeFromSubstPattern(a:name) . '\>') >= 0
			return 1
		endif
	endfor
	return 0
endfunction

function! JavaHasClassInThisPackage(name)
	return filereadable(expand('%:h') .'/' . a:name . '.java')
endfunction

function! JavaIsImportUsed(sname)
	call cursor(1, 1)
	let pat = '\<' . a:sname . '\>'
	while 1
		let lnr = search(pat, 'W')
		if !lnr
			return 0
		endif
		if !JavaIsImport(getline(lnr))
			return 1
		endif
	endwhile
endfunction

function! JavaPruneImports()
	let oriline = line('.')
	let oricol = col('.')
	let kill = []
	for lnr in range(1, line('$'))
		let l = getline(lnr)
		if JavaIsImport(l)
			let nstart = 6 + match(strpart(l, 6), '\h')
			let nend = nstart + match(strpart(l, nstart), '\(\s\|;\)')
			let qname = strpart(l, nstart, nend - nstart)
			let sname = strpart(qname, match(qname, '\h\w*$'))
			if !JavaIsImportUsed(sname)
				call add(kill, lnr)
				if lnr < oriline
					let oriline -= 1
				endif
			endif
		endif
	endfor
	let bias = 0
	for lnr in kill
		exec 'normal! ' . (lnr - bias) . 'Gdd'
		let bias += 1
	endfor
	call cursor(oriline, oricol)
endfunction

function! JavaStripStrings(data)
	return substitute(a:data, '"\%([^"\\]\|\\.\)*"', '', 'g')
endfunction

function! JavaGenImports()
	let oriline = line('.')
	let oricol = col('.')
	let types = {}
	for lnr in range(1, line('$'))
		let l = getline(lnr)
		if JavaIsPackageDeclaration(l) || JavaIsImport(l)
			continue
		endif
		let l = JavaStripStrings(l)
		let start = 0
		while 1
			let pos = match(l, '\<[A-Z]\w\w\+\>', start)
			if pos < 0
				break
			endif
			let sname = get(matchlist(l, '\<[A-Z]\w\w\+\>', start), 0)
			let types[sname] = 1
			let start = pos + len(sname)
		endwhile
	endfor
	for type in keys(types)
		if !JavaHasImportForSimple(type) && !JavaHasTypeDefinition(type) && !JavaHasClassInThisPackage(type)
			call JavaGenImportForSimple(type)
		endif
	endfor
	call cursor(oriline, oricol)
endfunction

function! JavaGenImportForSimple(name)
	let lstf = expand('~/.vim/javatypes.lst')
	if !len(glob(lstf))
		return
	endif
	let candidates = GetOutputOf(['grep', '-E', '\.' . a:name . '$', lstf], 1)
	if !len(candidates)
		return
	endif
	for cnd in candidates
		if cnd == 'java.lang.' . a:name
			return
		endif
	endfor
	if len(candidates) == 1
		call JavaGenImportForQualified(get(candidates, 0))
	else
		let idx = 1
		let choices = '&0 <none>'
		for cnd in candidates
			let choices .= "\n&" . idx . ' ' . cnd
			let idx += 1
		endfor
		let chosen = confirm('', choices, 1) - 1
		if chosen
			call JavaGenImportForQualified(get(candidates, chosen - 1))
		endif
	endif
endfunction

function! JavaGenImportForQualified(name)
	let lastimp = 0
	let insertnewlines = 0
	let pkgline = 0
	let apdata = 'import ' . a:name . ';'
	for lnr in range(1, line('$'))
		let l = getline(lnr)
		if match(l, '^\s*$') >= 0
			continue
		endif
		if JavaIsPackageDeclaration(l)
			let pkgline = lnr
			continue
		endif
		if !JavaIsImport(l)
			if lastimp
				call append(lastimp, apdata)
			elseif pkgline
				call append(pkgline, ['', apdata])
			else
				call append(0, [apdata, ''])
			endif
			return
		else
			if len(l) > len(apdata)
				call append(lnr - 1, apdata)
				return
			endif
			let lastimp = lnr
		endif
	endfor
	" No non-package, non-import lines?
	" Then how did we even get here...?
	call append(line('$'), apdata)
endfunction
