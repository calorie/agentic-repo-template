@AGENTS.md
@.agentic/PROJECT.md

# Project runtime

- 汎用オーケストレーション、context 管理、並列化、長期タスク、依存更新、Stacked PR は `agentic-engineering` Plugin を正本とする。
- **人間に `/clear`、`/compact`、subagent 数、並列数を管理させない。** ルート会話は control-plane とし、実質的な開発タスクの大量調査・実装・レビューは必要に応じ fresh context へ逃がす。
- 自動 compaction は safety net とし、長期タスクの正本は `.agent/tasks/` に置く。無関係な過去タスクの詳細を新しい実装判断へ持ち込まない。
- このファイルへ汎用手順を複製しない。プロジェクト固有で Claude が毎回知らないと誤る情報だけ `.agentic/PROJECT.md` に置く。
- Plugin と project 固有ルールが衝突する場合、repository の明示的な project rule / user request を優先する。
