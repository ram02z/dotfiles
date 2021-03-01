set nocompatible
filetype plugin indent on

call plug#begin()

" Neovim's (not yet) inbuilt lsp plugin config
Plug 'neovim/nvim-lspconfig'

" Completion support
Plug 'hrsh7th/nvim-compe'

" Code snippets 
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

" File manager 
Plug 'mcchrish/nnn.vim'

" Search tool (using ripgrep)
Plug 'mileszs/ack.vim'

" Comments stuff out
Plug 'preservim/nerdcommenter'

" Start screen for vim
Plug 'mhinz/vim-startify'

" Vim fancy status bar
Plug 'vim-airline/vim-airline'

" Dracula theme
Plug 'dracula/vim', {'as': 'dracula'}

" Git integration
Plug 'tpope/vim-fugitive'

" Auto pair
Plug 'Raimondi/delimitMate'

" Color Highlighting !!!
Plug 'norcalli/nvim-colorizer.lua'

" Rainbow paranthesis
Plug 'luochen1990/rainbow'

" Indentation lines
Plug 'lukas-reineke/indent-blankline.nvim', {'branch': 'lua'}

" Loads of language syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'romgrk/nvim-treesitter-context'
Plug 'nvim-treesitter/nvim-treesitter-refactor'

" Removes annoying search highlighting
Plug 'romainl/vim-cool'

" To profile startup
Plug 'dstein64/vim-startuptime', {'on': 'StartupTime'}

" fish syntax (remove if treesitter gets support)
Plug 'blankname/vim-fish', {'for': 'fish'} 

call plug#end()

let mapleader = "\<Space>"

" Unix line endings
set fileformats=unix

" Use system clipboard
set clipboard+=unnamedplus

" True terminal colors
set termguicolors

" Tabbing the right way
set tabstop=4
set shiftwidth=4
set expandtab
inoremap <S-Tab> <C-d>

" Relative line number
set number
set relativenumber

" Enable hidden buffers (don't need to save when switching files
set hidden

" Run nnn as a floating window
let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }

" Runs nnn wrapper defined in fish
" let g:nnn#command = 'n'

let g:nnn#action = {
      \ '<c-t>': 'tab split',
      \ '<c-x>': 'split',
      \ '<c-v>': 'vsplit' }

if executable('rg')
    let g:ackprg = 'rg --vimgrep --smart-case'
endif

" Abbreviations for ack
cnoreabbrev rg Ack
cnoreabbrev Rg Ack
cnoreabbrev rG Ack
cnoreabbrev RG Ack

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
let g:airline#extensions#tabline#enabled = 1
" Enable rainbow
let g:rainbow_active = 1

" WSL only settings
if $WSLENV != ""
    set background=dark
    set mouse=a
endif

"
" NerdCommenter config
"

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

"
" Misc
"

" removes annoying paren highlighting
let g:loaded_matchparen=1

" buffer manipulation using leader + key 
"  \b \f \g \d : go back/forward/last-used
nnoremap <Leader>l :ls<CR>
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>
nnoremap <Leader>g :e#<CR>
nnoremap <Leader>d :bd<CR>


" Snippet binds
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm({ 'keys': "\<Plug>delimitMateCR", 'mode': '' })
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Blankline plugin settings
let g:indent_blankline_use_treesitter = v:true
let g:indent_blankline_show_first_indent_level = v:false

" Source lua init file
lua require('init')
