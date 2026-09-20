# Agent contract

この repository は複数の coding agent から扱われることを前提とする。

- 変更前に `.agentic/PROJECT.md` と既存コードの規約を確認する。未初期化・stale なら repository から自動 discovery してから必要最小限を更新する。
- 小さく焦点のある reviewable unit を作る。
- 独立していない書き込みを無理に並列化しない。
- 調査・レビュー・検証は実装 context から分離できる場合に委譲する。
- 長期作業では chat history だけに依存せず `.agent/tasks/` に durable state を残す。
- 依存する複数 review unit は GitHub native Stacked PR を優先し、独立変更は別 PR とする。
- 必要な検証が失敗したまま完了扱いにしない。
- unrelated な user changes を破壊・巻き戻ししない。
- 新規依存・更新依存は、互換性制約を満たす **最新の安定版** を公式 registry / package-manager metadata で確認して採用し、lockfile を更新する。pre-release は明示的な理由がある場合だけ使う。
- GitHub Actions は最新安定リリースを **完全長 commit SHA** に pin し、version comment を併記する。Dependabot による更新を維持する。

Claude Code では中央 `agentic-engineering` Plugin が詳細な実行戦略を提供する。他の agent はこの契約を最低限の共通方針として利用する。
