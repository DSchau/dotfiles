#!/usr/bin/env bash
BASE_DIR="$HOME/Projects"
WORK_PATHS=("Gatsby" "Netlify" "Postman")

CURRENT_WORK="Postman"

mkdir -p "$BASE_DIR/Personal"
mkdir -p "$BASE_DIR/Work"

# create all work folders
for path in "${WORK_PATHS[@]}"; do
    PATH_TO_CREATE="$BASE_DIR/Work/$path"
    mkdir -p $PATH_TO_CREATE

    echo "Created $PATH_TO_CREATE"
done

mapfile -t GIT_REPOS < <(grep '^git@github.com' git_repos.txt)

# Enable case-insensitive matching
shopt -s nocasematch

for repo in "${GIT_REPOS[@]}"; do
  # Extract the organization name from the repo URL
  # This assumes the repo URL structure is like "git@github.com:Organization/repo_name.git"
  org_name=$(echo "$repo" | cut -d':' -f2 | cut -d'/' -f1 | cut -d'-' -f1)
  repo_name=$(echo "$repo" | cut -d':' -f2 | cut -d'/' -f2 | cut -d'.' -f1)

  if [[ "$org_name" == "DSchau" ]]; then
    # Personal repo, clone to the Personal directory
    echo $repo
    git clone "$repo" "$BASE_DIR/Personal/$repo_name"
  else
    # Work repo, determine the right sub-folder based on org name
    matched=false
    for path in "${WORK_PATHS[@]}"; do
        if [[ "$org_name" == "$path" ]]; then
            # If the org_name matches one of the WORK_PATHS, clone to that specific sub-folder
            git clone "$repo" "$BASE_DIR/Work/$path/$repo_name"
            matched=true
            break
        fi
    done

    if [[ "$matched" == "false" ]]; then
        echo "❌ Can't place folder: $repo"
    fi
  fi
done

# Disable case-insensitive matching
shopt -u nocasematch
