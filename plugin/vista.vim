" vista.vim - View and search LSP symbols, tags, etc.
" Author:     Liu-Cheng Xu <xuliuchengxlc@gmail.com>
" Website:    https://github.com/liuchengxu/vista.vim
" License:    MIT

if exists('g:loaded_vista')
  finish
endif

let g:loaded_vista = 1

let g:vista_floating_border = get(g:, 'vista_floating_border', 'none')
let g:vista_sidebar_width = get(g:, 'vista_sidebar_width', 30)
let g:vista_sidebar_position = get(g:, 'vista_sidebar_position', 'vertical botright')
let g:vista_blink =