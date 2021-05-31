
" SQL {{{1
" The SQL ctags parser seems to be buggy for me, so this just uses the
" normal kinds even though scopes should be available. Improvements
" welcome!
let s:types = {}

let s:types.lang = 'sql'

let s:types.kinds = {
    \ 'P': {'long' : 'packages',               'fold' : 1, 'stl' : 1},
    \ 'd': {'long' : 'prototypes',             'fold' : 0, 'stl' : 1},
    \ 'c': {'long' : 'cursors',                'fold' : 0, 'stl' : 