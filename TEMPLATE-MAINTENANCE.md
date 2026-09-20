# Template maintenance

この repository は Claude Code ultracode / Codex Ultra を利用する薄い project adapter として維持する。

## Native-first rule

実行方法を template や Plugin で固定しない。

Claude:
- ultracode / Dynamic Workflows が execution topology を所有する。

Codex:
- Ultra proactive multi-agent が execution topology を所有する。

Agentic Engineering:
- project constraints
- durable engineering state
- safe write-isolation boundaries
- verification requirements
- Git/review topology

を所有する。

## Template に置くもの

- `AGENTS.md`: runtime-neutral engineering contract
- `CLAUDE.md`: Claude ultracode adapter
- `.claude/settings.json`: Marketplace + ultracode request
- `.codex/config.toml`: Marketplace + Ultra request
- `.agentic/PROJECT.md`: project facts
- `.agentic/agentic.json`: declarative architecture contract
- `.agent/tasks/`: durable engineering state
- setup / doctor scripts

## Do not copy

中央 Plugin の Skills、fallback agents、hook scripts、generic orchestration policy を project repo に複製しない。

## Required validation

- Claude settings valid JSON and `ultracode = true`
- Codex config valid TOML and `model_reasoning_effort = "ultra"`
- `[agents] enabled = true`
- agentic schemaVersion = 4
- `orchestration = "runtime-native"`
- shell scripts pass `bash -n`
- setup does not swallow Plugin installation failures
- GitHub Actions remain latest-stable full-SHA pinned
- README reflects current Claude/Codex runtime behavior

Codex IDE extension は Plugin 非対応なので、`AGENTS.md` fallback の説明を維持する。
