" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et
"
" Render the content by the kind of tag.
scriptencoding utf8

let s:viewer = {}

function! s:viewer.init(data) abort
  let self.rows = []
  let self.data = a:data

  let self.prefixes = g:vista_icon_indent

  " TODO improve me!
  let up_gap = strwidth(self.prefixes[0])
  " By default the gap is half of the second prefix.
  " at least one
  if up_gap >= 2 && up_gap < 4
    let self.gap = up_gap
  elseif up_gap >= 4
    let self.gap = up_gap / 2
  else
    let self.gap = up_gap + strwidth(self.prefi