########################################################################################
### core zsh config
########################################################################################

unsetopt nomatch
export TERM=xterm-256color
# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
 source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

fpath=(/usr/local/share/zsh-completions $fpath)

DEFAULT_USER=jlorince

source /Users/jlorince/GoogleDrive/config/shell/.zshenv
ulimit -n 1000
source ~/.dotbare/dotbare.plugin.zsh

########################################################################################
### Env
########################################################################################
export EDITOR=nvim
export PATH="/Users/$USER/GoogleDrive/config/shell/scripts/:$PATH"
export PATH="/Users/$USER/.gem/ruby/2.3.0/bin/:$PATH"
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# export CFLAGS="-I$(brew --prefix openssl)/include"
# export CPPFLAGS="-I$(brew --prefix openssl)/include"
# export LDFLAGS="-L$(brew --prefix openssl@1.1)/lib"
# export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/zlib/lib/pkgconfig"
# export CFLAGS="-I$(brew --prefix openssl@1.1)/include -I$(xcrun --show-sdk-path)/usr/include"
# export CPPFLAGS="-I$(brew --prefix openssl@1.1)/include -I$(xcrun --show-sdk-path)/usr/include"
# export LDFLAGS="-L$(brew --prefix openssl)/lib"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PYTHON=$(which python)
# secrets
source /Users/$USER/GoogleDrive/config/shell/sh.sh

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

########################################################################################
###  Look & Feel
########################################################################################
# source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /Users/jlorince/GoogleDrive/config/shell/.custom

########################################################################################
###  Autosuggestions
########################################################################################
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#888888"
bindkey '^ ' autosuggest-accept

########################################################################################
###  Git(Hub)
########################################################################################
export REVIEW_BASE=master
source /Users/$USER/GoogleDrive/config/shell/forgit.plugin.zsh
source /Users/jlorince/GoogleDrive/config/shell/git_functions.sh
source /Users/jlorince/GoogleDrive/config/shell/git_function_key_bindings.zsh
### Basic aliases
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
# alias gd="ydiff" # use ydiff instead of standard diff
alias gds="ydiff -s" # side-by-side ydiff
alias gdm="git diff master... --name-only"

### Functions

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

# Create a pull request from the command line
function gpr(){
  squash "${2:-master}"
  gc $1
  ffp
  printf "$(gj) $1\n\n" > pr_desc
  hub pull-request -F pr_desc -e -c -b "${2:-master}"
  rm -f pr_desc
}

# One liner to create a WIP commit of all changes to tracked files
alias wip="gu && git commit -n -m 'wip'"

########################################################################################
###  exa
########################################################################################

alias ls="exa --git -l --group-directories-first"
alias recent="exa -l -s modified -r"
alias tree="exa --tree"

########################################################################################
###  fzf
########################################################################################

# Setup defaults
#   - tab to open fullscreen preview with `less` (not supported on commands that pipe
#     result, e.g. ctrl-t and ctrl-r)
#   - ctrl-y to copy filename to clipboard and close
#   - ? to toggle preview window
#   - ctrl-o to open file in GUI_EDITOR
#   - clrl-e to open file in EDITOR
source ~/.fzf.zsh
# export FZF_DEFAULT_COMMAND="git ls-tree -r --name-only HEAD || rg --files"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
preview_cmd='(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'
export FZF_DEFAULT_OPTS="
    --no-height
    --no-reverse
    --preview=\"$preview_cmd\"
    --bind=\"tab:execute($preview_cmd |LESS='-R' less)\"
    --bind \"ctrl-y:execute-silent(echo {} | pbcopy)+abort\"
    --bind '?:toggle-preview'
    --bind \"ctrl-o:execute-silent($GUI_EDITOR {})+abort\"
    --bind \"ctrl-e:execute-silent($EDITOR {})+abort\"
"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# ctrl-x-r to search history and immediately execute
fzf-history-widget-accept() {
  fzf-history-widget
  zle accept-line
}
zle     -N     fzf-history-widget-accept
bindkey '^X^R' fzf-history-widget-accept

# ff -> find files containing text
#   - enter to open file in GUI_EDITOR
#   - inline preview shows only matches plus 10 lines of context, tab opens full preview with matches highlighted
ff () {
  rg --files-with-matches --no-messages $1 | \
  fzf --preview "highlight -O ansi -l {1} 2> /dev/null | awk 'NR>={2}-10&&NR<={2}+10' | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 $1 || rg --ignore-case --pretty --context 10 $1 {1}"  \
    --bind="tab:execute(highlight -O ansi -l {1} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --passthru $1 |LESS='-R' less)" \
    --bind "enter:execute-silent($GUI_EDITOR {1})+abort"
}

# visual grep for input
#   - enter opens file at specified line number in GUI_EDITOR (this is only tested with `subl`)
#   - inline preview shows only matches plus 10 lines of context, tab opens full preview with matches highlighted
gg () {
  rg --no-heading --line-number $@ . | \
  fzf -0 --delimiter=:  \
    --preview "highlight -O ansi -l {1} 2> /dev/null | awk 'NR>={2}-10&&NR<={2}+10' | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 $1 || rg --ignore-case --pretty --context 10 $1 {1}"  \
    --bind "enter:execute-silent($GUI_EDITOR {1}:{2})+abort" \
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

. /Users/jlorince/GoogleDrive/config/shell/z.sh
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

### the fuck
 eval $(thefuck --alias)

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

