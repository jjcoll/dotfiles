# Claude Code

The parts of `~/.claude/` worth versioning. Everything else in that directory is
runtime state — sessions, history, caches, the plugin cache, 700 MB of `projects/` —
and is deliberately left out.

| File | What |
|---|---|
| `CLAUDE.md` | Global instructions, loaded every session in every project. |
| `settings.json` | Model, permissions, hooks, status line, enabled plugins, marketplaces. |
| `hooks/herdr-agent-state.sh` | `SessionStart` hook wired up in `settings.json`. |
| `statusline-command.sh` | Custom status line (below). |

Skills are **not** here. They live in [`coisoftware/skills`](https://github.com/coisoftware/skills)
as a plugin marketplace, installed with `claude plugin`, and `CLAUDE.md` explains why.

## Install

`~/.claude` is a fixed path Claude Code owns, so these are symlinked into it:

```sh
mkdir -p ~/.claude/hooks
ln -s ~/.config/claude/CLAUDE.md                  ~/.claude/CLAUDE.md
ln -s ~/.config/claude/settings.json              ~/.claude/settings.json
ln -s ~/.config/claude/statusline-command.sh      ~/.claude/statusline-command.sh
ln -s ~/.config/claude/hooks/herdr-agent-state.sh ~/.claude/hooks/herdr-agent-state.sh
```

`CLAUDE_CONFIG_DIR` would relocate the whole directory instead — but it relocates
*everything*, runtime state included, so pointing it here would drag sessions, history
and the plugin cache into this repo. Symlinks are the narrower tool.

### On another machine

`settings.json` holds **absolute paths** — the status line command and the hook both
name `/Users/eliot/...`. Fix those after symlinking, or the hook silently doesn't run.
Claude Code also rewrites this file itself (installing a plugin edits `enabledPlugins`),
so expect churn here that you didn't type.

## `statusline-command.sh`

```
Opus 5 high | ctx:95% | 5h:3%(4h37m) | +15(+107) -0(-31)
[~/project] [branch]
```

Top row: model + reasoning effort (color-coded), context remaining, 5-hour rate limit
usage with countdown to reset, uncommitted git diff with Claude's session line totals
nested in parens. Bottom row: cwd (`~`-shortened) and git branch.

Needs `jq`. POSIX `/bin/sh`, so it runs unmodified on Linux.
