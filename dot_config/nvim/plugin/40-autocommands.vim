" Toggle numbers in split
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,WinEnter * if &nu  | setlocal rnu   | endif
  autocmd BufLeave,FocusLost,WinLeave   * if &nu  | setlocal nornu | endif
augroup END

" Remove numbers and signcolumn in terminal buffers
autocmd TermOpen * startinsert | setlocal nonu nornu signcolumn=no

" Force formatoptions
" :help 'formatoptions' for more information
au OptionSet * setlocal formatoptions=cqnbj

" Disable syntax highlight on large files
augroup DisableSyn
  autocmd!
  autocmd BufEnter * if getfsize(@%) > 100000 | setlocal syntax=OFF | endif
augroup END

" using osc52
augroup Yank
  autocmd!
  autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' && !exists('b:visual_multi')
        \| call luaeval('vim.highlight.on_yank()')
        \| OSCYankReg "
        \| endif
augroup END

" From undo.vim
if has('persistent_undo')
  " We disable the default saving of undo file as we're overwriting it
  " NOTE: moved to settings.lua
  " set noundofile
  " Short-circuit undo read/write as noted in `:help wundo`
  augroup vim_undodir_tree
    autocmd!
    autocmd BufRead,BufEnter */tmp/*,COMMIT_EDITMSG,MERGE_MSG let b:skip_undofile = 1
    autocmd BufWritePost * call undo#write()
    autocmd BufReadPost * call undo#read()
  augroup END
endif

" From utils.vim
autocmd BufWritePre * call utils#mkdir()

autocmd BufEnter *.txt call utils#helpvsplit()

augroup windows
  autocmd!
  autocmd FileType * call utils#handle_win()
augroup END

augroup colorcolumn
  autocmd!
  autocmd OptionSet textwidth call utils#setccol()
  autocmd BufEnter * call utils#setccol()
augroup end
