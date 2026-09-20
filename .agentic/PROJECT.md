# Project-specific context

Record only information that is **specific to this repository and not immediately obvious from reading the code each time**.

Do not put generic coding-agent instructions here. On the first substantive engineering request, `project-bootstrap` discovers durable facts from the repository and records only information it can verify.

## Build / test / lint / typecheck

- Contract validation: `python3 -m json.tool .claude/settings.json >/dev/null && python3 -m json.tool .agentic/agentic.json >/dev/null && bash -n scripts/*.sh`
- Environment diagnostics: `./scripts/agentic-doctor.sh`

## Dependency / toolchain

- Runtime scripts require Bash and Python 3; CI validates with Python 3.14.

## Architecture invariants

<!-- Add only invariants whose violation would create a real design problem. -->

## Generated code / source of truth

<!-- List generated artifacts that must not be edited directly and the files or commands that generate them. -->

## External constraints

<!-- Record API compatibility requirements, migration ordering, deployment constraints, and similar durable facts. -->

<!-- agentic-profile: pending -->
