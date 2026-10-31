" ~/.vimrc — plain Vim 9, plugins via vim-plug (~/.vim/autoload/plug.vim).
" Install/update plugins with :PlugInstall / :PlugUpdate (done automatically
" on first start).

""""""""""""""""""""""
"      Plugins       "
""""""""""""""""""""""
call plug#begin()
" Looks
Plug 'fatih/molokai'
Plug 'itchyny/lightline.vim'

" Finding things (fzf binary is downloaded by the plugin; :Rg needs ripgrep)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Editing
Plug 'tpope/vim-commentary'     " gcc / gc{motion} to (un)comment
Plug 'tpope/vim-surround'       " cs\"' ds( ysiw]
Plug 'tpope/vim-repeat'         " make . work with the above
Plug 'tpope/vim-sleuth'         " detect indent style per file
Plug 'AndrewRadev/splitjoin.vim' " gS / gJ split or join a statement

" Languages
Plug 'fatih/vim-go'             " run :GoInstallBinaries once for gopls etc.
call plug#end()

" Install missing plugins on startup.
if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Vim's bundled EditorConfig support (.editorconfig files).
silent! packadd! editorconfig
" % jumps between if/else/endif, HTML tags, etc.
packadd! matchit

""""""""""""""""""""""
"      Settings      "
""""""""""""""""""""""
set nocompatible
filetype plugin indent on
syntax enable
set encoding=utf-8
set fileformats=unix,dos,mac

" UI
set number                      " line numbers
set signcolumn=yes              " always show the gutter, so text doesn't jump
set laststatus=2                " always show the status line
set noshowmode                  " lightline shows the mode
set showcmd                     " show partial commands
set scrolloff=5                 " keep context above/below the cursor
set sidescrolloff=5
set nowrap
set linebreak                   " when wrap is on, break at word boundaries
set list listchars=tab:\ \ ,trail:·,nbsp:␣,extends:›,precedes:‹
set fillchars=vert:│
set wildmenu wildmode=longest:full,full
set wildignore+=*/.git/*,*/node_modules/*,*/vendor/*,*.o,*.pyc
set shortmess+=c                " no 'match 1 of 2' messages
set noerrorbells visualbell t_vb=
set mouse=a ttymouse=sgr        " mouse in all modes, works in wide terminals
set ttyfast lazyredraw
set updatetime=300              " faster gitgutter / CursorHold
set completeopt=menu,menuone,noselect
set pumheight=10

" Colors
set t_Co=256
let g:rehash256 = 1
let g:molokai_original = 1
set background=dark
" molokai's line numbers (239) are hard to read; lighten them and show the
" current line's number in molokai's orange.
augroup vimrc_colors
  autocmd!
  autocmd ColorScheme molokai hi LineNr ctermfg=246 guifg=#949494
        \ | hi CursorLineNr ctermfg=208 guifg=#FD971F cterm=bold gui=bold
augroup END
set cursorline cursorlineopt=number  " highlight only the number, not the line
silent! colorscheme molokai

" Editing
set autoindent
set expandtab tabstop=4 shiftwidth=4 softtabstop=4  " sleuth overrides per file
set backspace=indent,eol,start
set nojoinspaces
set hidden                      " switch buffers without saving
set autoread autowrite
set splitright splitbelow
set virtualedit=block           " free cursor in visual block mode
if has('unnamedplus')
  set clipboard^=unnamed,unnamedplus
else
  set clipboard^=unnamed
endif

" Search
set incsearch hlsearch
set ignorecase smartcase
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
endif

" Files: no swap/backup clutter, but keep undo history across sessions.
set noswapfile nobackup nowritebackup
if has('persistent_undo')
  let s:undodir = expand('~/.config/vim/tmp/undo')
  if !isdirectory(s:undodir) | call mkdir(s:undodir, 'p', 0700) | endif
  let &undodir = s:undodir
  set undofile
endif

" Block cursor in normal mode, bar in insert, underline in replace.
let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"
let &t_EI = "\e[2 q"

""""""""""""""""""""""
"      Mappings      "
""""""""""""""""""""""
let mapleader = ","

" Move by display line unless a count is given (so 5j still works).
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" Keep search results centered.
nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap Y y$
nnoremap <silent> <leader><space> :nohlsearch<CR>
nnoremap <leader>w :w<CR>

" Windows: Ctrl-h/j/k/l to move between splits.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Buffers
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [b :bprevious<CR>

" Quickfix: Ctrl-n / ]q next, [q previous, <leader>a close.
nnoremap <silent> <C-n> :cnext<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> <leader>a :cclose<CR>

" Keep selection when indenting in visual mode.
vnoremap < <gv
vnoremap > >gv

" Move selected lines up/down with J/K in visual mode.
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" fzf
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <leader>f :GFiles<CR>
nnoremap <silent> <leader>; :Buffers<CR>
nnoremap <silent> <leader>/ :Rg<CR>
nnoremap <silent> <leader>* :Rg <C-r><C-w><CR>
nnoremap <silent> <leader>h :History<CR>

" Git
nnoremap <silent> <leader>gs :Git<CR>
nnoremap <silent> <leader>gb :Git blame<CR>
nnoremap <silent> <leader>gd :Gvdiffsplit<CR>
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

""""""""""""""""""""""
"    Autocommands    "
""""""""""""""""""""""
augroup vimrc
  autocmd!
  " Jump to the last known cursor position when reopening a file.
  autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif
  " Re-check for outside changes when focus returns.
  autocmd FocusGained,BufEnter * silent! checktime
  " Equalize splits when the terminal is resized.
  autocmd VimResized * wincmd =
  " Git commit messages: wrap at 72 and spell check.
  autocmd FileType gitcommit setlocal textwidth=72 spell
  " Two-space indent for config/markup files.
  autocmd FileType yaml,json,html,css,scss,javascript,typescript,ruby,vim
        \ setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
augroup END

""""""""""""""""""""""
"   Plugin config    "
""""""""""""""""""""""
" lightline
let g:lightline = {
      \ 'colorscheme': 'molokai',
      \ 'active': {
      \   'left':  [ ['mode', 'paste'], ['gitbranch', 'readonly', 'relativepath', 'modified'] ],
      \   'right': [ ['lineinfo'], ['percent'], ['filetype', 'fileencoding'] ],
      \ },
      \ 'component_function': { 'gitbranch': 'FugitiveHead' },
      \ }

" fzf
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }
let g:fzf_preview_window = ['right,50%', 'ctrl-/']
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git"'
endif

" gitgutter
let g:gitgutter_sign_added = '│'
let g:gitgutter_sign_modified = '│'
let g:gitgutter_sign_removed = '_'

" vim-go
let g:go_fmt_command = "goimports"
let g:go_list_type = "quickfix"
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1

" build_go_files builds the package, or compiles the tests in a _test.go file.
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

augroup go
  autocmd!
  autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
  autocmd FileType go nmap <buffer> <leader>b :<C-u>call <SID>build_go_files()<CR>
  autocmd FileType go nmap <buffer> <leader>t <Plug>(go-test)
  autocmd FileType go nmap <buffer> <leader>r <Plug>(go-run)
  autocmd FileType go nmap <buffer> <leader>d <Plug>(go-doc)
  autocmd FileType go nmap <buffer> <leader>c <Plug>(go-coverage-toggle)
  autocmd FileType go nmap <buffer> <leader>i <Plug>(go-info)
  autocmd FileType go nmap <buffer> <leader>l <Plug>(go-metalinter)
  autocmd FileType go nmap <buffer> <leader>v <Plug>(go-def-vertical)
  autocmd FileType go nmap <buffer> <leader>s <Plug>(go-def-split)
  " Open :GoDeclsDir with Ctrl-g
  autocmd FileType go nmap <buffer> <C-g> :GoDeclsDir<CR>
  autocmd FileType go imap <buffer> <C-g> <Esc>:<C-u>GoDeclsDir<CR>
  " :A / :AV / :AS / :AT jump between foo.go and foo_test.go
  autocmd FileType go command! -buffer -bang A  call go#alternate#Switch(<bang>0, 'edit')
  autocmd FileType go command! -buffer -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd FileType go command! -buffer -bang AS call go#alternate#Switch(<bang>0, 'split')
  autocmd FileType go command! -buffer -bang AT call go#alternate#Switch(<bang>0, 'tabe')
augroup END
