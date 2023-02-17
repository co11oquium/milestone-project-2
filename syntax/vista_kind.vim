" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

if exists('b:current_syntax') && b:current_syntax ==# 'vista_kind'
  finish
endif

let s:icons = join(values(g:vista#renderer#icons), '\|')
execute 'syntax match VistaIcon' '/'.s:icons.'/' 'contained'

syntax match VistaBracket /\(\[\|\]\)/ contained
syntax match VistaChildrenNr /\[\d*\]$/ contains=VistaBracket

let s:prefixes = filter(
      \ map(copy(g:vista_icon_indent), 'vista#util#Trim(v:val)'),
      \ '!empty(v:val)')
let s:pattern = join(s:prefixes, '\|')
execute 'syntax match VistaPrefix' '/\('.s:pattern.'\)/' 'contained'

syntax match VistaScope /^\S.*$/ contains=VistaPrefix,VistaChildrenNr,VistaIcon
syntax match VistaColon /:/ contained
syntax match VistaL