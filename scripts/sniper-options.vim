set bg=dark sw=4 ai sm ts=4 noea swb=usetab,newtab bs=2 ruler ls=2
set statusline=%<%f\ %h%m%r%=%{fugitive#statusline()}\ %-14.(%l,%c%V%)\ %P

if v:version > 703 || v:version == 703 && has("patch541")
	set formatoptions+=j
endif

if &t_Co == 8 && $TERM !~# '^linux'
	set t_Co=16
endif

if &listchars ==# 'eol:$'
	set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

syn on
