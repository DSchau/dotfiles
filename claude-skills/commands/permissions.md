---
description: Pre-allow common safe bash commands
allowed-tools: Bash(*)
---

# Whitelisted Commands

Pre-allow common safe commands so Claude Code doesn't ask before running them.

## Allowed Commands

The following bash commands are pre-allowed:

### Package Managers & Build Tools
- `Bash(npm run build:*)`
- `Bash(npm run test:*)`
- `Bash(npm run lint:*)`
- `Bash(npm test:*)`
- `Bash(yarn run build:*)`
- `Bash(yarn run test:*)`
- `Bash(yarn run lint:*)`
- `Bash(yarn test:*)`
- `Bash(pnpm run build:*)`
- `Bash(pnpm run test:*)`
- `Bash(pnpm test:*)`

### Git (read-only operations)
- `Bash(git status:*)`
- `Bash(git log:*)`
- `Bash(git diff:*)`
- `Bash(git branch:*)`
- `Bash(git show:*)`

### File Operations
- `Bash(find:*)`
- `Bash(ls:*)`
- `Bash(tree:*)`
- `Bash(pwd:*)`
- `Bash(which:*)`

### GitHub CLI (read-only)
- `Bash(gh pr list:*)`
- `Bash(gh pr view:*)`
- `Bash(gh issue list:*)`
- `Bash(gh issue view:*)`

These commands are considered safe and won't require approval prompts.
