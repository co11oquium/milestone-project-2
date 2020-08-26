" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:provider = fnamemodify(expand('<sfile>'), ':t:r')

let s:reload_only = v:false
let s:should_display = v:false

function! s:HandleLSPResponse(resp) abort
  let s:fetching = v:false
  if type(a:resp) != v:t_dict
        \ || has_key(a:resp, 'error')
        \ || !has_key(a:resp, 'result')
        \ || empty(get(a:resp, 'result', {}))
    return
  endif

  let s:data = vista#renderer#LSPPreprocess(a:resp.result)

  if !empty(s:data)
    let [s:reload_only, s:should_d