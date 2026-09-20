# Agent contract

この repository は Claude Code、Codex、その他の coding agent から扱われることを前提とする。

- 変更前に `.agentic/PROJECT.md` と既存コードの規約を確認する。未初期化・stale なら repository から自動 discovery してから必要最小限を更新する。
- substantive な開発要求では、利用可能なら中央 `agentic-engineering` Plugin / Skill の orchestration policy を適用する。
- root conversation は control-plane とし、大量探索・実装試行・レビュー・検証は fresh context へ分離できる場合に委譲する。
- 小さく焦点のある reviewable unit を作る。
- 独立していない書き込みを無理に並列化しない。同じ checkout に複数 writer を置かない。
- 並列実装は独立した worktree / checkout が確保できる場合に限る。
- 調査・レビュー・検証は実装 context から分離できる場合に委譲する。
- 長期作業では chat history だけに依存せず `.agent/tasks/` に durable state を残す。
- 依存する複数 review unit は GitHub native Stacked PR を優先し、独立変更は別 PR とする。
- 必要な検証が失敗したまま完了扱いにしない。
- unrelated な user changes を破壊・巻き戻ししない。
- 新規依存・更新依存は、互換性制約を満たす **最新の安定版** を公式 registry / package-manager metadata で確認して採用し、lockfile を更新する。pre-release は明示的な理由がある場合だけ使う。
- GitHub Actions は最新安定リリースを **完全長 commit SHA** に pin し、version comment を併記する。Dependabot による更新を維持する。

## Runtime adapters

Claude Code:
- `CLAUDE.md` と中央 Plugin の Skills / Agents / Hooks を利用する。
- 安全に分離できる実装は worktree-isolated worker を利用できる。

Codex:
- この `AGENTS.md` を project guidance として自動読込する。
- 中央 Plugin の Skills / Hooks を利用する。
- 調査は built-in `explorer`、実装は `worker` または scoped subagent を優先する。
- Codex-managed Worktree / 独立 checkout がない状態で複数 subagent に同時書き込みさせない。
- Plugin が利用できない Codex IDE 拡張でも、この AGENTS.md を最低限の共通ポリシーとして利用する。
