# Agent contract

この repository は Claude Code ultracode、Codex Ultra、その他の coding agent から扱われることを前提とする。

## Native-first execution

- substantive な開発要求では、runtime 自身の proactive multi-agent orchestration を第一選択にする。
- Claude Code では ultracode / Dynamic Workflows に task decomposition、fan-out、agent 数、runtime verification orchestration を任せる。
- Codex では Ultra の proactive delegation に task decomposition、subagent 数、execution topology を任せる。
- `agentic-engineering` は固定 worker graph を先に作らない。project constraints、durable engineering state、verification requirements、Git/PR topology を補強する。
- bundled/custom agents は native orchestration が利用できない場合、または狭い specialist role が明確に有益な場合だけ fallback として使う。

## Engineering guardrails

- 変更前に `.agentic/PROJECT.md` と既存コードの規約を確認する。未初期化・stale なら現在タスクに必要な durable facts を repository から discovery する。
- 同じ checkout に複数 writer を同時に置かない。
- 並列 write は独立 worktree / checkout と disjoint ownership が確保できる場合だけ許可する。
- DB schema、ordered migration、unstable shared interface、generated source of truth は synchronization boundary として扱う。
- unrelated な user changes を破壊・巻き戻ししない。
- 必要な検証が失敗したまま完了扱いにしない。
- native workflow 内で独立 review / verification が十分に行われた場合、同じ review を固定 fallback agent で重複させない。

## Durable engineering state

- runtime の transient agent graph、workflow queue、intermediate logs は runtime に任せる。
- session / runtime / human / PR を跨いで必要な情報だけ `.agent/tasks/` に残す。
- `SPEC.md` は goal / acceptance criteria / constraints。
- `STATE.md` は cross-session engineering progress / verification / blocker / next action。
- `DECISIONS.md` は durable rationale。
- chat transcript や runtime scratch state を durable state とみなさない。

## Review topology

Execution topology と review topology を分離する。

- 1つの焦点ある reviewable change -> 1 PR
- 独立 reviewable changes -> independent PRs
- dependent but separately reviewable foundation -> consumer changes -> GitHub Stacked PR

複数 agent を使ったという理由だけで PR を分割しない。

## Dependency policy

- 新規依存・更新依存は project constraint と互換な最新 stable を公式 registry / package-manager metadata で確認して採用する。
- lockfile がある ecosystem では lockfile を更新する。
- pre-release は明示的な理由がある場合だけ使う。
- GitHub Actions は最新 stable release を完全長 commit SHA に pin し、version comment を併記する。

## User experience

通常、ユーザーには engineering objective だけを入力してもらう。

ユーザーに agent 数、parallelism、worktree allocation、clear/compact、reviewer/verifier creation、PR topology の管理を要求しない。
