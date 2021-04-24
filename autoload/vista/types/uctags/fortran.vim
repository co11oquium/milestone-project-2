
" Fortran {{{1
let s:types = {}

let s:types.lang = 'fortran'

let s:types.kinds = {
    \ 'm': {'long' : 'modules',    'fold' : 0, 'stl' : 1},
    \ 'p': {'long' : 'programs',   'fold' : 0, 'stl' : 1},
    \ 'k': {'long' : 'components', 'fold' : 0, 'stl' : 1},
    \ 't': {'long' : 'derived types and structures', 'fold' : 0,'stl' : 1},
    \ 'c': {'long' : 'common blocks', 'fold' : 0, 'stl' : 1},
    \ 