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

# Note: `mas account` can't detect App Store sign-in on macOS 12+ (it always
# errors), so there's no sign-in check. Sign in to the App Store app first;
# `mas install` fails per-app if you aren't.

############################################
# Install apps                             #
############################################

mas_install_by_name() {
  local name="$1"

  # Search and find a line whose app name field exactly matches (case-insensitive).
  # mas search output format:  <id>  <App Name> (<version>)
  # Portable awk (macOS awk has no 3-arg match()).
  local search_output result
  search_output=$(mas search "$name" 2>/dev/null || true)
  result=$(printf '%s\n' "$search_output" \
    | awk -v target="$name" '
        {
          line = $0
          sub(/^[[:space:]]+/, "", line)
          id = line
          sub(/[[:space:]].*$/, "", id)
          title = line
          sub(/^[0-9]+[[:space:]]+/, "", title)
          sub(/[[:space:]]*\([^)]*\)[[:space:]]*$/, "", title)
          if (found == "" && tolower(title) == tolower(target)) found = id
        }
        END { print found }
      ' || true)

  if [[ -z "$result" ]]; then
    echo "  WARN: '$name' not found in the App Store — skipping."
    # App Store names drift; show the closest listings so mas_apps.txt is easy to fix.
    if [[ -n "$search_output" ]]; then
      echo "        Closest matches:"
      printf '%s\n' "$search_output" | head -n 3 | sed 's/^[[:space:]]*/          /'
    fi
    return 0
  fi

  local app_id="$result"

  if mas list 2>/dev/null | awk -v id="$app_id" '$1 == id { f = 1 } END { exit !f }'; then
    echo "  already installed: $name"
    return 0
  fi

  echo "  installing: $name (id: $app_id)"
  # `mas install` only works for apps this Apple ID has already "gotten";
  # otherwise it fails with "No downloads initiated". Try `mas purchase`
  # (free apps), then fall back to opening the App Store page.
  mas install "$app_id" && return 0
  mas purchase "$app_id" && return 0
  echo "  WARN: couldn't install '$name' — opening it in the App Store; click Get to install."
  open "macappstore://apps.apple.com/app/id${app_id}" || true
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
