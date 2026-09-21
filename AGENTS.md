# Agent contract

This repository uses a minimal, cost-aware engineering policy.

## Effort and orchestration

Start ordinary work at the runtime/model default.

Escalate only when the task is meaningfully long-running, codebase-wide, strongly parallelizable, difficult to verify manually, or expensive to get wrong.

- Claude Code: use Dynamic Workflows for high-leverage work when available. Do not require ultracode for every session.
- Codex: keep multi-agent capability available, but do not require Ultra reasoning for every task.
- Let the native runtime own decomposition, agent count, fan-out, and transient workflow state.

The user should normally provide the engineering objective, not orchestration instructions.

## Methodology plugins

If Superpowers is installed:

- use TDD, systematic debugging, and verification methodology when useful;
- do not nest another scheduler under an already active native workflow;
- deduplicate equivalent planning, review, verification, and worktree setup.

If Ponytail is installed:

- prefer the simplest correct implementation;
- explicit requirements, safety, and repository invariants take precedence over minimization.

## Engineering guardrails

- Read `.agentic/PROJECT.md` before substantive changes when it exists.
- Never place multiple concurrent writers in the same checkout.
- Parallel writes require isolated worktrees/checkouts and disjoint ownership.
- Treat shared schemas, ordered migrations, unstable interfaces, generated sources of truth, and scarce mutable test infrastructure as synchronization boundaries.
- Never revert unrelated user changes.
- Do not declare completion while relevant verification is failing.

## Durable state

Keep transient runtime state in the runtime.

For work that must survive sessions, runtimes, pull requests, or human handoff, use only what is needed under:

```text
.agent/tasks/<task>/
├── SPEC.md
├── STATE.md
└── DECISIONS.md
```

Persist stable requirements, progress, verification status, blockers, and durable rationale. Do not persist native agent graphs, workflow queues, compaction state, or full transcripts.

## Review topology

- one focused reviewable change -> one PR;
- independent reviewable changes -> independent PRs;
- dependent but independently reviewable changes -> GitHub Stacked PRs.

Execution topology does not determine PR topology.

## Dependency policy

- Use the latest stable dependency version compatible with project constraints.
- Update lockfiles when supported.
- Pin GitHub Actions to the full commit SHA of the latest stable release and include a version comment.
- Use pre-release versions only for an explicit reason.
