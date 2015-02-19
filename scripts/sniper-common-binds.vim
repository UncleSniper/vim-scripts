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
nmap <silent> <Leader>m :make<Space>\|<Space>cwindow<CR>
nmap <silent> <Leader>e :cn<CR>

" gah
imap <C-l> l

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
imap <C-l> <End>

" common, but optional
function! BindSemicolonLanguage()
	inoremap ; <End>;
	inoremap ;<BS> ;
	"inoremap ;; <End>
endfunction
