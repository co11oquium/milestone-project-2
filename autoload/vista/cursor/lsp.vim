" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

function! s:GetInfoFromLSPAndExtension() abort
  let raw_cur_line = getline('.')

  " TODO use range info of LSP symbols?
  if g:vista.provider ==# 'co