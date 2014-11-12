function! NewProject()
	let langChoices = "&Java\nCancel&!"
	let plang = confirm('Which language?', langChoices, 2)
	if plang == 2
		echo 'Nevermind, then.'
		return
	endif
	let modtype = confirm('Module type?', "&Executable\n&Library")
	let name = input('Project name? ')
	if !len(name)
		echo 'No name supplied, aborting.'
		return
	endif
	if len(glob(name))
		echo "File '" . name . "' already exists."
		return
	endif
	if plang == 1
		call NewJavaProject(name, modtype)
	endif
endfunction

let g:javaPackagePrefixes = []

function! AddJavaPackagePrefix(prefix)
	call add(g:javaPackagePrefixes, a:prefix)
endfunction

function! CompleteJavaProjectBasePackage(argLead, cmdLine, cursorPos)
	let items = []
	for prefix in g:javaPackagePrefixes
		for suffix in ['', '.' . s:javaProjectName]
			let base = prefix . suffix
			if len(base) >= len(argLead) && strpart(base, 0, len(argLead)) == argLead
				call add(items, base)
			endif
		endfor
	endfor
	return items
endfunction

function! NewJavaProject(name, modtype)
	let s:javaProjectName = a:name
	let pkg = input('Base package? ', '', 'customlist,CompleteJavaProjectBasePackage')
	if !len(pkg)
		echo 'No package name supplied, aborting.'
		return
	endif
endfunction

command! Proj call NewProject()
command! -nargs=1 AddJavaPackagePrefix call AddJavaPackagePrefix('<args>')
