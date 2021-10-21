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
autocmd! BufEnter * setlocal formatoptions=tcqnbj

" Void linux templates
autocmd! BufRead,BufNewFile srcpkgs/*/template set ft=sh

" using osc52
augroup Yank
  autocmd!
  autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' && !exists('b:visual_multi')
        \| call luaeval('vim.highlight.on_yank()')
        \| execute 'OSCYankReg "'
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
  autocmd BufNew * call utils#handle_win()
  autocmd FileType * call utils#handle_win()
augroup END

augroup colorcolumn
  autocmd!
  autocmd BufEnter * call utils#setccol()
  autocmd OptionSet textwidth call utils#setccol()
augroup END

augroup diagnostics
  au!
  autocmd VimEnter * lua require"modules.diagnostic"
  autocmd CursorHold,CursorHoldI * lua require"modules.diagnostic".update_hover_diagnostics()
  autocmd User DiagnosticsChanged lua require"modules.diagnostic".update_hover_diagnostics()
augroup END

