# Agentic Engineering Project Template

A thin project template for https://github.com/calorie/agentic-engineering.

The template intentionally avoids custom orchestration scripts. Claude Code and Codex own execution; the repository provides only a small shared engineering contract.

## Quick start

Create a repository from **Use this template**, then install the Plugin for the runtime you use.

### Claude Code

```bash
claude plugin marketplace add calorie/agentic-engineering
claude plugin install agentic-engineering@agentic-engineering
```

### Codex

```bash
codex plugin marketplace add calorie/agentic-engineering \
  --sparse .agents/plugins \
  --sparse plugins/agentic-engineering

codex plugin add agentic-engineering@agentic-engineering
```

The repository configuration already enables the Plugin after it is installed.

## Cost-aware execution

Do **not** run maximum effort for every task.

Start ordinary work at the model/runtime default. Escalate when work is long-running, codebase-wide, strongly parallelizable, hard to verify manually, or expensive to get wrong.

### Claude Code

This template does not persist ultracode.

For a high-leverage session where automatic Dynamic Workflow selection is desirable:

```bash
claude --effort ultracode
```

For ordinary work, launch Claude normally:

```bash
claude
```

Dynamic Workflow availability depends on the account and administrator settings.

### Codex

This template enables multi-agent tools but does not pin project-level Ultra reasoning.

Use the normal runtime/model default for ordinary work and increase reasoning/delegation when the task justifies the additional usage.

## Responsibilities

The runtime owns:

- decomposition;
- agent count;
- fan-out;
- transient workflow state.

The repository policy owns:

- safe write isolation;
- durable project facts and long-task state;
- relevant verification evidence;
- final Git/PR topology.

## Superpowers and Ponytail

Superpowers is optional and should be treated as methodology, not as a second scheduler. TDD, systematic debugging, and verification compose well with native runtime execution; avoid nested scheduling and duplicate review/worktree setup.

Ponytail is optional and should bias implementation toward the simplest correct solution without overriding explicit requirements, safety, or repository invariants.

## Durable state

Use `.agentic/PROJECT.md` for durable repository facts.

For work that must survive sessions or human handoff:

```text
.agent/tasks/<task>/
├── SPEC.md
├── STATE.md
└── DECISIONS.md
```

No custom compaction, active-task, or runtime checkpoint framework is required.

## Review topology

- one focused change -> one PR;
- independent changes -> independent PRs;
- dependent but separately reviewable changes -> GitHub Stacked PRs.

## Existing 0.4.x repository migration

Fetch the current template and update the small repository contract:

```bash
git remote add agentic-template https://github.com/calorie/agentic-repo-template.git 2>/dev/null || true
git fetch agentic-template main

git checkout agentic-template/main -- \
  AGENTS.md \
  CLAUDE.md \
  .claude/settings.json \
  .codex/config.toml \
  .agentic/PROJECT.md \
  .github/workflows/agentic-contract.yml \
  .gitignore
```

Remove obsolete 0.4.x infrastructure if it exists:

```bash
git rm -f .agentic/agentic.json 2>/dev/null || true
git rm -rf scripts 2>/dev/null || true
git rm -rf .agent/plans 2>/dev/null || true
git rm -f .agent/tasks/.gitignore 2>/dev/null || true
```

Preserve application code and any meaningful durable task files.

Then update/reinstall the central Plugin with the normal Claude Code or Codex Plugin commands above.

## Repository layout

```text
.
├── AGENTS.md
├── CLAUDE.md
├── .claude/settings.json
├── .codex/config.toml
├── .agentic/PROJECT.md
└── .agent/tasks/
```

That is intentionally most of the agent infrastructure.
