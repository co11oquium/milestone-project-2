" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

function! s:GetAvaliableExecutives() abort
  let avaliable = []

  if exists('*ale#lsp_linter#SendRequest')
    call add(avaliable, 'ale')
  endif

  if exists('*CocAction')
    call add(avaliable, 'coc')
  endif

  if executable('ctags')
    call add(avaliable, 'ctags')
  endif

  if exists('*LanguageClient#textDocument_documentSymbol')
    call add(avaliable, 'lcn')
  endif

  if exists('*lsc#server#userCall')
    call add(avaliable, 'vim_lsc')
  endif

  if exists('*lsp#get_whitelisted_servers')
    call add(avaliable, 'vim_lsp')
  