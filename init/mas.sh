#!/usr/bin/env bash
# Install Mac App Store apps listed in mas_apps.txt by name.
# Names are resolved to App Store IDs automatically — no IDs in config.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APPS_FILE="${SCRIPT_DIR}/mas_apps.txt"

############################################
# Ensure mas is available                  #
############################################

if ! command -v mas &>/dev/null; then
  echo "mas not found — installing via Homebrew..."
  brew install mas
fi

############################################
# Ensure signed in to App Store            #
############################################

if ! mas account &>/dev/null; then
  echo "ERROR: Not signed in to the Mac App Store."
  echo "  Open the App Store app, sign in, then re-run this script."
  exit 1
fi

echo "Signed in as: $(mas account)"

############################################
# Install apps                             #
############################################

mas_install_by_name() {
  local name="$1"

  # Search and find a line whose app name field exactly matches (case-insensitive).
  # mas search output format:  <id>  <App Name> (<version>)
  local result
  result=$(mas search "$name" 2>/dev/null \
    | awk -v target="$name" '
        {
          # Strip leading whitespace, grab id, then everything up to the version in parens
          match($0, /^ *([0-9]+) +(.+) \([^)]+\)$/, arr)
          id   = arr[1]
          title = arr[2]
          # Trim trailing spaces from title
          gsub(/[[:space:]]+$/, "", title)
          if (tolower(title) == tolower(target)) {
            print id
            exit
          }
        }
      ')

  if [[ -z "$result" ]]; then
    echo "  WARN: '$name' not found in the App Store — skipping."
    return 0
  fi

  local app_id="$result"

  if mas list | awk '{print $1}' | grep -q "^${app_id}$"; then
    echo "  already installed: $name"
    return 0
  fi

  echo "  installing: $name (id: $app_id)"
  mas install "$app_id"
}

echo ""
echo "Installing Mac App Store apps..."
echo ""

while IFS= read -r line; do
  # Skip comments and blank lines
  [[ "$line" =~ ^[[:space:]]*# ]] && continue
  [[ -z "${line// /}" ]] && continue

  mas_install_by_name "$line"
done < "$APPS_FILE"

echo ""
echo "Done."
