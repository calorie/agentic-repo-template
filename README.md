# Agentic Engineering Project Template

Claude Code **ultracode** と Codex **Ultra** を native execution engine とし、利用者が agent 数・parallelism・context cleanup・review topology を毎回管理しなくてよい project template です。

中央 policy は https://github.com/calorie/agentic-engineering から配布します。

## 最短手順

### 1. Use this template

GitHub 上で **Use this template** から repository を作成します。

### 2. 初回 setup

```bash
./scripts/setup-agentic.sh
```

setup は利用可能な runtime に応じて:

- Claude Code Marketplace / Plugin
- Claude ultracode capability
- Codex Marketplace / Plugin
- Codex Ultra project configuration
- GitHub Stacked PR extension
- environment diagnostics

を確認します。

### 3. 普通に起動

```bash
claude
# または
codex
```

あとは engineering objective だけを入力します。

```text
ユーザー検索機能を追加して。名前とメールアドレスで検索できるようにする。
```

## 0.4 runtime model

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

`.claude/settings.json` で ultracode を要求します。

ultracode は xhigh reasoning に加えて、substantive task について Dynamic Workflow を使うべきか Claude 自身が判断します。

Plugin に同梱された investigator / planner / worktree-worker / reviewer / verifier は **fallback** です。native workflow が同等の仕事を行っている場合は重複して起動しません。

明示的に起動したい場合:

```bash
claude --effort ultracode
```

setup/doctor は current Claude CLI がこの flag を受け付けることを確認します。

### Codex

`.codex/config.toml` は:

```toml
model_reasoning_effort = "ultra"

[agents]
enabled = true
```

を設定します。

Ultra 対応 model/account では Codex 自身が suitable work を proactive に subagent へ委譲します。Claude の Dynamic Workflow graph を Codex 側へ静的にコピーしません。

Codex IDE extension は Plugin 非対応です。その surface では `AGENTS.md` が fallback policy になります。Plugin / Hooks / bundled Skills を使う場合は Codex CLI または Plugin 対応 surface を利用します。

## Agentic Engineering が担当するもの

Runtime に任せる:

- task decomposition
- agent count
- fan-out
- staged execution
- transient workflow state
- runtime-native review/verification orchestration

Agentic Engineering が担当:

- project-specific durable facts
- parallel-write safety boundaries
- cross-session engineering state
- verification requirements
- dependency/version policy
- single PR / independent PR / Stacked PR

## Parallel write safety

- same checkout に複数 writer を置かない
- parallel write は isolated worktree / checkout + disjoint ownership がある場合だけ
- shared DB schema / ordered migration / unstable interface は synchronization boundary
- dependent Stacked PR layers は dependency order を守る

Native runtime が parallelism を決めますが、この boundary は越えません。

## Context / long tasks

Runtime-native workflow state を duplicate しません。

Durable engineering state:

```text
.agentic/PROJECT.md

.agent/tasks/<task>/
├── SPEC.md
├── STATE.md
└── DECISIONS.md
```

`COMPACT.md` / `RUNTIME.md` は fallback diagnostics です。

ユーザーに `/clear` / `/compact` のタイミング管理を通常要求しません。

## Project discovery

`.agentic/PROJECT.md` が pending/stale の場合だけ必要な project facts を discovery します。

対象:

- build / test / lint / typecheck
- package manager / lockfile
- generated code source of truth
- CI/task runner
- migration / compatibility constraints
- durable architecture invariants

## Review topology

Execution topology と PR topology は別物です。

- one focused change -> 1 PR
- independent reviewable changes -> independent PRs
- dependent but separately reviewable changes -> GitHub Stacked PR

複数 agents が使われたという理由だけで PR を分割しません。

## Diagnose

```bash
./scripts/agentic-doctor.sh
```

0.4 では少なくとも次を確認します。

- Claude project requests ultracode
- current Claude CLI accepts ultracode, when installed
- Codex project requests Ultra reasoning
- Codex multi-agent tools enabled
- Plugin installed
- Git worktree
- GitHub auth / gh stack
- JSON/TOML validity

Claude CLI を使わない環境では `WARN claude CLI not found` は正常です。

## Existing 0.2 / 0.3 repository migration

Template repository 全体を merge せず、agent infrastructure だけ更新してください。

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

保持するもの:

- application code
- `.agentic/PROJECT.md`
- `.agent/tasks/**`
- project-specific rules that were intentionally added

その後:

```bash
./scripts/setup-agentic.sh
./scripts/agentic-doctor.sh
```

## Version / dependency policy

- GitHub Actions: latest stable release + full commit SHA
- Dependabot: weekly updates
- project dependencies: latest stable compatible
- lockfile update where supported
- pre-release only for explicit reasons

## Fork / custom central marketplace

```bash
./scripts/configure-central-plugin.sh <github-owner> [plugin-repo]
```

Claude Code と Codex の source を同時に更新します。

## Maintainer

この repository は GitHub の **Template repository** 設定を有効にしてください。

generic orchestration implementation を template に複製せず、中央 Plugin と native runtimes に寄せます。
