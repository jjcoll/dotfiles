# zsh setup

Mirror of zsh config (oh-my-zsh + plugins + custom).

## New machine setup

```sh
# 1. Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 2. Install external plugins (not bundled with omz)
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# 3. Install nvm (optional — only if you use Node)
brew install nvm
mkdir -p ~/.nvm

# 4. Symlink this .zshrc (overwrite the one omz installed)
ln -sf ~/.config/zsh/.zshrc ~/.zshrc

# 5. Reload
exec zsh
```

## Excluded from this repo (machine-specific or one-off)

- conda init block — re-run `conda init zsh` after installing anaconda/miniconda
- gcloud SDK path — re-run `gcloud init` after installing the SDK
- Antigravity PATH entry — only needed if that tool is installed
- p10k instant prompt — theme is `candy`, not p10k (dead code in original)
