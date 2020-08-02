" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

scriptencoding utf8

function! s:EchoScope(scope) abort
  if g:vista#renderer#enable_icon
    echohl Function | echo ' '.a:scope.': ' | echohl NONE
  else
    echohl Function  | echo '['.a:scope.'] '  | echohl NONE
  endif
endfunction

function! s:TryParseAndEchoScope() abort
  let linenr = vista#util#LowerIndentLineNr()

  " Echo the scope of current tag if found
  if linenr != 0
    let scope = matchstr(getline(linenr), '\a\+$')
    if !empty(scope)
      call s:EchoScope(scope)
    else
      " For the kind renderer
      let pieces = split(getline(linenr), ' ')
      if !empty(pieces)
        let scope = pieces[1]
        call s:EchoScope(scope)
      endif
    endif
  endif
endfunction

function! vista#echo#EchoScopeInCmdlineIsOk() abort
  let cur_line = getline('.')
  if cur_line[-1:] ==# ']'
    let splitted = split(cur_line)
    " Join the scope parts i