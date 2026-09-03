# Neovim

[LazyVim](https://lazyvim.github.io) starter, plus the files below. Plugin
versions are pinned in `lazy-lock.json` (tracked — that's what makes a fresh
machine reproduce this exact setup).

```
init.lua                     LazyVim bootstrap, untouched
lua/config/                  keymaps, options, autocmds, lazy setup
lua/plugins/                 one file per customisation
lua/custom/                  local modules, not plugins
```

## Local modules

**`custom/hotreload.lua`** — reloads buffers when the file changes on disk,
without the usual `:checktime` prompt. Written because agents edit files
underneath an open editor constantly; the stock "file changed, reload?" dialog
turns that into a stream of interruptions. Skips command-line, replace, ex and
select modes so a reload never lands mid-keystroke. Wired up in
`config/autocmds.lua`, inspired by
[hotreload.nvim](https://github.com/diogo464/hotreload.nvim).

**`custom/directory-watcher.lua`** — the `vim.uv` filesystem watcher underneath
it, with debouncing so a bulk edit doesn't fire a callback storm. Only consumer
is hotreload.

## Plugin decisions

| File | What it changes |
|---|---|
| `colorscheme.lua` | catppuccin, flavour **mocha** (was macchiato) |
| `vue.lua` | volar + `ts_ls` extended to `.vue` files |
| `formatting.lua` | conform: prettierd → prettier for `.astro`, first match wins |
| `image.lua` | snacks image rendering via the **kitty** graphics protocol |
| `render-markdown.lua` | numbered heading icons |
| `snacks.lua` | explorer shows hidden files |
| `diffview.lua` | unbinds gitsigns' `<leader>gd` so diffview can own it |
| `example.lua` | LazyVim's shipped sample, inert |

The kitty graphics protocol matters outside nvim too: `../tmux/tmux.conf` sets
`allow-passthrough on` and herdr has `kitty_graphics` for the same reason —
images only render if every layer between nvim and Ghostty forwards them.

## Keymaps

Only three additions on top of LazyVim's defaults (`config/keymaps.lua`):
`jk` to leave insert mode, `M-BS` (opt+backspace) to delete a word — which
depends on `macos-option-as-alt = left` in `../ghostty/README.md` — and a
commented-out `Cmd+A`.
