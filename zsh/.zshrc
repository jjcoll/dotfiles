# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="candy"

# Plugins (zsh-autosuggestions and zsh-syntax-highlighting are external — see install notes)
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# p10k (only loads if config exists)
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# nvm (homebrew install — works on both Apple Silicon and Intel)
export NVM_DIR="$HOME/.nvm"
if command -v brew >/dev/null 2>&1; then
  NVM_PREFIX="$(brew --prefix nvm 2>/dev/null)"
  [ -s "$NVM_PREFIX/nvm.sh" ] && \. "$NVM_PREFIX/nvm.sh"
  [ -s "$NVM_PREFIX/etc/bash_completion.d/nvm" ] && \. "$NVM_PREFIX/etc/bash_completion.d/nvm"
fi

# envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Aliases
alias vim="nvim"
alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"

# Print N most recent files (default 10)
lsrecent() {
  ls -ltU | head -${1:-10}
}
