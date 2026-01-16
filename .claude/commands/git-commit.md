---
description: Summarize changes, create commit, and push to current branch
allowed-tools: Bash(git:*), Read, Glob, Grep
---

# Git Commit and Push

Analyze staged and unstaged changes, create a descriptive commit with an AI-generated summary, and push to the current branch.

First, read the changes to understand what's being committed, then run the following commands:

```bash
# Check git status and current branch
git status
git branch --show-current

# Show staged and unstaged changes
git diff HEAD

# Show recent commits for style reference
git log -3 --format='%h %s'
```

After analyzing the changes:

1. Stage any relevant untracked or modified files with `git add`
2. Create a commit with a descriptive message that:
   - Follows the repository's commit message style
   - Summarizes the nature of changes (e.g., "feat:", "fix:", "chore:", "refactor:")
   - Focuses on the "why" rather than the "what"
   - Does NOT include Co-Authored-By unless specifically requested
3. Push to the current branch with `git push origin <current-branch>`

Example commit format:
```bash
git commit -m "$(cat <<'EOF'
chore: update configuration files

Add new environment variables and update API endpoints for production deployment.
EOF
)"
```

Important:
- Only commit files that are relevant to the changes
- Do not commit files that likely contain secrets (.env, credentials.json, etc.)
- Review the diff carefully before committing
- Use conventional commit prefixes when appropriate (feat, fix, chore, docs, style, refactor, test)
