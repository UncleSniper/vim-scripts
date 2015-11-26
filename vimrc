runtime scripts/sniper-options.vim
runtime scripts/sniper-utils.vim

" functions
runtime scripts/java-fold.vim
runtime scripts/java-pruneimports.vim
runtime scripts/java-gencode.vim
runtime scripts/newblock.vim
runtime scripts/java-utils.vim

" global stuff
runtime scripts/sniper-common-actions.vim
runtime scripts/sniper-common-binds.vim
runtime scripts/sniper-languages.vim
runtime scripts/sniper-projects.vim
runtime scripts/sniper-git-binding.vim
runtime scripts/sniper-genproject.vim
runtime scripts/snippet-callbacks.vim
runtime scripts/abbrevs.vim

" language-specific stuff
runtime scripts/sniper-java.vim
runtime scripts/sniper-cpp.vim
runtime scripts/sniper-latex.vim
runtime scripts/sniper-flexipl.vim

" evaluation stuff
runtime scripts/sniper-eval-binding.vim
runtime scripts/postgresql-evaluator.vim

" project-specific stuff
runtime scripts/redstrain-actions.vim

" now the bundle manager can do its thing
call pathogen#infect()

" language-specific stuff managed by package manager
runtime scripts/extern-common.vim
runtime scripts/extern-java.vim

" things to do on startup
runtime scripts/sniper-boot.vim
