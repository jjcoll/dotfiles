#!/bin/sh
# Claude Code status line — based on oh-my-zsh "candy" theme
# Format: [~/current/dir] [git-branch] | model effort | ctx% | 5h%(countdown) | +git(+claude) -git(-claude)
input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')
model=$(echo "$input" | jq -r '.model.display_name')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
[ -z "$effort" ] && effort=$(jq -r '.effortLevel // empty' "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/settings.json" 2>/dev/null)
session_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
resets_at=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
lines_add=$(echo "$input" | jq -r '.cost.total_lines_added // empty')
lines_del=$(echo "$input" | jq -r '.cost.total_lines_removed // empty')

# color code for a percentage: mode "high" = high value is bad, "low" = low value is bad
pct_color() {
  pct=$(printf '%.0f' "$1")
  if [ "$2" = "high" ]; then
    if   [ "$pct" -ge 75 ]; then echo 31
    elif [ "$pct" -ge 50 ]; then echo 33
    else echo 32
    fi
  else
    if   [ "$pct" -le 25 ]; then echo 31
    elif [ "$pct" -le 50 ]; then echo 33
    else echo 32
    fi
  fi
}

countdown_str() {
  sec=$1
  [ "$sec" -le 0 ] && { echo "now"; return; }
  h=$((sec / 3600))
  m=$(((sec % 3600) / 60))
  if [ "$h" -gt 0 ]; then printf "%dh%dm" "$h" "$m"; else printf "%dm" "$m"; fi
}

effort_color() {
  case "$1" in
    low) echo 33 ;;
    medium) echo 32 ;;
    high) echo 35 ;;
    xhigh) echo 36 ;;
    max) echo 31 ;;
    ultracode) echo 95 ;;
    *) echo 37 ;;
  esac
}

# Shorten home directory to ~
home="$HOME"
short_cwd=$(echo "$cwd" | sed "s|^$home|~|")

# Git branch (skip optional lock)
branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
is_git=$(git -C "$cwd" rev-parse --is-inside-work-tree 2>/dev/null)

# Uncommitted working-tree diff (staged + unstaged), separate from claude's session total
git_add=0
git_del=0
if [ "$is_git" = "true" ]; then
  stats=$(git -C "$cwd" diff --numstat 2>/dev/null; git -C "$cwd" diff --cached --numstat 2>/dev/null)
  git_add=$(echo "$stats" | awk '{a+=$1} END{print a+0}')
  git_del=$(echo "$stats" | awk '{d+=$2} END{print d+0}')
fi

# Build prompt parts
dir_part="[$short_cwd]"

line=$(printf "\033[37m%s\033[0m" "$dir_part")

if [ -n "$branch" ]; then
  line=$(printf "%s \033[32m[%s]\033[0m" "$line" "$branch")
fi

# Dir/branch becomes the bottom row; metrics build up on the top row
dir_line="$line"

# Append model + effort
line=$(printf "\033[38;5;245m%s\033[0m" "$model")
if [ -n "$effort" ]; then
  ec=$(effort_color "$effort")
  line=$(printf "%s \033[%sm%s\033[0m" "$line" "$ec" "$effort")
fi

# Context remaining % (low remaining = bad)
if [ -n "$remaining" ]; then
  cc=$(pct_color "$remaining" low)
  line=$(printf "%s \033[38;5;245m| ctx:\033[%sm%s%%\033[0m" "$line" "$cc" "$(printf '%.0f' "$remaining")")
fi

# 5-hour rate limit usage % (high usage = bad), with countdown to reset
if [ -n "$session_pct" ]; then
  sc=$(pct_color "$session_pct" high)
  line=$(printf "%s \033[38;5;245m| 5h:\033[%sm%s%%\033[0m" "$line" "$sc" "$(printf '%.0f' "$session_pct")")
  if [ -n "$resets_at" ]; then
    remaining_sec=$((resets_at - $(date -u +%s)))
    line=$(printf "%s\033[38;5;245m(%s)\033[0m" "$line" "$(countdown_str "$remaining_sec")")
  fi
fi

# Uncommitted git diff, with claude's session total nested in parens
if [ -n "$lines_add" ] && [ -n "$lines_del" ]; then
  if [ "$is_git" = "true" ]; then
    line=$(printf "%s \033[38;5;245m| \033[32m+%s\033[0m\033[38;5;245m(+%s)\033[0m \033[31m-%s\033[0m\033[38;5;245m(-%s)\033[0m" \
      "$line" "$git_add" "$lines_add" "$git_del" "$lines_del")
  else
    line=$(printf "%s \033[38;5;245m| \033[32m+%s\033[0m \033[31m-%s\033[0m\033[38;5;245m (no git)\033[0m" "$line" "$lines_add" "$lines_del")
  fi
fi

printf "%s\n%s" "$line" "$dir_line"
