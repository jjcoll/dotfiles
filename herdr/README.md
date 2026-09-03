# herdr

Terminal workspace manager for AI coding agents ([herdr.dev](https://herdr.dev)).
tmux-shaped, but it detects agent processes in panes, labels them, and restores
their sessions across restarts.

Binary: `~/.local/bin/herdr` · Config: `~/.config/herdr/config.toml`

Only `config.toml` and this README are tracked. `session.json`, `*.log`,
`*.sock` and `config.toml.bak` are runtime state and stay out of git.

## Architecture

```
Ghostty → herdr client → herdr server (daemon, parent PID 1) → pane shell → agent
```

The server owns the PTYs and survives detach, so `prefix+d` drops the UI without
killing anything. `session.json` persists workspaces → tabs → panes, each pane
storing its `cwd` and `agent_session` — that's what makes agent resume work
after a restart.

## Keymap

Ported from `../tmux/tmux.conf` for muscle-memory parity.

### Unchanged — herdr defaults already matched tmux

| Key | Action |
|---|---|
| `prefix+h/j/k/l` | focus pane left/down/up/right |
| `prefix+c` | new tab |
| `prefix+n` / `prefix+p` | next / previous tab |
| `prefix+1..9` | switch tab |
| `prefix+x` | close pane |
| `prefix+z` | zoom pane |
| `prefix+?` | live keybinding help |

Prefix is `ctrl+b`.

### Changed

| Key | Action | herdr default was |
|---|---|---|
| `prefix+s` | workspace picker | `prefix+w` |
| `prefix+,` | settings | `prefix+s` |
| `prefix+d` | detach | `prefix+q` |
| `prefix+r` | reload config | `prefix+shift+r` |
| `prefix+shift+r` | resize mode | `prefix+r` |
| `prefix+'` | split stacked | `prefix+minus` |
| `prefix+"` | split side-by-side | `prefix+v` |
| `prefix+ctrl+h/j/k/l` | resize pane | unbound |
| `prefix+v` | copy mode | `prefix+[` (still bound) |
| `prefix+shift+1..9` | switch workspace | unbound |
| `prefix+alt+1..9` | focus agent | unbound |

**Why `prefix+s` for workspaces:** herdr workspaces are conceptually tmux
sessions, and tmux.conf binds `s` to `choose-tree`. Settings got displaced to
`prefix+,` (editor convention).

**Why the splits look inverted:** tmux names the *motion* (`split-window -v`
= split vertically = stacked panes); herdr names the *divider*
(`split_horizontal` = horizontal divider = stacked panes). Same result,
opposite word. So tmux `'` → `split_horizontal`, tmux `"` → `split_vertical`.

### Navigate mode

Navigate mode has its own keymap that shadows the bindings above while open.

| Key | Action |
|---|---|
| `j` / `k` | workspace down / up |
| `↓` / `↑` | pane down / up |
| `h` / `l` / `←` / `→` | pane left / right |

Vim keys drive workspaces because that's the outer level. Panes moved to the
arrows since `navigate_pane_up/down` default to `k`/`j` and would collide.
Left/right arrows are hardwired to pane-left/right and can't be rebound.

## Copy mode

`prefix+v` (or `prefix+[`). `prefix+v` is free because `split_vertical` moved
to `prefix+"`, and it mirrors `v` starting a selection once inside.

| Key | Action |
|---|---|
| `h/j/k/l`, `w/b/e`, `W/B/E`, `{`/`}` | motions |
| `ctrl+u`/`ctrl+d`, `ctrl+f`/`ctrl+b` | half/full page |
| `/` `?`, then `n`/`N` | search (smart-case), repeat |
| `v` / Space | start selection |
| `y` / Enter | yank to clipboard |
| `q` / Esc | leave without copying |

Unlike tmux, copy mode does **not** pause the pane — output stays live and
follows at the bottom, pinning when you scroll into history. `ctrl+b` will not
page up because the prefix claims it; use `ctrl+u`/`ctrl+d`.

Mouse drag-select copies without entering copy mode at all
(`ui.copy_on_select` defaults to true).

## Dependency: Ghostty `macos-option-as-alt`

`opt+backspace` (delete-word) needs `macos-option-as-alt = left` in
`../ghostty/config`. Without it macOS treats Option as a compose modifier and
`opt+backspace` sends a bare `DEL` — byte-identical to plain backspace, so
nothing downstream can bind it. `left` keeps right-Option free for `é`/`ñ`.

This is a terminal-level setting, not a herdr one. It fixes delete-word
everywhere: shell, editor, agent prompts.

## Commands

```sh
herdr config check          # validate config.toml, print diagnostics
herdr server reload-config  # apply edits live (or prefix+r)
herdr config reset-keys     # back up config.toml, drop [keys], restore defaults
herdr --default-config      # print the full annotated default config
herdr status                # client + server version and health
```

Invalid values fall back to a safe default with a startup warning rather than
failing to boot — always run `config check` after editing.

## Gotchas

- **Resize doesn't auto-repeat.** tmux `bind -r C-hjkl` lets you hold the key;
  herdr has no `-r` equivalent, so `prefix+ctrl+h` nudges once. Use
  `prefix+shift+r` (resize mode) for sustained resizing.
- **No `move-pane` equivalent.** The tmux `H/J/K/L`/`Y`/`O` pane-rearrangement
  binds have no herdr counterpart.
- **`prefix+e` is not copy-mode.** It opens scrollback in `$EDITOR`.
- **Stale `TERM_PROGRAM`.** If the server daemon was first launched from inside
  tmux, every pane inherits `TERM_PROGRAM=tmux` and apps may emit tmux
  passthrough sequences nothing unwraps. Fix with `herdr server stop` and
  relaunch from a clean terminal — this kills all panes.
