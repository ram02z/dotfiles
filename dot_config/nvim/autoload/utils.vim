" Local functions

" start help page in left vsplit
" Helper function for helpvsplit
" from https://vi.stackexchange.com/a/8927
function! s:BufferWidth() abort
  let view = winsaveview()
  let max_col = 0
  g/^/let max_col=max([max_col, col('$') - 1])
  call histdel('search', -1)
  let @/ = histget('search', -1)
  call winrestview(view)
  return max_col
endfunction


" Creates a directory if it doesn't exist
function! utils#mkdir()
  let dir = expand('%:p:h')

  if dir =~ '://'
    return
  endif

  if !isdirectory(dir)
    call mkdir(dir, 'p')
    echo 'Created non-existing directory: '.dir
  endif
endfunction

" Sets help window to left vsplit and resizes to max
" Doesn't do anything if buffer width is too large
function! utils#helpvsplit()
  if &buftype == 'help'
    let l:bufwidth = s:BufferWidth()
    if &columns > l:bufwidth*2
      wincmd H
      exec 'vertical resize '. string(l:bufwidth)
    endif
  endif
endfunction

" Used to set darked winhighlight for specific filetypes
function! utils#handle_win()
  let l:sidebar = ['undotree', 'Outline', 'qf']
  if index(l:sidebar, &filetype) >= 0
    setlocal winhighlight=Normal:TabLineFill
  endif
endfunction

function! utils#setccol()
  if &textwidth != 0
    let &l:colorcolumn=&l:textwidth+1
  else
    setlocal colorcolumn=999999
  endif
endfunction
