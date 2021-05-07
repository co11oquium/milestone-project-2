
" Flex {{{1
" Vim doesn't support Flex out of the box, this is based on rough
" guesses and probably requires
" http://www.vim.org/scripts/script.php?script_id=2909
" Improvements welcome!
let s:types = {}

let s:types.lang = 'flex'

let s:types.kinds = {
    \ 'v': {'long' : 'global variables', 'fold' : 0, 'stl' : 0},
    \ 'c': {'long' : 'clas