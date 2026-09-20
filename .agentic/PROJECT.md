# Project-specific context

このファイルには **この repository 固有で、コードを読むだけでは毎回すぐ分からない情報だけ** を記録する。
汎用的な coding-agent 手順は書かない。初回の実質的な開発要求で `project-bootstrap` が repository から自動発見し、確実に分かった内容だけ追記する。

## Build / test / lint / typecheck

- Contract validation: `python3 -m json.tool .claude/settings.json >/dev/null && python3 -m json.tool .agentic/agentic.json >/dev/null && bash -n scripts/*.sh`
- Environment diagnostics: `./scripts/agentic-doctor.sh`（中央 Plugin owner 設定前は意図どおり失敗する）

## Dependency / toolchain

- Runtime scripts require Bash and Python 3; CI validates with Python 3.14.

## Architecture invariants

<!-- 破ると設計上問題になる不変条件だけ。 -->

## Generated code / source of truth

<!-- 直接編集してはいけない生成物と、その生成元。 -->

## External constraints

<!-- API compatibility、migration順序、deployment制約など。 -->
