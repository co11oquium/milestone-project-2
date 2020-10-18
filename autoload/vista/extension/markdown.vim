" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:provider = fnamemodify(expand('<sfile>'), ':t:r')

function! s:IsHeader(cur_line, next_line) abort
  return a:cur_line =~# '^#\+' ||
        \ a:cur_line =~# '^\S' && (a:next_line =~# '^=\+\s*$' || a:next_line =~# '^-\+\s*$')
endfunction

function! s:GatherHeaderMetadata() abort
  let is_fenced_block = 0

  let s:lnum2tag = {}

  let headers = []

  let idx = 0
  let lines = g:vista.source.lines()

  for line in lines
    let line = substitute(line, '#', "\\\#", 'g')
    let next_line = get(lines, idx + 1, '')

    if l:line =~# '````*' || l:line =~# '\~\~\~\~*'
      let is_fenced_block = !is_fenced_block
    endif
