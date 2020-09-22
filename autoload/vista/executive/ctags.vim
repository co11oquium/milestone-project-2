
" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:provider = fnamemodify(expand('<sfile>'), ':t:r')

let s:reload_only = v:false
let s:should_display = v:false

let s:ctags = get(g:, 'vista_ctags_executable', 'ctags')
let s:support_json_format =
      \ len(filter(systemlist(s:ctags.' --list-features'), 'v:val =~# ''^json''')) > 0

" Expose this variable for debugging
let g:vista#executive#ctags#support_json_format = s:support_json_format

let s:ctags_project_opts = get(g:, 'vista_ctags_project_opts', '')

if s:support_json_format
  let s:default_cmd_fmt = '%s %s %s --output-format=json --fields=-PF -f- %s'
  let s:DefaultTagParser = function('vista#parser#ctags#FromJSON')
else
  let s:default_cmd_fmt = '%s %s %s -f- %s'
  let s:DefaultTagParser = function('vista#parser#ctags#FromExtendedRaw')
endif

let s:is_mac = has('macunix')
let s:is_linux = has('unix') && !has('macunix') && !has('win32unix')
let s:can_async = has('patch-8.0.0027')

function! s:GetCustomCmd(filetype) abort
  if exists('g:vista_ctags_cmd')
        \ && has_key(g:vista_ctags_cmd, a:filetype)
    return g:vista_ctags_cmd[a:filetype]
  endif
  return v:null
endfunction

function! s:GetDefaultCmd(file) abort
  " Refer to tagbar
  let common_opt = '--format=2 --excmd=pattern --fields=+nksSaf --extras=+F --sort=no --append=no'

  " Do not pass --extras for C/CPP in order to let uctags handle the tags for anonymous
  " entities correctly.
  if g:vista.source.filetype() !=# 'c' && g:vista.source.filetype() !=# 'cpp'
    let common_opt .= ' --extras= '
  endif

  let language_specific_opt = s:GetLanguageSpecificOptition(&filetype)
  let cmd = printf(s:default_cmd_fmt, s:ctags, common_opt, language_specific_opt, a:file)

  return cmd
endfunction

function! s:GetLanguageSpecificOptition(filetype) abort
  let opt = ''

  try
    let types = g:vista#types#uctags#{a:filetype}#
    let lang = types.lang
    let kinds = join(keys(types.kinds), '')
    let opt = printf('--language-force=%s --%s-kinds=%s', lang, lang, kinds)
  " Ignore Vim(let):E121: Undefined variable
  catch /^Vim\%((\a\+)\)\=:E121/
  endtry

  return opt
endfunction

function! s:NoteTemp() abort
  if exists('s:tmp_file')
    call add(g:vista.tmps, s:tmp_file)
    unlet s:tmp_file
  endif
endfunction

" FIXME support all languages that ctags does
function! s:BuildCmd(origin_fpath) abort
  let s:tmp_file = s:IntoTemp(a:origin_fpath)
  if empty(s:tmp_file)
    return ''
  endif

  call vista#Debug('executive::ctags::s:BuildCmd origin_fpath:'.a:origin_fpath)
  let s:fpath = a:origin_fpath

  let custom_cmd = s:GetCustomCmd(&filetype)

  if custom_cmd isnot v:null
    let cmd = printf('%s %s', custom_cmd, s:tmp_file)
    if stridx(custom_cmd, '--output-format=json') > -1
      let s:TagParser = function('vista#parser#ctags#FromJSON')
    else
      let s:TagParser = function('vista#parser#ctags#FromExtendedRaw')
    endif
  else
    let cmd = s:GetDefaultCmd(s:tmp_file)
    let s:TagParser = s:DefaultTagParser
  endif

  let g:vista.ctags_cmd = cmd

  return cmd
endfunction

function! s:PrepareContainer() abort
  let s:data = {}
  let g:vista = get(g:, 'vista', {})
  let g:vista.functions = []
  let g:vista.raw = []
  let g:vista.kinds = []
  let g:vista.raw_by_kind = {}
  let g:vista.with_scope = []
  let g:vista.without_scope = []
  let g:vista.tree = {}
endfunction

" Process the preprocessed output by ctags and remove s:jodid.
function! s:ApplyExtracted() abort
  " Update cache when new data comes.
  let s:cache = get(s:, 'cache', {})
  let s:cache[s:fpath] = s:data
  let s:cache.ftime = getftime(s:fpath)
  let s:cache.bufnr = bufnr('')

  call vista#Debug('executive::ctags::s:ApplyExtracted s:fpath:'.s:fpath.', s:reload_only:'.s:reload_only.', s:should_display:'.s:should_display)
  let [s:reload_only, s:should_display] = vista#renderer#LSPProcess(s:data, s:reload_only, s:should_display)

  if exists('s:jodid')
    unlet s:jodid
  endif

  call s:NoteTemp()
  call vista#cursor#TryInitialRun()
endfunction

function! s:ExtractLinewise(raw_data) abort
  call s:PrepareContainer()
  call map(a:raw_data, 's:TagParser(v:val, s:data)')
endfunction

function! s:AutoUpdate(fpath) abort
  call vista#Debug('executive::ctags::s:AutoUpdate '.a:fpath)
  if g:vista.source.filetype() ==# 'markdown'
        \ && get(g:, 'vista_enable'.&filetype.'_extension', 1)
    call vista#extension#{&ft}#AutoUpdate(a:fpath)
  else
    call vista#OnExecute(s:provider, function('s:AutoUpdate'))
    let s:reload_only = v:true
    call vista#Debug('executive::ctags::s:AutoUpdate calling s:ApplyExecute '.a:fpath)
    call s:ApplyExecute(v:false, a:fpath)
  endif
endfunction

function! vista#executive#ctags#AutoUpdate(fpath) abort
  call vista#OnExecute(s:provider, function('s:AutoUpdate'))
  call s:AutoUpdate(a:fpath)
endfunction

" Run ctags synchronously given the cmd
function! s:ApplyRun(cmd) abort
  call vista#Debug('executive::ctags::s:ApplyRun:'.a:cmd)
  let output = system(a:cmd)
  if v:shell_error
    return vista#error#('Fail to run ctags: '.a:cmd)
  endif

  let s:cache = get(s:, 'cache', {})
  let s:cache.fpath = s:fpath

  call s:ExtractLinewise(split(output, "\n"))
endfunction

if has('nvim')
  function! s:on_exit(_job, _data, _event) abort dict
    if !exists('g:vista') || v:dying || !has_key(self, 'stdout')
      return
    endif

    if self.stdout == ['']
      return
    endif

    call vista#Debug('ctags::s:on_exit '.string(self.stdout))
    " Second last line is the real last one in neovim
    call s:ExtractLinewise(self.stdout[:-2])

    call s:ApplyExtracted()
  endfunction

  " Run ctags asynchronously given the cmd
  function! s:ApplyRunAsync(cmd) abort
      " job is job id in neovim
      let jobid = jobstart(a:cmd, {
              \ 'stdout_buffered': 1,
              \ 'stderr_buffered': 1,
              \ 'on_exit': function('s:on_exit')
              \ })
    return jobid > 0 ? jobid : 0
  endfunction
else

  function! s:close_cb(channel) abort
    call s:PrepareContainer()

    while ch_status(a:channel, {'part': 'out'}) ==# 'buffered'
      let line = ch_read(a:channel)
      call s:TagParser(line, s:data)
    endwhile

    call s:ApplyExtracted()
  endfunction

  if has('win32')
    function! s:WrapCmd(cmd) abort
      return &shell . ' ' . &shellcmdflag . ' ' . a:cmd
    endfunction
  else
    function! s:WrapCmd(cmd) abort
      return split(&shell) + split(&shellcmdflag) + [a:cmd]
    endfunction
  endif

  function! s:ApplyRunAsync(cmd) abort
    let job = job_start(s:WrapCmd(a:cmd), {
          \ 'close_cb':function('s:close_cb')
          \ })
    let jobid = matchstr(job, '\d\+') + 0
    return jobid > 0 ? jobid : 0
  endfunction
endif

function! s:TryAppendExtension(tempname) abort
  let ext = g:vista.source.extension()
  if !empty(ext)
    return join([a:tempname, ext], '.')
  else
    return a:tempname
  endif
endfunction

function! s:BuiltinTempname() abort
  let tempname = tempname()
  return s:TryAppendExtension(tempname)
endfunction

function! s:TempnameBasedOnSourceBufname() abort
  let tempname = sha256(fnamemodify(bufname(g:vista.source.bufnr), ':p'))
  return s:TryAppendExtension(tempname)
endfunction

function! s:FromTMPDIR() abort
  let tmpdir = $TMPDIR
  if empty(tmpdir)
    let tmpdir = '/tmp/'
  elseif tmpdir !~# '/$'
    let tmpdir .= '/'
  endif