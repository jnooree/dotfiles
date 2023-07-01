set nu
set title
set fileencodings=utf-8,cp949
set encoding=utf-8
set tabstop=8 sw=4 softtabstop=4 smarttab expandtab
set nocompatible
set cindent
set ruler
set autowrite undofile backup
set textwidth=80
set ai showmatch hidden incsearch ignorecase smartcase smartindent hlsearch
set splitbelow splitright
set formatoptions-=t

if !has("nvim")
    source $VIMRUNTIME/vimrc_example.vim
endif

set backupdir=~/.vim/backup// directory=~/.vim/swap// undodir=~/.vim/undo//

filetype on
filetype plugin on
filetype indent on

autocmd BufRead,BufNewFile *.py syntax on
autocmd BufRead,BufNewFile *.py set ai
autocmd BufRead,BufNewFile *.py set makeprg=errout\ python\ %
autocmd BufRead,BufNewFile *.py set ts=8 sw=4 softtabstop=4 expandtab
autocmd BufRead,BufNewFile *.py set smarttab smartindent sta

autocmd BufRead,BufNewFile Makefile set ts=8 sts=8 sw=8 noet

filetype on
filetype plugin on
filetype indent on

autocmd BufRead,BufNewFile *.f90 syntax on
autocmd BufRead,BufNewFile *.f90 set ai
autocmd BufRead,BufNewFile *.f90 set makeprg=errout\ fortran\ %
autocmd BufRead,BufNewFile *.f90 set ts=8 sw=4 softtabstop=4 expandtab
autocmd BufRead,BufNewFile *.f90 set smartindent sta

autocmd BufRead,BufNewFile *.condarc set syntax=yaml

autocmd FileType *sh setlocal shiftwidth=2 tabstop=2

function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END
