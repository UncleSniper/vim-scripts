syn keyword genPrjAction MKDIR CHDIR INIT GEN NOTE IMPORT

syn match genPrjError /^ERROR .*$/

hi link genPrjAction Type
hi link genPrjError Error
