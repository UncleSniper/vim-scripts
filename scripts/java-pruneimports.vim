function! JavaIsImport(data)
	return match(a:data, '^import\s\+\h\w*\(\.\h\w*\)*\s*;\s*$') >= 0
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
