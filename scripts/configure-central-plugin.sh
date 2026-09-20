#!/usr/bin/env bash
set -euo pipefail

owner="${1:-}"
repo="${2:-agentic-engineering}"

if [[ -z "$owner" ]]; then
  echo "Usage: $0 <github-owner> [plugin-repo]" >&2
  exit 2
fi

root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
claude_settings="$root/.claude/settings.json"
codex_config="$root/.codex/config.toml"
repo_slug="$owner/$repo"
repo_url="https://github.com/$repo_slug.git"

python3 - "$claude_settings" "$codex_config" "$repo_slug" "$repo_url" <<'PY'
import json
import re
import sys
from pathlib import Path

claude_path = Path(sys.argv[1])
codex_path = Path(sys.argv[2])
repo_slug = sys.argv[3]
repo_url = sys.argv[4]

data = json.loads(claude_path.read_text(encoding="utf-8"))
market = data["extraKnownMarketplaces"]["agentic-engineering"]
market["source"]["repo"] = repo_slug
claude_path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

text = codex_path.read_text(encoding="utf-8")
pattern = r'(?ms)(\[marketplaces\.agentic-engineering\].*?^source\s*=\s*)".*?"'
updated, count = re.subn(pattern, lambda m: m.group(1) + json.dumps(repo_url), text, count=1)
if count != 1:
    raise SystemExit("Could not update [marketplaces.agentic-engineering] source in .codex/config.toml")
codex_path.write_text(updated, encoding="utf-8")
PY

printf 'Configured central plugin marketplace for Claude Code and Codex: %s\n' "$repo_slug"
echo "Commit .claude/settings.json and .codex/config.toml before creating derived repositories."
