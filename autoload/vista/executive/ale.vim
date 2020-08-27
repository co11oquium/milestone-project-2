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
    let [s:reload_only, s:should_display] = vista#renderer#LSPProcess(s:data, s:reload_only, s:should_display)

    " Update cache when new data comes.
    let s:cache = get(s:, 'cache', {})
    let s:cache[s:fpath] = s:data
    let s:cache.ftime = getftime(s:fpath)
    let s:cache.bufnr = bufnr('')
  endif

  call vista#cursor#TryInitialRun()
endfunction

function! s:AutoUpdate(fpath) abort
  let s:reload_only = v:true
  let s:fpath = a:fpath
  call s:RunAsync()
endfunction

function! s:Run() abort
  let s:fetching = v:false
  call s:RunAsync()
  while s:fetching
    sleep 100m
  endwhile
  return get(s:, 'data', {})
endfunction

function! s:RunAsync() abort
  let linters = map(filter(ale#linter#Get(&filetype), '!empty(v:val.lsp)'), 'v:val.name')
  if empty(linters)
    return
  endif

  let method = 'textDocument/documentSymbol'
  let bufnr = g:vista.source.bufnr
  let params = {
    \   'textD