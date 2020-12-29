set smartcase
set incsearch
set hlsearch
set nobackup
set bs=2
set tabstop=4
set expandtab
set autoindent
set smartindent
set showmatch
set ruler
set showmode

set nocompatible
filetype off

" ===============
" Display
" ===============
set number
set list
set listchars=tab:>-
set cursorline
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline


" ===============
" Vundle
" ===============
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

" 一般
Plugin 'VundleVim/Vundle.vim'
Plugin 'tomasr/molokai'

" 補完
Plugin 'vim-scripts/L9'
Plugin 'vim-scripts/OmniCppComplete'

Plugin 'othree/vim-autocomplpop'
Plugin 'tpope/vim-surround'

Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'

" 便利
Plugin 'vim-syntastic/syntastic'
Plugin 'szw/vim-tags'
Plugin 'vim-scripts/taglist.vim'
Plugin 'thinca/vim-quickrun'

call vundle#end()
filetype plugin indent on

" ===============
" KeyBind
" ===============
" TagList
nnoremap <Space>. :<C-u>edit $MYVIMRC<Enter>
nnoremap <Space>s. :<C-u>source $MYVIMRC<Enter>

" Fast Help
nnoremap <C-h> :<C-u>help<Space>
nnoremap <C-h><C-h> :<C-u>help<Space><C-r><C-w><Enter>

" Ignore Wrap
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Fast Data Input
nnoremap gc [v']
vnoremap gc :<C-u>normal gc<Enter>
onoremap gc :<C-u>normal gc<Enter>

" ===============
" EXCmd
" ===============
" File Encoding
command! Cp932 edit ++enc=cp932
command! Eucjp edit ++enc=euc-jp
command! Iso2022jp edit ++enc=iso-2022-jp
command! Utf8 edit ++enc=utf-8
command! Jis iso2022jp
command! Sjis cp932 

" ===============
" QuickRun
" ===============
let g:quickrun_config = {
\  "_" : {
\    "outputter/buffer/split" : ":rightbelow 8sp",
\    "outputter/buffer/close_on_empty" : 1
\  },
\}

" ===============
" TagList
" ===============
let Tlist_Use_Right_Window = 1
let Tlist_Auto_Open = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Show_One_File = 1
nnoremap <C-]> g<C-]>
" C
autocmd BufNewFile,BufRead *.c let g:vim_tags_project_tags_command = "ctags --append=yes --recurse=yes --languages=c -f ~/c.tags `pwd` 2>/dev/null"
autocmd BufNewFile,BufRead *.c set tags+=$HOME/c.tags
" CPP
autocmd BufNewFile,BufRead *.cpp let g:vim_tags_project_tags_command="ctags --append=yes --recurse=yes --languages=c++ -f ~/cpp.tags `pwd` 2>/dev/null"
autocmd BufNewFile,BufRead *.cpp set tags+=$HOME/cpp.tags