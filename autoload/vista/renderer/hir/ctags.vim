" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

scriptencoding utf-8

let s:scope_icon = ['⊕', '⊖']

let s:visibility_icon = {
      \ 'public': '+',
      \ 'protected': '~',
      \ 'private': '-',
      \ }

let g:vista#renderer#default#vlnum_offset = 3

let s:indent_size = g:vista#renderer#enable_icon ? 2 : 4

" Return the rendered row to be displayed given the depth
function! s:Assemble(line, depth) abort
  let line = a:line

  let kind = get(line, 'kind', '')
  let kind_icon = vista#renderer#IconFor(kind)
  let kind_icon = empty(kind_icon) ? '' : kind_icon.' '
  let kind_text = vista#renderer#KindFor(kind)
  let kind_text = empty(kind_text) ? '' : ' '.kind_text

  let row = vista#util#Join(
        \ repeat(' ', a:depth * s:indent_size),
        \ s:GetVisibility(line),
        \ kind_icon,
        \ get(line, 'name'),
        \ get(line, 'signature', ''),
        \ kind_text,
        \ ':'.get(line, 'line', '')
        \ )

  return row
endfunction

" Actually append to the rows
function! s:Append(line, rows, depth) abort
  let line = a:line
  let rows = a:rows

  let row = s:Assemble(line, a:depth)

  call add(rows, row)
  call add(s:vlnum_cache, line)
endfunction

function! s:ApplyAppend(line, row, rows) abort
  let line = a:line
  let rows = a:rows

  call add(rows, a:row)
  call add(s:vlnum_cache, line)
endfunction

" Return the next root name and line after appending to the rows.
function! s:AppendChild(line, rows, depth) abort
  if has_key(a:line, 'scope')
    call s:Append(a:line, a:rows, a:depth)
    let parent_name = a:line.scope
    let next_root_name = parent_name . s:scope_seperator . a:line.name
    return [next_root_name, a:line]
  endif

  return [v:null, v:null]
endfunction

function! s:Compare(s1, s2) abort
  return a:s1.line - a:s2.line
endfunction

" This way is more of heuristic.
"
" the line of child should larger than parent's, which partially fixes this issue comment:
" https://github.com/universal-ctags/ctags/issues/2065#issuecomment-485117935
"
" The previous nearest one should be the exact one.
function! s:RealParentOf(candidate) abort
  let candidate = a:candidate

  let name = candidate.scope
  let kind = candidate.scopeKind

  let parent_candidates = []
  for pc in g:vista.without_scope
    if pc.name ==# name && pc.kind ==# kind && pc.line <= candidate.line
      call add(parent_candidates, pc)
    endif
  endfor

  if !empty(parent_candidates)
    call sort(parent_candidates, function('s:Compare'))
    return parent_candidates[-1]
  endif

  return {}
endfunction

" Previously we use the regexp to see if the scope of candidate is matched:
"
" \ ' && v:val.scope =~# ''^''.l:scope'.
"
" but it runs into the error like NFA E869 '\@ ' in some cases, so we use this
" now. Ref #161
function! s:StartWith(candidate_scope, root_scope) abort
  return a:candidate_scope[:len(a:root_scope)] == a:root_scope
endfunction

" Find all descendants of the root
function! s:DescendantsOf(candidates, root_line, scope) abort
  let candidates = filter(copy(a:candidates),
        \ 'has_key(v:val, ''scope'')'.
        \ ' && s:StartWith(v:val.scope, a:scope)'.
        \ ' && v:val.scopeKind ==# a:root_line.kind'.
        \ ' && v:val.line >= a:root_line.line'
        \ )

  return candidates
  " The real parent problem seemingly has been solved?
  " return filter(candidates, 's:RealParentOf(v:val) ==# a:root_line')
endfunction

function! s:DescendantsOfRoot(candidates, root_line) abort
  let candidates = filter(copy(a:candidates),
        \ 'has_key(v:val, ''scope'')'.
        \ ' && s:StartWith(v:val.scope, a:root_line.name)'.
        \ ' && v:val.scopeKind ==# a:root_line.kind'.
        \ ' && v:val.line >= a:root_line.line'
        \ )

  return filter(candidates, 's:RealParentOf(v:val) ==# a:root_line')
endfunction

function! s:RenderDescendants(parent_name, parent_line, descendants, rows, depth) abort
  let depth = a:depth
  let rows = a:rows

  " Clear the previous duplicate parent line that is about to be added.
  "
  " T