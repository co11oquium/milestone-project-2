let s:types = {}

let s:types.lang = 'rust'

let s:types.kinds = {
    \ 'n': {'long' : 'module',          'fold' : 1, 'stl' : 0},
    \ 's': {'long' : 'struct',          'fold' : 0, 'stl' : 1},
    \ 'i': {'long' : 'trait',           'fold' : 0, 'stl' : 1},
    \ 'c': {'long' : 'implementation',  'fold' : 0, 'stl' : 0},
    \ 'f': {'long' : 'function',        'fold' : 0, 'stl' : 1},
    \ 'g': {'long' : 'enum',            'fold' : 0, 'stl' : 1},
    \ 't'