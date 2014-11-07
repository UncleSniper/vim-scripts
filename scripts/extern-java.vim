let g:UltiSnipsSnippetDirectories=["UltiSnips", "usnippets"]
let g:UltiSnipsListSnippets = "<S-Tab>"
let g:UltiSnipsJumpForwardTrigger = "<Tab>"

let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1

nmap <Leader>d :NERDTreeToggle<CR>

let g:ctrlp_map = "<Leader>t"
set wildignore+=*/bin/**
set wildignore+=*/dist/**
set wildignore+=*/build/**
let g:ctrlp_use_caching=0

let g:rooter_use_lcd = 1
let g:rooter_patterns = ['.git', '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/', 'makefile', 'Makefile', 'build.xml', 'pom.xml']
