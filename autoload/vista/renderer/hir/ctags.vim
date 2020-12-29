" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

scriptencoding utf-8

let s:scope_icon = ['⊕', '⊖']

let s:visibility_icon = {
      \ 'public': '+',
      \ 'protected': '~',
      \ 'private': '-',
      \ }

let g:vista#renderer#default#vlnum_offset = 3

let s:indent_size = g:vista#renderer#enable_icon ? 2 : 4

" Return the rendered row to be displayed given the depth
function! s:Assemble(line, depth) abort
  let line = a:line

  let kind = get(line, 'kind', '')
  let kind_icon = vista#renderer#IconFor(kind)
  let kind_icon = empty(kind_icon) ? '' : kind_icon.' '
  let kind_text = vista#renderer#KindFor(kind)
  let kind_text = empty(kind_text) ? '' : ' '.kind_text

  let row = vista#util#Join(
        \ repeat(' ', a:depth * s:indent_size),
        \ s:GetVisibility(line),
        \ kind_icon,
        \ get(line, 'name'),
        \ get(line, 'signature