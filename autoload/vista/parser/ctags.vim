
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

function! s:LoadData(container, line) abort
  let line = a:line

  let kind = line.kind

  call vista#util#TryAdd(g:vista.raw_by_kind, kind, line)

  call add(g:vista.raw, line)

  if has_key(line, 'scope')
    call add(g:vista.with_scope, line)
  else
    call add(g:vista.without_scope, line)
  endif

  let picked = {'lnum': line.line, 'text': get(line, 'name', '') }

  if kind =~# '^f' || kind =~# '^m'
    if has_key(line, 'signature')
      let picked.signature = line.signature
    endif
    call add(g:vista.functions, picked)
  endif

  if index(g:vista.kinds, kind) == -1
    call add(g:vista.kinds, kind)
  endif

  call vista#util#TryAdd(a:container, kind, picked)
endfunction

" Parse the output from ctags linewise and feed them into the container
" The parsed result should be compatible with the LSP output.
"
" Currently we only use these fields:
"
" {
"   'lnum': 12,
"   'col': 8,
"   'kind': 'Function',
"   'text': 'testnet_genesis',
" }

function! s:ShortToLong(short) abort
  let ft = getbufvar(g:vista.source.bufnr, '&filetype')

  try

    let types = g:vista#types#uctags#{ft}#
    if has_key(types.kinds, a:short)
      return types.kinds[a:short]['long']
    endif

  catch /^Vim\%((\a\+)\)\=:E121/
  endtry

  return a:short
endfunction

function! s:ParseTagfield(tagfields) abort
  let fields = {}

  if stridx(a:tagfields[0], ':') > -1
    let colon = stridx(a:tagfields[0], ':')
    let value = a:tagfields[0][colon+1:]
    let fields.kind = value
  else
    let kind = s:ShortToLong(a:tagfields[0])
    let fields.kind = kind
    if index(g:vista.kinds, kind) == -1
      call add(g:vista.kinds, kind)
    endif
  endif

  if len(a:tagfields) > 1
    for tagfield in a:tagfields[1:]
      let colon = stridx(tagfield, ':')
      let name = tagfield[0:colon-1]
      let value = tagfield[colon+1:]
      let fields[name] = value
    endfor
  endif

  return fields
endfunction

" {tagname}<Tab>{tagfile}<Tab>{tagaddress}[;"<Tab>{tagfield}..]
" {tagname}<Tab>{tagfile}<Tab>{tagaddress};"<Tab>{kind}<Tab>{scope}
" ['vista#executive#ctags#Execute', '/Users/xlc/.vim/plugged/vista.vim/autoload/vista/executive/ctags.vim', '84;"', 'function']
function! vista#parser#ctags#FromExtendedRaw(line, container) abort