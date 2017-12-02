" This must be first, because it changes other options as side effect
set nocompatible

" Use pathogen to easily modify the runtime path to include all
" plugins under the ~/.vim/bundle directory
" MUST BE BEFORE filetype on
call pathogen#infect()
call pathogen#helptags()

scriptencoding utf-8
set encoding=utf-8
set fileencoding=utf-8

" Quickly edit/reload the vimrc file
nmap <silent> <leader>v :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" enable mouse (good for resizing splits)
set mouse=a

" history of commands used
set history=1000


"nie dziala: set rtp+=/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim/

" Always show statusline
set laststatus=2
" full 256 enabled
set t_Co=256

" style 
" Our old colorscheme: 
color xoria256
" New colorscheme:
set regexpengine=1
syntax enable
" set background=dark
" colorscheme solarized

" numery lini
set nu


" map NERDTree to '\p'
nmap <silent> <Leader>p :NERDTreeToggle<CR>

" typy plikow
set filetype=on
filetype plugin on
filetype indent on

" wciecia
set autoindent
set tabstop=2
set expandtab
set shiftwidth=2
set softtabstop=2

" ignore those files
set wildignore=*.swp,*.bak,*.pyc,*.class

" no backup files
set nobackup
" set noswapfile " uncomment to don't use swap files

" change default command start from ':' to just ';'. so that you don't have
" to press shift each time
nnoremap ; :

" leave insert mode just by writing 'jj' ;-)
imap jj <Esc>

" don't use arrows!
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" jsDoc comment
au FileType javascript nnoremap <buffer> <C-c>  :<C-u>call WriteJSDocComment()<CR>

" Prolog prog. lan. filetype recognition
autocmd BufNewFile,BufRead *.pl setfiletype prolog

" Ponizej funkcja zaczerpnieta z vimcast.org na ustawianie szerokosci wciec
" ustawiamy jedna szerokosc na ts, sts, sw
" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction

" dlugosc wiersza
set textwidth=0
set wrapmargin=0
set nowrap

" podświetla kolumnę za textwidth
set colorcolumn=+1
highlight ColorColumn ctermbg=darkgray

" białe znaki widoczne po :set list
set listchars=eol:$,tab:»·,trail:~,extends:>,precedes:<
" makro na toggle dla set list/nolist przypisany na "\l"
nmap <leader>l :set list!<CR>

" podświetlanie
autocmd InsertEnter * set cursorline
autocmd WinEnter * setlocal cursorline


" automatyczne uzupelnianie
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

"Incremental search
set incsearch

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d :",
    \ &tabstop, &shiftwidth, &textwidth)
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" zamienia początkowe spacje na tabulatory :) używaj: 'SuperRetab <X>' gdzie
" <X> to liczba spacji jakie należy zamienić na taba
command! -nargs=1 -range SuperRetab <line1>,<line2>s/\v%(^ *)@<= {<args>}/\t/g



" folding oparty na składni
set foldmethod=syntax
set foldlevel=4
set foldcolumn=4

" folding dla java scriptu
function! JavaScriptFold()
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
        return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction
au FileType javascript call JavaScriptFold()
au FileType javascript setl fen


" Wykrywanie typu plikow i odpowiednia szerokosc wciec oraz traktowanie pewnego
" rozszerzenia jako typ innego formatu.
" Only do this part when compiled with support for autocommands
if has("autocmd")
  " Enable file type detection
  filetype on

  " Syntax of these languages is fussy over tabs Vs spaces
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType rst setlocal ts=4 sts=4 sw=4 expandtab
  autocmd Filetype javascript setlocal ts=2 sts=2 sw=2 expandtab

  " Treat .rss files as XML
  " autocmd BufNewFile,BufRead *.rss setfiletype xml " jedynie w celach demo
endif

" funkcja wykonujaca komende przy zachowaniu stanu
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
" usuwa spacje z konca
nmap _$ :call Preserve("%s/\\s\\+$//e")<CR>
" fix indent
nmap _= :call Preserve("normal gg=G")<CR>


" pozwala na przeskakiwanie miedzy nie zapisanymi buforami
set hidden

" szybsze przeskakiwanie miedzy okienkami
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" konfiguracja wiki
let g:vimwiki_list = [{'path': '~/.vim/Wiki-files/src/',
					   \ 'auto_export': 1,
					   \ 'path_html': '~/.vim/Wiki-files/html/' }]

" poprawianie skladni JSa
let g:jsbeautify = {'indent_size': 1, 'indent_char': '\t'}
let g:htmlbeautify = {'indent_size': 4, 'indent_char': ' ', 'max_char': 78, 'brace_style': 'expand', 'unformatted': ['a', 'sub', 'sup', 'b', 'i', 'u']}
let g:cssbeautify = {'indent_size': 2, 'indent_char': ' '}

autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>

" Wylaczenie paneli gvima dla Windowsa
"set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar

" Ustawienie krojów pisma zależnie od środowiska w którym działamy.
if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 12
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h14
  elseif has("gui_win32")
    set guifont=Consolas:h12:cANSI
  endif
endif

"Invisible character colors (zielone białe znaki)
highlight NonText guifg=#4ad455
highlight SpecialKey guifg=#4ad455

" Toggle spell checking on and off with `,s`
let mapleader = ","
nmap <silent> <leader>s :set spell!<CR>
" Set region to British English
set spelllang=en_us,pl

" Below there is a hack to make <Alt+?> combination works under normal
" terminal. The full explanation can be found over here:
" http://stackoverflow.com/questions/6778961/alt-key-shortcuts-not-working-on-gnome-terminal-with-vim
let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw
set timeout ttimeoutlen=50

" Hybrid line number mode.
set relativenumber 
set number

" set backup to ~/.tmp 
set backup 
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp 
set backupskip=/tmp/*,/private/tmp/* 
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp 
set writebackup

" turn on text wrapping
set wrap
set linebreak

let mapleader=','
nmap <leader>; :Tab /:<CR>
vmap <leader>; :Tab /:<CR>
nmap <leader>= :Tab /=<CR>
vmap <leader>= :Tab /=<CR>

