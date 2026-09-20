#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$root"

if grep -q '__GITHUB_OWNER__' .claude/settings.json; then
  echo "ERROR: central plugin owner is not configured." >&2
  echo "Run only when using a fork/custom marketplace:" >&2
  echo "  scripts/configure-central-plugin.sh <github-owner> [plugin-repo]" >&2
  exit 1
fi

market_repo="$(python3 - <<'PY'
import json
with open('.claude/settings.json') as f:
    d=json.load(f)
print(d['extraKnownMarketplaces']['agentic-engineering']['source']['repo'])
PY
)"

if command -v claude >/dev/null 2>&1; then
  echo "Configuring Claude Code marketplace: $market_repo"
  claude plugin marketplace add "$market_repo"
  echo "Installing/enabling agentic-engineering for Claude Code"
  claude plugin install agentic-engineering@agentic-engineering
else
  echo "INFO: claude CLI not found; Claude Code setup skipped."
fi

if command -v codex >/dev/null 2>&1; then
  echo "Configuring Codex marketplace: $market_repo"
  if codex plugin marketplace list 2>/dev/null | grep -q 'agentic-engineering'; then
    codex plugin marketplace upgrade agentic-engineering
  else
    codex plugin marketplace add "$market_repo" --sparse .agents/plugins --sparse plugins/agentic-engineering
  fi

  if codex plugin list --marketplace agentic-engineering --json 2>/dev/null | grep -q '"installed"[[:space:]]*:[[:space:]]*true'; then
    echo "agentic-engineering is already installed for Codex; marketplace upgrade refreshed it."
  else
    echo "Installing agentic-engineering for Codex"
    codex plugin add agentic-engineering@agentic-engineering
  fi

  cat <<'MSG'
NOTE: Codex requires review/trust for unmanaged plugin hooks.
On first Codex launch, review the agentic-engineering hooks when prompted (or open /hooks).
After plugin installation/update, start a new Codex session so skills and hooks are loaded.
MSG
else
  echo "INFO: codex CLI not found; Codex setup skipped."
fi

if command -v gh >/dev/null 2>&1; then
  echo "Installing/upgrading GitHub native stacked-PR extension"
  gh extension install github/gh-stack --force
else
  echo "WARN: gh CLI not found; native stacked PR automation will be unavailable until installed." >&2
fi

"$root/scripts/agentic-doctor.sh"
