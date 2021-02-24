call plug#begin()

" Neovim's inbuilt lsp plugin config
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'

" Code snippets 
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Starts nerdtree on toggle
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }

" Comments stuff out
Plug 'preservim/nerdcommenter'

" Fuzzy finder
Plug 'ctrlpvim/ctrlp.vim'

" Start screen for vim
Plug 'mhinz/vim-startify'

" Vim fancy status bar
Plug 'vim-airline/vim-airline'

" Dracula theme
Plug 'dracula/vim', {'as': 'dracula'}

" Git integration
Plug 'tpope/vim-fugitive'

" Auto pair
Plug 'tmsvg/pear-tree'

" Rainbow paranthesis
Plug 'luochen1990/rainbow'

" Loads of language syntax highlighting
Plug 'sheerun/vim-polyglot'

" Removes annoying search highlighting
Plug 'romainl/vim-cool'

" To profile startup
Plug 'dstein64/vim-startuptime'

call plug#end()

"
" Color scheme
"
colorscheme dracula
hi Normal guibg=NONE ctermbg=NONE
" Automatically display all buffers when one tab is open
let g:airline#extensions#tabline#enabled = 1
" Just airline theme bcz the full theme didn't look good imo
let g:airline_theme='dracula'
let g:airline_powerline_fonts = 1
" Enable rainbow
let g:rainbow_active = 1

" WSL only settings
if $WSLENV != "" 
    set background=dark
endif

" Unix line endings
set fileformats=unix

" Tabbing the right way
set tabstop=4
set shiftwidth=4
set expandtab
inoremap <S-Tab> <C-d>

" Remap comment toggle
if has('win32')
    nmap <C-_> <Plug>NERDCommenterToggle
    vmap <C-_> <Plug>NERDCommenterToggle<CR>gv
    imap <C-_> <esc><Plug>NERDCommenterToggle gi
else
    nmap <C-_> <Plug>NERDCommenterToggle
    vmap <C-_> <Plug>NERDCommenterToggle<CR>gv
    imap <C-_> <esc><Plug>NERDCommenterToggle gi
endif

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1"

" removes annoying paren highlighting
let g:loaded_matchparen=1

" ctrl p ignore
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

" sync open file with NERDTree
" " Check if NERDTree is open or active
function! IsNERDTreeOpen()        
    return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Toggle NERDTree hotkey
nnoremap <C-n> :NERDTreeToggle<CR>

" Auto quits nerd tree on file open
let NERDTreeQuitOnOpen=1
" Shows hidden files 
let g:NERDTreeShowHidden=1

" Automatically display all buffers when one tab is open
let g:airline#extensions#tabline#enabled = 1

" Just airline theme bcz the full theme didn't look good imo
let g:airline_theme='dracula'
let g:airline_powerline_fonts = 1
" Enable rainbow
let g:rainbow_active = 1

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_matching_smart_case = 1
let g:completion_trigger_on_delete = 1
let g:UltiSnipsExpandTrigger="<tab>"

:lua << EOF
    local nvim_lsp = require('lspconfig')
    local on_attach = function(client, bufnr)
        require('completion').on_attach()
    end

    -- Use a loop to conveniently both setup defined servers
    -- and map buffer local keybindings when the language server attaches
    local servers = { "pyls" }
    for _, lsp in ipairs(servers) do
      nvim_lsp[lsp].setup { on_attach = on_attach }
    end
EOF
