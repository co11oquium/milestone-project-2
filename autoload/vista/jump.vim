" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

function! s:EscapeForVimRegexp(str) abort
  return escape(a:str, '^$.*?/\[]')
endfun