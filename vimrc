set nocompatible

" Disabling 'Alternate Screen'
" Refer to http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set autoindent        " always set autoindenting on

set nobackup        " do not keep a backup file, use versions instead
set history=50        " keep 50 lines of command line history
set ruler           " show the cursor position all the time
set showcmd         " display incomplete commands
set laststatus=2    " Always include a status line, which shows filename,
                    " displayes [+] if file's been modified

set titlestring=%F\ %m\ %r\ %* " Display full path on the window title bar.
set stl=%<%f\ %h%m%r%=0x%B\ %-10.((col:%c,line:%l)\ %L\ Lines%) " Status line

set fileformat=unix
set foldcolumn=0

" Search options
set hlsearch
set ignorecase
set incsearch

" Insert 4 spaces instead of tab.
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab

syntax on

" Keep buffer of 3 lines at each end of screen: top and bottom.
" set scrolloff=3

set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

" Don't use Ex mode, use Q for formatting
map Q gq
" map K k

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

nnoremap <silent> <S-F2> :tp<cr>            " Go to previous tag
nnoremap <silent> <S-F3> :tn<cr>            " Go to next tag
nnoremap <silent> <F2>   :cp<cr>            " Go to previous error line (compile result)
nnoremap <silent> <F3>   :cn<cr>            " Go to next error line (compile result)
" nnoremap <silent> <S-F2> :cold<cr>          " Go to older quickfix window
" nnoremap <silent> <S-F3> :cnew<cr>          " Go to newer quickfix window

" Split window into two vertical widows.
" Each of them are of 80 column width and of 68 lines height.
" map <F7> <esc>:set columns=165<CR>:vs<CR>=:set lines=68<CR>

" Removing trailing white spaces
nnoremap <S-F12> :%s/\s\+$//g<CR>
" Making source code line foo(a, b, c,
"                         foo(a,
"                             b,
"                             c,
" meaning: , not followed by 1 or more traling white spaces
" :help \@!
nnoremap <S-F11> mr:s/,\(\s*$\)\@!/,\r/g<CR>=`r

" nnoremap <S-F10> :!./maketags.sh<CR>:!./scripts/maketags.sh
" nnoremap <S-F10> :!([[ -f ./maketags.sh ]] && ./maketags.sh || [[ -f ./scripts/maketags.sh ]] && ./scripts/maketags.s)<CR>
nnoremap <S-F10> :![[ -f ./maketags.sh ]] && ./maketags.sh \|\| ([[ -f ./scripts/maketags.sh ]] && ./scripts/maketags.sh \|\| echo "No maketags.sh found")<CR>

" Scroll screen by 3 lines. Upwards, downwards.
noremap <C-U> 3<C-U>
noremap <C-D> 3<C-D>

" Scroll screen without moving cursor. In insert mode.
inoremap <C-E> <C-O><C-E>
inoremap <C-Y> <C-O><C-Y>

" Making Ctrl-BS to erase a word before.
map! <C-BS> <C-W>

noremap <F9> :Rgrep<CR>
map <F10> <ESC>:make -j 40<CR>
map <F11> <ESC>:make -j 40 test<CR>

" Note that grep's options are set by env variable GREP_OPTIONS
let Grep_Path = '/bin/grep'
let Grep_OpenQuickfixWindow = 1
let Grep_Default_Options = '--exclude=.\* --exclude=tags --exclude=TAGS --exclude=*.d --exclude-dir=.git -rnI'

" Suppress beeping and flashing screen
if $OS_NAME == "osx"
    set vb " macvim beeps unless this option is set
    set noeb
else
    set vb t_vb=
    set novb " gvim flashes screen without this option
    set noeb
endif

" Decorate doxygen comment.
let g:load_doxygen_syntax=1
let g:doxygen_enhanced_color=1

colorscheme default

if &diff
    hi DiffChange ctermbg=153 " Light Light blue
    hi DiffText   ctermbg=33 " Light blue
endif

hi Search ctermbg=225
hi IncSearch ctermbg=225

set mouse=a

