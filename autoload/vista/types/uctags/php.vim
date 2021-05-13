
" PHP {{{1
let s:types = {}

let s:types.lang = 'php'

let s:types.kinds = {
    \ 'n': {'long' : 'namespaces',           'fold' : 0, 'stl' : 0},
    \ 'a': {'long' : 'use aliases',          'fold' : 1, 'stl' : 0},
    \ 'd': {'long' : 'constant definitions', 'fold' : 0, 'stl' : 0},
    \ 'i': {'long' : 'inte