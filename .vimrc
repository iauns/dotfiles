" Available top level normal mode keys:
" \ - Most people use this as their leader key and currently does nothing.
"     A long reach though.
" x - Hardly ever use this key. Same as dl or dh (used with repeat)
"     I only use this key for swapping two characters, which could easily just
"     be a leader mapping.
" space - (remapped) Similar to another leader key - mostly used for easymotion.
" m - can be remapping to !. No need to place such an infrequent key close to
"     home.

" Maybe re-mappable:
" , - A possibility since its use is very infrequent.

" We usually use the fish shell which doesn't play nicely with Vim...
set shell=/bin/bash

" gnome-terminal settings (doesn't advertise 256 color)
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

" TODO: Look at colorscheme 'jellybeans'

"-------------------------------------------------------------------------------
" General VIM settings
"-------------------------------------------------------------------------------
set nocompatible          " No compatibility with Vi.
syntax enable             " Turn on color syntax highlighting.
"set background=dark       " Default background is dark.
"colorscheme xoria256      " Use two color schemes: xoria256 for dark.
"set background=dark       " The colorscheme above sets the background to light.
"                          " (only when in the terminal, curiously).
"colorscheme seoul256      " Unified color scheme.
" NOTE: colorscheme needs to be set after bundleinstall
set guioptions-=r         " Disable the right scrollbar.
set guioptions-=L         " Disable the left scrollbar.
set guioptions+=c         " Make gvim use text prompts, not gui popups.
set guioptions-=m         " I don't want the menu. Frees up the alt button.
set guioptions-=e         " Make mac vim use ASCII tabs (like terminal).
                          " This to get similar color coding as the rest of vim.
set incsearch             " Enable incremental search.
set rnu                   " Set relative line numbers. Can easily navigate with #j/k.
set nu                    " Show absolute line number on current line (works in vim 7.4).
let mapleader="s"         " Set mapleader to 's'. I do not use the substitute 
                          " command all that often (c-<motion>). BUT: this does
                          " mess up nerdtree's vertical split 's' key.
set autoread              " Autoread file when changed externally.
set scrolloff=0           " Lines of vertical padding around cursor.
set noswapfile            " No more *.swp files.
set nobackup              " No backup files (we have a large undo history).
set nowb                  " No backup when writing the file to disk.
set completeopt=longest   " Do not automatically suggest the first element
set completeopt+=menuone  " Use popup menu also when there is only one match.
set virtualedit=onemore   " Add one extra 'virtual' space at end of each line.
                          " Also could use: set virtualedit=all
set tabstop=2             " Number of spaces that a <Tab> counts for.
set softtabstop=2         " Num spaces that a <Tab> is converted into.
set shiftwidth=2          " # of spaces to use for each step of autoindent.
set expandtab             " Tell vim to insert spaces instead of tabs.
set laststatus=2          " tell VIM to always put a status line in.
set encoding=utf-8        " Show unicode glyphs.
set tags=./tags;/         " Set ctags to recurse upwards.
set hidden                " Allow switching from unsaved buffers.
set wildmenu              " Better command line completion
set wildmode=longest:full,full
set showcmd               " Show partial commands in last line of screen.
set hlsearch              " Highlight all of the search patterns.
set ignorecase            " Case of normal letters is ignored.
set smartcase             " Used to ignore case if no capitals are used.
set backspace=indent,eol,start " Allow backspacing over autoindent, line breaks,
                          " and start of insert action.
set autoindent            " Keep same indent as line you are currently on
                          " (while minding file-type based autoindent).
set nostartofline         " Cursor on same column and first non-blank on line.
set ruler                 " Display cursor position in the status line.
set confirm               " Confirm dialog for save instead of auto-fail.
set visualbell            " Visual bell instead of audible beep.
set t_vb=                 " Disable the visual bell (reset terminal code).
"set mouse=a               " Use mouse for all modes (consider removing).
set cmdheight=2           " Set command winow height to 2 (avoiding cases of 
                          " 'press return to continue').
                          " The following  two lines were causing problems 
                          " exiting insert mode when using the terminal.
set timeout timeoutlen=5000 ttimeoutlen=0 " Lower the delay of escaping out of other modes
set pastetoggle=<F10>     " F10 to enter paste mode. Super useful if you are
                          " trying to paste into terminal vim.
set linebreak             " Wraps at 'breakat' instead of in the middle.
set shiftround
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set sessionoptions-=options  " Don't save options in sessions. 
set noshowmatch           " Don't show matching brackets (%).

set so=2                  " Lines of context at the bottom / top of document.

" Speed up vim's syntax highlighting.
set nocursorcolumn
set nocursorline
syntax sync minlines=256

" Note: Not sure this is necessary with the easy-clip plugin installed.
" Writes to the unnamed register also writes to the * and + registers. This
" makes it easy to interact with the system clipboard.
" This allows you to simply yank text and it will end up on the system
" clipboard. This also works if you delete text.
if has ('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

" Expands what is considered a 'word'. I generally like the granularity
" of the default and navigate with capitol 'w' and 'b' when necessary.
" I keep this around anyways for future reference.
"set iskeyword+=<,>,[,],:,-,`,!
"set iskeyword-=_

" Cursor settings. This makes terminal vim sooo much nicer!
" Tmux will only forward escape sequences to the terminal if surrounded by a DCS
" sequence. This turns the insert mode cursor into a nice single bar!
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Ignore object files and git folders.
let g:wildignoredefaults='*.o,*.obj,.git,*.a'
exe 'set wildignore+='.g:wildignoredefaults

" Setup persistent undo/redo. Quite nice.
silent !mkdir ~/.vim/backups > /dev/null 2>&1
set undodir=~/.vim/backups
set undofile
set undolevels=1250

" When opening files, return to the last edit position.
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

" Always show the gutter (sign column).
autocmd BufEnter * sign define dummy
autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')

"-------------------------------------------------------------------------------
" VUNDLE
"-------------------------------------------------------------------------------
"
" NOTE: May want to switch te Neobundle. It allows you to place compiler
" directives along with the bundle. This would be helpful for vimproc and
" youcompleteme. Below is the build directives for vimproc:
"
" NeoBundle 'Shougo/vimproc', { 'build': {
"      \ 'windows': 'make -f make_mingw32.mak',
"      \ 'cygwin': 'make -f make_cygwin.mak',
"      \ 'mac': 'make -f make_mac.mak',
"      \ 'unix': 'make -f make_unix.mak',
"      \ } }
"
" NeoBundle was inspired by Vundle, so it looks extremelly similar.
" The only downside is the documentation.
"
" Filetype needs to be off with vundle,
" See: https://github.com/gmarik/vundle/issues/16
" And: https://bugs.launchpad.net/ultisnips/+bug/1067416
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'

" build vimproc : % cd dot.vim/bundle/vimproc/ && make -f make_mac.mak
Bundle 'Shougo/vimproc'

" Rest of Shougo's stuff.
" Look at the following when digging back into unite:
" https://github.com/terryma/dotfiles/blob/master/.vimrc
Bundle 'Shougo/unite.vim'
Bundle 'Shougo/unite-outline'
Bundle 'Shougo/unite-help'
Bundle 'Shougo/unite-session'

" Bundles
Bundle 'Valloric/YouCompleteMe.git'
Bundle 'godlygeek/tabular.git'
Bundle 'tpope/vim-markdown.git'
Bundle 'paradigm/SkyBison.git'
Bundle 'vim-scripts/Cpp11-Syntax-Support.git'
Bundle 'derekwyatt/vim-protodef.git'
" New motion objects. This introduces the comma ','.
" Use it to perform an action on a word in camel case. Like ci,w
Bundle 'bkad/CamelCaseMotion.git'
" Text object based on indentation level. Adds 'i' and 'I' as text objects.
Bundle 'michaeljsmith/vim-indent-object.git'
Bundle 'suan/vim-instant-markdown'
Bundle 'dhruvasagar/vim-table-mode'
" Unimpaired plugin (bindings to left and right braces) -- Unimpaired must
" come before svermeulen's branch of easymotion. Otherwise 'yp' won't be bound
" correctly.
Bundle 'tpope/vim-unimpaired.git'
" Easy motion (moved to Bundle from VAM). Using alternative which uses two chars.
Bundle 'iauns/vim-easymotion.git'
Bundle 'iauns/vim-subbed'
"Bundle 'svermeulen/vim-easymotion'
Bundle 'tpope/vim-repeat.git'
Bundle 'tpope/vim-speeddating.git'
" Narrow region. Lets you edit the selection in a separate buffer.
" The shortcut is <leader>nr.
Bundle 'chrisbra/NrrwRgn.git'
Bundle 'vim-scripts/utl.vim.git'
Bundle 'tpope/vim-surround.git'
Bundle 'SirVer/ultisnips.git'
Bundle 'vim-scripts/mayansmoke.git'
Bundle 'derekwyatt/vim-fswitch.git'
Bundle 'tpope/vim-fugitive.git'
Bundle 'scrooloose/nerdtree.git'
Bundle 'scrooloose/syntastic.git'
Bundle 'AndrewRadev/simple_bookmarks.vim.git'
Bundle 'guns/xterm-color-table.vim.git'
Bundle 'mattn/zencoding-vim.git'
Bundle 'Raimondi/delimitMate'
Bundle 'tikhomirov/vim-glsl'
Bundle 'mhinz/vim-signify'
Bundle 'vim-scripts/Tab-Name'
Bundle 'oinksoft/tcd.vim'
" Haskell dev plugins (for syntastic and definition of types)
Bundle 'bitc/vim-hdevtools'
" Perform ack from within vim! Look into replacing with unit's proc grep.
Bundle 'mileszs/ack.vim.git'
" Parameter / Argument text objects -- uses capitol 'P'.
Bundle 'vim-scripts/Parameter-Text-Objects.git'
" Slime
Bundle 'jpalardy/vim-slime.git'
" Alignment plugin
Bundle 'junegunn/vim-easy-align'
" Clever-f - gets rid of ; and , when searching. Replaced by 'f' and 'F'.
" Makes sense considering I never use multiple searches in a row.
" Removed because it was just getting in the way and jumping beyond the
" current line.
"Bundle 'rhysd/clever-f.vim.git'

" I pulled most of the javascript plugins from:
" https://github.com/joyent/node/wiki/Vim-Plugins
"
" Coffeescript support for vim. This is a more active fork of the original repo.
Bundle "kchmck/vim-coffee-script"
" Better syntax highlighting for javascript in VIM
Bundle "jelera/vim-javascript-syntax"
" Syntax highlighting for stylus (less verbose CSS language, much like
" Coffeescript is for javascript).
Bundle "wavded/vim-stylus"
" Full javascript completion engine that integrates with youcompleteme.
" (omnicomplete)
Bundle "marijnh/tern_for_vim"
" Color schemes
Bundle 'junegunn/seoul256.vim'
Bundle 'baskerville/bubblegum'

" Sparkup
Bundle 'rstacruz/sparkup', {'rtp' : 'vim/'}

" Vim wiki. Replacing my personal wiki. While this isn't a semantic wiki,
" there are better ways of tracking progress other than using a semantic wiki.
" Additionally there were HTTPS concerns with the full-blown wiki approach.
Bundle "vimwiki/vimwiki"

" Clang formatter for C++
Bundle 'rhysd/vim-clang-format'
Bundle 'kana/vim-operator-user'

" Alternative to powerline and airline.
"Bundle 'itchyny/lightline.vim'

" CtrlP was replaced by unite.
"Bundle 'kien/ctrlp.vim.git'

" Extended session tools
"Bundle 'xolox/vim-misc.git'
"Bundle 'xolox/vim-session.git'

" Plugins that I've tried but are currently disabled.
"Bundle 'majutsushi/tagbar.git'
"Bundle 'mattn/webapi-vim'
"Bundle 'mattn/gist-vim'
"Bundle 'def-lkb/merlin', {'rtp' : 'vim/'}

" Multiedit (haven't experimented with this)
"Bundle 'https://github.com/hlissner/vim-multiedit.git'
" Visual increment - unsure about carrying around this plugin. I never use it.
"Bundle 'vim-scripts/VisIncr.git'
" Powerline -- this is the new powerline
"Bundle 'Lokaltog/powerline.git'
" lldb debugger for vim. Official lldb repo.
" Using slime instead.
"Bundle 'http://llvm.org/git/lldb', {'rtp' : 'utils/vim-lldb/'}
"" Merlin for OCaml completion
"Bundle 'def-lkb/merlin', {'rtp' : 'vim/'}
" Railcasts colorscheme
"Bundle 'dhruvasagar/vim-railscasts-theme'
"" ZoomWin.git - replaces <C-w>o with zoom-in / zoom-out.
"Bundle 'vim-scripts/ZoomWin.git'
"" Gundo
"Bundle 'sjl/gundo.vim.git'
"" Plugin to automatically update tags when a file is modified.
"Bundle 'vim-scripts/AutoTag.git'
"" Switch.vim - use regular expressions to switch between vim elements.
"Bundle 'AndrewRadev/switch.vim'
" Latex box
"Bundle 'LaTeX-Box-Team/LaTeX-Box'
" Vim-seek. We use the '-' for seeking. '0', '-', and '\' are the only keys
" that are really available. May want to consider seek as 's' instead of
" leader.
"Bundle 'goldfeld/vim-seek.git'

" Plugins to think about installing:
" Indent_Guides
" Command-T
" SuperTab script #1643 -- Don't know if I need this.

" Possible future addons:
" buftabs - Displays a tab list in the emptyspace at the bottom of the screen.
"           Removed because I never used it.
" repmo   - Repeats a motion command (like 5j). But, it breaks several things.
"           It started breaking my f and t commands. And it also remaps
"           j so that I cannot map it to gj.
" yankring- Removed because it was appearing to interfere with macros. @@ in
"           particular. Macros in general, found a lighter weight alternative:
"           yankstack.
"           Note: This plugin is covered by unite.
" Scratch - Be wary of this plugin! It rebinds <esc>-s to :Scratch, which makes
"           escape behave oddly in normal mode.
" https://github.com/vimoutliner/vimoutliner.git -- Figure out how to get this
" to work with the files coming in from the wiki.
"           
" Bundle 'ervandew/supertab.git' - Was overriding <CR>. Causing conflict with
" delimit mate.
"
" (using this) delimitMate - Introduced a bug that caused cursor keys to insert A, B, C, D
"                            in insert mode.
"
" Git sessions -- saves sessions based off of the git branch and git dir.
"Bundle 'wting/gitsessions.vim.git'
" Stopped using this because I could not open single files from the command
" line. Instead this plugin would load a new session in its place.
"
"Bundle 'Rip-Rip/clang_complete.git'
" Used to use this, but it got surpassed by youcompleteme (which also include
" a goto definition in this translation unit).
"
" https://github.com/ptrin/JumpToCSS
" https://github.com/spiiph/vim-space
" RepeatLast - I like the idea, but it needs a little bit more work.
"Bundle 'vim-scripts/RepeatLast.vim'
"
" Rejected plugins:
" argtextobj - I couldn't get the text object to behave appropriately.
"
filetype plugin indent on


"-------------------------------------------------------------------------------
" Color scheme
"-------------------------------------------------------------------------------
"colorscheme seoul256      " Unified color scheme.

function! GetColourSchemeName()
  try
    return g:colors_name
  catch /^Vim:E121/
    return "default
  endtry
endfunction

set background=dark       " Default background is dark.
colorscheme xoria256      " Unified color scheme.
"colorscheme bubblegum
set background=dark       " Default background is dark.

"-------------------------------------------------------------------------------
" Keyboard bindings
"-------------------------------------------------------------------------------

" ---------------- Auxiliary functions ------------------
function! JHBGSetup()
  " I determined the XTerm(cterm) colors by using:
  " :Xtermcolortable
  if &background == "light"
    highlight ColorColumn ctermbg=253 guibg=White
  else
    " xoria
    highlight ColorColumn ctermbg=235 guibg=gray15
    " Bubblegum
    "highlight ColorColumn ctermbg=237 guibg=gray21
    " seoul256
    "highlight ColorColumn ctermbg=238 guibg=gray31
  endif
endfunction

" Toggle between light and dark backgrounds.
function! LightDarkToggle()
  if (&background == "light")
    set background=dark
    "colorscheme xoria256
    " xoria sets &background to light in the terminal!
    set background=dark
  else
    set background=light
    "colorscheme mayansmoke
  endif
  call JHBGSetup()
endfunc

" Function saved for future reference.
"function! JH_OpenDailyTodoList()
"  let templateFile=$HOME.'/me/self/daily/template'
"  let targDir=$HOME.'/me/self/daily/'.strftime("%Y/%m")
"  let targFile=targDir.'/'.strftime("%d")
"  if !isdirectory(targDir)
"    silent call mkdir(targDir, "p")
"  endif
"  " If the file does not exist populate it with the daily defaults.
"  " Use a unix command to do this
"  if !filereadable(targFile)
"    let readLines = readfile(templateFile)
"    call writefile(readLines, l:targFile)
"  endif
"  exe 'e '.targFile
"  exe 'let b:ctrlp_working_path_mode="wr"'
"endfunc

function! JH_OpenVimRC()
  exe 'e '.$HOME.'/.vimrc'
  exe 'let b:ctrlp_working_path_mode="wr"'
endfunc

function! JH_ArchiveLines(type, ...)
  let fname=expand('%:p:r').'.archive'
  " The output from getpos is a list. We are only retrieving the middle two
  " elems.
  let [lnum1, col1] = getpos("'[")[1:2]
  let [lnum2, col2] = getpos("']")[1:2]
  let lines = getline(lnum1, lnum2)
  " If we wanted the *exact* selection
  "let lines[-1] = lines[-1][: col2 - 2]
  "let lines[0] = lines[0][col1 - 1:]

  " Append the lines to the archive file
  if filereadable(fname)
    let archiveFileLines = readfile(fname)
  else
    let archiveFileLines = []
  endif

  " Append time to each of the lines we are pulling out of the todo file
  for line in lines
    let archiveFileLines = archiveFileLines + [strftime("%Y/%m/%d %H:%M - ".line)]
  endfor
  call writefile(archiveFileLines, fname)

  "echom join(lines, "\n")
  "exe '!echo "'.join(lines,"\n").'" >> '.fname

  " Now delete the lines from the current buffer.
  exe lnum1.','.lnum2."delete"
endfunc

" See: http://stackoverflow.com/questions/5825490/vim-command-with-count-and-motion-possible
function! JH_ArchiveExecuteCountOrMotion()
  setlocal operatorfunc=JH_ArchiveLines
  if v:count is 0
    return 'g@'
  else
    return 'g@g@'
  endif
endfunction

" Project specific directory.
let g:prosp_directory = $HOME.'/prosp'

" Utility {{{
function! s:IsVirtualFileSystem()
  return match(expand('%:p'), '^\w\+://.*') != -1
endfunction

function! s:IsNormalFile()
  return empty(&buftype)
endfunction

function! s:ChangeDirectory(directory)
  let cmd = g:rooter_use_lcd == 1 ? 'lcd' : 'cd'
  execute ':' . cmd . ' ' . fnameescape(a:directory)
endfunction

function! s:IsDirectory(pattern)
  return stridx(a:pattern, '/') != -1
endfunction
" }}}

function! s:HasProspDir(dir)
  " Get the path from the parent root directory to the user's home
  " directory.
  " \V turns on very nomagic mode. Only special regex characters accepted
  " must be escaped with \
  let searchExpr = '\V'.escape($HOME.'', '\')
  let homeToRoot = substitute(a:dir, searchExpr, '', '')

  let prospDir = g:prosp_directory . homeToRoot

  if isdirectory(prospDir)
    if filereadable(prospDir . '/.prosp')
      return 1
    else
      return 0
    endif
  else
    return 0
  endif
endfunction

function! s:SearchDownForProspDir(dir)
  " fnamemodify with :h removes last path component, see
  " http://stackoverflow.com/questions/16485748/vimscript-how-to-get-the-parent-directory-of-a-path-string
  let curDir = a:dir
  let homeDir = $HOME
  if s:HasProspDir(curDir)
    return curDir
  else
    if curDir ==# homeDir
      return ''
    else
      if curDir ==# '/'
        return ''
      else
        return s:SearchDownForProspDir(fnamemodify(curDir, ':h'))
      endif
    endif
  endif
endfunction

" Taken from: https://github.com/airblade/vim-rooter
" Great example of finding a parent directory containing a SCM dir.
function! s:FindInCurrentPath(pattern)
  let dir_current_file = fnameescape(expand('%:p:h'))

  if s:IsDirectory(a:pattern)
    let match = finddir(a:pattern, dir_current_file . ';')
    if empty(match)
      return ''
    endif
    return fnamemodify(match, ':p:h:h')
  else
    let match = findfile(a:pattern, dir_current_file . ';')
    if empty(match)
      return ''
    endif
    return fnamemodify(match, ':p:h')
  endif
endfunction


" Returns the root directory for the current file based on the list of
" known SCM directory names.
function! s:FindRootDirectory()

  " First attempt to see if the prosp directory already exists.
  let possibleRoot = expand('%:p:h')
  let prospRoot = s:SearchDownForProspDir(possibleRoot)

  " Now determine what it would be if we were to search based off of
  " common SCMs.
  let rooter_patterns = ['.git', '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']
  let result = ''
  for pattern in rooter_patterns
    let result = s:FindInCurrentPath(pattern)
    if !empty(result)
      break
    endif
  endfor

  " Take whichever path is larger.
  if strlen(prospRoot) > strlen(result)
    return prospRoot
  else
    return result
endfunction

function! s:OpenFileInProjectSpecificContext(file)
  " Check to see if the file exists without navigating to root.
  " This is plausible since we may want to have little 'havens' inside of
  " a git repo.

  let root = s:FindRootDirectory()
  if empty(root)
    " Just use the current file's directory as root if there is no
    " .git directory.
    let root = expand('%:p:h')
  endif

  " Remove the trailing slash off the end if it exists
  let fullpath = substitute(root, '\(\\\|\/\)$', '', '')

  " Get the path from the parent root directory to the user's home
  " directory.
  " \V turns on very nomagic mode. Only special regex characters accepted
  " must be escaped with \
  let searchExpr = '\V'.escape($HOME.'', '\')
  let homeToRoot = substitute(root, searchExpr, '', '')

  " Create the appropriate subdirectory within prosp
  let prospDir = g:prosp_directory . homeToRoot . '/' . fnamemodify(a:file, ":h:t")
  silent! call mkdir(prospDir, "p")
  echo prospDir

  " Open target file.
  exe 'e ' . g:prosp_directory . homeToRoot . '/' . a:file

  "" To get the name of *just* the parent directory of root, do the
  "" following:
  "let parentDir = fnamemodify(fullpath, ":t")
endfunction

function! JH_OpenContextTodo()
  call s:OpenFileInProjectSpecificContext('pdocs/todo')
endfunc

function! JH_OpenContextDebug()
  call s:OpenFileInProjectSpecificContext('pdocs/debug')
endfunc


" ---------------- System Specific Keybindings ------------------
" Bindings involving the command/windows key
" These bindings do not affect the console.
if has("mac") || has("macunix")"
  " Mac vim settings (disabling keyboard shortcuts and re-wiring). :help macvim
  " NOTE: See the .gvimrc file for these settings. They are necessary for
  " getting a small subset of the keybindings below to work.
  " I also disabled Hide MacVim (command-H) from the 
  " System Preferences -> Keyboard -> Shortcuts menu.

  " Remap 'alternate header and c file.
  nnoremap <silent> <D-'> :FSHere<CR>
  inoremap <silent> <D-'> <esc>:FSHere<CR>
  " Map goto definition (even in insert mode)
  " TODO: Replace: I no longer use eclim
  "nmap <silent> <D-m> :CSearchContext<CR>
  "imap <silent> <D-m> :CSearchContext<CR>
  " Map 'backspace to Cmd-H'. Also mapped to X in normal mode.
  nnoremap <silent> <D-h> dh
  inoremap <silent> <D-h> <BS>
  " Map Command-E to goto the end of the line.
  nnoremap <silent> <D-e> $l
  inoremap <silent> <D-e> <C-o>A
  " Map Command-A to goto the beginning of the line.
  nnoremap <silent> <D-a> ^
  inoremap <silent> <D-a> <C-o>I
  " Map Command-E to goto the end of the line.
  nnoremap <silent> <D-e> $l
  inoremap <silent> <D-e> <C-o>A
  " Map delete 
  nnoremap <silent> <D-d> x 
  inoremap <silent> <D-d> <C-o>x

  " Map word left / word right in insert mode
  " NOTE: This doesn't work because both <C-,> and <C-.> are not mappable.
  " See: http://stackoverflow.com/questions/8033779/
  "             is-there-a-way-to-map-ctrl-period-and-ctrl-comma-in-vim

elseif has("win32") || has("win64")
  " There is not a whole lot that we can do on windows.
  " The windows key doesn't appear to make it to cygwin or gvim.
  " So we will need to manually program those keystrokes using autohotkeys.
elseif has("win32unix")
  echom "Enabling light color scheme in cygwin."
  call LightDarkToggle()
endif

" ---------------- General VIM usability enhancements ------------------
" Think about organizing this section much like:
" https://github.com/terryma/dotfiles/blob/master/.vimrc
" does in his. He places the keys in succession, even if he doesn't
" rebind them to anything.

" Treat wrapped lines like normal lines when moving through them
" This interfers with 'goto relative line number'. BUT it appears easy-motion
" works with motion commands. As such we should just use easy motion to do our
" dirty work, and maybe gain some screen realestate!
" :h map-examples
"noremap  <silent> k gk
"noremap  <silent> j gj
"noremap  <silent> 0 g0
"noremap  <silent> $ g$

" Places a mark in the `'` buffer and moves the cursor. I only use 'j' and 'k'
" to move up and down through the files
" KEEP IN MIND: The exclamation after normal executes without regard to
" mappings. So, since we have remapped j and k, we use ! to get around this.
" http://learnvimscriptthehardway.stevelosh.com/chapters/29.html
" execute "normal! m`"|
" call setpos("'`", getpos("'`"))|
"noremap <silent> j :<C-U>execute "normal! m`" | execute "normal! " . v:count . "j"<CR>
"command! -nargs=1 JHMoveDown echo <args>."j"

" Had to use an intermediate variable because args disappears after the first
" pipe. Also, the -count parameter always passed in the line number instead of
" a count (it added the count ontop of the line number, hence resulting to
" <C-u> and v:count). C-u is required to stop the count from becoming a range
" (found this reference in the vimdocs).
" NOTE: We could also do gj and gk instead of j and k. But we need relative
" line numbering to include wrapped lines.
" The if statements account for the possibility of 0 being encountered within
" count. This resulted in a jump to the beginning of the line '0', then
" executing j or k.
" We also don't save the mark if no count was given to j or k.
"command! -nargs=1 JHMoveDown execute "let i = ".<args> | execute "if ".i." != 0 | execute 'normal! m`' | endif" | execute "if ".i." == 0 | execute 'normal! j' | else | execute 'normal! ".i."j' | endif"
"noremap <silent> j :<C-u>JHMoveDown(v:count)<CR>
"command! -nargs=1 JHMoveUp execute "let i = ".<args> | execute "if ".i." != 0 | execute 'normal! m`' | endif" | execute "if ".i." == 0 | execute 'normal! k' | else | execute 'normal! ".i."k' | endif"
"noremap <silent> k :<C-u>JHMoveUp(v:count)<CR>

" Copy the full path of the current file to the clipboard
nnoremap <silent> <Leader>fp :let @+=expand("%:p")<cr>:echo "Copied current file
      \ path '".expand("%:p")."' to clipboard"<cr>

" Remap paste mode to <leader>1
nnoremap <silent> <Leader>1 :set paste!<cr>

" U: Redos since 'u' undos
nnoremap U <c-r>

" H: Go to beginning of line. Repeated invocation goes to previous line
noremap <expr> H getpos('.')[2] == 1 ? 'k' : '^'

" L: Go to end of line. Repeated invocation goes to next line
" This doesn't actually work -- probably something to do with my virtual space
" settings.
noremap <expr> L <SID>end_of_line()
function! s:end_of_line()
  let l = len(getline('.'))
  if (l == 0 || l == getpos('.')[2]-1)
    return 'jg_'
  else
    return 'g_'
endfunction

" +/_: Increment number. Underscore makes sense: shift is used for both
"      + and _. Also, I'm using '-' as the leader key for unite.
nnoremap + <c-a>
nnoremap _ <c-x>

" Remap semicolon to colon and colon to semicolon. I don't use repeat last
" 'f' command very often.
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" We use the <C-h,j,k,l> keys for tmux. Instead, in vim, I switch windows with
" <space>h, <space>j, etc... These overwrite the bindings supplied by Also use
" <space>s and <space>- for splitting the windows.
nnoremap <silent> <space>- :vsplit<CR>
nnoremap <silent> <space>s :split<CR>

" Exits visual mode and initiates a search within the last visual selection.
vnoremap \ <Esc>/\%V

" Remap <C-W><C-W> to move to previously active buffer.
nnoremap <C-W><C-W> :wincmd p<CR>

" Mapping to run make command, but silent! Only pops open quick fix
" if there were errors. Still need to fix linker error recognition.
"noremap <leader>m :make \| :redraw! \| :botright :cw<cr>

" Color scheme extensions
noremap <silent> <leader>ow :call LightDarkToggle()<CR>

" Remap apostrophe to backtick
nnoremap ' `
nnoremap ` '

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
nnoremap Y y$

" Save file through sudo
cnoremap w!! %!sudo tee > /dev/null %

" List buffers and start command to goto one.
nnoremap gb :ls<CR>:b

" move the current line up and down
nnoremap <leader>k      :m-2<CR>==
nnoremap <leader>j      :m+<CR>==

nnoremap <silent><leader>d "_d

" Set an undo break on every 'return' key press in insert mode.
" Makes vim undo more granualar (well, per-line granularity)
" This is great, but interferes with delimit mate's expansion of return inside
" of expanded characters. So I modified it to also include delimit mates'
" CR.
"inoremap <CR> <C-G>u<CR>
silent! imap <CR> <C-g>u<Plug>delimitMateCR

" Remap ! as mark (will replace m eventually -- when a worthy command is found)
nnoremap ! m

" ---------------- Text transformations ------------------
" Convert inner word to upper case.
nnoremap <leader>tu g~iw

" Swap two characters
nnoremap <leader>tw "zylx"zp

" ---------------- Open/close semantic ------------------
" Close the current window.
" Close 'highlighting'.
" Close quick fix window.
" Close buffer: http://vim.wikia.com/wiki/Deleting_a_buffer_without_closing_the_window
noremap <silent> <leader>cc :close<CR>
noremap <silent> <leader>h :noh<CR>
noremap <silent> <leader>cb :Kwbd<CR>
" Consider the following binding to turn highlighting off:

" Open quick fix window.
" Open vimrc.
" Open todolist (if part of an applicable project).
" Open general todolist.
" Open nerdtree
noremap <silent> <leader>oq :copen<CR>
noremap <silent> <leader>oQ :cclose<CR>
noremap <silent> <leader>ov :call JH_OpenVimRC()<CR>
noremap <silent> <leader>x :call JH_OpenContextTodo()<CR>
noremap <silent> <leader>l :call JH_OpenContextDebug()<CR>
noremap <silent> <leader>ob :TagbarToggle<CR>
noremap <silent> <leader>ou :GundoToggle<CR>
noremap <silent> <leader>ol :lopen<cr>
noremap <silent> <leader>oL :lclose<cr>

" ---------------- Previous / Next ------------------

" Location list.
nnoremap <leader>nL :lprevious<CR>
nnoremap <leader>NL :lprevious<CR>
nnoremap <leader>nl :lnext<CR>

" ---------------- Maximal ------------------

" Location list
nnoremap <leader>ml :llast<CR>
nnoremap <leader>mL :lfirst<CR>
nnoremap <leader>ML :lfirst<CR>

" ---------------- Run semantic ------------------
" Run ctangs
" Run syntastic
" Run/source vimrc
" Run archive on lines
"noremap <leader>rt c!ctags -R<CR>
"noremap <leader>rs :SyntasticCheck<CR>
"noremap <leader>rl :sign unplace *<CR>:YcmForceCompileAndDiagnostics<CR>
"noremap <leader>rs :sign unplace *<CR>:YcmDiags<CR>
noremap <leader>rl :YcmForceCompileAndDiagnostics<CR>
noremap <leader>rs :YcmDiags<CR>
noremap <leader>rv :source ${HOME}/.vimrc<CR>
"noremap <leader>ra :write >> %:p:r.archive<CR>
" See: http://stackoverflow.com/questions/5825490/vim-command-with-count-and-motion-possible
noremap <expr> <leader>ra JH_ArchiveExecuteCountOrMotion()

" ---------------- Spell checking ------------------
noremap <leader>ss :setlocal spell!<CR>
noremap <leader>sn ]s
noremap <leader>sp [s
noremap <leader>sa zg
noremap <leader>sh z=

" ---------------- Tabularize ------------------
" Align on commas, leaving the commas in-place
noremap <leader>a= :Tabularize /=<CR>
noremap <leader>a, :Tabularize /,\zs/l1<CR>
noremap <leader>a: :Tabularize /:\zs<CR>

" ---------------- Fugitive keys ------------------
" http://vimcasts.org/episodes/fugitive-vim-working-with-the-git-index/
" help :diffget -- see: http://vimcasts.org/episodes/fugitive-vim-working-with-the-git-index/
" :diffget, :diffput, :diffupdate
" Resolve merge conflict by performing a 3-way diff:
" http://vimcasts.org/episodes/fugitive-vim-resolving-merge-conflicts-with-vimdiff/
" Lots of goodies and bindings for fugitive:
" http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/
" How to explore the history of a git repo:
" http://vimcasts.org/episodes/fugitive-vim-exploring-the-history-of-a-git-repository/
noremap <silent> <leader>gs :Gstatus<CR>
noremap <silent> <leader>gb :Gblame<CR>
noremap <silent> <leader>gc :Gcommit<CR>
noremap <silent> <leader>ge :Gedit<CR>
noremap <silent> <leader>gd :Gdiff<CR>
" Simply closes the other diff window (moves to it with C-h)
noremap <silent> <leader>gD <c-w>h<c-w>czR
noremap <silent> <leader>gw :Gwrite<CR>
noremap <silent> <leader>gr :Gread<CR>
noremap <silent> <leader>gl :Glog<CR>

" ---------------- CTSwitch keys ------------------
nnoremap <silent> <leader>oc :CTSHere<CR>

" ---------------- SkyBison keys ------------------
nnoremap <leader>b :<c-u>call SkyBison("")<cr>

" ---------------- NerdTree keys ------------------
" Finds the current file in nerdtree.
nnoremap <silent> <leader>nf :NERDTree<CR><C-w>p:NERDTreeFind<CR>
noremap <silent> <leader>nn :NERDTreeToggle<CR>

" ---------------- Slime ------------------
let g:slime_target = "tmux"
let g:slime_no_mappings = 1
xmap <leader>i <Plug>SlimeRegionSend
nmap <leader>i <Plug>SlimeMotionSend
nmap <leader>il <Plug>SlimeLineSend

" ---------------- Utl keys ------------------
" Open manual
"  " See: <url:vimhelp:uel#^a folder-URL. Utl.vim>
"<url:http://en.cppreference.com/mwiki/index.php\?title\=Special\%3ASearch\&search\=vector>
"nnoremap <silent> <leader>om :exe ":Utl ol http://en.cppreference.com/mwiki/index.php?title=Special%3ASearch&search=".expand("<cword>")<CR>:redraw!<CR>

function! JH_JumpToOnlineManual()
  if &filetype == 'vim'
    execute "Utl ol https://www.google.com/search?q=site%3Alearnvimscriptthehardway.stevelosh.com%2F%20".expand("<cword>")
  elseif &filetype == 'cpp'
    execute "Utl ol http://en.cppreference.com/mwiki/index.php\\\\?title=Special%3ASearch\\\\&search=".expand("<cword>")
  elseif &filetype == 'javascript'
    execute "Utl ol https://www.google.com/search?q=site%3Anodejs.org/api%2F%20".expand("<cword>")
  endif
  execute "redraw!"
endfunc

nnoremap <silent> <leader>om :call JH_JumpToOnlineManual()<CR>
"nnoremap <silent> <leader>om :exe ':Utl ol http://en.cppreference.com/mwiki/index.php\\\\?title=Special%3ASearch\\\\&search='.expand("<cword>")<CR>:redraw!<CR> 
nnoremap <silent> <leader>og :exe ':Utl ol https://www.google.com/search?q='.expand("<cword>")<CR>:redraw!<CR> 
nnoremap <silent> <leader>oh :Utl<CR>:redraw!<CR>

" ---------------- Unite keys ------------------
" <F1>: Help
nmap <F1> [unite]h

" ---------------- Vim-easy-align keys ------------------
vnoremap <silent> <Enter> :EasyAlign<Enter>

" ---------------- Vimwiki keys ------------------
nnoremap <silent> <leader>wo :VimwikiGoto 
nnoremap <silent> <leader>we :VimwikiSearch 
nmap <silent> <leader>wx <Plug>VimwikiToggleListItem


if has("gui_running")
  map <C-h> <C-w>h
  map <C-j> <C-w>j
  map <C-k> <C-w>k
  map <C-l> <C-w>l

  " Splits the current window in half. s = horizontal, S = vertical.
  noremap <C-_> :vsplit<CR>
  noremap <C-s> :split<CR>

  " Hacky but simple binding of C-b <number>
  nnoremap <C-b> <nop>
  nnoremap <C-b>1 1gt
  nnoremap <C-b>2 2gt
  nnoremap <C-b>3 3gt
  nnoremap <C-b>4 4gt
  nnoremap <C-b>5 5gt
  nnoremap <C-b>6 6gt
  nnoremap <C-b>7 7gt
  nnoremap <C-b>8 8gt
  nnoremap <C-b>9 9gt
  nnoremap <C-b>0 0gt
else
  " ---------------- Tmux pane integration ---------------
  " Maps <C-h/j/k/l> to switch vim splits in the given direction. If there are
  " no more windows in that direction, forwards the operation to tmux.
  " Additionally, <C-\> toggles between last active vim splits/tmux panes.
  " See: https://gist.github.com/mislav/5189704
  if exists('$TMUX')

    let s:tmux_is_last_pane = 0
    au WinEnter * let s:tmux_is_last_pane = 0

    " Like `wincmd` but also change tmux panes instead of vim windows when needed.
    function s:TmuxWinCmd(direction)
      let nr = winnr()
      let tmux_last_pane = (a:direction == 'p' && s:tmux_is_last_pane)
      if !tmux_last_pane
        " try to switch windows within vim
        exec 'wincmd ' . a:direction
      endif
      " Forward the switch panes command to tmux if:
      " a) we're toggling between the last tmux pane;
      " b) we tried switching windows in vim but it didn't have effect.
      if tmux_last_pane || nr == winnr()
        let cmd = 'tmux select-pane -' . tr(a:direction, 'phjkl', 'lLDUR')
        call system(cmd)
        let s:tmux_is_last_pane = 1
        echo cmd
      else
        let s:tmux_is_last_pane = 0
      endif
    endfunction

    " navigate between split windows/tmux panes
    nnoremap <c-j> <ESC>:call <SID>TmuxWinCmd('j')<cr>
    inoremap <c-j> <ESC>:call <SID>TmuxWinCmd('j')<cr>
    nnoremap <c-k> <ESC>:call <SID>TmuxWinCmd('k')<cr>
    inoremap <c-k> <ESC>:call <SID>TmuxWinCmd('k')<cr>
    nnoremap <c-h> <ESC>:call <SID>TmuxWinCmd('h')<cr>
    inoremap <c-h> <ESC>:call <SID>TmuxWinCmd('h')<cr>
    nnoremap <c-l> <ESC>:call <SID>TmuxWinCmd('l')<cr>
    inoremap <c-l> <ESC>:call <SID>TmuxWinCmd('l')<cr>
    nnoremap <c-\> <ESC>:call <SID>TmuxWinCmd('p')<cr>
    inoremap <c-\> <ESC>:call <SID>TmuxWinCmd('p')<cr>
  end
end

"-------------------------------------------------------------------------------
" Addon settings
"-------------------------------------------------------------------------------

" ---------------- Signify ------------------
let g:signify_vcs_lst = [ 'git', 'svn' ]

let g:signify_mapping_next_hunk = '<leader>gj'
let g:signify_mapping_prev_hunk = '<leader>gk'

let g:signify_mapping_toggle_highlight = '<leader>gh'
let g:signify_mapping_toggle           = '<leader>gt'

let g:signify_sign_overwrite = 0

let g:signify_cursorhold_normal = 0
let g:signify_cursorhold_insert = 0

highlight SignifySignAdd cterm=bold ctermbg=237 ctermfg=119
highlight SignifySignDelete cterm=bold ctermbg=237 ctermfg=167
highlight SignifySignChange cterm=bold ctermbg=237 ctermfg=227

" Must manually toggle signify (if you want navigation).
" Toggle with :SignifyToggle (mapped to <leader>gt above)
let g:signify_disable_by_default = 1

" ---------------- EasyMotion ------------------
let g:EasyMotion_leader_key = '<space>'
let g:EasyMotion_keys       = 'htnsbcfgijklpzqrvmwaoeu'

call EasyMotion#InitOptions({
      \   'leader_key'      : '<space><space>'
      \ , 'keys'            : 'htnsbcfgijklpzqrvmwaoeu'
      \ , 'do_shade'        : 1
      \ , 'do_mapping'      : 1
      \ , 'grouping'        : 1
      \
      \ , 'hl_group_target' : 'Question'
      \ , 'hl_group_shade'  : 'EasyMotionShade'
      \ })

" ---------------- Syntastic ---------------- 
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_always_populate_loc_list=1
let g:syntastic_enable_highlighting = 0


" ---------------- CtrlP ---------------- 
" Set control-p up to search for the root directory of the current file.
" The root directory has a .git, .hg, .svn, .bzr, or _darcs in it.
let g:ctrlp_working_path_mode = 'rwa'
let g:ctrlp_match_window_bottom = 0     " Place match window at the top.
let g:ctrlp_match_window_reversed = 0   " Same as default Command-T listing.
let g:ctrlp_switch_buffer = 0           " Always open window, even if open.
let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
      \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']
let g:ctrlp_max_height = 30

" ---------------- YouCompleteMe ---------------- 
"let g:ycm_add_preview_to_completeopt = 1
"let g:ycm_autoclose_preview_window_after_completion = 0
"let g:ycm_autoclose_preview_window_after_insertion = 1
"let g:ycm_filetype_specific_completion_to_disable = {
"      \ 'markdown':0,
"      \ 'cpp':0
"      \}
let g:ycm_key_invoke_completion = '<C-a>'
" White list everythin in sci and sand.
let g:ycm_extra_conf_globlist = ['~/sci/*', '~/sand/*']
" Definitely do NOT want youcompleteme active in unite.
let g:ycm_filetype_blacklist = {
      \ 'notes' : 1,
      \ 'markdown' : 1,
      \ 'text' : 1,
      \ 'unite' : 1,
      \}
let g:ycm_complete_in_strings = 0

let g:ycm_min_num_of_chars_for_completion = 2

nnoremap <silent><leader>e :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <silent><leader>yc :YcmCompleter ClearCompilationFlagCache<CR>

" ----------------- UltiSnips ----------------
so ~/.vim/UltiSnips/UltiSnipHelpers.vim
" It is legal to set the expand trigger and the jump forward trigger to the
" same value.
let g:UltiSnipsExpandTrigger="<C-e>"
let g:UltiSnipsJumpForwardTrigger="<C-e>"
let g:UltiSnipsJumpBackwardTrigger="<C-i>"

" ----------------- CommandT -----------------
" We place the match window at the top of the screen because of laptop use.
" My fingers often obscure the very bottom of the screen.
let g:CommandTMatchWindowAtTop=1

" I would like it to take up half of the screen, but this is a good 
" guesstimation.
let g:CommandTMaxHeight=40

" ----------------- Tagbar ----------------
let g:tagbar_autoclose=1
let g:tagbar_autofocus=1

"set guifont=Source\ Code\ Pro:h14
set guifont=Menlo:h14
" Another useful way of changing the font in macvim is :set gfn=*
" This will open up a font dialog where you can choose your font.

" ----------------- Protodef ----------------
let g:protodefprotogetter='$HOME/.vim/bundle/vim-protodef/pullproto.pl'
let g:protodefctagsexe='/usr/local/bin/ctags'

" ----------------- CTSwitch ----------------
" CTSwitch switches between test code and the current code.
augroup ctswitch
  au!
  au BufEnter *.h,*.hpp,*.c,*.cpp,*.cxx let b:ctswitchdst = 'cc' 
        \ | let b:ctswitchlocs = '../Tests,./Tests'
        \ | let b:ctswitchprefixes = 'Test,UTest'
  au BufEnter *.cc let b:ctswitchdst = 'h,hpp,cpp,cxx,c' 
        \ | let b:ctswitchlocs = '..'
        \ | let b:ctswitchprefixes = 'Test,UTest'
augroup END

" ----------------- FSwitch ----------------
" FSwitch auto execute mappings.
augroup fswitch
  au!
  au BufEnter *.c,*.cpp,*.cc,*.cxx,*.mm,*.m let b:fswitchdst = 'hpp,h' | let b:fswitchlocs = '.,../inc'
  au BufEnter *.hpp,*.h let b:fswitchdst = 'cpp,cc,cxx,c,mm,m'
augroup END

" ----------------- Simple bookmarks ----------------
let g:simple_bookmarks_filename = '~/self/unix/vim/vim_bookmarks'

" ----------------- Instant Markdown ----------------
" Only refresh the page when saved, or after a while of no input.
let g:instant_markdown_slow = 1

" ----------------- Delimit Mate ----------------
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_balance_matchpairs = 1

" Disable delimit mate in unite buffers.
au FileType unite let b:delimitMate_autoclose = 0

" ---------------- ZenCoding ------------------
let g:user_zen_leader_key = '<c-f>'

" ---------------- Sessions ------------------
" We don't want to be asked to autosave sessions.
let g:session_autosave = 'no'

" ---------------- vim-seek ------------------
"let g:SeekKeys = '- _ 0 +'
"let g:SeekKey = '-'
"let g:SeekBackKey = '_'

" ---------------- sparkup ------------------
let g:sparkupExecuteMapping = '<c-a>'
let g:sparkupNextMapping = '<c-n>'

" ---------------- vim-wiki ------------------
let g:vimwiki_list = [
      \{'path':              '~/me/wiki/central',
      \ 'template_path':     '~/me/wiki/templates',
      \ 'template_default':  'default',
      \ 'template_ext':      '.html'}]
let g:vimwiki_url_maxsave = 0


" ---------------- clang_format ------------------

let g:clang_format#code_style = 'llvm'

let g:clang_format#style_options = {
            \ "AllowShortIfStatementsOnASingleLine" : "true",
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "BreakBeforeBraces": "Linux",
            \ "Standard" : "C++11"}

let g:clang_format#command = 'clang-format-3.4'

" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>

" ----------------- Utl ----------------
if has("win32")
  " Windows
endif
" We prefer this style of detecting the platform because it will detect 
" the console version of vim appropriately.
if has("unix")
  "if system('uname')=~'Darwin'
  let g:utl_cfg_hdl_scm_http_system="silent !open /Applications/Firefox.app %u"
  let g:utl_cfg_hdl_mt_generic="silent !open %p"
  "else
  "endif
endif

"if has("mac") || has("macunix")
"  let g:utl_cfg_hdl_scm_http_system="silent !open /Applications/Firefox.app %u"
"  let g:utl_cfg_hdl_mt_generic="silent !open %p"
"  " TODO: Instead of using VIM as the directory browser, use:
"  " http://technotales.wordpress.com/2007/10/03/like-slime-for-vim/
"  " We can call tmux directly from VIM.
"  " See: <url:vimhelp:utl#^a folder-URL. Utl.vim>
"
"  " Utl has a lot of nice features such as executing vimscript:
"  " <url:vimscript:split|call input('I will open a new window now!')>
"  " See: <url:vimhelp:utl#^3.11 The Vimscript scheme>
"
"  " Can lookup words (or possibly references at cpp reference) by doing:
"  " nmap ,l :exe ":Utl ol http://dict.leo.org/?search=" . expand("<cword>")
"  " See: <url:vimhelp:utl#^Lookup word>
"
"  " For backup examples / compiling latex: <url:vimhelp:utl#Using vimscript URL for backup>
"
"  " You can even setup costum schemes, see the bug tracker example
"  " <url:vimhelp:utl#Reference your bug tracker database>
"
"" suggested mappings for most frequent commands  [id=suggested_mappings] [
""
"" nmap <unique> <Leader>ge :Utl openLink underCursor edit<CR>
"" nmap <unique> <Leader>gu :Utl openLink underCursor edit<CR>
"" nmap <unique> <Leader>gE :Utl openLink underCursor split<CR>
"" nmap <unique> <Leader>gS :Utl openLink underCursor vsplit<CR>
"" nmap <unique> <Leader>gt :Utl openLink underCursor tabedit<CR>
"" nmap <unique> <Leader>gv :Utl openLink underCursor view<CR>
"" nmap <unique> <Leader>gr :Utl openLink underCursor read<CR>
""
""					[id=suggested_mappings_visual]
"" vmap <unique> <Leader>ge "*y:Utl openLink visual edit<CR>
"" vmap <unique> <Leader>gu "*y:Utl openLink visual edit<CR>
"" vmap <unique> <Leader>gE "*y:Utl openLink visual split<CR>
"" vmap <unique> <Leader>gS "*y:Utl openLink visual vsplit<CR>
"" vmap <unique> <Leader>gt "*y:Utl openLink visual tabedit<CR>
"" vmap <unique> <Leader>gv "*y:Utl openLink visual view<CR>
"" vmap <unique> <Leader>gr "*y:Utl openLink visual read<CR>
""
""
"" nmap <unique> <Leader>cfn :Utl copyFileName underCursor native<CR>
"" nmap <unique> <Leader>cfs :Utl copyFileName underCursor slash<CR>
"" nmap <unique> <Leader>cfb :Utl copyFileName underCursor backSlash<CR>
""
"" vmap <unique> <Leader>cfn "*y:Utl copyFileName visual native<CR>
"" vmap <unique> <Leader>cfs "*y:Utl copyFileName visual slash<CR>
"" vmap <unique> <Leader>cfb "*y:Utl copyFileName visual backSlash<CR>
""
""
"" nmap <unique> <Leader>cl :Utl copyLink underCursor<CR>
""
"" vmap <unique> <Leader>cl "*y:Utl copyLink visual<CR>
""
"
"endif

"===============================================================================
" Unite
"===============================================================================

"call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#custom#source('file,file_rec', 'sorters', 'sorter_rank')
call unite#custom#source('file,file/new,buffer,file_rec,file_rec/async,file_mru,outline',
      \ 'matchers', 'matcher_fuzzy')

" Set up some custom ignores
call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
      \ 'ignore_pattern', join([
      \ '\.git/',
      \ 'git5/.*/review/',
      \ 'google/obj/',
      \ 'bin/',
      \ '3rdParty/',
      \ '.*\.png',
      \ 'node_modules/',
      \ '\.gitignore',
      \ 'Externals/',
      \ 'externals/',
      \ '\.svn/'
      \ ], '\|'))

" Ensure we ignore appropriate files.
let g:unite_source_rec_async_command='ag --nocolor --nogroup --ignore ".hg" --ignore ".svn" --ignore ".git" --ignore ".bzr" --hidden -g ""'


" Map '-' to the prefix for Unite. Makes sense on dvorak keyboards (next to
" semicolon).
nnoremap [unite] <Nop>
nmap <leader>u [unite]

"nnoremap <silent> [unite]t :<C-u>UniteWithCurrentDir
"	        \ -buffer-name=files buffer file_mru bookmark file<CR>

" General fuzzy search
"nnoremap <silent> [unite]<space> :<C-u>Unite -no-split -buffer-name=files buffer file_mru bookmark file_rec/async:!<CR>
"nnoremap <silent> [unite]<space> :<C-u>Unite -no-split -buffer-name=files file_mru file_rec/async:!<CR>
"nnoremap <silent> <C-p> :<C-u>Unite -no-split -buffer-name=files file_mru file_rec/async:!<CR>
" Remember, order matters!
nnoremap <silent> <C-p> :<C-u>Unite -no-split -buffer-name=files file_rec/async<CR>
"nnoremap <silent> <C-p> :<C-u>Unite -no-split -buffer-name=files file_rec file_mru<CR>
" The exclamation after file_rec/async implies that vim should search for the
" nearest directory containing a '.git', '.hg', etc... see
" unite-source-file_rec.
nnoremap <silent> [unite]u :<C-u>Unite -no-split -buffer-name=files file_rec:! file_mru<CR>
"nnoremap <silent> [unite]u :<C-u>Unite -buffer-name=files file_mru file_rec:!<CR>

" Search current working directory
nnoremap <silent> [unite]f :<C-u>Unite -no-split -buffer-name=files -start-insert file<CR>

" Quick registers
"nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
" Unite resume
nnoremap <silent> [unite]r :<C-u>UniteResume -no-split<CR>

" Quick buffer and mru
nnoremap <silent> [unite]b :<C-u>Unite -no-split -buffer-name=buffers buffer file_mru<CR>

" Quick yank history
nnoremap <silent> [unite]y :<C-u>Unite -buffer-name=yanks history/yank<CR>

" Quick outline
nnoremap <silent> [unite]o :<C-u>Unite -no-split -buffer-name=outline -vertical outline<CR>

" Quick tags
nnoremap <silent> [unite]t :<C-u>Unite -buffer-name=tags -vertical tag<CR>

" Quick sessions (projects)
nnoremap <silent> [unite]p :<C-u>Unite -buffer-name=sessions session<CR>

" Quick sources
nnoremap <silent> [unite]a :<C-u>Unite -buffer-name=sources source<CR>

" Quick snippet
nnoremap <silent> [unite]s :<C-u>Unite -buffer-name=snippets snippet<CR>

" Quickly switch lcd
"nnoremap <silent> [unite]d
"      \ :<C-u>Unite -buffer-name=change-cwd -default-action=lcd directory_mru<CR>

" Quick file search
"nnoremap <silent> [unite]f :<C-u>Unite -buffer-name=files file_rec/async file/new<CR>

" Quick grep from cwd
nnoremap <silent> [unite]g :<C-u>Unite -buffer-name=grep grep:.<CR>

" Quick help
nnoremap <silent> [unite]h :<C-u>Unite -buffer-name=help help<CR>

" Quick line using the word under cursor
nnoremap <silent> [unite]l :<C-u>UniteWithCursorWord -buffer-name=search_file line<CR>

" Quick MRU search
nnoremap <silent> [unite]m :<C-u>Unite -buffer-name=mru file_mru<CR>

" Quick find
nnoremap <silent> [unite]n :<C-u>Unite -buffer-name=find find:.<CR>

" Quick commands
nnoremap <silent> [unite]c :<C-u>Unite -buffer-name=commands command<CR>

" Quick jumps
nnoremap <silent> [unite]j :<C-u>Unite -buffer-name=jumps jump<CR>

" Quick bookmarks
"nnoremap <silent> [unite]b :<C-u>Unite -buffer-name=bookmarks bookmark<CR>

" Quickly search from buffer directory.
nnoremap <silent> [unite]d  :<C-u>UniteWithBufferDir
      \ -buffer-name=files -prompt=%\  buffer file_mru bookmark file<CR>

" Fuzzy search from current buffer
" nnoremap <silent> [unite]b :<C-u>UniteWithBufferDir
" \ -buffer-name=files -prompt=%\ buffer file_mru bookmark file<CR>

"" Quick commands
"nnoremap <silent> [unite]; :<C-u>Unite -buffer-name=history history/command command<CR>
"
"" Custom Unite settings
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()

  " Todo: Unite re-assigns both C-l and C-h for default mappings. Other than
  " editing the unite code directly, we need to find a way to either tell
  " unite not to bind these keys or re-bind the tmux keys.

  imap <buffer> <C-n> <Plug>(unite_select_next_page)
  imap <buffer> <C-p> <Plug>(unite_select_previous_page)

  " Transpose window changes unite's splitting direction.
	"nmap <buffer> <C-z> <Plug>(unite_toggle_transpose_window)
	"imap <buffer> <C-z> <Plug>(unite_toggle_transpose_window)
  nmap <buffer> <C-c> <Plug>(unite_exit)
  imap <buffer> <C-c> <Plug>(unite_exit)
  imap <buffer> <c-a> <Plug>(unite_choose_action)
  imap <buffer> <C-w> <Plug>(unite_delete_backward_word)
  imap <buffer> <C-u> <Plug>(unite_delete_backward_path)
  " Quick match is awesome! I use this all of the time.
  imap <buffer> ' <Plug>(unite_quick_match_default_action)
  nmap <buffer> ' <Plug>(unite_quick_match_default_action)
  nmap <buffer> <C-r> <Plug>(unite_redraw)
  imap <buffer> <C-r> <Plug>(unite_redraw)
  " The following doesn't work because we rebound these keys in tmux already.
  "inoremap <silent><buffer><expr> <C-s> unite#do_action('split')
  "nnoremap <silent><buffer><expr> <C-s> unite#do_action('split')
  "inoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
  "nnoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')

  " Renaming files from the unite buffer... based on the buffer names we have
  " been assigning to unite.
  let unite = unite#get_current_unite()
  if unite.buffer_name =~# '^search'
    nnoremap <silent><buffer><expr> r unite#do_action('replace')
  else
    nnoremap <silent><buffer><expr> r unite#do_action('rename')
  endif

  " Press 'cd' in normal mode will change vim's current directory to that of
  " the selected file.
  nnoremap <silent><buffer><expr> cd unite#do_action('lcd')

  " Using Ctrl-\ to trigger outline, so close it using the same keystroke
  if unite.buffer_name =~# '^outline'
    imap <buffer> <C-\> <Plug>(unite_exit)
  endif

  " Using Ctrl-/ to trigger line, close it using same keystroke
  if unite.buffer_name =~# '^search_file'
    imap <buffer> <C-_> <Plug>(unite_exit)
  endif

	nnoremap <buffer><expr> S      unite#mappings#set_current_filters(
	        \ empty(unite#mappings#get_current_filters()) ? ['sorter_reverse'] : [])
endfunction

" Start in insert mode
let g:unite_enable_start_insert = 1

" Enable short source name in window
" let g:unite_enable_short_source_names = 1

" Enable history yank source
let g:unite_source_history_yank_enable = 1

" Shorten the default update date of 500ms
"let g:unite_update_time = 200

let g:unite_source_file_mru_limit = 200
let g:unite_cursor_line_highlight = 'TabLineSel'
" let g:unite_abbr_highlight = 'TabLine'

" For optimization leave unite_source_file_mru_filename_format empty.
let g:unite_source_file_mru_filename_format = ''
"let g:unite_source_file_mru_filename_format = ':~:.'
let g:unite_source_file_mru_time_format = ''

" I tend to have relative line numbering turned on, so it's quicker to just
" type (apstrophe)-relative line number. That's the way this table is setup.
let g:unite_quick_match_table =
      \ get(g:, 'unite_quick_match_table', {
      \     '1' : 0, '2' : 1, '3' : 2, '4' : 3, '5' : 4, '6' : 5, '7' : 6, '8' : 7, '9' : 8, 'a' : 9,
      \     'o' : 10, 'e' : 11, 'u' : 12, 'h' : 13, 't' : 14, 'n' : 15, 's' : 16, 'p' : 17, 'g' : 18, 'c' : 19,
      \     'r' : 20, 'l' : 21, 'q' : 22, 'j' : 23, 'k' : 24, 'b' : 25, 'm' : 26, 'w' : 27, 'v' : 28, 'z' : 29,
      \ })

" For ack.
if executable('ack-grep')
  let g:unite_source_grep_command = 'ack-grep'
  " Match whole word only. This might/might not be a good idea
  let g:unite_source_grep_default_opts = '--no-heading --no-color -a -w'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ack')
  let g:unite_source_grep_command = 'ack'
  let g:unite_source_grep_default_opts = '--no-heading --no-color'
  let g:unite_source_grep_recursive_opt = ''
endif

" Ability to use -no-split. Affects resume.
augroup unite
  au!
  "au BufLeave \[unite\]* if "nofile" ==# &buftype | setlocal bufhidden=wipe | endif
  autocmd BufLeave \*unite\** if "nofile" ==# &buftype | setlocal bufhidden=wipe | endif
  autocmd BufLeave \[unite\]* if "nofile" ==# &buftype | setlocal bufhidden=wipe | endif
augroup END

"-----------------------------------------------------------------------------
" Custom au c/cpp
"-----------------------------------------------------------------------------

" Derek Wyatt's bindings in protodey needed to be nnoremap instead of nmap
" (probably something funky to do with my vim rc or extensions)..
function! JHMakeMapping()
  if !exists('g:disable_protodef_mapping')
    nnoremap <buffer> <silent> <leader>PP :set paste<cr>i<c-r>=protodef#ReturnSkeletonsFromPrototypesForCurrentBuffer({})<cr><esc>='[:set nopaste<cr>
    nnoremap <buffer> <silent> <leader>PN :set paste<cr>i<c-r>=protodef#ReturnSkeletonsFromPrototypesForCurrentBuffer({'includeNS' : 0})<cr><esc>='[:set nopaste<cr>
  endif
endfunction

augroup jh_ccpp
  au!
  " Pretty sure that setting the foldmethod=syntax slowed VIM down GREATLY
  " when I was using youcompleteme and easymotion in CPP files.
  "au BufAdd *.c,*.cpp,*.cc,*.cxx,*.h,*.hpp set foldmethod=syntax
  "      \ | set foldlevel=9999
  au BufEnter *.cpp,*.C,*.cxx,*.cc,*.CC call JHMakeMapping()
augroup END

"-----------------------------------------------------------------------------
" Markdown files
"-----------------------------------------------------------------------------
augroup jh_markdown
  au!
  au BufEnter *.md,*.mkd set formatoptions=tq
        \ | set textwidth=78
  au BufLeave *.md,*.mkd set formatoptions=ql
        \ | set textwidth=0
augroup END

"-----------------------------------------------------------------------------
" OCaml
"-----------------------------------------------------------------------------
augroup jh_ocaml
  au!
  au BufNewFile,BufRead *.eliom set filetype=ocaml
augroup END

"-----------------------------------------------------------------------------
" Color schemes / general aesthetics
"-----------------------------------------------------------------------------

" ---------------- Mayan smoke color setup ------------------
let g:mayansmoke_search_visibility = 2
let g:mayansmoke_cursor_line_visibility = 2
let g:mayansmoke_special_key_visibility = 2

" ---------------- Color column ------------------
set colorcolumn=81
call JHBGSetup()
hi! link SignColumn LineNr

" Keep the following at the bottom of the file!

" Source the :Man command from sources included in vim distro
runtime ftplugin/man.vim
runtime macros/matchit.vim

" Never continue a comment when using 'o' or 'O' in normal mode.
" Comments will only be continued when in insert mode.
autocmd FileType * setlocal formatoptions-=o

