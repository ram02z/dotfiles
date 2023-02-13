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
  autocmd BufNew,FileType * call utils#handle_win()
augroup END

augroup colorcolumn
  autocmd!
  autocmd BufEnter * call utils#setccol()
  autocmd OptionSet textwidth call utils#setccol()
augroup END
