
" Eiffel {{{1
let s:types = {}

let s:types.lang = 'eiffel'

let s:types.kinds = {
    \ 'c': {'long' : 'classes',  'fold' : 0, 'stl' : 1},
    \ 'f': {'long' : 'features', 'fold' : 0, 'stl' : 1}
    \ }

let s:types.sro = '.' " Not sure, is nesting even possible?

let s:types.kind2scope = {
    \ 'c' 