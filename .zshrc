# zmodload zsh/zprof

########################################################################################
### core zsh config
########################################################################################
source $HOME/.powerlevel10k
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shelenv)
fi
source $(brew --prefix)/share/zsh/site-functions/_todoist_fzf

# secrets
source $HOME/GoogleDrive/config/shell/sh.sh

# unsetopt nomatch
export TERM=xterm-256color
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
zinit ice depth=1;
zinit light romkatv/powerlevel10k
zinit wait lucid light-mode for \
  kazhala/dotbare \
  atload'bindkey -M vicmd "k" history-substring-search-up; bindkey -M vicmd "j" history-substring-search-down' \
  zsh-users/zsh-history-substring-search \
  atload'_zsh_autosuggest_start; bindkey -v "^ " autosuggest-accept' \
  zsh-users/zsh-autosuggestions \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay; _dotbare_completion_cmd dotbare" \
  atload"FAST_HIGHLIGHT[chroma-man]=" \
  zdharma/fast-syntax-highlighting \
  wfxr/forgit
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh


########################################################################################
### Settings
########################################################################################
eval "$(pyenv init -)"
export PYTHON=$(which python)
#
########################################################################################
### Settings
########################################################################################

# history
HISTSIZE=50000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history

# completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/completion
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' \
  max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zmodload zsh/complist
LISTMAX=9999

# misc
setopt nobeep
setopt ignoreeof


########################################################################################
###  Autosuggestions
########################################################################################
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#888888"

########################################################################################
###  Git(Hub)
########################################################################################
export REVIEW_BASE=master
alias git=hub  # Use Hub instead of standard git
alias gch="git checkout"
alias gu="git add -u"
alias gs="git status"
alias gcm="git checkout master -- "
function gpo(){
  branch=`git rev-parse --abbrev-ref HEAD`
  git pull origin $branch
}
function gp(){
  branch=`git rev-parse --abbrev-ref HEAD`
  git push --set-upstream origin $branch
}
alias gbl="git branch --sort=-committerdate" # list all branches, ordered by recency
alias restash="git stash show -p  $1| git apply --reverse" # undo the latest `git stash pop`
alias gds="ydiff -s" # side-by-side ydiff
alias gdm="git diff master... --name-only"


# merge with tip of master
function mm(){
    current_branch=`git rev-parse --abbrev-ref HEAD`
    git checkout master
    git pull origin master
    git checkout $current_branch
    git merge master
}

# create a new branch off of master
function nbm(){
  git checkout master
  git pull origin master
  git checkout -b $1
}

# create new branch off of current branch
function nb(){
  git checkout -b $1
}

# pull JIRA ticket number off of branch name e.g.
#   "ABC-12345-my-branch-name" --> "ABC-12345"
function getJIRA(){
    python -c 'import sys; print("-".join(sys.stdin.read().split("-")[:2]))'
}
alias gj="git rev-parse --abbrev-ref HEAD | getJIRA"

# call `git commit` with the specified message and JIRA ticket prepended
function gc(){
    git commit -m "$(gj) $1"
}

# Force push
function ffp(){
  current_branch=`git rev-parse --abbrev-ref HEAD`
  git push -ff --set-upstream origin $current_branch
}

# Squash all changes into a single commit; defaults to basing off master, but accepts
# optional base branch argument
function squash(){
  current_branch=`git rev-parse --abbrev-ref HEAD`
  git branch -D my-branch-old
  git branch -m my-branch-old
  git checkout "${1:-master}"
  git checkout -b $current_branch
  git merge --squash my-branch-old
}

# One liner to create a WIP commit of all changes to tracked files
alias wip="gu && git commit -n -m 'wip'"


########################################################################################
###  fzf
########################################################################################

# Setup defaults
#   - tab to open fullscreen preview with `less` (not supported on commands that pipe
#     result, e.g. ctrl-t and ctrl-r)
#   - ctrl-y to copy filename to clipboard and close
#   - ? to toggle preview window
#   - clrl-e to open file in EDITOR
source ~/.fzf.zsh
# export FZF_DEFAULT_COMMAND="git ls-tree -r --name-only HEAD || rg --files"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
preview_cmd='(highlight -O ansi -l {} 2> /dev/null || cat {} || tree {}) 2> /dev/null | head -200'
export FZF_DEFAULT_OPTS="
    --no-height
    --no-reverse
    --preview=\"$preview_cmd\"
    --bind \"tab:execute($preview_cmd |LESS='-R' less)\"
    --bind \"ctrl-y:execute-silent(echo {} | pbcopy)+abort\"
    --bind '?:toggle-preview'
    --bind \"ctrl-e:execute-silent($EDITOR {})+abort\"
"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3"
export FZF_ALT_C_OPTS="--preview 'tree {} | head -200'"

# ctrl-x-r to search history and immediately execute
fzf-history-widget-accept() {
  fzf-history-widget
  zle accept-line
}
zle     -N     fzf-history-widget-accept
bindkey '^X^R' fzf-history-widget-accept

# ff -> find files containing text
#   - enter to open file in EDITOR
#   - inline preview shows only matches plus 10 lines of context, tab opens full preview with matches highlighted
ff () {
  rg --files-with-matches --no-messages $1 | \
  fzf --preview "highlight -O ansi -l {1} 2> /dev/null | awk 'NR>={2}-10&&NR<={2}+10' | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 $1 || rg --ignore-case --pretty --context 10 $1 {1}"  \
    --bind="tab:execute(highlight -O ansi -l {1} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --passthru $1 |LESS='-R' less)" \
    --bind "enter:execute-silent($EDITOR {1})+abort"
}

# visual grep for input
#   - enter opens file at specified line number in GUI_EDITOR (this is only tested with `subl`)
#   - inline preview shows only matches plus 10 lines of context, tab opens full preview with matches highlighted
gg () {
  rg --no-heading --line-number $@ . | \
  fzf -0 --delimiter=:  \
    --preview "highlight -O ansi -l {1} 2> /dev/null | awk 'NR>={2}-10&&NR<={2}+10' | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 $1 || rg --ignore-case --pretty --context 10 $1 {1}"  \
    --bind "enter:execute-silent($EDITOR {1}:{2})+abort" \
    --bind="tab:execute(highlight -O ansi -l {1} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --passthru $1 |LESS='-R' less +{2}g )"
}

# fuzzy global search
loc () {
  locate $1 | fzf
}

# fuzzy list all aliases
function aliases() {
  command=$(alias |
    ack --color --color-match=bright_blue --passthru '^[^=]+' |
    fzf-tmux --cycle --ansi --reverse --height=90% --query="$1" --multi --select-1 --exit-0 --tac |
    cut -d "=" -f 1)
  echo $command
}


#######################################################################################
###  Z
########################################################################################

. ~/.z.sh
unalias z
z() {
  if [[ -z "$*" ]]; then
    cd "$(_z -l 2>&1 | fzf +s --tac --preview '(tree -C {2})'| sed 's/^[0-9,.]* *//')"
  else
    _last_z_args="$@"
    _z "$@"
  fi
}

########################################################################################
###  Misc
########################################################################################

# Make a new directory and CD into it
function mkcd {
    mkdir $1
    cd $1
}

# Go to parent directory
function up() {
  COUNTER=$1
  # set default to 1 if no argument provided
  [[ -z "$1" ]] && COUNTER='1'

  while [[ $COUNTER -gt 0 ]]; do
    UP="${UP}../"
    COUNTER=$(($COUNTER - 1))
  done

  # Print out command only if the destination is more than one level away
  [[ $UP != '../' ]] && echo "cd $UP"

  cd $UP
  UP='' # Clear the value for future reuse
}

# Copy
function pwdcopy() {
  printf \'$(pwd)\' | pbcopy
}

function cpstat() {
  rsync -a --progress --human-readable "$1" "$2" | highlight --theme ~/GoogleDrive/configh/shell/.highlightrc
}

function copy() { # A more user-friendly copy CLI
  if [ "$1" = "--to" ] || [ "$1" = "-t" ]; then
    cpstat "$2" "$3"
  else
    cat "$@" | pbcopy
  fi
}


# Files removal
function trash() {
  mv "$@" ~/.Trash
}

function emptytrash() {
  rm -rf ~/.Trash/*
  rm -rf ~/.Trash/.*
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# zprof

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/jlorince/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/jlorince/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/jlorince/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/jlorince/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

