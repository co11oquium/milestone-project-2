" Ada
let s:types = {}

let s:types.lang = 'ada'

let s:types.kinds = {
    \ 'P': {'long' : 'package specifications',        'fold' : 0, 'stl' : 1},
    \ 'p': {'long' : 'packages',                      'fold' : 0, 'stl' : 0},
    \ 't': {'long' : 'types',                         'fold' : 0, 'stl' : 1},
    \ 'u': {'long' : 'subtypes',                      'fold' : 0, 'stl' : 1},
    \ 'c': {'long' : 'record type components',        'fold' : 0, 'stl' : 1},
    \ 'l': {'long' : '