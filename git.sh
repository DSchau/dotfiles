#!/usr/bin/env bash
BASE_DIR="$HOME/Projects"

# Map GitHub org names to local folder names under $BASE_DIR/Work/
declare -A ORG_TO_FOLDER
ORG_TO_FOLDER["gatsbyjs"]="Gatsby"
ORG_TO_FOLDER["gatsby-inc"]="Gatsby"
ORG_TO_FOLDER["netlify"]="Netlify"
ORG_TO_FOLDER["postmanlabs"]="Postman"
ORG_TO_FOLDER["adaptcom"]="Adapt"

CURRENT_WORK="Adapt"

mkdir -p "$BASE_DIR/Personal"
mkdir -p "$BASE_DIR/Work"

# create all work folders
for folder in "${ORG_TO_FOLDER[@]}"; do
    PATH_TO_CREATE="$BASE_DIR/Work/$folder"
    mkdir -p "$PATH_TO_CREATE"
    echo "Created $PATH_TO_CREATE"
done

GIT_REPOS=()
while IFS= read -r line; do
  GIT_REPOS+=("$line")
done < <(grep '^git@github.com' git_repos.txt)

# Enable case-insensitive matching
shopt -s nocasematch

for repo in "${GIT_REPOS[@]}"; do
  # Extract the organization and repo name from the URL
  # URL format: git@github.com:Organization/repo_name.git
  org_name=$(echo "$repo" | cut -d':' -f2 | cut -d'/' -f1)
  repo_name=$(echo "$repo" | cut -d':' -f2 | cut -d'/' -f2 | cut -d'.' -f1)

  if [[ "$org_name" == "DSchau" ]]; then
    # Personal repo, clone to the Personal directory
    git clone "$repo" "$BASE_DIR/Personal/$repo_name"
  else
    folder="${ORG_TO_FOLDER[$org_name]}"
    if [[ -n "$folder" ]]; then
      git clone "$repo" "$BASE_DIR/Work/$folder/$repo_name"
    else
      echo "❌ Can't place folder: $repo"
    fi
  fi
done

# Disable case-insensitive matching
shopt -u nocasematch
