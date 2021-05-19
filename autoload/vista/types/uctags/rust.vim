let s:types = {}

let s:types.lang = 'rust'

let s:types.kinds = {
    \ 'n': {'long' : 'module',          'fold' : 1, 'stl' : 0},
    \ 's': {'long' : 'struct',          'fold' : 0, 'stl' : 1},
    \ 'i': {'long' : 'trait',           'fold' 