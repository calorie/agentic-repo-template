# Agentic Engineering GitHub Template Repository

Claude Code のコンテキスト管理・エージェント並列化・長期タスク・GitHub Stacked PR を、利用者が毎回意識せずに使うための **薄い project template** です。

汎用ロジックはこの repository にコピーせず、中央の [calorie/agentic-engineering](https://github.com/calorie/agentic-engineering) Claude Code Plugin から配布します。

## 使い始める

### 1. この repository を Template として使う

GitHub 上でこの repository の **Use this template** から新しい project repository を作成します。

作成後、clone して project root へ移動します。

### 2. 初回セットアップ

各開発環境で一度だけ実行します。

```bash
./scripts/setup-agentic.sh
```

この script は次を行います。

- `calorie/agentic-engineering` Marketplace の登録
- `agentic-engineering@agentic-engineering` Plugin の install / enable
- GitHub CLI がある場合は `github/gh-stack` extension の install / update
- agentic environment の診断

Team / Enterprise で中央 Plugin を Organization settings から managed / Required 配布している場合、Plugin install は既に満たされるため、主に環境診断と `gh stack` setup が実行されます。

### 3. Claude Code を起動する

```bash
claude
```

以後は通常の開発要求だけを入力します。

```text
ユーザー検索機能を追加して。名前とメールアドレスで検索できるようにする。
```

利用者が毎回次を指定する必要はありません。

- 「subagent を使って」
- 「worktree を作って」
- 「context を節約して」
- 「/clear / /compact して」
- 「長期タスク用の state を作って」
- 「Stacked PR にして」
- 「reviewer を別 context で立てて」

中央 Plugin が task shape と project state に応じて判断します。

## 前提

最低限:

- Git
- Claude Code
- Bash
- Python 3

GitHub Stacked PR を使う場合:

- GitHub CLI (`gh`)
- GitHub への認証

状態確認:

```bash
./scripts/agentic-doctor.sh
```

Claude Code 内では Plugin の `/agentic-engineering:agentic-doctor` も利用できます。

## 2層構造

```text
Central: calorie/agentic-engineering
  Marketplace + versioned Plugin
  ├─ Skills
  ├─ Agents
  ├─ Hooks
  └─ orchestration policy
            │
            │ central update
            ▼
Project repository (this template)
  ├─ CLAUDE.md              # 極小
  ├─ AGENTS.md              # agent 共通契約
  ├─ .agentic/PROJECT.md    # project 固有情報だけ
  ├─ .agentic/agentic.json  # policy knobs
  ├─ .claude/settings.json  # central Plugin 参照
  └─ .agent/tasks/          # long-task durable state
```

Generic な Skill / Agent / Hook を project ごとにコピーしません。中央 Plugin の更新を各 project が利用できるため、orchestration policy の drift を抑えます。

## Context を人間に管理させない設計

通常運用では `/clear` / `/compact` を人間の手順にしません。

root session は control-plane に限定し、substantive な実装・広域調査・レビュー・検証を fresh-context subagent / workflow / worktree に委譲します。Claude Code の auto-compaction は safety net とし、長期タスクでは compaction summary と Git runtime state を hooks が `.agent/tasks/` に保存します。

Claude Code Plugin API には任意の `UserPromptSubmit` から現在 session をプログラム的に `/clear` する公式機構はないため、この template は「毎回物理的に clear する」のではなく、**root context を汚さない execution model** で manual clear を通常不要にします。

## Project 情報は自動 discovery

初期状態の `.agentic/PROJECT.md` には project 固有情報がほとんどありません。

最初の実質的な開発要求で中央 Plugin が repository から以下を discovery します。

- package manager / lockfile
- build / test / lint / typecheck
- CI
- task runner
- generated code と source of truth
- migration / compatibility constraint
- architecture 上の非自明な invariant

確実に判明した durable facts だけを `.agentic/PROJECT.md` に保存します。

dependency / toolchain manifest が変化した場合は profile を stale とみなし、次の substantive task で必要部分を再確認します。

## Parallelism

中央 Plugin は task shape に応じて次を選択します。

- 小さい局所変更 → main agent で直接
- repository-wide investigation → investigator subagents
- 独立 implementation → worktree-isolated worker
- dependent implementation → sequential implementation + Stacked PR
- review / verification → fresh subagents

目的は同時エージェント数の最大化ではなく、**merged throughput の最大化と conflict / rework の最小化**です。

## GitHub Stacked PR

依存する複数の review unit に分割する価値がある場合だけ GitHub native `gh stack` を利用します。

初回 setup では:

```bash
gh extension install github/gh-stack --force
```

相当の処理を実行し、extension を利用可能な最新安定版へ寄せます。

単一の小変更は通常の単一 PR、独立した変更は別 worktree / PR を優先します。

## 長期タスク

必要な場合だけ次を生成します。

```text
.agent/tasks/<task>/
├── SPEC.md
├── STATE.md       # gitignored
├── COMPACT.md     # hook-generated, gitignored
├── RUNTIME.md     # hook-generated, gitignored
└── DECISIONS.md
```

`.agent/ACTIVE_TASK` は local runtime state で Git 管理外です。

active task がある場合、Plugin が必要な durable state を次の session へ復元します。

## Version policy

- GitHub Actions は最新安定リリースを full commit SHA に固定し、version comment を併記します。
- Dependabot が GitHub Actions の更新を weekly で確認します。
- validation runtime は最新 stable Python feature series を使用します。
- project dependency は、project の runtime / compatibility constraint を満たす最新 stable を registry metadata で確認し、lockfile とともに更新します。
- pre-release を「最新」という理由だけで自動採用しません。

## Project 固有情報を追加するとき

project 固有の durable information は `.agentic/PROJECT.md` に置きます。

良い例:

- 実際の test command
- generated code の source of truth
- この repository 固有の migration 制約
- deployment / backward compatibility 制約

中央 Plugin の generic policy を project 側へコピーしないでください。

悪い例:

- 「context を節約する」
- 「subagent を使う」
- 「PR を小さくする」
- 「reviewer を fresh context にする」

これらは中央 Plugin の責務です。

## 中央 Plugin を fork / 差し替えたい場合

通常利用では不要です。

自分の Marketplace repository を使う場合だけ:

```bash
./scripts/configure-central-plugin.sh <github-owner> [plugin-repo]
git add .claude/settings.json
git commit -m "chore: configure central agentic plugin"
```

その後、各開発環境で再度 `./scripts/setup-agentic.sh` を実行してください。

## Repository maintainer 向け

この repository 自体を GitHub Template Repository として公開する場合は、GitHub の repository settings で **Template repository** を有効にしてください。

template maintenance の詳細は `TEMPLATE-MAINTENANCE.md` を参照してください。
