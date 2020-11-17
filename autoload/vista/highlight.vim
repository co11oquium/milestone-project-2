" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

" Highlight the line given the line number and ensure it's visible if required.
"
" lnum - current line number in vista window
" ensure_visible - kepp this line visible
" optional: tag - accurate tag
function! vista#highlight#Add(lnum, ensure_visible, tag) abort
  if exists('w:vista_highlight_id')
    try
      call matchdelete(w:vista_highlight_id)
    catch /E803/
      " ignore E803 error: ID not found
    endtry
    unlet w:vista_highlight_id
  endif

  if get(g:, 'vista_highlight_whole_line', 0)
    let hi_pos = a:lnum
  else
    let cur_line = getline(a:lnum)
    " Current line may contains +,-,~, use `\S` is incorr