set nocompatible
set mouse=a
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
"Plugin 'valloric/youcompleteme'
Plugin 'vim-scripts/taglist.vim'
Plugin 'dracula/vim', { 'name': 'dracula' }
call vundle#end()            " required
filetype plugin indent on    " required
let g:dracula_colorterm = 0
let g:dracula_italic = 0
colorscheme dracula

syntax on
filetype plugin indent on
set modelines=0
set wrap
"set foldmethod=indent
set nofoldenable

nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>

if exists("b:did_indent")
    finish
endif
let b:did_indent = 1


function! GoogleCppIndent()
    let l:cline_num = line('.')

    let l:orig_indent = cindent(l:cline_num)

    if l:orig_indent == 0 | return 0 | endif

    let l:pline_num = prevnonblank(l:cline_num - 1)
    let l:pline = getline(l:pline_num)
    if l:pline =~# '^\s*template' | return l:pline_indent | endif

    " TODO: I don't know to correct it:
    " namespace test {
    " void
    " ....<-- invalid cindent pos
    "
    " void test() {
    " }
    "
    " void
    " <-- cindent pos
    if l:orig_indent != &shiftwidth | return l:orig_indent | endif

    let l:in_comment = 0
    let l:pline_num = prevnonblank(l:cline_num - 1)
    while l:pline_num > -1
        let l:pline = getline(l:pline_num)
        let l:pline_indent = indent(l:pline_num)

        if l:in_comment == 0 && l:pline =~ '^.\{-}\(/\*.\{-}\)\@<!\*/'
            let l:in_comment = 1
        elseif l:in_comment == 1
            if l:pline =~ '/\*\(.\{-}\*/\)\@!'
                let l:in_comment = 0
            endif
        elseif l:pline_indent == 0
            if l:pline !~# '\(#define\)\|\(^\s*//\)\|\(^\s*{\)'
                if l:pline =~# '^\s*namespace.*'
                    return 0
                else
                    return l:orig_indent
                endif
            elseif l:pline =~# '\\$'
                return l:orig_indent
            endif
        else
            return l:orig_indent
        endif

        let l:pline_num = prevnonblank(l:pline_num - 1)
    endwhile

    return l:orig_indent
endfunction

set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab
set textwidth=80

set cindent
set cinoptions=h1,l1,g1,t0,i4,+4,(0,w1,W4

set indentexpr=GoogleCppIndent()

let b:undo_indent = "setl sw< ts< sts< et< tw< wrap< cin< cino< inde<"

set scrolloff=5
set backspace=indent,eol,start
set ttyfast

set laststatus=2

set showmode
set showcmd

set matchpairs+=<:>

set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.

set number

set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [BUFFER=%n]\ %{strftime('%c')}

set encoding=utf-8

set hlsearch

set incsearch
set ignorecase
set smartcase

" Map the <Space> key to toggle a selected fold opened/closed.
"nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
"vnoremap <Space> zf
"
" Automatically save and load folds
"autocmd BufWinLeave *.* mkview
"autocmd BufWinEnter *.* silent loadview"
" Call the .vimrc.plug file
if filereadable(expand("~/.vimrc.plug"))
  source ~/.vimrc.plug
endif

"let mapleader="`"
"
"nnoremap <leader>gt :YcmCompleter GoTo<CR>
"
"nnoremap <leader>fi :YcmCompleter FixIt<CR>
"
"nnoremap <leader>gd :YcmCompleter GetDoc<CR>
"
"nnoremap <leader>gtp :YcmCompleter GetType<CR>
"
"nnoremap <leader>gp :YcmCompleter GetParent<CR>
"
"nnoremap <leader>gti :YcmCompleter GoToInclude<CR>
"
"nnoremap <leader>gtdd :YcmCompleter GoToDefinition<CR>
"
"nnoremap <leader>gtd :YcmCompleter GoToDeclaration<CR>
"
"nnoremap <leader>yd :YcmDiags<CR>
set noshowmode
set noruler
set laststatus=0
set noshowcmd
set cmdheight=2
" noremap e k
" noremap n j
" noremap k n
" noremap K N
" noremap N J
" noremap j y
" noremap l u
" noremap i l
" noremap u i
" set clipboard=unnamedplus

source ~/cscope_maps.vim
