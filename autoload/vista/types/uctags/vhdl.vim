
" VHDL {{{1
" The VHDL ctags parser unfortunately doesn't generate proper scopes
let s:types = {}

let s:types.lang = 'vhdl'

let s:types.kinds = {
    \ 'P': {'long' : 'packages',   'fold' : 1, 'stl' : 0},
 