# AeroSpace

macOS tiling window manager. `aerospace.toml` is the live config — AeroSpace reads
`~/.aerospace.toml` first and falls back to `~/.config/aerospace/aerospace.toml`,
and there is no `~/.aerospace.toml` here, so this file is the one in effect.

## Decisions

**`on-focus-changed = ['move-mouse window-lazy-center']`.** The pointer follows
focus lazily, so it doesn't fight you mid-drag but also never ends up hovering a
window you're no longer in — which otherwise makes scroll wheel events land in
the wrong place.

**Gaps of 2px** (inner and outer). Enough to see a window boundary, not enough to
waste screen.

**`start-at-login = true`.** A tiling WM that isn't running is worse than not
having one, since window positions from the last session are already scrambled.

## Loose end

`copy-aerospace.toml` is an older variant from Sep 2025 — larger gaps (5/8px),
`accordion-padding = 30`, `on-focused-monitor-changed` enabled. It is not read by
anything. Either fold the settings you still want into `aerospace.toml` and delete
it, or rename it to say what it is.
