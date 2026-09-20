# Agentic Engineering Project Template

Claude Code と Codex のコンテキスト管理・エージェント並列化・長期タスク・GitHub Stacked PR を、利用者が毎回意識せずに使うための **薄い project template** です。

中央 policy は [calorie/agentic-engineering](https://github.com/calorie/agentic-engineering) から配布します。

## 最短手順

### 1. Use this template

GitHub 上で **Use this template** から新しい repository を作ります。

### 2. 初回セットアップ

clone 後、各開発環境で一度だけ:

```bash
./scripts/setup-agentic.sh
```

インストールされている runtime に応じて:

- Claude Code Marketplace / Plugin
- Codex Marketplace / Plugin
- GitHub native Stacked PR extension
- environment diagnostics

をセットアップします。

### 3. 好きな runtime を起動

```bash
claude
```

または:

```bash
codex
```

あとは通常の要求だけを入力します。

```text
ユーザー検索機能を追加して。名前とメールアドレスで検索できるようにする。
```

毎回次を指定する必要はありません。

- 「subagent を使って」
- 「worktree を作って」
- 「context を節約して」
- 「clear / compact して」
- 「長期タスク state を作って」
- 「Stacked PR にして」
- 「別 context でレビューして」

## Runtime support

| Runtime | 共通 policy | Plugin / Skills / Hooks | 並列化 |
| --- | --- | --- | --- |
| Claude Code | `AGENTS.md` + `CLAUDE.md` | 対応 | worktree-isolated worker 等 |
| Codex CLI | `AGENTS.md` | 対応 | subagents + isolated worktree/checkout |
| ChatGPT desktop の Codex | `AGENTS.md` 相当の project context | Plugin 対応環境で利用 | subagents / Worktree |
| Codex IDE extension | `AGENTS.md` | **Plugin 非対応** | Codex built-in subagents |

Codex IDE extension でも `AGENTS.md` による共通 policy は残りますが、中央 Plugin hooks の完全自動化は利用できません。

## Codex の初回注意点

project の `.codex/config.toml` は trusted project で適用されます。

また、中央 Plugin には lifecycle hooks が含まれるため、Codex では初回に hook のレビュー / trust が必要です。プロンプトを確認するか、`/hooks` で状態を確認してください。

Plugin install / update 後は新しい Codex session を開始します。

## 2層構造

```text
Central: calorie/agentic-engineering
  portable Agent Plugin
  ├─ shared Skills
  ├─ shared scripts/state protocol
  ├─ Claude adapter
  └─ Codex adapter
            │
            ▼
Project repository
  ├─ AGENTS.md              # 共通契約
  ├─ CLAUDE.md              # Claude adapter
  ├─ .claude/settings.json
  ├─ .codex/config.toml     # Codex adapter
  ├─ .agentic/PROJECT.md    # project 固有 facts
  ├─ .agentic/agentic.json
  └─ .agent/tasks/          # durable long-task state
```

## Context を人間に管理させない

root session/thread は control-plane とし、大量探索・実装試行・レビュー・検証を fresh context へ逃がします。

長期タスクでは:

```text
.agent/tasks/<task>/
├── SPEC.md
├── STATE.md
├── COMPACT.md
├── RUNTIME.md
└── DECISIONS.md
```

を使い、chat history だけに依存しません。

runtime-native compaction は safety net とし、人間に `/clear` / `/compact` のタイミング判断を通常要求しません。

## Project 情報は自動 discovery

初期の `.agentic/PROJECT.md` は intentionally minimal です。

最初の substantive task で必要に応じ:

- package manager / lockfile
- build / test / lint / typecheck
- CI
- generated code
- migration / compatibility
- architecture invariant

を自動 discovery し、durable な project facts だけ保存します。

dependency / toolchain manifest の変更も stale 判定に利用します。

## Parallelism

共通原則:

- 小さい局所変更 → 直接
- 広い調査 → fresh subagents
- reviewer / verifier → fresh subagent
- 複数 writer → **別 worktree / checkout がある場合だけ**
- 同じ checkout / schema / interface → sequential
- Stacked PR の上下 layer → sequential

目的は agent 数ではなく **merged throughput 最大化**です。

## GitHub Stacked PR

依存する複数 review unit の場合だけ `gh stack` を選択します。

```bash
gh extension install github/gh-stack --force
```

setup script が GitHub CLI を検出した場合は自動で install / update します。

## 診断

```bash
./scripts/agentic-doctor.sh
```

Claude Code では Plugin の doctor Skill も利用できます。

Codex では:

```bash
codex plugin list --marketplace agentic-engineering
```

でも install / enabled 状態を確認できます。

## Version / dependency policy

- GitHub Actions は最新安定 release を full commit SHA で pin
- Dependabot で weekly update
- validation runtime は最新 stable Python feature series
- project package は project constraint と互換な最新 stable
- lockfile がある ecosystem では lockfile も更新
- pre-release は明示的な理由がある場合だけ

## 中央 Plugin を fork / 差し替える場合

通常は不要です。

Claude 側 Marketplace を変更する helper:

```bash
./scripts/configure-central-plugin.sh <github-owner> [plugin-repo]
```

Codex 側も fork を使う場合は `.codex/config.toml` の marketplace source を同じ repository に変更してください。

## Maintainer 向け

この repository は GitHub の **Template repository** 設定を有効にしてください。

generic policy を template 側へ複製せず、中央 Plugin に集約します。詳細は `TEMPLATE-MAINTENANCE.md` を参照してください。
