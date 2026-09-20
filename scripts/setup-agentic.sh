#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$root"

if grep -q '__GITHUB_OWNER__' .claude/settings.json; then
  echo "ERROR: central plugin owner is not configured." >&2
  echo "Run: scripts/configure-central-plugin.sh <github-owner>" >&2
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
  echo "Registering Claude Code marketplace: $market_repo"
  claude plugin marketplace add "$market_repo" || true
  echo "Installing/enabling agentic-engineering plugin"
  claude plugin install agentic-engineering@agentic-engineering || true
else
  echo "WARN: claude CLI not found; project settings will request the marketplace when Claude Code trusts this repository."
fi

if command -v gh >/dev/null 2>&1; then
  echo "Installing/upgrading GitHub native stacked-PR extension to latest stable"
  gh extension install github/gh-stack --force || true
else
  echo "WARN: gh CLI not found; native stacked PR automation will be unavailable until installed."
fi

"$root/scripts/agentic-doctor.sh"
