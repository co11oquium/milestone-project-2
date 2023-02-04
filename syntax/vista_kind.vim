" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

if exists('b:current_syntax') && b:current_syntax ==# 'vista_kind'
  finish
endif

let s:icons = join(values(g:vista#renderer#icons), '\|')
execute 'syntax match VistaIcon' '/'.s:icons.'/' 'contained'

