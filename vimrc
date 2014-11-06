runtime scripts/sniper-options.vim

" functions
runtime scripts/java-fold.vim
runtime scripts/java-pruneimports.vim
runtime scripts/java-gencode.vim
runtime scripts/newblock.vim

" global stuff
runtime scripts/sniper-common-binds.vim
runtime scripts/sniper-languages.vim
runtime scripts/sniper-projects.vim

" language-specific stuff
runtime scripts/sniper-java.vim

" now the bundle manager can do its thing
call pathogen#infect()

" language-specific stuff managed by package manager
runtime scripts/extern-java.vim
