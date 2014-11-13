" ========== common ==========

function! NewProject()
	let langChoices = "&Java\nCancel&!"
	let plang = confirm('Which language?', langChoices, 2)
	if plang == 2
		echo 'Nevermind, then.'
		return
	endif
	if plang == 1
		let modtype = confirm('Module type?', "&Executable\n&Library\n&Servlet")
	else
		let modtype = confirm('Module type?', "&Executable\n&Library")
	endif
	let name = input('Project name? ')
	if !len(name)
		echo 'No name supplied, aborting.'
		return
	endif
	if len(glob(name))
		echo "File '" . name . "' already exists."
		return
	endif
	let oldlz = &lz
	set lz
	if plang == 1
		call NewJavaProject(name, modtype)
	endif
	let &lz = oldlz
	redraw!
endfunction

let s:commonGitExcudes = ['.*.swp']

function! CommonGenProjectHead(name)
	call OpenInfoWindowHorizontal('bottom', &lines / 2, 'genprojectout')
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

let g:genProjectTemplatesDir = '~/.vim/genproject'

function! GenProjectFileFromTemplate(template, destination, variables, resolve, resolveVars)
	call LogGenProjectAction('gen', a:destination)
	let tplfile = fnamemodify(g:genProjectTemplatesDir . '/' . a:template, ':p')
	let dest = fnamemodify(a:destination, ':p')
	vsplit
	exec 'vi ' . tplfile
	exec 'write ' . dest
	exec 'vi ' . dest
	if IsFuncref(a:resolve)
		call a:resolve(a:resolveVars)
	endif
	for key in keys(a:variables)
		let value = get(a:variables, key)
		exec '%s/\<' . EscapeFromSubstPattern(key) . '\>/' . EscapeFromSubstReplacement(value) . '/g'
	endfor
	write
	quit
endfunction

function! GenProjectFileKillMarker(marker)
	exec '/^' . EscapeFromSubstPattern(a:marker) . '$'
	normal dd
endfunction

function! GenProjectFileResolveMarker(marker, template)
	let path = fnamemodify(g:genProjectTemplatesDir . '/' . a:template, ':p')
	exec '/^' . EscapeFromSubstPattern(a:marker) . '$'
	normal ddk
	exec 'read ' . path
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
let s:javaGitExcludes = ['/lib/*.jar', '/bin', '/warbin', '/dist', '/doc/api']
let s:javaDependLines = ['This component does not have any dependencies.']
let s:javaDependLinesWAR = ['Place the Servlet API package (servlet-api.jar) into this directory.']

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
	if a:modtype == 1 || a:modtype == 3
		let mainclass = input('Main class? ', '')
	else
		let mainclass = ''
	endif
	call GenJavaProject(a:name, a:modtype, pkg, mainclass)
endfunction

function! GenJavaProject(name, modtype, basepkg, mainclass)
	call CommonGenProjectHead(a:name)
	" Git stuff
	call GenProjectFile('.git/info/exclude', s:commonGitExcudes + s:javaGitExcludes, 0)
	" build.xml
	call GenAntBuildfile(a:name, a:basepkg, a:modtype)
	" manifest.mf
	if a:modtype == 1
		call GenProjectFile('manifest.mf', ['Main-Class: ' . a:basepkg . '.' . a:mainclass], 1)
	endif
	" web.xml
	if a:modtype == 3
		call GenJavaWebXML(a:name, a:basepkg . '.' . a:mainclass)
	endif
	" jre6.packages
	call GenProjectFileFromTemplate('jre6.packages', 'jre6.packages', {}, 0, 0)
	" lib/
	call LogGenProjectAction('mkdir', 'lib')
	call mkdir('lib')
	call GenProjectFile('lib/DEPEND', a:modtype == 3 ? s:javaDependLinesWAR : s:javaDependLines, 1)
	" src/
	let srcdir = 'src/' . substitute(a:basepkg, '\.', '/', 'g')
	call LogGenProjectAction('mkdir', srcdir)
	call mkdir(srcdir, 'p')
	" Resources.java, Localization.java
	let resdir = srcdir . '/resource'
	call LogGenProjectAction('mkdir', resdir)
	call mkdir(resdir)
	call GenJavaResourcesClass(a:name, resdir, a:basepkg)
	" res/
	call LogGenProjectAction('mkdir', 'res')
	call mkdir('res')
	call GenProjectFile('res/' . a:name . '.properties', [], 1)
	" done
	call LogGenProjectAction('note', 'Finished generating Java project.')
	redraw!
endfunction

function! GenAntBuildfile(prjname, basepkg, modtype)
	call GenProjectFileFromTemplate('build.xml', 'build.xml', {
\		'PRJNAME': a:prjname,
\		'BASEPKG': a:basepkg,
\		'BASEPKGDIR': substitute(a:basepkg, '\.', '/', 'g'),
\		'MANIFEST_REFERENCE': a:modtype == 1 ? ' manifest="${manifest}"' : ''
\	}, function('GenAntBuildfileResolve'), {
\		'hasManifest': a:modtype == 1,
\		'makesWAR': a:modtype == 3
\	})
endfunction

function! GenAntBuildfileResolve(variables)
	" manifest
	if get(a:variables, 'hasManifest')
		call GenProjectFileResolveMarker('MANIFEST_PROPERTY', 'build-manifest-property.xml')
	else
		call GenProjectFileKillMarker('MANIFEST_PROPERTY')
	endif
	" warball
	if get(a:variables, 'makesWAR')
		call GenProjectFileResolveMarker('WAR_PROPERTIES', 'build-war-properties.xml')
		call GenProjectFileResolveMarker('WAR_INIT', 'build-war-init.xml')
		call GenProjectFileResolveMarker('SERVLET_LIB_EXCLUDE', 'build-servlet-lib-exclude.xml')
		call GenProjectFileResolveMarker('WAR_TARGET', 'build-war-target.xml')
		call GenProjectFileResolveMarker('WAR_CLEAN', 'build-war-clean.xml')
	else
		call GenProjectFileKillMarker('WAR_PROPERTIES')
		call GenProjectFileKillMarker('WAR_INIT')
		call GenProjectFileKillMarker('SERVLET_LIB_EXCLUDE')
		call GenProjectFileKillMarker('WAR_TARGET')
		call GenProjectFileKillMarker('WAR_CLEAN')
	endif
endfunction

function! GenJavaResourcesClass(prjname, resdir, basepkg)
	call GenProjectFileFromTemplate('Resources.java', a:resdir . '/Resources.java', {
\		'PRJNAME': a:prjname,
\		'BASEPKG': a:basepkg
\	}, 0, 0)
	call GenProjectFileFromTemplate('Localization.java', a:resdir . '/Localization.java', {
\		'BASEPKG': a:basepkg
\	}, 0, 0)
endfunction

function! GenJavaWebXML(prjname, mainclass)
	let mcbase = substitute(a:mainclass, '.*\.', '', '')
	call GenProjectFileFromTemplate('web.xml', 'web.xml', {
\		'PRJNAME': a:prjname,
\		'SERVLET_CLASS_BASE': mcbase,
\		'SERVLET_CLASS_QNAME': a:mainclass
\	}, 0, 0)
endfunction

" ========== commands ==========

command! Proj call NewProject()

command! -nargs=1 AddJavaPackagePrefix call AddJavaPackagePrefix('<args>')
command! -nargs=1 AddJavaProjectNameStrip call AddJavaProjectNameStrip('<args>')
