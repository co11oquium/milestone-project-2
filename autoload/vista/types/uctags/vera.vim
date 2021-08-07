
" Vera {{{1
" Why are variables 'virtual'?
let s:types = {}

let s:types.lang = 'vera'

let s:types.kinds = {
    \ 'h': {'long' : 'header files', 'fold' : 1, 'stl' : 0},
    \ 'd': {'long' : 'macros',      'fold' : 1, 'stl' : 0},
    \ 'g': {'long' : 'enums',       