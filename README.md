# Agentic Engineering GitHub Template Repository

Claude Code のコンテキスト管理・エージェント並列化・長期タスク・GitHub Stacked PR を、利用者が毎回意識せずに使うための **薄い project template** です。

汎用ロジックはこの repository にコピーせず、中央の `agentic-engineering` Claude Code Plugin から配布します。

## Context を人間に管理させない設計

通常運用では `/clear` / `/compact` を人間の手順にしません。ルート session は control-plane に限定し、substantive な実装・広域調査は fresh-context subagent / Dynamic Workflow / worktree に委譲します。Claude Code の auto-compaction は safety net とし、長期タスクでは compaction summary と Git runtime state を hooks が `.agent/tasks/` に自動保存します。

ただし Claude Code Plugin API には、任意の `UserPromptSubmit` から現在 session をプログラム的に `/clear` する公式機構はありません。そのため「物理的に毎トップレベル要求を必ず新 session にする」ことまで厳密保証したい場合は Agent SDK / 外部 launcher が必要です。この template は通常の Claude Code UI で手動 clear を不要にすることを目標にしています。

初回は `.agentic/PROJECT.md` が pending です。次の実質的な開発要求で中央 Plugin が package manager、lockfile、CI、build/test/lint/typecheck 等を自動 discovery し、durable な project facts だけを profile に保存します。依存 manifest の変更は FileChanged hook が profile を stale にするため、次タスクで自動再確認されます。

## Version policy

- GitHub Actions は最新安定リリースを full commit SHA に固定し、version comment を併記します。Dependabot が weekly で更新します。
- validation runtime は現在の最新 stable Python feature series を指定し、`check-latest: true` で patch release を追従します。
- `gh-stack` は setup 時に `--force` で latest stable release へ更新します。
- project 依存は最新安定版かつ既存互換性を満たすものを registry で確認し、lockfile を更新します。

## 2層構造

```text
Central: agentic-engineering repository
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
  ├─ .claude/settings.json  # central plugin 参照
  └─ .agent/tasks/          # long-task durable state
```

## Template 管理者が最初に1回だけ行うこと

この template repository 自体で中央 Plugin の GitHub owner を設定します。

```bash
./scripts/configure-central-plugin.sh <github-owner>
git add .claude/settings.json
git commit -m "chore: configure central agentic plugin"
```

その後 GitHub の Settings で **Template repository** を有効にします。

## この Template から作った project

Claude Code を初めて開く前または初回に:

```bash
./scripts/setup-agentic.sh
```

Team / Enterprise で中央 Plugin を Organization settings から Required 配布している場合、Plugin インストール部分は既に満たされるため、この script は環境診断と `gh stack` セットアップが主になります。

設定後は通常どおり:

```bash
claude
```

そして次のプロンプトから、例えば単に:

```text
ユーザー検索機能を追加して。名前とメールアドレスで検索できるようにする。
```

と依頼します。

利用者が以下を毎回指定する必要はありません。

- 「subagent を使って」
- 「worktree を作って」
- 「context を節約して」
- 「長期タスク用の state を作って」
- 「Stacked PR にして」
- 「reviewer を別 context で立てて」

中央 Plugin がタスク形状に応じて自動判断します。

## Context の考え方

常時読み込む project 側のテキストを小さく保ちます。

- `CLAUDE.md`: Plugin と project overlay の接続だけ
- `AGENTS.md`: agent 非依存の最小契約
- `.agentic/PROJECT.md`: project 固有で毎回必要な非自明情報だけ
- 詳細手順: Plugin Skills（必要時だけロード）
- 広い調査: subagent
- 長期進捗: `.agent/tasks/<task>/STATE.md`

`.agent/ACTIVE_TASK` がある場合、Plugin の SessionStart hook が該当 task の SPEC / STATE を自動的に context へ戻します。

## Parallelism

Plugin は以下を自動選択します。

- 小さい局所変更 → main agent で直接
- repository-wide investigation → investigator subagents
- 独立 implementation → worktree-isolated worker
- dependent implementation → sequential + Stacked PR
- review / verification → fresh subagents

同時エージェント数の最大化ではなく、merged throughput と conflict / rework の最小化を目的にします。

## GitHub Stacked PR

GitHub native `gh stack` を利用します。依存する複数 review unit の場合のみ stack を選択します。

```bash
gh extension install github/gh-stack --force
```

Stacked PR は GitHub 上で public preview のため、中央 Plugin 側に workflow を集約し、仕様変更時は中央だけ更新する設計です。

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

## project 固有情報を追加するとき

`.agentic/PROJECT.md` にだけ追加します。中央 Plugin の generic policy を project 側へコピーしないでください。

良い例:
- 実際の test command
- generated code の source of truth
- この repository 固有の migration 制約

悪い例:
- 「context を節約する」
- 「subagent を使う」
- 「PR を小さくする」

これらは中央 Plugin の責務です。

## 診断

```bash
./scripts/agentic-doctor.sh
```

Claude Code 内では Plugin の `/agentic-engineering:agentic-doctor` も利用できます。
