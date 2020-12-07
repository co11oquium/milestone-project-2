" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:last_lnum = -1
let s:popup_timer = -1
let s:popup_delay = get(g:, 'vista_floating_delay', 100)

function! s:ClosePopup() abort
  if exists('s:popup_winid')
    call popup_close(s:popup_winid)
    unlet s:popup_winid
    autocmd! VistaPopup
  endif
  let g:vista.popup_visible = v:false
endfunction

call prop_type_delete('VistaMatch')
call prop_type_add('VistaMatch', { 'highlight': 'Search