# Agent contract

This repository is designed to be used by Claude Code ultracode, Codex Ultra, and other coding agents.

## Native-first execution

- For substantive engineering requests, prefer the runtime's own proactive multi-agent orchestration.
- In Claude Code, let ultracode / Dynamic Workflows own task decomposition, fan-out, agent count, and runtime verification orchestration.
- In Codex, let Ultra proactive delegation own task decomposition, subagent count, and execution topology.
- `agentic-engineering` must not pre-build a fixed worker graph. It augments project constraints, durable engineering state, verification requirements, and Git/PR topology.
- Use bundled/custom agents only as fallbacks when native orchestration is unavailable or when a narrow specialist role is clearly useful.

## Superpowers compatibility

If Superpowers is installed, use it as a methodology provider rather than as a second scheduler.

Prefer methodology skills such as:

- `test-driven-development`
- `systematic-debugging`
- `verification-before-completion`
- `receiving-code-review`

Use `brainstorming`, `writing-plans`, `requesting-code-review`, `using-git-worktrees`, and `finishing-a-development-branch` only when they add value not already supplied by the runtime.

When native proactive orchestration is active, do not let these skills take over execution topology:

- `subagent-driven-development`
- `dispatching-parallel-agents`
- `executing-plans`

Preserve their useful principles inside the native workflow instead of nesting another scheduler.

Deduplicate equivalent code review, verification, and worktree setup across the runtime, Superpowers, and Agentic Engineering.

Do not manufacture extra human approval checkpoints for requirements that are already clear. Explicit user requests for a specific Superpowers workflow still take precedence, subject to repository safety constraints.

## Engineering guardrails

- Before changing code, read `.agentic/PROJECT.md` and the existing project conventions. If the profile is uninitialized or stale, discover only the durable facts required for the current task.
- Never place multiple writers in the same checkout at the same time.
- Allow parallel writes only when isolated worktrees/checkouts and disjoint ownership are available.
- Treat shared DB schemas, ordered migrations, unstable shared interfaces, and generated sources of truth as synchronization boundaries.
- Never destroy or revert unrelated user changes.
- Do not declare completion while required verification is failing.
- If the native workflow has already performed sufficient independent review or verification, do not duplicate the same work with a fixed fallback agent.

## Durable engineering state

- Leave transient agent graphs, workflow queues, and intermediate logs to the runtime.
- Persist only information that must survive sessions, runtimes, humans, or pull requests under `.agent/tasks/`.
- `SPEC.md` stores the goal, acceptance criteria, and constraints.
- `STATE.md` stores cross-session engineering progress, verification status, blockers, and the next action.
- `DECISIONS.md` stores durable rationale.
- Do not treat chat transcripts or runtime scratch state as durable state.

## Review topology

Keep execution topology separate from review topology.

- one focused reviewable change -> one PR
- independent reviewable changes -> independent PRs
- dependent but separately reviewable foundation -> consumer changes -> GitHub Stacked PRs

Do not split pull requests merely because multiple agents were used.

## Dependency policy

- For new or updated dependencies, verify the latest stable version compatible with project constraints using the official registry or package-manager metadata.
- Update the lockfile when the ecosystem supports one.
- Use pre-release versions only for an explicit reason.
- Pin GitHub Actions to the full commit SHA of the latest stable release and include a version comment.

## User experience

The user should normally provide only the engineering objective.

Do not ask the user to manage agent count, parallelism, worktree allocation, clear/compact commands, reviewer/verifier creation, or PR topology.
