
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

function! vista#init#Api() abort
  let g:vista = {}
  let g:vista.tmps = []

  " =========================================
  " Api for manipulating the vista buffer.
  " =========================================
  function! g:vista.winnr() abort
    return bufwinnr('__vista__')
  endfunction
