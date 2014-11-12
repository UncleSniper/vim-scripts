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

let s:javaPackagePrefixes = []
let s:javaProjectNameStrip = []

function! AddJavaPackagePrefix(prefix)
	call add(s:javaPackagePrefixes, a:prefix)
endfunction

function! AddJavaProjectNameStrip(prefix)
	call add(s:javaProjectNameStrip, a:prefix)
	call reverse(sort(s:javaProjectNameStrip))
endfunction

function! CompleteJavaProjectBasePackage(argLead, cmdLine, cursorPos)
	let pname = s:javaProjectName
	for strip in s:javaProjectNameStrip
		if len(pname) > len(strip) && strpart(pname, 0, len(strip)) == strip
			let pname = strpart(pname, len(strip))
			break
		endif
	endfor
	let items = []
	for prefix in s:javaPackagePrefixes
		for suffix in ['', '.' . pname]
			let base = prefix . suffix
			if len(base) >= len(a:argLead) && strpart(base, 0, len(a:argLead)) == a:argLead
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
	call GenJavaProject(name, modtype, pkg)
endfunction

function! GenJavaProject(name, modtype, basepkg)
	call CommonGenProjectHead(name)
endfunction

function! CommonGenProjectHead(name)
	call OpenInfoWindowHorizontal('bottom', &lines / 3, 'genprojectout')
	file *gen-project*
	setl nomodifiable
	nmap <buffer> <CR> <C-w>q
	call LogGenProjectAction('mkdir', a:name)
	call mkdir(a:name, 'p')
	call LogGenProjectAction('chdir', a:name)
	exec 'chdir ' . expand(a:name . ':p')
	call LogGenProjectAction('init', '.git')
	!git init
endfunction

function! LogGenProjectAction(action, argument)
	let msg = toupper(a:action)
	if len(msg) < 5
		let msg .= repeat(' ', 5 - len(msg))
	endif
	if len(a:argument)
		let msg .= ' ' . a:argument
	endif
	setl modifiable
	call append(line('$'), msg)
	setl nomodifiable
	redraw!
endfunction

command! Proj call NewProject()
command! -nargs=1 AddJavaPackagePrefix call AddJavaPackagePrefix('<args>')
command! -nargs=1 AddJavaProjectNameStrip call AddJavaProjectNameStrip('<args>')
