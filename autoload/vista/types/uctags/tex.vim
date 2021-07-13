
" LaTeX {{{1
let s:types = {}

let s:types.lang = 'tex'

let s:types.kinds = {
    \ 'i': {'long' : 'includes',       'fold' : 1, 'stl' : 0},
    \ 'p': {'long' : 'parts',          'fold' : 0, 'stl' : 1},
    \ 'c': {'long' : 'chapters',       'fold' : 0, 'stl' : 1},
    \ 's': {'long' : 's