
" C++ {{{1
let s:types = {}

let s:types.lang = 'c++'

let s:types.kinds = {
    \ 'h': {'long' : 'header files', 'fold' : 1, 'stl' : 0},
    \ 'd': {'long' : 'macros',       'fold' : 1, 'stl' : 0},
    \ 'p': {'long' : 'prototypes',   'fold' : 1, 'stl' : 0},
    \ 'g': {'long' : 'enums',    