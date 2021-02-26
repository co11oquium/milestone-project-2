" Ada
let s:types = {}

let s:types.lang = 'ada'

let s:types.kinds = {
    \ 'P': {'long' : 'package specifications',        'fold' : 0, 'stl' : 1},
    \ 'p': {'long' : 'packages',                      'fold' : 0, 