# zsh setup

Plain zsh — no framework. Rationale and measurements: [.zshrc.md](./.zshrc.md).

## New machine

```sh
# 1. Plugins (plain git clones, no framework)
mkdir -p ~/.zsh/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/plugins/zsh-syntax-highlighting

# 2. Node (optional)
brew install nvm && mkdir -p ~/.nvm
nvm install --lts && nvm alias default lts/*

# 3. Symlink
ln -sf ~/.config/zsh/.zshrc ~/.zshrc

# 4. Reload
exec zsh
```

Everything else in `.zshrc` is guarded — missing tools are skipped silently.

## Not in this repo

- `~/.zshrc.local` — secrets (API tokens). Machine-local, never committed.
- conda — install anaconda at `/opt/anaconda3`; the lazy shim picks it up.
- gcloud SDK — re-run `gcloud init`; adjust the path in `.zshrc` if it lands
  somewhere other than `~/Downloads/google-cloud-sdk`.
- Antigravity / bun / maestro / libpq PATH entries — harmless if absent.
- A prompt worth the name. Plain zsh for now — see [.zshrc.md](./.zshrc.md#prompt).
