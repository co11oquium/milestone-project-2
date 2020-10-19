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

    let is_header = s:IsHeader(l:line, l:next_line)

    if is_header && !is_fenced_block
        let matched = matchlist(l:line, '\(\#*\)\(.*\)')
        let text = vista#util#Trim(matched[2])
        let s:lnum2tag[len(headers)] = text
        call add(headers, {'lnum': idx+1, 'text': text, 'level': strlen(matched[1])})
    endif

    let idx += 1
  endfor

  return headers
endfunction

" Use s:lnum2tag so that we don't have to extract the header fro