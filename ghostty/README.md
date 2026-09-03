# Ghostty

The actual terminal emulator — everything else (herdr, tmux, Claude Code) draws
inside it. `config` is the whole configuration, 14 lines.

## Decisions

**`macos-option-as-alt = left`.** Required, not cosmetic. Without it macOS treats
Option as a compose modifier and `opt+backspace` sends a bare `DEL`, byte-identical
to plain backspace — so nothing downstream can bind delete-word. Setting `left`
fixes it in every program at once (shell, nvim, agent prompts) while leaving right
Option free to type `é`/`ñ`.

**`theme = Nordfox` with an explicit `background = #2e3440`.** The theme's own
background is nordfox bg1. Overriding to bg0 puts the terminal *below* herdr's
panes in apparent depth, so herdr's sidebar chrome reads as a layer on top rather
than floating on the same plane. The palette is matched in `../herdr/config.toml`
and `../tmux/tmux.conf`.

Was `light:Catppuccin Latte,dark:Nordfox` — auto-switching was dropped because
herdr's palette is pinned dark, and a light terminal under a dark multiplexer
looks broken.

**`cursor-style = block`, no blink.** Claude Code never emits `DECSCUSR`, so it
never sets a cursor shape and never restores one. Whatever the terminal is set
to is what you get; pinning it here keeps the cursor consistent everywhere.

**`font-family = Maple Mono NL`.** NL = "no ligatures".
