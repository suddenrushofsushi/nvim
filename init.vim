" Use Vim settings, rather then Vi settings. This setting must be as early as
" possible, as it has side effects.
filetype off
let mapleader = " "
execute pathogen#infect()
set termguicolors

" :q is now :close (:quit will still exit vim)
cabbrev q <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'close' : 'q')<CR>

set nocompatible
set timeoutlen=300
set runtimepath^=~/.vim/bundle/ctrlp.vim
set splitbelow
set splitright

" Numbers
set number
set numberwidth=5
set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
set guifont=Fira\ Code\ Retina:h23
set previewheight=20
" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab
" Display extra whitespace
set list listchars=tab:»·,trail:·
" Sessions
set ssop-=options
set ssop-=folds

let g:session_autosave = 'no'
let g:session_autoload = 'no'
let g:session_lock_enabled = 0
let g:session_autosave = "yes"
let g:session_autosave_periodic = 2
let g:airline_powerline_fonts = 1
let g:airline_theme = "light"
let g:gitgutter_max_signs=9000
let g:indentLine_color_gui = '#222222'

let g:bufExplorerReverseSort=1       " Sort in reverse order.
let g:buffergator_viewport_split_policy = 'R'
let g:ctrlp_funky_syntax_highlight = 1
let g:ctrlp_working_path_mode = 0
let g:ctrlp_max_files = 0
let g:ctrlp_map = '<leader>p'
let g:ctrlp_cmd = 'CtrlP'
let g:vim_markdown_folding_disabled=0
let g:gist_post_private=1
let g:auto_save = 1
let g:auto_save_in_insert_mode = 0
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
let g:tagbar_left=1

" daily log
map <leader>dl :e ~/Dropbox/daily/daily.md<cr>

map <leader>t :call VimuxRunCommand("mix test")<cr>
map <leader>et :call VimuxRunCommand("elixir *_test.exs")<cr>
" QQ buffers!
map <leader>qq :bufdo :bd<CR>
map <leader>n :NERDTreeToggle<cr>
nnoremap <leader>s :TagbarToggle<Cr>
nnoremap <leader>. :OpenAlternate<cr>
nnoremap <leader>m :CtrlPModels<cr>
nnoremap <leader>c :CtrlPControllers<cr>
nnoremap <leader>v :CtrlPViews<cr>
nnoremap <leader>o :CtrlPMixed<cr>
nnoremap <leader>r :CtrlPMRU<cr>
map <leader>tv :Tview<cr>
map <leader>[ :bprevious<cr>
map <leader>] :bnext<cr>
map <leader>` :bp <BAR> bd #<cr>
map <leader>bb :BuffergatorOpen<cr>
map <leader>bc :BuffergatorClose<cr>
nmap <leader>jj :BuffergatorMruCyclePrev<cr>
nmap <leader>kk :BuffergatorMruCycleNext<cr>
nmap <leader>gs :Gstatus<cr>
nmap <leader>gc :Gcommit<cr>
nmap <leader>gb :Gblame<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gpp :Gpush<cr>
nmap <leader>gpu :Gpull<cr>
nmap <leader>, <C-^>
" leader => arrow navigation for splits
map <leader><Down> <C-W><C-J>
map <leader><Up> <C-W><C-K>
map <leader><Right> <C-W><C-L>
map <leader><Left> <C-W><C-H>
nnoremap <leader>wt <C-W>T
map <leader>ww :bd<cr>

let &t_8f="\e[38;2;%ld;%ld;%ldm"
let &t_8b="\e[48;2;%ld;%ld;%ldm"
if !has('nvim')
  set guicolors
endif
color molokai

autocmd! BufWritePost * Neomake

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif


  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile Guardfile set filetype=ruby
  autocmd BufRead,BufNewFile *.js.slim set filetype=javascript
  autocmd BufRead,BufNewFile *.js.erb set filetype=javascript
  autocmd BufRead,BufNewFile *.slimbars set filetype=slim
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 80 characters for Markdown
  " autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END

function! MysqlE(params)
  :exe ':!mysql -u root -D SeoManager_development -e "' . a:params . '"'
endfunction

command! -nargs=1 Mysqle call MysqlE(<f-args>)

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

autocmd BufEnter * let &titlestring = substitute(expand("%:p"), $HOME, "~", "")
set title

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

"command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
"function! s:RunShellCommand(cmdline)
  "echo a:cmdline
  "let expanded_cmdline = a:cmdline
  "for part in split(a:cmdline, ' ')
     "if part[0] =~ '\v[%#<]'
        "let expanded_part = fnameescape(expand(part))
        "let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     "endif
  "endfor
  "botright new
  "setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  "call setline(1, 'You entered:    ' . a:cmdline)
  "call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  "call setline(3,substitute(getline(2),'.','=','g'))
  "execute '$read !'. expanded_cmdline
  "setlocal nomodifiable
  "1
"endfunction

