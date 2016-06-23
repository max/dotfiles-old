PATH=$HOME/.bin:$PATH

fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit && compinit

autoload colors && colors
setopt prompt_subst

current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

git_branch () {
  ref=$(current_branch)
  if [[ $ref == "" ]]; then
    echo ""
  else
    echo "$ref"
  fi
}

git_dirty () {
  st=$(/usr/local/bin/git status 2> /dev/null | tail -n 1)
  if [[ $st == "" ]]; then
    echo ""
  else
    if [[ $st == "nothing to commit, working directory clean" ]]; then
      echo "👍"
    else
      echo "👎"
    fi
  fi
}

PROMPT='💻  %{$fg[cyan]%}%~%{$reset_color%}: '
RPROMPT='$(git_branch) $(git_dirty)'

precmd () { print -Pn "\e]2;%~\a" }

HISTSIZE=1000
HISTFILE=~/.history
SAVEHIST=1000

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

alias ..='cd ..'
alias ls='ls -GA'
alias ll='ls -GAlh'

alias ggpull='git pull origin $(current_branch)'
alias ggpush='git push origin $(current_branch)'
alias ggsync='git pull origin $(current_branch) && git push origin $(current_branch)'
alias gaa='git add -A'
alias gci='git commit'
alias gco='git checkout'
alias gcob='git branch | cut -c 3- | selecta | xargs git checkout'
alias glg='git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --'
alias gst='git status --short'

eval "$(hub alias -s)"

proj() {
  cd $(find ~/Code -maxdepth 1 -type d | selecta)
}
alias p='proj'

# Added by NVM
export NVM_DIR="/Users/Max/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# Added by RVM
export PATH="$PATH:$HOME/.rvm/bin"

# Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Load local config
[ -e $HOME/.localrc ] && source $HOME/.localrc
