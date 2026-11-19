# Interactive-only guard
case $- in
  *i*) ;;
    *) return ;;
esac

# ble.sh (path is symlinked by home-manager above)
[ -f ~/.local/share/blesh/ble.sh ] && source ~/.local/share/blesh/ble.sh

# ls colors (dircolors lives in the Nix store, found via PATH)
if command -v dircolors >/dev/null 2>&1; then
  if [ -r ~/.dircolors ]; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
  alias ls='ls --color=auto'
fi

############################################################
#                    POWERLINE
############################################################
__git_branch() { git branch 2>/dev/null | sed -n '/\* /{s///p;q}'; }

__git_dirty() {
  if git rev-parse --git-dir >/dev/null 2>&1; then
    [ -n "$(git status --porcelain 2>/dev/null)" ] && echo " dirty"
  fi
}

__venv_marker() {
  [ -n "${VIRTUAL_ENV:-}" ] && echo " venv"
}

__build_prompt() {
  local base_fg="\[\e[38;2;30;30;46m\]"
  local blue_fg="\[\e[38;2;137;180;250m\]"
  local pink_fg="\[\e[38;2;245;194;231m\]"
  local teal_fg="\[\e[38;2;148;226;213m\]"
  local green_fg="\[\e[38;2;166;227;161m\]"

  local blue_bg="\[\e[48;2;137;180;250m\]"
  local pink_bg="\[\e[48;2;245;194;231m\]"
  local teal_bg="\[\e[48;2;148;226;213m\]"
  local green_bg="\[\e[48;2;166;227;161m\]"

  local reset="\[\e[0m\]"
  local sep=""

  # xterm title (must be inside PS1 to survive PROMPT_COMMAND)
  PS1="\[\e]0;\u@\h: \w\a\]"

  PS1+="${blue_bg}${base_fg} \\u ${reset}${pink_bg}${blue_fg}${sep}${reset}"
  PS1+="${pink_bg}${base_fg} \\h ${reset}"

  local branch; branch=$(__git_branch)
  if [ -n "$branch" ]; then
    PS1+="${pink_fg}${green_bg}${sep}${reset}"
    PS1+="${green_bg}${base_fg}${branch}$(__git_dirty) ${reset}"
  else
    PS1+="${pink_fg}${teal_bg}${sep}${reset}"
  fi

  local venv_mark; venv_mark=$(__venv_marker)
  if [ -n "$venv_mark" ]; then
    PS1+="${green_fg}${green_bg}${sep}${reset}"
    PS1+="${green_bg}${base_fg}${venv_mark} ${reset}"
    PS1+="${green_fg}${teal_bg}${sep}${reset}"
  elif [ -n "$branch" ]; then
    PS1+="${green_fg}${teal_bg}${sep}${reset}"
  fi

  PS1+="${teal_bg}${base_fg} \\w ${reset}"
  PS1+="${teal_fg}${sep}${reset}"
  PS1+="\n${teal_fg}\\$ ${reset}"   # \\$ so root gets #
}

PROMPT_COMMAND=__build_prompt

# Up/Down = history search
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
