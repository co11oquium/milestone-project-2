
" Perl {{{1
let s:types = {}

let s:types.lang = 'perl'

let s:types.kinds = {
    \ 'p': {'long' : 'packages',    'fold' : 1, 'stl' : 0},
    \ 'c': {'long' : 'constants',   'fold' : 0, 'stl' : 0},
    \ 'f': {'long' : 'formats',     'fold' : 0, 'stl' : 0},
    \ 'l': {'long' : 'labels',      'fold' : 0, 'stl' : 1}