@AGENTS.md
@.agentic/PROJECT.md

# Claude Code runtime adapter

- This project assumes Claude Code **ultracode**. Let Dynamic Workflows own execution topology for substantive tasks.
- The `agentic-engineering` Plugin must not pre-build a fixed subagent graph. It augments project constraints, durable engineering state, verification requirements, and Git/PR topology.
- Bundled investigator, planner, worker, reviewer, and verifier agents are fallbacks only when the native workflow has not already performed equivalent work.
- Prefer runtime-native workflow progress and checkpoints. Do not duplicate transient agent state into chat or `.agent/tasks/`.
- Do not make the user manage `/clear`, `/compact`, subagent count, or parallelism.
- Put only durable project-specific facts in `.agentic/PROJECT.md`.
- If Plugin policy conflicts with explicit repository rules or the user's request, the explicit repository rule or user request takes precedence.
