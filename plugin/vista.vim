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
let g:vista_blink = get(g:, 'vista_blink', [2, 100])
let g:vista_top_level_blink = get(g:, 'vista_top_level_blink', [2, 100])
let g:vista_icon_indent = get(g:, 'vista_icon_indent', ['└ ', '│ '])
let g:vista_fold_toggle_icons = get(g:, 'vista_fold_toggle_icons', ['▼', '▶'])
let g:vista_update_on_text_changed = get(g:, 'vista_update_on_text_changed', 0)
let g:vista_update_on_text_changed_delay = get(g:, 'vista_update_on_text_changed_delay', 500)