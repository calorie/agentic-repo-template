@AGENTS.md
@.agentic/PROJECT.md

# Claude Code runtime adapter

- この project は Claude Code **ultracode** を前提とする。substantive task の execution topology は Dynamic Workflows に任せる。
- `agentic-engineering` Plugin は固定 subagent graph を先に作らず、project constraints、durable engineering state、verification requirements、Git/PR topology を補強する。
- bundled investigator / planner / worker / reviewer / verifier は native workflow が同等処理を行わない場合だけ fallback として使う。
- runtime-native workflow progress / checkpoints を優先し、transient agent state を chat や `.agent/tasks/` に重複保存しない。
- 人間に `/clear`、`/compact`、subagent 数、parallelism を管理させない。
- project 固有で durable な情報だけ `.agentic/PROJECT.md` に置く。
- Plugin と project 固有ルールが衝突する場合、repository の明示的ルールと user request を優先する。
