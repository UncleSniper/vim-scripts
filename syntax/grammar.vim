setl isk=a-z,A-Z,48-57,_

syn match gramDef /::=/
syn match gramNonTerm /\<[a-z][a-z0-9_]\+\>/
syn match gramRule /^\<[a-z][a-z0-9_]\+\>/
syn match gramOper /[|%()?+*]/
syn match gramToken /\<[A-Z][A-Z0-9_]\+\>/

syn region gramTerm start=+'+ end=+'+

hi link gramDef Type
hi link gramRule Special
hi link gramOper Keyword
hi link gramToken Comment
hi link gramTerm Constant

"hi link gramNonTerm Type
