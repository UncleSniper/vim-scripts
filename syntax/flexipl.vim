syn match flexiplType /\<\%(char\|int\|string\|type\)\>[*?]*/
syn keyword flexiplConstant true false

syn match flexiplPrimedName /\<[a-zA-Z0-9_]'\+/
syn match flexiplModifiedType /\<[a-zA-Z0-9_]\+\zs[*?]\+/

syn region flexiplString start=+"+ end=+"+
syn region flexiplChar start=+^'+ end=+'+
syn region flexiplChar start=+'+ end=+'+
syn match flexiplNumber /[+-]\?\<[0-9]\+\%(\.[0-9]\+\)\?\>/

syn match flexiplOperator /[\[\]{};]/
syn keyword flexiplOperator if then else while do end

hi link flexiplType Type
hi link flexiplModifiedType Type
hi link flexiplConstant Constant
hi link flexiplString String
hi link flexiplChar String
hi link flexiplOperator Keyword

call DoFlexiPLBindings()
