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

if python3 - <<'PY' >/dev/null 2>&1
import json
with open(".claude/settings.json", encoding="utf-8") as f:
    data = json.load(f)
raise SystemExit(0 if data.get("ultracode") is True else 1)
PY
then
  pass "Claude project requests ultracode"
else
  failure "Claude project does not request ultracode"
fi

if command -v claude >/dev/null 2>&1; then
  pass "claude CLI available"
  if claude --effort ultracode --version >/dev/null 2>&1; then
    pass "claude CLI accepts ultracode"
  else
    failure "claude CLI does not accept --effort ultracode; upgrade Claude Code"
  fi
else
  warning "claude CLI not found"
fi

if grep -Eq '^model_reasoning_effort[[:space:]]*=[[:space:]]*"ultra"[[:space:]]*$' .codex/config.toml 2>/dev/null; then
  pass "Codex project requests Ultra reasoning"
else
  failure "Codex project does not request model_reasoning_effort = \"ultra\""
fi

if awk '
  /^\[agents\][[:space:]]*$/ { in_agents=1; next }
  /^\[/ { in_agents=0 }
  in_agents && /^[[:space:]]*enabled[[:space:]]*=[[:space:]]*true[[:space:]]*$/ { found=1 }
  END { exit(found ? 0 : 1) }
' .codex/config.toml 2>/dev/null; then
  pass "Codex multi-agent tools enabled"
else
  failure "Codex [agents] enabled = true missing"
fi

codex_marketplace_ok=0
if command -v codex >/dev/null 2>&1; then
  pass "codex CLI available"
  tmp_codex="/tmp/agentic-codex-plugins.$$"
  if codex plugin list --marketplace agentic-engineering --json >"$tmp_codex" 2>/dev/null; then
    codex_marketplace_ok=1
    if grep -q '"installed"[[:space:]]*:[[:space:]]*true' "$tmp_codex"; then
      pass "agentic-engineering Codex plugin installed"
    else
      warning "agentic-engineering Codex plugin is not installed"
    fi
  else
    warning "Codex marketplace/plugin status unavailable; run scripts/setup-agentic.sh"
  fi
  rm -f "$tmp_codex"
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

toml_checked=0
if python3 -c 'import tomllib' >/dev/null 2>&1; then
  toml_checked=1
  if python3 - <<'PY' >/dev/null 2>&1
import tomllib
with open(".codex/config.toml", "rb") as f:
    tomllib.load(f)
PY
  then
    pass ".codex/config.toml valid TOML"
  else
    failure "invalid .codex/config.toml"
  fi
elif python3 -c 'import tomli' >/dev/null 2>&1; then
  toml_checked=1
  if python3 - <<'PY' >/dev/null 2>&1
import tomli
with open(".codex/config.toml", "rb") as f:
    tomli.load(f)
PY
  then
    pass ".codex/config.toml valid TOML (tomli)"
  else
    failure "invalid .codex/config.toml"
  fi
elif [[ "$codex_marketplace_ok" -eq 1 ]]; then
  toml_checked=1
  pass ".codex/config.toml accepted by Codex"
fi

if [[ "$toml_checked" -eq 0 ]]; then
  warning ".codex/config.toml syntax check skipped (need Python 3.11+, tomli, or Codex)"
fi

printf '\nResult: %d fail, %d warn\n' "$fail" "$warn"
[[ "$fail" -eq 0 ]]
