syntax on
set nocompatible                " Use vim defaults
set ls=2                        " Always show status line

set tabstop=2
set shiftwidth=2
set expandtab

set hlsearch                    " Highlight searches
set incsearch                   " Do incremental searching
set listchars=tab:>-
set nomodeline                  " Disable mode lines (security measure)
set novisualbell                " Turn off visual bell
set nowrap
set number                      " Show line numbers
set ruler                       " Show the cursor position all the time
set scrolloff=3                 " Keep 3 lines when scrolling
set shortmess+=I                " Hide the launch screen
set showcmd                     " Display incomplete commands
set showmode                    " Always show what mode we're currently editing in
set tabpagemax=50
set title                       " Make your xterm inherit the title from Vim
set ttyfast                     " Don't lag…
set visualbell t_vb=            " Turn off error beep/flash
set wildmenu                    " Enhanced tab-completion shows all matching cmds in a popup menu
set wildmode=list:longest,full  " full completion options
set switchbuf+=usetab,newtab    " Switch to existing tab

let g:loaded_matchparen= 1
set t_Co=256
colorscheme 256_redblack

" CTRL+P
" cd ~/.vim; git clone https://github.com/kien/ctrlp.vim.git bundle/ctrlp.vim
set runtimepath^=~/.vim/bundle/ctrlp.vim

" Compiler in use
compiler gcc

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Eliminating delays on ESC in vim
set timeoutlen=1000 ttimeoutlen=0

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" build using makeprg with <F7>
map <F7> :make<CR>
" build using makeprg with <S-F7>
map <S-F7> :make clean all<CR>

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Toggle show/hide invisible chars
nnoremap <leader>i :set list!<cr>

" Toggle show/hide numbers
nnoremap <leader>n :set nu!<cr>

" Toggle and untoggle spell checking
map <leader>s :setlocal spell!<cr>
map <leader>s? z=

" Search word under the cursor
map <F4> :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>

"folding settings
set foldenable   " enable folding
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup         " do not keep a backup file
set noswapfile
set nowritebackup

" store swap files in one of these directories
" (in case swapfile is ever turned on)
set directory=~/.vim/.tmp,~/tmp,/tmp

" Auto reload ~/.vimrc file upon saving
autocmd BufWritePost .vimrc source %

" Status line
set statusline=
set statusline +=*\ %n\ %*         " buffer number
set statusline +=%w%h%m%r          " Options
set statusline +=\[%{&ff}/%Y]      " filetype
set statusline +=\ [%{hostname()}] " hostname
set statusline +=\ [%{getcwd()}]   " current dir
set statusline +=\ %<%f\           " Filename
set statusline +=*%=%5l%*          " current line
set statusline +=*/%LL%*           " total lines
set statusline +=*%4vC\ %*         " virtual column number
set statusline +=*0x%04B\ %*       " character under cursor

" \p = Runs PHP lint checker on current file
map <leader>p :! php -l %<CR>

" \o remove reply indent levels
map <leader>o :call StripReply()<CR>
fun! StripReply()
  execute '%s/^\W*/> /g'
endfun

" \g generates the header guard
map <leader>g :call IncludeGuard()<CR>
fun! IncludeGuard()
   let basename = substitute(bufname(""), '.*/', '', '')
   let guard = substitute(toupper(basename), '\.', '_', "H")
   call append(0, "#ifndef " . guard . "_INCLUDED")
   call append(1, "#define " . guard . "_INCLUDED")
   call append( line("$"), "#endif // for #ifndef " . guard)
endfun

" Strip trailing whitespace
map <leader>w :call StripTrailingWhitespace()<CR>
fun! StripTrailingWhitespace()
    " Don't strip on these filetypes
    if &ft =~ 'markdown'
        return
    endif
    %s/\s\+$//e
endfun

set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,big5,gb2312,latin1

" Make Vim recognize xterm escape sequences for Page and Arrow
" keys combined with modifiers such as Shift, Control, and Alt.
" See http://www.reddit.com/r/vim/comments/1a29vk/_/c8tze8p
if &term =~ '^screen'
  " Page keys http://sourceforge.net/p/tmux/tmux-code/ci/master/tree/FAQ
  execute "set t_kP=\e[5;*~"
  execute "set t_kN=\e[6;*~"

  " Arrow keys http://unix.stackexchange.com/a/34723
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

" let b:SuperTabDisabled = 0
map <leader>t :call SuperTabToggle()<CR>
let b:SuperTabDisabled = 0
fun! SuperTabToggle()
	if b:SuperTabDisabled == 0
		let b:SuperTabDisabled = 1
	else
		let b:SuperTabDisabled = 0
	endif	
	echo "SuperTab: " b:SuperTabDisabled
endfun

" Show tab index in the tabline
if exists("+showtabline")
function! MyTabLine()
  let s = ''
  let wn = ''
  let t = tabpagenr()
  let i = 1
  while i <= tabpagenr('$')
    let buflist = tabpagebuflist(i)
    let winnr = tabpagewinnr(i)
    let s .= '%' . i . 'T'
    let s .= (i == t ? '%1*' : '%2*')
    let s .= ' '
    let wn = tabpagewinnr(i,'$')

    let s .= '%#TabNum#'
    let s .= i
    " let s .= '%*'
    let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
    let bufnr = buflist[winnr - 1]
    let file = bufname(bufnr)
    let buftype = getbufvar(bufnr, 'buftype')
    if buftype == 'nofile'
      if file =~ '\/.'
        let file = substitute(file, '.*\/\ze.', '', '')
      endif
    else
      let file = fnamemodify(file, ':p:t')
    endif
    if file == ''
      let file = '[No Name]'
    endif
    let s .= ' ' . file . ' '
    let i = i + 1
  endwhile
  let s .= '%T%#TabLineFill#%='
  let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
  return s
endfunction
set stal=2
set tabline=%!MyTabLine()
set showtabline=1
highlight link TabNum Special
endif

" Indentation
autocmd BufRead,BufNewFile *.php,*.js,*.volt,*.html,*.htm,*.ini,*.css,*.mustache set noexpandtab shiftwidth=4 tabstop=4
