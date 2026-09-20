# Template maintenance

この repository は薄く保つ。

中央 Plugin に置くもの:
- orchestration policy
- Skills
- Agents
- Hooks
- GitHub stack workflow
- long-task protocol

Template に置くもの:
- central plugin を発見・有効化する settings
- 最小 `CLAUDE.md` / `AGENTS.md`
- project-specific overlay の空の器
- runtime state directory
- setup / doctor scripts

中央 policy を Template に複製しない。Plugin 更新だけで派生 repository の挙動を改善できる状態を維持する。
