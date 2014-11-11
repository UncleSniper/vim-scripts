syn match gitStatusStaged /^[MDAR]  .*$/

syn match gitStatusUnstaged /^ M .*$/
syn match gitStatusUnstaged /^?? .*$/

syn match gitStatusSplit /^[MAR]M .*$/

syn match gitStatusMissing /^[MAR]D .*$/

syn match gitStatusUnmerged /^D[DU] .*$/
syn match gitStatusUnmerged /^A[AU] .*$/
syn match gitStatusUnmerged /^U[DAU] .*$/

hi link gitStatusStaged Type
hi link gitStatusUnstaged Keyword
hi link gitStatusSplit Constant
hi link gitStatusMissing Error
hi link gitStatusUnmerged Error
