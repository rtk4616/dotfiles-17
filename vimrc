""" Auto Installation

  if empty(glob("~/.vim/autoload/plug.vim"))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    auto VimEnter * PlugInstall
  endif

  if !empty(glob("~/.fzf/bin/fzf"))
    if empty(glob("~/.fzf/bin/rg"))
      silent !curl -fLo /tmp/rg.tar.gz
            \ https://github.com/BurntSushi/ripgrep/releases/download/0.4.0/ripgrep-0.4.0-x86_64-unknown-linux-musl.tar.gz
      silent !tar xzvf /tmp/rg.tar.gz --directory /tmp
      silent !cp /tmp/ripgrep-0.4.0-x86_64-unknown-linux-musl/rg ~/.fzf/bin/rg
    endif
  endif
  
  if empty(glob("~/.vim/colors/lucius.vim"))
    silent !curl -fLo ~/.vim/colors/lucius.vim --create-dirs
          \ https://raw.githubusercontent.com/bag-man/dotfiles/master/lucius.vim
  endif
  
  if !isdirectory($HOME . "/.vim/undodir")
    call mkdir($HOME . "/.vim/undodir", "p")
  endif

""" Appearance

  syntax on
  set number relativenumber
  set nowrap

  colorscheme lucius
  LuciusDarkLowContrast

  set cindent
  set expandtab
  set shiftwidth=2
  set softtabstop=2

  set laststatus=2
  set statusline=%F
  set wildmenu
  set showcmd

  match Delimiter /\d\ze\%(\d\d\%(\d\{3}\)*\)\>/

""" Key modifiers

  set pastetoggle=<F2>
  map <F3> :F <C-r><C-w><Cr>
  map <F5> :make!<cr>
  map <F6> :set hlsearch!<CR>

  map <Cr> O<Esc>j

  map Y y$
  map H ^
  map L $
  map £ g_   

  nnoremap J :tabprev<CR>
  nnoremap K :tabnext<CR>

  nnoremap M J
  nnoremap S "_diwP

  map "p vi"p
  map 'p vi'p
  map (p vi(p
  map )p vi)p

  map q: :q
  map n nzz
  xnoremap p "_dP
  cmap w!! w !sudo tee > /dev/null %

  map <C-l> :bn<Cr>
  map <C-h> :bp<Cr>

  nnoremap <tab> :tabnext<CR>
  nnoremap <s-tab> :tabprev<CR>
  nnoremap <C-t> :tabnew<CR>
  inoremap <C-t> <Esc>:tabnew<CR>i

  inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
  inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))
  inoremap <expr> <tab> ((pumvisible())?("\<Cr>"):("<Cr>"))
  
  imap <Tab> <C-X><C-F>
  imap <s-Tab> <C-X><C-P>

  map cp :CopyRelativePath<Cr>
  map gp :Sprunge<cr>
  map go :Google<cr>
  map gl :Gblame<Cr>
  map gb :Gbrowse!<Cr>
  map ch :Gread<Cr>
  cmap bc :Bclose<Cr>
  noremap gt <C-w>gf
  noremap gs <C-w>vgf
  noremap gi <C-w>f

  noremap <C-]> <C-w><C-]><C-w>T
  nnoremap <Space> za

  " resize splits with Ctrl+←↑→↓
  map Od <C-w>>
  map Oc <C-w><
  map Oa <C-w>+ 
  map Ob <C-w>-

""" Behaviour modifiers

  set undofile
  set undodir=~/.vim/undodir
  set clipboard=unnamed
  set wildignore+=*/tmp/*,*.so,*.swp,*.zip
  set foldmethod=marker
  set backspace=indent,eol,start

  autocmd BufWritePre *.erb,*.scss,*.rb,*.js,*.c,*.py,*.php :%s/\s\+$//e

  autocmd InsertEnter * let save_cwd = getcwd() | set autochdir
  autocmd InsertLeave * set noautochdir | execute 'cd' fnameescape(save_cwd)

  set ignorecase
  set incsearch
  set smartcase
  set scrolloff=10
  set hlsearch!

  set wildmode=longest,list,full
  set completeopt=longest,menuone

  setlocal spell spelllang=en
  nmap ss :set spell!<CR>
  set nospell
  autocmd FileType gitcommit setlocal spell

  let g:tex_flavor = 'tex'
  autocmd FileType markdown,tex 
    \ setlocal spell wrap |
    \ map j gj |
    \ map k gk |
   
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
  function! ExecuteMacroOverVisualRange()
    echo "@".getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
  endfunction

""" Plugins
    
  " NERDTree
  map <C-n> :NERDTreeTabsToggle<CR>
  map <C-f> :NERDTreeFind<CR>
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
  let NERDTreeChDirMode=2
  let g:NERDTreeDirArrowExpandable = '├'
  let g:NERDTreeDirArrowCollapsible = '└'
  let g:NERDTreeMapActivateNode = '<tab>'
  set mouse=a

  " Ale
  let g:ale_sign_error = ' '
  let g:ale_sign_warning = ' '
  let g:ale_sign_column_always = 1
  let g:ale_linters = {
  \   'javascript': ['eslint'],
  \}

  " argwrap
  nnoremap <silent> <Bslash>a :ArgWrap<CR>
  let g:argwrap_padded_braces = '{'

  " fzf config
  nmap <C-p> :Files<cr>
  imap <c-x><c-l> <plug>(fzf-complete-line)

  let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-i': 'split',
    \ 'ctrl-s': 'vsplit' }
  let g:fzf_layout = { 'down': '~20%' }

  let g:rg_command = '
    \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
    \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf}"
    \ -g "!*.{min.js,swp,o,zip}" 
    \ -g "!{.git,node_modules,vendor}/*" '

  command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)

  " vim-move
  let g:move_key_modifier = 'C'

  " rainbow brackets
  autocmd VimEnter * RainbowParenthesesToggle
  autocmd Syntax * RainbowParenthesesLoadRound
  autocmd Syntax * RainbowParenthesesLoadSquare
  autocmd Syntax * RainbowParenthesesLoadBraces

  " sneak
  map s <Plug>Sneak_s
  let g:sneak#s_next = 1
  hi link SneakPluginTarget ErrorMsg

  " vimtex
  let g:vimtex_view_general_viewer = 'zathura'
  " community/zathura
  " community/zathura-pdf-poppler

  " instant markdown
  let g:instant_markdown_slow = 1
  " dom.allow_scripts_to_close_windows = true
  " euclio/instant-markdown-d@4fcd47422d

  call plug#begin('~/.vim/plugged')
  filetype plugin indent on

  Plug 'w0rp/ale'                                                      " Async linting
  Plug 'scrooloose/nerdtree'                                           " File tree browser
  Plug 'Xuyuanp/nerdtree-git-plugin'                                   " Git for NerdTree
  Plug 'moll/vim-node'                                                 " Syntax for node.js
  Plug 'digitaltoad/vim-jade'                                          " Syntax for jade
  Plug 'rbgrouleff/bclose.vim'                                         " Close current buffer
  Plug 'tpope/vim-surround'                                            " Operate on surrounding 
  Plug 'tpope/vim-speeddating'                                         " Increment dates
  Plug 'tpope/vim-repeat'                                              " Repeat plugins
  Plug 'tpope/vim-commentary'                                          " Comment out blocks
  Plug 'mkitt/tabline.vim'                                             " Cleaner tabs
  Plug 'jistr/vim-nerdtree-tabs'                                       " NerdTree independent of tabs
  Plug 'bag-man/copypath.vim'                                          " copy path of file
  Plug 'tpope/vim-fugitive'                                            " Git integration
  Plug 'can3p/incbool.vim'                                             " Toggle true/false
  Plug 'chrisbra/Colorizer'                                            " Show hex codes as colours
  Plug 'triglav/vim-visual-increment'                                  " Increment over visual selection
  Plug 'kopischke/vim-fetch'                                           " Use line numbers in file paths
  Plug 'matze/vim-move'                                                " Move lines up and down
  Plug 'jreybert/vimagit'                                              " Interactive git staging
  Plug 'justinmk/vim-sneak'                                            " Multiline find
  Plug 'kien/rainbow_parentheses.vim'                                  " Colour matched brackets
  Plug 'suan/vim-instant-markdown'                                     " Markdown preview instant-markdown-d
  Plug 'undofile_warn.vim'                                             " Warn old undo
  Plug 'wavded/vim-stylus'                                             " Stylus for stylus
  Plug 'wellle/targets.vim'                                            " Additional text objects                   
  Plug 'tpope/vim-abolish'                                             " Flexible search
  Plug 'chilicuil/vim-sprunge'                                         " Paste selection to sprunge
  Plug 'lervag/vimtex'                                                 " Build LaTeX files
  Plug 'michaeljsmith/vim-indent-object'                               " Indented text object
  Plug 'kana/vim-textobj-user'                                         " Add additional text objects
  Plug 'kana/vim-textobj-function'                                     " Add function based text objects
  Plug 'thinca/vim-textobj-function-javascript'                        " Add JS function object
  Plug 'FooSoft/vim-argwrap'                                           " Wrap arguments to multi-lines
  Plug 'szw/vim-g'                                                     " Google from Vim
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }    " Install fzf for user
  Plug 'junegunn/fzf.vim'                                              " Fzf vim plugin

  call plug#end()
