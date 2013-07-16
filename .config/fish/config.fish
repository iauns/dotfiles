# non-interactive users (scp, a...)
if not status --is-interactive
  exit # skips the rest of this file; does not actually exit the shell!
end

set BROWSER open

# MANPATH should NOT be set on Mac OS X. See 'man manpath'. Or run 'man -w'.

# The -x exports the variable.
set -x PATH $HOME/.opam/system/bin $HOME/.cabal/bin /usr/local/sbin \
      /usr/local/bin /usr/local/share/npm/bin $HOME/sw/bin $HOME/.tmuxifier/bin \
      /usr/local/opt/ruby/bin $PATH
set -x EDITOR /usr/local/bin/vim
set -x OCAML_TOPLEVEL_PATH $HOME/.opam/system/lib/toplevel
set -x CAML_LD_LIBRARY_PATH $HOME/.opam/system/lib/stublibs \
      /usr/local/lib/ocaml/stublibs
set -x TMUXIFIER_LAYOUT_PATH $HOME/.tmuxifier_layouts
set -x IGNOREOF 10
set -o ignoreeof

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

function man
  vim -c "Man $argv" -c "only"
end

function g
  git $argv
end

function v
  vim $argv
end

function q
  exit
end

function p
  pro $argv
end

function vi
  vim $argv
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

function gs
  git status $argv
end

function gc
  git commit $argv
end

function lh
  open http://localhost:8080/
end

# fish vi-mode
. $HOME/.config/fish/vi-mode.fish

function fish_user_key_bindings
  vi_mode_insert
end

function mutty
  bash --login -c '/usr/local/bin/mutt' $argv;
end

function l
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

  printf '%s ' (__fish_git_prompt)

  printf '{'
  set_color 16759E
  printf '%s' (hostname|cut -d . -f 1)
  set_color normal
  printf '} '

  printf '[%s] ' $vi_mode

  set_color normal
end

