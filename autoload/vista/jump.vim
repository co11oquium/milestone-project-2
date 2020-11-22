" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

function! s:EscapeForVimRegexp(str) abort
  return escape(a:str, '^$.*?/\[]')
endfunction

" Jump to the source line containing the given tag
function! vista#jump#TagLine(tag) abort
  let cur_line = split(getline('.'), ':')

  " Skip if the current line or the target line is empty
  if empty(cur_line)
    return
  endif

