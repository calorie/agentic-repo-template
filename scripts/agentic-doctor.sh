#!/usr/bin/env bash
set -uo pipefail

fail=0
warn=0
pass() { printf 'PASS  %s\n' "$1"; }
warning() { printf 'WARN  %s\n' "$1"; warn=$((warn+1)); }
failure() { printf 'FAIL  %s\n' "$1"; fail=$((fail+1)); }

root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$root"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then pass "Git repository"; else failure "Not a Git repository"; fi
[[ -f CLAUDE.md ]] && pass "CLAUDE.md" || warning "CLAUDE.md missing (Claude Code adapter unavailable)"
[[ -f AGENTS.md ]] && pass "AGENTS.md" || failure "AGENTS.md missing"
[[ -f .agentic/PROJECT.md ]] && pass ".agentic/PROJECT.md" || failure ".agentic/PROJECT.md missing"
[[ -f .agentic/agentic.json ]] && pass ".agentic/agentic.json" || failure ".agentic/agentic.json missing"
[[ -f .codex/config.toml ]] && pass ".codex/config.toml" || warning ".codex/config.toml missing (Codex project adapter unavailable)"

if grep -q '__GITHUB_OWNER__' .claude/settings.json 2>/dev/null; then
  failure "Central plugin GitHub owner is still placeholder"
else
  pass "Central plugin marketplace configured"
fi

if command -v claude >/dev/null 2>&1; then
  pass "claude CLI available"
else
  warning "claude CLI not found"
fi

if command -v codex >/dev/null 2>&1; then
  pass "codex CLI available"
  if codex plugin list --marketplace agentic-engineering --json >/tmp/agentic-codex-plugins.$$ 2>/dev/null; then
    if grep -q '"installed"[[:space:]]*:[[:space:]]*true' /tmp/agentic-codex-plugins.$$; then
      pass "agentic-engineering Codex plugin installed"
    else
      warning "agentic-engineering Codex plugin is not installed"
    fi
    rm -f /tmp/agentic-codex-plugins.$$
  else
    warning "Codex marketplace/plugin status unavailable; run scripts/setup-agentic.sh"
  fi
else
  warning "codex CLI not found"
fi

if command -v gh >/dev/null 2>&1; then
  pass "gh CLI available"
  if gh auth status >/dev/null 2>&1; then pass "gh authenticated"; else warning "gh is not authenticated"; fi
  if gh stack --help >/dev/null 2>&1; then pass "gh stack available"; else warning "gh stack extension not installed"; fi
else
  warning "gh CLI not found"
fi

if git worktree list >/dev/null 2>&1; then pass "git worktree available"; else failure "git worktree unavailable"; fi

python3 -m json.tool .claude/settings.json >/dev/null 2>&1 && pass ".claude/settings.json valid JSON" || failure "invalid .claude/settings.json"
python3 -m json.tool .agentic/agentic.json >/dev/null 2>&1 && pass ".agentic/agentic.json valid JSON" || failure "invalid .agentic/agentic.json"
python3 - <<'PY' >/dev/null 2>&1
import tomllib
with open(".codex/config.toml", "rb") as f:
    tomllib.load(f)
PY
if [[ $? -eq 0 ]]; then pass ".codex/config.toml valid TOML"; else failure "invalid .codex/config.toml"; fi

printf '\nResult: %d fail, %d warn\n' "$fail" "$warn"
[[ "$fail" -eq 0 ]]
