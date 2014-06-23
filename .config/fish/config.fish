# non-interactive users (scp, a...)
if not status --is-interactive
  exit # skips the rest of this file; does not actually exit the shell!
end

# Attach tmux.
#if test -z $TMUX
#  tmux att
#end

set BROWSER open

# Configure autojump.
. (brew --prefix)/Cellar/autojump/HEAD/etc/autojump.fish

# MANPATH should NOT be set on Mac OS X. See 'man manpath'. Or run 'man -w'.

# The -x exports the variable.
set -x PATH $HOME/.opam/system/bin $HOME/.cabal/bin /usr/local/sbin \
      /usr/local/bin /usr/local/share/npm/bin $HOME/sw/bin $HOME/.tmuxifier/bin \
      /usr/local/opt/ruby/bin /Applications/git-annex.app/Contents/MacOS $PATH
set -x EDITOR /usr/local/bin/vim
set -x OCAML_TOPLEVEL_PATH $HOME/.opam/system/lib/toplevel
set -x CAML_LD_LIBRARY_PATH $HOME/.opam/system/lib/stublibs \
      /usr/local/lib/ocaml/stublibs
set -x TMUXIFIER_LAYOUT_PATH $HOME/.tmuxifier_layouts
set -x CPM_CACHE_DIR $HOME/.cpm_cache
set -x IGNOREOF 10
set -o ignoreeof

# Set ag as the default source for fzf
set -x FZF_DEFAULT_COMMAND 'ag -l -g ""'
set -x FZF_DEFAULT_OPTS '--sort 10000'

# Completions from current directory ONLY
set CDPATH .

# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow

# Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '↑'
set __fish_git_prompt_char_upstream_behind '↓'

# Load external scripts.
. ~/.config/fish/gnupg.fish

function man
  vim -c "Man $argv" -c "only"
end

function g
  git $argv
end

function gs
  git status $argv
end

function v
  vim $argv
end

function vi
  vim $argv
end

function p
  pro $argv
end

function t
  task $argv
end

function tt
  set my_count (count $argv)
  if test $my_count -gt 0
    if test "$argv" = "out"
      # Always sync when we indicate we are checking out. This can happen
      # even after jout if it is the only thing left.
      timetrap out
      echo 'Syncing checkout...'
      eval '~/me/scripts/performSync'
      echo 'Done'
    else
      timetrap $argv
    end
  else
    timetrap today all
  end
end

function nu
  octave -q --eval "$argv"
end

function mutt
  bash --login -c 'cd ~/Desktop; /usr/local/bin/mutt' $argv;
end

function blog
  cd ~/web/blog/posts
end

function gc
  gcalcli $argv
end

function lh
  open http://localhost:8080/
end

function fish_vi_cursor
    # switch $fish_bind_mode
    #     case insert
    #         printf '\e]50;CursorShape=1\x7'
    #     case default
    #         printf '\e]50;CursorShape=0\x7'
    #     case "*"
    #         printf '\e]50;CursorShape=0\x7'
    # end

  set -l uses_echo

  set fcn
  set fcn __fish_cursor_konsole
  set uses_echo 1

  set -l tmux_prefix
  set -l tmux_postfix
  if begin; set -q TMUX; and set -q uses_echo[1]; end
    set tmux_prefix echo -ne "'\ePtmux;\e'"
    set tmux_postfix echo -ne "'\e\\\\'"
  end

  set -q fish_cursor_unknown
  or set -g fish_cursor_unknown block blink

  echo "
  function fish_vi_cursor_handle --on-variable fish_bind_mode
    set -l varname fish_cursor_\$fish_bind_mode
    if not set -q \$varname
      set varname fish_cursor_unknown
    end
    #echo \$varname \$\$varname
    $tmux_prefix
    $fcn \$\$varname
    $tmux_postfix
  end
  " | source
end

set fish_cursor_default underscore
set fish_cursor_insert block
set fish_cursor_visual line

fish_vi_cursor

# Source fzf key bindings.
. $HOME/.config/fish/functions/fzf_key_bindings.fish

function fish_user_key_bindings

  fish_vi_key_bindings

  # Note, this call to fzf_key_bindings should come after fish_vi_key_bindings.
  # I've had to modify this function slightly so that it indicates -M insert
  # mode as its primary mode hook.
  fzf_key_bindings

  # Rebind fzf keys to appropriate functions.
  bind \ct -M insert '__fzf_ctrl_t'
  bind \cr -M insert '__fzf_ctrl_r'
  bind \ec -M insert '__fzf_alt_c'

  #-------------------------
  # Insert mode keybindings
  #-------------------------
  bind \cw -M insert backward-kill-word
  bind \cc -M insert 'echo; commandline ""'

  # Something to remember:
  # -M is the mode in which the keybinding applies (default is normal).
  # -m is the mode in which we are left after the keybinding
  #    is executed. If no -m is specified, then it is assumed
  #    to be the same as -M.
  bind \cc -M default -m insert 'echo; commandline ""'
end

function mutty
  bash --login -c '/usr/local/bin/mutt' $argv;
end

function l
  ls
end

function s
  ls
end

function mux
  tmuxifier $argv
end

function muxs
  tmuxifier load-session $argv
end

# Fish prompt that includes git.
function fish_prompt
  set last_status $status

  set_color $fish_color_cwd
  printf '%s' (prompt_pwd)
  set_color normal

  #printf '%s ' (__fish_git_prompt)
  printf ' '

  printf '{'
  set_color 16759E
  printf '%s' (hostname|cut -d . -f 1)
  set_color normal
  printf '} '

  #$vi_mode
  #printf '[%s] ' $fish_bind_mode

  set_color normal
end

