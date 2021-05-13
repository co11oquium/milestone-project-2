
" PHP {{{1
let s:types = {}

let s:types.lang = 'php'

let s:types.kinds = {
    \ 'n': {'long' : 'namespaces',           'fold' : 0, 'stl' : 0},
    \ 'a': {'long' : 'use aliases',          'fold' : 1, 'stl' : 0},
    \ 'd': {'long' : 'constant definitions', 'fold' : 0, 'stl' : 0},
    \ 'i': {'long' : 'interfaces',           'fold' : 0, 'stl' : 1},
    \ 't': {'long' : 'traits',               'fold' : 0, 'stl' : 1},
    \ 'c': {'long' : 'classes',              'fold' : 0, 'stl' : 1},
    \ 'v': {'long' : 'variables',    