" TODO: integrate undofile_warn

" Returns the full path where to save the undo file
" This will replace any "%" in the original filepath with "/" to create
" a proper tree
function! s:GetUndoFile(filepath)
  let undofile = undofile(a:filepath)
  let undofile = substitute(undofile, '%', '/', 'g')
  let undofile = substitute(undofile, '//', '/', 'g')
  return undofile
endfunction

" Saves the undo file
function! undo#write()
  set noundofile
  if exists('b:skip_undofile')
    return
  endif
  let undofile = s:GetUndoFile(expand('%:p'))
  let undodir = fnamemodify(undofile, ":h")
  if !isdirectory(undodir)
    call mkdir(undodir, "p")
  endif

  execute 'wundo ' . fnameescape(undofile)
endfunction

" Read the undo file
function undo#read()
  if exists('b:skip_undofile')
    return
  endif
  let undofile = s:GetUndoFile(expand('%:p'))
  if filereadable(undofile)
    silent! execute 'rundo ' . fnameescape(undofile)
  endif
endfunction
