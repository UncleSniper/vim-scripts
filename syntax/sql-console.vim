runtime syntax/sql.vim

syn match sqlConsoleError /^>> \zsERROR: .*$/

hi link sqlConsoleError Error
