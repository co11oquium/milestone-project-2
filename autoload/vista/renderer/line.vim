" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:scope_icon = ['⊕', '⊖']

let s:visibility_icon = {
      \ 'public': '+',
      \ 'protected': '#',
      \ 'private': '-',
      \ }

function! s:RenderLinewise() abort
  let rows = []

  " FIXME the same kind tags could be in serveral sections
  let idx = 0
  let raw_len = len(g:vista.raw)

  while idx < raw_len
    let line = g:vista.raw[idx]

    if has_key(line, 'access')
      let access = get(s:visibility_icon, line.access, '?')
    else
      let access