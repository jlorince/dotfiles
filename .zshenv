########################################################################################
### Env
########################################################################################
export EDITOR=nvim
export PATH="/Users/$USER/.gem/ruby/2.3.0/bin/:$PATH"
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
ulimit -n 1000

########################################################################################
###  exa
########################################################################################

alias ls="exa --git -l --group-directories-first"
alias recent="exa -l -s modified -r"
alias tree="exa --tree"

