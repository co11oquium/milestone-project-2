" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:provider = fnamemodify(expand('<sfile>'), ':t:r')

let s:reload_only = v:false
let s:should_display = v:false

let s:fetching = v:true

function! s:HandleLSPResponse(output) abort
  let s:fetching = v:false
  if !has_key(a:output, 'result')
    call vista#error#Notify('No result via LanguageClient#textDocument_documentSymbol()')
    return
  endif

  let s:data = vista#renderer#LSPPreprocess(a:output.result)
  let [s:reload_only, s:should_display] = vista#renderer#LSPProcess(s:data, s:reload_only, s:should_display)

  " Update cache when new data comes.
  let s:cache = get(s:, 'cache', {})
  let s:cache[s:fpath] = s:data
  let s:cache.ftime = ge