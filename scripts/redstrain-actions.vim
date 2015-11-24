function! SniperRedStrainInit()
	setl wildignore-=*/build/**
	let fpath = expand('%')
	let isModComp = !stridx(fpath, 'modules/')
	let isBlobComp = !stridx(fpath, 'data/')
	let isToolComp = !stridx(fpath, 'tools/')
	if isBlobComp
		let blobName = strpart(fpath, 5)
		let pos = stridx(blobName, '/')
		if pos < 0
			let blobName = ''
		else
			let blobName = strpart(blobName, 0, pos)
		endif
		if match(blobName, '-l10n$') > 0
			call SniperRedStrainInit_L10NBlob(blobName)
		endif
	endif
endfunction

function! SniperRedStrainInit_L10NBlob(blobName)
	let fext = expand('%:e')
	if fext == 'msgsc'
		let b:makeFunc = 'SniperRedStrainMake_MessageSpecification'
	elseif fext == 'msgdf'
		let b:makeFunc = 'SniperRedStrainMake_MessageDefinition'
	endif
	let b:rsBlobName = a:blobName
	let b:rsCompType = 'data'
endfunction

function! SniperRedStrainMake_MessageSpecification()
	let msgshdr = 'tools/msgshdr/redmsgshdr-static'
	let blobName = b:rsBlobName
	if match(blobName, '-l10n$') > 0
		let blobName = strpart(blobName, 0, len(blobName) - 5)
	endif
	let lower = tolower(blobName)
	let capital = toupper(strpart(blobName, 0, 1)) . tolower(strpart(blobName, 1))
	if capital == 'Io'
		let capital = 'IO'
	endif
	let upper = toupper(blobName)
	let ktype = 'redengine::' . lower . '::l10n::' . capital . 'ModuleMessageKey'
	let guard = 'REDSTRAIN_' . toupper(b:rsCompType) . '_' . upper . '_L10N_' . upper . 'MODULEMESSAGEKEY_HPP'
	let hdrfile = b:rsCompType . '/' . b:rsBlobName . '/src/' . capital . 'ModuleMessageKey.hpp'
	exec '!' . msgshdr . ' -t' . ktype . ' -pMSG_ -g' . guard . ' ' . expand('%') . ' ' . hdrfile
endfunction

function! SniperRedStrainMake_MessageDefinition()
	let updmsgs = 'tools/updmsgs/redupdmsgs-static'
	if expand('%:t:r') == 'en_US'
		let refflag = ''
	else
		let refflag = '-f' . expand('%:h') . '/en_US.msgdf'
	endif
	exec '!' . updmsgs . ' -v ' . refflag . ' ' . expand('%:h') . '/messages.msgsc ' . expand('%')
endfunction
