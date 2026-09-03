# dotfiles

This repository **is** `~/.config`. Not a copy that gets deployed, not a symlink
farm — the working tree is the live configuration. Editing a tracked file here
changes the running tool; there is no install step.

## Two decisions hold the whole thing up

**1. The repo root is `~/.config`, not `~`.** Nearly every tool here follows the
XDG convention and reads `~/.config/<tool>` already, so the repo root lands where
the files had to live anyway. Rooting at `~` instead would put Downloads, Desktop
and every stray dotfile in git's view — which is why other people end up needing
bare repos or `stow`.

**2. `.gitignore` is inverted: deny everything, then allow.** This is a safety
property, not tidiness. `~/.config` also holds `gcloud/` (credentials) and `gh/`
(a GitHub token). With a conventional gitignore, one absent-minded `git add -A`
publishes them. Deny-by-default means a new tool is invisible to git until it is
explicitly opted in — so `git add -A` here is harmless by construction.

Opting a tool in is two lines:

```gitignore
!newtool/
!newtool/**
```

## What's tracked

| Directory | Tool | Notes |
|---|---|---|
| `zsh/` | zsh | plus [`.zshrc.md`](zsh/.zshrc.md), the decision log |
| `starship.toml` | starship | prompt; a bare file, not a directory |
| `herdr/` | herdr | terminal workspace manager for agents |
| `tmux/` | tmux | predates herdr; kept as fallback |
| `ghostty/` | Ghostty | the actual terminal emulator |
| `nvim/` | Neovim | LazyVim base + local plugins |
| `aerospace/` | AeroSpace | macOS tiling WM |
| `claude/` | Claude Code | status line script |

Everything else in `~/.config` — `gcloud/`, `gh/`, `git/`, `raycast/`, `uv/`,
`fish/`, `kitty/`, `iterm2/`, … — is present on disk and deliberately untracked.

## Tools that refuse to use `~/.config`

zsh and Claude Code only look in `$HOME`. Those files live in the repo and are
symlinked out:

```
~/.zshrc                        → ~/.config/zsh/.zshrc
~/.claude/statusline-command.sh → ~/.config/claude/statusline-command.sh
```

**Symlink, never copy.** `~/.zshrc` was a copy until 2026-09-03, and the tracked
version silently froze in May while the live one kept changing. A copy always
drifts; a symlink cannot.

## Not in this repo, on purpose

| Path | Why |
|---|---|
| `~/.zshrc.local` | secrets (API tokens), machine-local |
| `~/.config/gcloud`, `~/.config/gh` | credentials |
| `~/.zsh/plugins/` | third-party git clones — see [zsh/README.md](zsh/README.md) |
| `~/.nvm`, `~/.local/share/google-cloud-sdk` | hundreds of MB of binaries |
| `~/.zsh_history`, `*.bak`, herdr's `session.json`/logs/sockets | machine state |

## Documenting decisions

**Every tracked directory carries a `README.md`,** and a non-obvious decision
gets written down where the config lives, at the time it is made.

What belongs in one: why a setting is set to a surprising value, what broke that
led to it, what was measured, what was deliberately *not* done. What does not:
restating what the config file already says.

When the reasoning is long enough to bury the setup instructions, split it —
`zsh/` keeps `README.md` for how to install and [`.zshrc.md`](zsh/.zshrc.md) for
why it looks the way it does.

The test: in six months, would you be able to tell this line from a typo?

## New machine

`~/.config` already exists, so `git clone` into it won't work:

```sh
mkdir -p ~/.config && cd ~/.config
git init
git remote add origin https://github.com/jjcoll/dotfiles.git
git fetch origin
git checkout -f main
```

Then follow [zsh/README.md](zsh/README.md) — it's the only one with required
steps (symlink `.zshrc`, clone the two plugins).
