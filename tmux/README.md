# tmux

Plugins: tmux-sensible, tmux-resurrect, tmux-continuum (`@continuum-restore on`,
so saved sessions come back whenever a tmux server starts; `@continuum-boot` is
unset, so nothing starts at login).

**Two plugin directories, both real.** The last line of `tmux.conf` bootstraps
tpm from `~/.tmux/plugins/tpm/tpm`, but because `tmux.conf` lives under
`~/.config/tmux/`, tpm then installs and manages everything in
`~/.config/tmux/plugins/`. That's where sensible, resurrect and continuum
actually load from. `~/.tmux/plugins/` holds only the bootstrap copy of tpm and
a stale `vim-tmux-navigator` that no `@plugin` line references, so it never
loads. Both dirs are untracked. Works as-is; consolidating means pointing the
`run` line at `~/.config/tmux/plugins/tpm/tpm`.

Config path is `~/.config/tmux/tmux.conf`, which tmux 3.x reads natively —
there is no `~/.tmux.conf` symlink to keep in sync.

## Decisions

**`base-index 0` is re-asserted at the very bottom, after `run tpm`.** tmux-sensible
sets it to 1 when it loads, and tpm loads plugins at the point it's invoked — so
setting it earlier in the file is silently overwritten. The duplicate `renumber-windows`
line down there is the same story. Order matters; don't tidy those three lines up
into the section above.

**Splits are named for the divider, not the motion.** `bind "'"` is `split-window -v`
(stacked) and `bind '"'` is `-h` (side by side).

**Both open in `#{pane_current_path}`**, so a new pane starts where you were.

**Copy mode is vi keys, yanking straight to `pbcopy`**, and a mouse drag copies
without entering copy mode at all.

**`allow-passthrough on`** lets Kitty graphics protocol sequences reach the
terminal, so images can render inside a pane.
