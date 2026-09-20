# Template maintenance

Keep this repository as a thin project adapter for Claude Code ultracode and Codex Ultra.

## Native-first rule

Do not hardcode execution strategy in the template or Plugin.

Claude:

- ultracode / Dynamic Workflows own execution topology.

Codex:

- Ultra proactive multi-agent execution owns execution topology.

Agentic Engineering owns:

- project constraints;
- durable engineering state;
- safe write-isolation boundaries;
- verification requirements;
- Git/review topology.

## What belongs in the template

- `AGENTS.md`: runtime-neutral engineering contract
- `CLAUDE.md`: Claude ultracode adapter
- `.claude/settings.json`: Marketplace + ultracode request
- `.codex/config.toml`: Marketplace + Ultra request
- `.agentic/PROJECT.md`: project-specific facts
- `.agentic/agentic.json`: declarative architecture contract
- `.agent/tasks/`: durable engineering state
- setup / doctor scripts

## Do not copy

Do not copy central Plugin Skills, fallback agents, hook scripts, or generic orchestration policy into project repositories.

## Required validation

- Claude settings are valid JSON and request `ultracode = true`.
- Codex config is valid TOML and requests `model_reasoning_effort = "ultra"`.
- `[agents] enabled = true`.
- Agentic `schemaVersion = 4`.
- `orchestration = "runtime-native"`.
- Shell scripts pass `bash -n`.
- Setup does not hide Plugin-installation failures.
- GitHub Actions remain pinned to full SHAs for the latest stable releases.
- README matches current Claude/Codex runtime behavior.
- Repository text remains English-only.

The Codex IDE extension does not currently support Plugins, so retain the `AGENTS.md` fallback explanation.
