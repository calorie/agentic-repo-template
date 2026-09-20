#!/usr/bin/env bash
set -euo pipefail

owner="${1:-}"
repo="${2:-agentic-engineering}"

if [[ -z "$owner" ]]; then
  echo "Usage: $0 <github-owner> [plugin-repo]" >&2
  exit 2
fi

root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
settings="$root/.claude/settings.json"

python3 - "$settings" "$owner" "$repo" <<'PY'
import json, sys
from pathlib import Path
path = Path(sys.argv[1])
owner, repo = sys.argv[2], sys.argv[3]
data = json.loads(path.read_text())
market = data["extraKnownMarketplaces"]["agentic-engineering"]
market["source"]["repo"] = f"{owner}/{repo}"
path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
PY

printf 'Configured central plugin marketplace: %s/%s\n' "$owner" "$repo"
echo "Commit .claude/settings.json in the TEMPLATE repository before creating derived repositories."
