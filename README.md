# Agentic Engineering Project Template

This project template uses Claude Code **ultracode** and Codex **Ultra** as native execution engines so users do not have to manage agent count, parallelism, context cleanup, or review topology on every task.

The central policy is distributed from https://github.com/calorie/agentic-engineering.

## Quick start

### 1. Use this template

Create a new repository from GitHub's **Use this template** action.

### 2. Run first-time setup

```bash
./scripts/setup-agentic.sh
```

Depending on the runtimes installed on the machine, setup checks and configures:

- Claude Code Marketplace / Plugin;
- Claude ultracode capability;
- Codex Marketplace / Plugin;
- Codex Ultra project configuration;
- GitHub Stacked PR extension;
- environment diagnostics.

### 3. Start the runtime normally

```bash
claude
# or
codex
```

Then provide only the engineering objective:

```text
Add user search by name and email address.
```

## Runtime model

```text
                   AGENTS.md / agentic-engineering
                   engineering policy
                  /                  \
                 /                    \
        Claude Code                    Codex
        ultracode                      Ultra
        Dynamic Workflows              proactive delegation
             |                              |
             +------ native execution ------+
                         |
                  verified changes
                         |
                 Git / PR topology
```

### Claude Code

`.claude/settings.json` requests ultracode.

ultracode combines high reasoning effort with native Dynamic Workflow decisions for substantive tasks.

Bundled investigator, planner, worktree-worker, reviewer, and verifier agents are **fallbacks**. Do not launch them redundantly when the native workflow already performs equivalent work.

To start ultracode explicitly:

```bash
claude --effort ultracode
```

The setup/doctor scripts verify that the current Claude CLI accepts this flag when Claude is installed.

### Codex

`.codex/config.toml` sets:

```toml
model_reasoning_effort = "ultra"

[agents]
enabled = true
```

On supported models/accounts, let Codex proactively delegate suitable work to subagents. Do not statically copy Claude's Dynamic Workflow graph into Codex.

The Codex IDE extension does not currently support Plugins. On that surface, `AGENTS.md` remains the fallback policy. Use Codex CLI or another Plugin-capable Codex surface for Plugin / Hooks / bundled Skills behavior.

## Agentic Engineering responsibilities

Leave these to the runtime:

- task decomposition;
- agent count;
- fan-out;
- staged execution;
- transient workflow state;
- runtime-native review/verification orchestration.

Agentic Engineering owns:

- project-specific durable facts;
- parallel-write safety boundaries;
- cross-session engineering state;
- verification requirements;
- dependency/version policy;
- single PR / independent PR / Stacked PR topology.

## Parallel-write safety

- never place multiple writers in the same checkout;
- allow parallel writes only with isolated worktrees/checkouts and disjoint ownership;
- treat shared DB schemas, ordered migrations, and unstable interfaces as synchronization boundaries;
- preserve dependency order for dependent Stacked PR layers.

The native runtime decides parallelism, but it must stay within these boundaries.

## Context and long-running work

Do not duplicate runtime-native workflow state.

Durable engineering state:

```text
.agentic/PROJECT.md

.agent/tasks/<task>/
├── SPEC.md
├── STATE.md
└── DECISIONS.md
```

`COMPACT.md` and `RUNTIME.md` are fallback diagnostics.

Do not require users to manage `/clear` or `/compact` timing.

## Project discovery

When `.agentic/PROJECT.md` is pending or stale, discover only the project facts needed for correct work:

- build / test / lint / typecheck;
- package manager / lockfile;
- generated-code source of truth;
- CI / task runner;
- migration / compatibility constraints;
- durable architecture invariants.

## Review topology

Execution topology and PR topology are separate.

- one focused change -> one PR;
- independent reviewable changes -> independent PRs;
- dependent but separately reviewable changes -> GitHub Stacked PRs.

Do not split pull requests merely because multiple agents were used.

## Diagnostics

```bash
./scripts/agentic-doctor.sh
```

The 0.4.x doctor checks at least:

- the Claude project requests ultracode;
- the installed Claude CLI accepts ultracode, when present;
- the Codex project requests Ultra reasoning;
- Codex multi-agent tools are enabled;
- the Plugin is installed;
- Git worktree support;
- GitHub authentication and `gh stack`;
- JSON/TOML validity.

If Claude CLI is intentionally not installed, `WARN claude CLI not found` is expected.

## Migrating an existing 0.2 / 0.3 / 0.4.0 repository

Do not merge the entire template repository. Update only agent infrastructure:

```bash
git remote add agentic-template https://github.com/calorie/agentic-repo-template.git 2>/dev/null || true
git fetch agentic-template main

git checkout agentic-template/main -- \
  AGENTS.md \
  CLAUDE.md \
  .claude/settings.json \
  .codex/config.toml \
  .agentic/agentic.json \
  scripts/setup-agentic.sh \
  scripts/agentic-doctor.sh \
  scripts/configure-central-plugin.sh \
  .github/workflows/agentic-contract.yml
```

Preserve:

- application code;
- `.agentic/PROJECT.md`;
- `.agent/tasks/**`;
- intentionally added project-specific rules.

Then run:

```bash
./scripts/setup-agentic.sh
./scripts/agentic-doctor.sh
```

## Version / dependency policy

- GitHub Actions: latest stable release pinned to a full commit SHA;
- Dependabot: weekly updates;
- project dependencies: latest stable compatible version;
- update lockfiles when supported;
- pre-release versions only for explicit reasons.

## Fork / custom central marketplace

```bash
./scripts/configure-central-plugin.sh <github-owner> [plugin-repo]
```

The helper updates both Claude Code and Codex Marketplace sources.

## Maintainer notes

Enable GitHub's **Template repository** setting for this repository.

Keep generic orchestration implementation out of the template; prefer the central Plugin and native runtime capabilities.
