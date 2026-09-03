# tmux

Kept as a fallback. Day-to-day multiplexing moved to [herdr](../herdr/README.md),
whose keymap was deliberately ported *from* this file — so muscle memory carries
across and this config stays the reference for what those keys mean.

Plugins are managed by tpm and live in `~/.tmux/plugins/` (untracked):
tmux-sensible, tmux-resurrect, tmux-continuum (`@continuum-restore on`).

## Decisions

**`base-index 0` is re-asserted at the very bottom, after `run tpm`.** tmux-sensible
sets it to 1 when it loads, and tpm loads plugins at the point it's invoked — so
setting it earlier in the file is silently overwritten. The duplicate `renumber-windows`
line down there is the same story. Order matters; don't tidy those three lines up
into the section above.

**Splits are named for the divider, not the motion.** `bind "'"` is `split-window -v`
(stacked) and `bind '"'` is `-h` (side by side). herdr inverts this naming, which is
why the two configs look contradictory — see herdr's README for the mapping.

**Both open in `#{pane_current_path}`**, so a new pane starts where you were.

**`prefix + s` is a Claude-agent overview, not plain `choose-tree`.** The `@cis`
format string detects an agent pane heuristically: its process name looks like a
version string (`2.1.259`), or its title starts with one of Claude's status glyphs
(`✳◑◐◒◓✻✽*`). `@cdot` renders a green dot per agent, `@cfilter` hides non-agent
panes from the tree while always passing sessions and windows. Fragile by nature —
if Claude Code changes how it sets the pane title, this quietly shows nothing.

**Copy mode is vi keys, yanking straight to `pbcopy`**, and a mouse drag copies
without entering copy mode at all.

**`allow-passthrough on`** lets Kitty graphics protocol sequences reach the
terminal, so images can render inside a pane.
