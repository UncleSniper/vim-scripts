imap <C-\> <Esc>
imap <C-@> <C-p>

for tmp in range(1, 12)
	exec "nmap <F" . tmp . "> " . tmp . "gt"
	exec "imap <F" . tmp . "> <Esc>" . tmp . "gta"
endfor

nmap <C-s> :w<CR>
nmap <Leader>ns /\<TODO\><CR>

noremap <silent> <Leader><Leader> :BufExplorer<CR>
"noremap <silent> <C-n> :bn<CR>
"noremap <silent> <C-p> :bp<CR>

" languages may override
"nmap <silent> <Leader>m :make<Space>\|<Space>cwindow<CR>
nmap <silent> <Leader>m :<C-U>call MakeWrapper()<CR>
nmap <silent> <Leader>e :cn<CR>

" gah
imap <C-l> l
cmap <C-a> <C-\>eCommandLineBackSegment()<CR>

" programming stuff
"imap <C-b> {<CR>}<C-o>O<Tab>
imap <C-b> {<CR><Tab>
imap <expr> <C-]> InsertNewBlock()
nmap <C-p> }<CR>

" generic stuff
nmap <Leader>s :vsp<CR>
nmap <Leader>S :sp<CR>
nmap <expr> <Leader>W CleanUpWhitespace()
nmap <expr> <Leader>N NewFileInteractive()
nmap <expr> <Leader>O OpenFileInteractive()
imap <C-l> <End>
imap <C-q> <C-o>O<Tab>
imap <C-z> <Esc>O<CR>
imap <C-n> <C-o>o
nmap <Leader>T :call ShowBufferInOwnTab()<CR>

" window stuff
nmap <S-Left> <C-w><Left>
nmap <S-Right> <C-w><Right>
nmap <S-Up> <C-w><Up>
nmap <S-Down> <C-w><Down>

" common, but optional
function! BindSemicolonLanguage()
	inoremap <buffer> ; <End>;
	inoremap <buffer> ;<BS> ;
	"inoremap ;; <End>
endfunction
