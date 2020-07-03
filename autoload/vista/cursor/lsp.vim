" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

function! s:GetInfoFromLSPAndExtension() abort
  let raw_cur_line = getline('.')

  " TODO use range info of LSP symbols?
  if g:vista.provider ==# 'coc'
    if !has_key(g:vista, 'vlnum2tagname')
      return v:null
    endif
    if has_key(g:vista.vlnum2tagname, line('.'))
      return g:vista.vlnum2tagname[line('.')]
    else
      let items = split(raw_cur_line)
      if g:vista#renderer#enable_icon
        return join(items[1:-2], ' ')
      else
        return join(items[:-2], ' ')
      endif
    endif
  elseif g:vista.provider ==# 'nvim_lsp'
    return substitute(raw_cur_line, '\v.*\s(.*):.*', '\1', '')
  elseif g