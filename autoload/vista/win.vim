" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:has_floating_win = exists('*nvim_open_win')
let s:has_popup = exists('*popup_create')

function! vista#win#CloseFloating() abort
  if s:has_floating_win
    call vista#floating#Close()
  elseif s:has_popup
    call vista#popup#Close()
  endif
endfunction

function! vista#win#FloatingDispl