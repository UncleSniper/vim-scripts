" ========== common ==========

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

let s:commonGitExcudes = ['.*.swp']

function! CommonGenProjectHead(name)
	call OpenInfoWindowHorizontal('bottom', &lines / 3, 'genprojectout')
	file *gen-project*
	setl nomodifiable
	nmap <buffer> <CR> <C-w>q
	call LogGenProjectAction('mkdir', a:name)
	call mkdir(a:name, 'p')
	call LogGenProjectAction('chdir', a:name)
	echo 'chdir ' . fnamemodify(a:name, ':p')
	exec 'chdir ' . fnamemodify(a:name, ':p')
	call LogGenProjectAction('init', '.git')
	silent !git init
endfunction

function! GenProjectFile(path, lines, clear)
	call LogGenProjectAction('gen', a:path)
	vsplit
	exec 'vi ' . a:path
	if a:clear
		normal ggdG
	endif
	call append(line('$'), a:lines)
	if a:clear
		normal ggdd
	endif
	write
	quit
endfunction

function! LogGenProjectAction(action, argument)
	let msg = toupper(a:action)
	if len(msg) < 5
		let msg .= repeat(' ', 5 - len(msg))
	endif
	if len(a:argument)
		let msg .= ' ' . a:argument
	endif
	let wasEmpty = !len(getline(1))
	setl modifiable
	call append(line('$'), msg)
	if wasEmpty
		normal ggdd
	endif
	setl nomodifiable
	redraw!
endfunction

" ========== Java ==========

let s:javaPackagePrefixes = []
let s:javaProjectNameStrip = []
let s:javaGitExcludes = ['/lib/*.jar', '/bin', '/dist']
let s:javaDependLines = ['This component does not have any dependencies.']

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
	call GenJavaProject(a:name, a:modtype, pkg)
endfunction

function! GenJavaProject(name, modtype, basepkg)
	call CommonGenProjectHead(a:name)
	" Git stuff
	call GenProjectFile('.git/info/exclude', s:commonGitExcudes + s:javaGitExcludes, 0)
	" lib/
	call LogGenProjectAction('mkdir', 'lib')
	call mkdir('lib')
	call GenProjectFile('lib/DEPEND', s:javaDependLines, 1)
	" src/
	let srcdir = 'src/' . substitute(a:basepkg, '\.', '/', 'g')
	call LogGenProjectAction('mkdir', srcdir)
	call mkdir(srcdir, 'p')
	" done
	call LogGenProjectAction('note', 'Finished generating Java project.')
	redraw!
endfunction

" ========== commands ==========

command! Proj call NewProject()

command! -nargs=1 AddJavaPackagePrefix call AddJavaPackagePrefix('<args>')
command! -nargs=1 AddJavaProjectNameStrip call AddJavaProjectNameStrip('<args>')
