---
description: Initialize git repo with .gitignore, create first commit, and set up GitHub repo
allowed-tools: Bash(git:*), Bash(gh:*), Bash(cat:*), Read, Glob
---

# Git Initialization with GitHub

Initialize a git repository if it doesn't exist, create a comprehensive .gitignore to prevent committing secrets and build files, create the first commit with an AI-generated summary, and set up a GitHub remote.

First, read the project files to understand what's being committed, then run the following commands:

```bash
# Initialize git repo if needed
[ -d .git ] || git init

# Create .gitignore if it doesn't exist
if [ ! -f .gitignore ]; then
  cat > .gitignore << 'EOF'
# Dependencies
node_modules/
vendor/
*.pyc
__pycache__/

# Environment & Secrets
.env
.env.*
!.env.example
*.key
*.pem
*.p12
*.pfx
credentials.json
secrets.yml
secrets.yaml
.envrc

# Build outputs
dist/
build/
out/
target/
*.o
*.so
*.dylib
*.dll
*.exe
*.app

# IDE & Editor files
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store
Thumbs.db

# Logs & databases
*.log
logs/
*.sql
*.sqlite
*.db

# Test & Coverage
coverage/
.nyc_output/
htmlcov/
.pytest_cache/
.coverage

# Package manager
package-lock.json
yarn.lock
pnpm-lock.yaml
Gemfile.lock
Cargo.lock
EOF
fi

# Stage files
git add .

# After staging, read key files (package.json, README, main source files, etc.) to understand the project
# Then create a commit with a summary describing what kind of project this is and what files are included
# Use git commit with a descriptive message (do NOT include Co-Authored-By)

# Create GitHub repo if origin remote doesn't exist
if ! git remote get-url origin &> /dev/null; then
  gh repo create --source=. --private --push
fi
```

This will:
1. Check if `.git` exists, initialize repo only if needed
2. Create a comprehensive .gitignore (if it doesn't exist) to prevent committing:
   - Secrets (.env files, keys, credentials)
   - Build artifacts (dist/, build/, compiled files)
   - Dependencies (node_modules/, vendor/)
   - IDE files and OS files
3. Stage all files (respecting .gitignore)
4. Read and analyze the project files to understand the codebase
5. Create the initial commit with an AI-generated summary (without Co-Authored-By)
6. Check if origin remote exists
7. If not, create a private GitHub repo and push to it automatically
