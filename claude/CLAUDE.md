# Global Claude Code instructions

## NEVER kill or take over the user's dev servers

The user runs their own dev server and keeps it running. Do **not** kill it,
restart it, or commandeer its port.

- **Never** run `pkill`/`kill`/`killall` against dev servers (`vite`, `npm run dev`,
  `next`, etc.) or free a port by killing whatever holds it.
- To verify something in a running app, first **ask which port the user's dev
  server is on** and use that. If you genuinely need your own instance, start it
  on a **distinct port** and leave theirs untouched — and only ever stop
  processes you started yourself.
- Prefer not to auto-spawn dev servers at all; ask first.

This applies to every project.

## My skills live in a plugin marketplace, not in `~/.claude/skills/`

Source of truth: **`/Users/eliot/coisoftware/code/skills`** (remote
`github.com/coisoftware/skills`, commits land on `main`). That repo is a
marketplace holding two plugins:

| Plugin | Skills | Enabled |
|---|---|---|
| `ticket` | `new`, `start`, `ship`, `close` — invoked `/ticket:ship` etc. | **Per repo**, via the repo's own committed `.claude/settings.json`. They read `.claude/workflow.json`, so they are noise anywhere else. |
| `dev` | `discuss`, `diagnosis`, `quickfix`, `slides`, `timesheet` | Globally, in `~/.claude/settings.json`. |

To change a skill, edit it **in that repo** and push from there. Never edit
`~/.claude/plugins/cache/coisoftware/…` — that is an installed copy and is
overwritten on the next update. `~/.claude` is not a git repo, so running git
there fails with `fatal: not a git repository`.

Releasing a skill change, in order: **bump `version` in the plugin's
`.claude-plugin/plugin.json`** (SemVer — MAJOR if a consumer's config must change,
MINOR for a new skill, PATCH for wording), `claude plugin validate` on the plugin dir
and the repo root, push, then `claude plugin update <plugin>@coisoftware`. Without the
bump that update is a silent no-op — the cache is keyed by version, so the old files
keep loading and a restart reloads the same folder. `/reload-plugins` applies it
mid-session; otherwise restart.

## Park a blocked ticket in Needs Decision — don't just ask in chat

When work on a tracker ticket stops because of something only I can answer, move the
ticket to **Needs Decision** and post the open question as a comment *before* asking me
in chat. Applies at any point, in or out of a ticket skill — the moment it matters is
usually mid-work, where no skill is loaded.

The trigger is **"this ticket can't proceed the way it was specified or labelled"**, not
"something went wrong":

- An unanswered product, wording or scope question → Needs Decision.
- CI red on an `auto-merge` ticket → Needs Decision, because the decision is *fix it, or
  drop it to review*, and that is mine.
- A test failing, a typo, a bad import → **not** Needs Decision. That's breakage. Fix it.

Priority is a separate axis: leave it where it is. Low + Backlog reads as *we chose to
deprioritise this*; Needs Decision reads as *waiting on you*. Those are different facts
and the state is the one that carries the second.

## NEVER create artifacts unless explicitly asked

Hard rule, all projects. Do **not** call the Artifact tool — no publish, no
Artifact type, no quickstart — unless I say so in that message, in words like
"make an artifact", "publish this", "put it on a page", "make me a
dashboard/deck/site".

- Default output is the terminal, or a local file when I ask for a file.
- Reports, summaries, plans, write-ups, docs "for the team": terminal/file. Still no artifact.
- Do not offer to publish, do not ask if I want an artifact, do not mention artifacts. I will ask.
- Permission is per-request and does not carry to the next task. Updating an
  artifact I point at is fine; creating a new one is not.

## End a finished task with a clear-chat verdict

Last line of the final response on a task, always one of two shapes:

- Nothing outstanding → `✅ Done — safe to clear the chat.`
- Something outstanding → `⏳ Left: <one line each>`, mine or yours, and say which.

Counts as left, even when the code is finished: a restart or `/reload-plugins`
needed to apply something, a decision I asked you for and you haven't answered,
commits not pushed, a background process or dev server still running, a check
that was skipped or failed.

Don't emit the line mid-task, on a question I merely asked you to answer, or in a
message that ends by asking me something — the ask *is* the state.
