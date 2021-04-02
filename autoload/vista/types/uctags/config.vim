" Autoconf {{{1
let s:types = {}

let s:types.lang = 'autoconf'

let s:types.kinds = {
    \ 'p': {'long': 'packages',            'fold': 0, 'stl': 1},
    \ 't': {'long': 'templates',           'fold': 0, 'stl': 1},
    \ 'm': {'long': 'autoconf macros',     'fold': 0, 'stl': 1},
    \ 'w': {'long': '"with" options',   