# Claude Code

`statusline-command.sh` — custom status line:

```
Opus 5 high | ctx:95% | 5h:3%(4h37m) | +15(+107) -0(-31)
[~/project] [branch]
```

Top row: model + reasoning effort (color-coded), context remaining, 5-hour rate
limit usage with countdown to reset, uncommitted git diff with Claude's session
line totals nested in parens. Bottom row: cwd (`~`-shortened) and git branch.

## Install

```sh
ln -s ~/.config/claude/statusline-command.sh ~/.claude/statusline-command.sh
```

Then merge into `~/.claude/settings.json` (path must be absolute, adjust for the
machine's home dir):

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash /Users/<you>/.claude/statusline-command.sh"
  }
}
```

Needs `jq`. POSIX `/bin/sh`, so it runs unmodified on Linux.
