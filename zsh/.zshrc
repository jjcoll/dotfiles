# ~/.zshrc — symlinked from ~/.config/zsh/.zshrc (dotfiles repo)
# Why each block exists, and what was removed: see ./.zshrc.md

# --- prompt -------------------------------------------------------------
# Plain zsh, no framework: cwd, the exit code when non-zero, and the sigil.
# Git is deliberately absent — herdr's sidebar and Claude Code both show the
# branch already. See .zshrc.md § Prompt to add vcs_info or starship.
# %2~ = last two path segments; leading newline separates commands in scrollback;
# %(?..) shows the exit code only when non-zero; RPROMPT time auto-hides on long
# lines. `%2~` -> `%~` for the full path.
PROMPT=$'\n%F{cyan}%2~%f %(?..%F{red}%?%f )%F{green}%#%f '
RPROMPT='%F{240}%*%f'

# --- shell behaviour (was oh-my-zsh lib/) -------------------------------
bindkey -e
setopt AUTO_CD INTERACTIVE_COMMENTS

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY SHARE_HISTORY INC_APPEND_HISTORY \
       HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_VERIFY

# Completion. -C skips the security audit; the dump is rebuilt if >24h old.
autoload -Uz compinit
setopt EXTENDED_GLOB
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then compinit; else compinit -C; fi

# --- plugins (syntax-highlighting must be last) -------------------------
ZSH_PLUGINS="$HOME/.zsh/plugins"
[ -r "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh" ] \
  && source "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -r "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] \
  && source "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# --- node ---------------------------------------------------------------
# Default version straight on PATH; nvm.sh (0.9s) loads only when called.
export NVM_DIR="$HOME/.nvm"
NVM_DEFAULT="$(cat "$NVM_DIR/alias/default" 2>/dev/null)"
[ -n "$NVM_DEFAULT" ] && PATH="$NVM_DIR/versions/node/v${NVM_DEFAULT#v}/bin:$PATH"
unset NVM_DEFAULT
nvm() {
  unset -f nvm
  local prefix="$(brew --prefix nvm 2>/dev/null)"
  [ -s "$prefix/nvm.sh" ] && . "$prefix/nvm.sh"
  nvm "$@"
}

# --- conda (lazy; auto_activate_base is off, python3 is homebrew's) -----
if [ -x /opt/anaconda3/bin/conda ]; then
  conda() {
    unset -f conda
    eval "$(/opt/anaconda3/bin/conda shell.zsh hook)"
    conda "$@"
  }
fi

# --- PATH ---------------------------------------------------------------
export BUN_INSTALL="$HOME/.bun"
PATH="$BUN_INSTALL/bin:$PATH"
PATH="/opt/homebrew/opt/libpq/bin:$PATH"
PATH="$HOME/.antigravity/antigravity/bin:$PATH"
PATH="$PATH:$HOME/.maestro/bin"
export PATH

# --- tool init ----------------------------------------------------------
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
# gcloud SDK still lives under ~/Downloads — see .zshrc.md § Landmines
GCLOUD_SDK="$HOME/Downloads/google-cloud-sdk"
[ -f "$GCLOUD_SDK/path.zsh.inc" ] && . "$GCLOUD_SDK/path.zsh.inc"
[ -f "$GCLOUD_SDK/completion.zsh.inc" ] && . "$GCLOUD_SDK/completion.zsh.inc"
unset GCLOUD_SDK

# --- aliases ------------------------------------------------------------
alias ls='ls -G'
alias vim='nvim'
alias code='/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code'
lsrecent() { ls -ltU | head -${1:-10}; }

# --- secrets (untracked, machine-local) ---------------------------------
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
