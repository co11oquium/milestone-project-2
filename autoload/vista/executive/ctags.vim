
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:provider = fnamemodify(expand('<sfile>'), ':t:r')

let s:reload_only = v:false
let s:should_display = v:false

let s:ctags = get(g:, 'vista_ctags_executable', 'ctags')
let s:support_json_format =
      \ len(filter(systemlist(s:ctags.' --list-features'), 'v:val =~# ''^json''')) > 0

" Expose this variable for debugging
let g:vista#executive#ctags#support_json_format = s:support_json_format