let g:python3_host_prog = '~/.pyenv/shims/python'
call plug#begin()
""Display
Plug 'sickill/vim-monokai'
Plug 'Yggdroot/indentLine'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'flazz/vim-colorschemes'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'knubie/vim-kitty-navigator'
Plug 'plasticboy/vim-markdown'
Plug 'valloric/matchtagalways'
Plug 'myusuf3/numbers.vim'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1
Plug 'danilamihailov/beacon.nvim'

""Git
Plug 'tpope/vim-fugitive'
set diffopt+=vertical
Plug 'tpope/vim-rhubarb'
Plug 'prakashdanish/vim-githubinator'
Plug 'christoomey/vim-conflicted'

""Editing
Plug 'terryma/vim-multiple-cursors'
Plug 'jiangmiao/auto-pairs'
Plug 'kburdett/vim-nuuid'
Plug 'haya14busa/incsearch.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-speeddating'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = [
  \'coc-css',
  \'coc-cssmodules',
  \'coc-eslint',
  \'coc-explorer',
  \'coc-flow',
  \'coc-fzf-preview',
  \'coc-git',
  \'coc-json',
  \'coc-lists',
  \'coc-marketplace',
  \'coc-prettier',
  \'coc-python',
  \'coc-snippets',
  \'coc-tsserver',
  \'coc-yank',
  \]
Plug 'tpope/vim-commentary'
Plug 'junegunn/vim-slash'
Plug 'machakann/vim-highlightedyank'
Plug 'svermeulen/vim-cutlass'
Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger = '<c-j>'
let g:UltiSnipsSnippetDirectories = ['~/.config/nvim/UltiSnips', 'UltiSnips']
Plug 'honza/vim-snippets'
Plug 'tpope/vim-repeat'
Plug 'godlygeek/tabular'
Plug 'terryma/vim-expand-region'
Plug 'wellle/visual-split.vim'
Plug 'farmergreg/vim-lastplace'
Plug 'pechorin/any-jump.vim'
Plug 'tpope/vim-sleuth'
Plug 'cometsong/CommentFrame.vim'
let g:CommentFrame_SkipDefaultMappings = 1

""Browsing
" Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
" let g:NERDTreeWinSize=40
" Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'liuchengxu/vista.vim'
let g:vista_default_executive = 'ctags'
let g:vista_echo_cursor = 1
let g:vista_fzf_preview = ['right:50%']
let g:vista_sidebar_width = 40
" Plug 'dyng/ctrlsf.vim'
Plug 'mcchrish/nnn.vim'
Plug 'francoiscabrol/ranger.vim'

" Utils
Plug 'simnalamburt/vim-mundo'
set undofile
set undodir=~/.config/nvim/undo
Plug 'itspriddle/vim-marked'
Plug 'tpope/vim-unimpaired'
Plug 'rbgrouleff/bclose.vim'
let g:bclose_no_plugin_maps = 1
map <C-q> :Bclose<cr>
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'ludovicchabant/vim-gutentags'
call plug#end()

"Misc Settings
set shell=bash
set title
set omnifunc=syntaxcomplete#Complete
set noshowcmd
set nocompatible
syntax on
filetype plugin on
set hid
set clipboard=unnamed
set number
filetype plugin on
set updatetime=750
set tabstop=4
set linespace=2
set tags=tags
set softtabstop=4   " when hitting <BS>, pretend like a tab is removed, even if spaces
set shiftwidth=4        " use multiple shiftwidth when indenting with '<' and '>'
set expandtab     " expand tabs by default
set smartcase           " ignore case if seach pattern is all lowercase
set mouse=a
set autoindent          " always set autoindenting on
set smartindent
set nowrap              " do not wrap lines by default
set formatoptions+=or   " comment auto indentset shell=zsh\ -i
colorscheme monokai
set colorcolumn=88
highlight ColorColumn ctermbg=0 guibg=lightgrey
set relativenumber
set smarttab

" Filetype settings
" autocmd Filetype javascript setlocal ts=2 sw=2 sts=0 expandtab
au BufRead,BufNewFile *.sfn set filetype=python

" Window switching
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Terminal mode
tnoremap <C-\><C-\> <C-\><C-n>

cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" incsearch
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)


" Cutlass
nnoremap x d
xnoremap x d
nnoremap xx dd
nnoremap X D

let g:indentLine_fileType = ['python', 'javascript']
let g:indentLine_conceallevel=1

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_highlighting_cache = 1
let g:airline_theme='dark_minimal'

" Automatically remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

set wildignore+=*/bower_components/**,*/node_modules/**,*/__pycache__/**,*/.egg-info/**,*/build/**,*/.git/**

let mapleader = " "
let g:mapleader = " "

highlight Search cterm=underline


" Sidebars
nmap <Leader>b :CocCommand explorer<cr>
nmap <C-t> :Vista!!<cr>

" Resize vsplit
nmap 50 <c-w>=
" Replace text selected in visual mode
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>e

" ----------------------------------------------------------------------------
" Coc
" ----------------------------------------------------------------------------
" " Remap keys for gotos
nmap <silent> gdd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

imap <C-l> <Plug>(coc-snippets-expand)

" ----------------------------------------------------------------------------
" File/path copying
" ----------------------------------------------------------------------------
" Copy relative path to clipboard
nnoremap <silent> <Leader>c :let @+ = expand("%")<CR>
nnoremap <silent> <Leader>C :let @+ = expand("%:p")<CR>
nnoremap <silent> <Leader>cl :let @+ = expand("%") . ":" . line(".")<CR>

" ----------------------------------------------------------------------------
" Look and feel
" ----------------------------------------------------------------------------
" Dim inactive window when not in use
set winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow
au VimEnter,WinEnter,BufEnter,BufWinEnter,FocusGained * hi ActiveWindow ctermbg=234 | hi InactiveWindow ctermbg=235

" ----------------------------------------------------------------------------
" vim-fugitive / git
" ----------------------------------------------------------------------------
nmap     <Leader>g :Gstatus<cr>gg<c-n>
nnoremap <Leader>d :Gdiff<CR>
map <F2> :!git shortlog -s -n HEAD %<CR>

" ----------------------------------------------------------------------------
"  " vim-slash
"  ----------------------------------------------------------------------------
 if has('timers')
   noremap <expr> <plug>(slash-after) slash#blink(2, 50)
 endif
 "Places the current match at the center of the window.
 noremap <plug>(slash-after) zz

" ============================================================================
" Misc utils / mappings
" ============================================================================

" use jk as an alternative to Esc
inoremap jk <Esc>

" Save
nnoremap <C-s> :update<cr>
vnoremap <c-s> <c-c>:update<cr>
inoremap <c-s> <c-o>:update<cr><esc>

" ============================================================================
" Window / buffer management
" ============================================================================
nnoremap <c-\> :bnext<cr>
nnoremap <c-]> :bprev<cr>


" Zoom
function! s:zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
                  \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
  endif
endfunction
nnoremap <silent> <leader>z :call <sid>zoom()<cr>


" ============================================================================
" FZF {{{
" ============================================================================

nnoremap \ :CocCommand fzf-preview.ProjectGrep <space>
nnoremap <silent> <Leader>p :CocCommand fzf-preview.ProjectFiles <CR>
nnoremap <silent> <Leader><Enter>  :CocCommand fzf-preview.AllBuffers<CR>
nmap <silent> <Leader>t         :CocCommand fzf-preview.VistaBufferCtags<CR>
nnoremap <silent> <Leader>j     :CocCommand fzf-preview.Jumps<CR>
" nnoremap <silent> <Leader>T        :CocCommand fzf-preview.VistaCtags<CR>
nnoremap <silent> <Leader>rg       :Rg <C-R><C-W><CR>
nnoremap <silent> <Leader>RG       :Rg <C-R><C-A><CR>
xnoremap <silent> <Leader>rg       :Rg <C-R>"<CR>
nnoremap <silent> <Leader>`        :CocCommand fzf-preview.Marks<CR>
nnoremap <silent> <Leader>P        :Commands<CR>
nnoremap <silent> <Leader>s        :Snippets<CR>
