" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:finder = fnamemodify(expand('<sfile>'), ':t:r')

" Actually call skim#run()
function! s:ApplyRun() abort
  try
    " skim_colors may interfere custom syntax.
    " Unlet and restore it later.
    if exists('g:skim_colors')
      let old_skim_colors = g:skim_colors
      unlet g:skim_colors
 