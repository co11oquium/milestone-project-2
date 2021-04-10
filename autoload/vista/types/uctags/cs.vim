
" C# {{{1
let s:types = {}

let s:types.lang = 'c#'

let s:types.kinds = {
    \ 'd': {'long' : 'macros',      'fold' : 1, 'stl' : 0},
    \ 'f': {'long' : 'fields',      'fold' : 0, 'stl' : 1},
    \ 'g': {'long' : 'enums',       'fold' : 0, 'stl' : 1},
    \ 'e': {'long' : 'enumerators', 'fold' : 0, 'stl' : 0},
    \ 't': {'long' : 'typedefs',    'fold' : 0, 'stl' : 1},
    \ 'n': {'long' : '