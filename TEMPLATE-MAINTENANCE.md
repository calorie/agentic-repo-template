# Template maintenance

この repository は薄く保つ。

## 中央 Plugin に置くもの

- orchestration policy
- Skills
- Agents
- Hooks
- GitHub stack workflow
- long-task protocol
- context management policy

## Template に置くもの

- central Plugin を発見・有効化する settings
- 最小 `CLAUDE.md` / `AGENTS.md`
- project-specific overlay の空の器
- runtime state directory
- setup / doctor scripts

中央 policy を Template に複製しない。Plugin 更新だけで派生 repository の挙動を改善できる状態を維持する。

## 公開設定

公開版は `calorie/agentic-engineering` を中央 Marketplace として参照する。

通常利用者に `configure-central-plugin.sh` の実行を要求しない。これは fork / custom Marketplace に切り替える場合だけ使用する。

GitHub repository settings で **Template repository** を有効にし、README の **Use this template** 導線と一致させる。

## 変更時の確認

- `.claude/settings.json` が有効な JSON であること
- `.agentic/agentic.json` が有効な JSON であること
- `scripts/*.sh` が `bash -n` を通ること
- setup が Plugin install failure を握りつぶさないこと
- README の導入手順が公開 Marketplace の実体と一致すること
