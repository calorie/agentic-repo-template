# Template maintenance

この repository は Claude Code / Codex 共通の **薄い project adapter** として維持する。

## 中央 Plugin に置くもの

- orchestration policy
- Skills
- context firewall
- long-task protocol
- review / verification policy
- GitHub stack workflow
- Claude / Codex runtime adapter

## Template に置くもの

- `AGENTS.md`: runtime 共通の最小契約
- `CLAUDE.md` / `.claude/settings.json`: Claude Code adapter
- `.codex/config.toml`: Codex adapter
- `.agentic/PROJECT.md`: project-specific overlay
- `.agentic/agentic.json`: runtime-neutral policy knobs
- `.agent/tasks/`: durable state
- setup / doctor scripts

中央 policy を Template に複製しない。Plugin 更新だけで派生 repository の挙動を改善できる状態を維持する。

## 公開設定

公開版は `calorie/agentic-engineering` を中央 Marketplace として参照する。

通常利用者に Marketplace owner の書き換えを要求しない。fork / custom Marketplace に切り替える場合だけ source を変更する。

GitHub repository settings で **Template repository** を有効にし、README の Use this template 導線と一致させる。

## Runtime compatibility

Claude Code:
- `.claude/settings.json` が中央 Marketplace を参照する。
- `CLAUDE.md` は generic policy を複製せず `AGENTS.md` / project facts への adapter に留める。

Codex:
- `.codex/config.toml` が中央 Git Marketplace と Plugin enabled state を定義する。
- `AGENTS.md` が Plugin 非対応 surface を含む fallback policy になる。
- unmanaged Plugin hooks の trust review が必要であることを README に維持する。

## 変更時の確認

- `.claude/settings.json` が valid JSON
- `.agentic/agentic.json` が valid JSON
- `.codex/config.toml` が valid TOML
- `scripts/*.sh` が `bash -n` を通る
- setup が Claude / Codex Plugin install failure を握りつぶさない
- README の install command が現行 CLI と一致する
- Codex IDE の Plugin 非対応という境界を誤って消さない
