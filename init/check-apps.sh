#!/usr/bin/env bash
# Report casks from brew.sh and App Store apps from mas_apps.txt that aren't installed.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Casks: check the .app they install (apps may have been installed outside brew);
# casks without an app (e.g. CLIs, fonts) must be installed via brew.
casks=$(awk '/^brew install --cask/ {print $4}' "${SCRIPT_DIR}/../brew.sh" | sed 's#.*/##')
installed_casks=$(brew list --cask 2>/dev/null)
brew info --cask --json=v2 $casks \
  | jq -r '.casks[] | [.token, (
      [.artifacts[] | select(.app) | .app[] | strings] + # e.g. "Arc.app"
      [.artifacts[] | select(.uninstall) | .uninstall[].delete? | select(.) | if type == "array" then .[] else . end
        | select(test("^/Applications/[^/]+\\.app$"))] # pkg casks, e.g. zoom
      | first // "" | sub("^/Applications/"; ""))] | @tsv' \
  | while IFS=$'\t' read -r cask app; do
      if [[ -n "$app" ]]; then
        [[ -d "/Applications/$app" || -d "$HOME/Applications/$app" ]] && continue
      else
        grep -qx "$cask" <<< "$installed_casks" && continue
      fi
      echo "$cask not installed (run ./brew.sh)"
    done

# App Store: `mas list` shows short names (e.g. "Fantastical") that prefix the store name.
installed_mas=$(mas list 2>/dev/null | sed -E 's/^ *[0-9]+ +//; s/ +\([^)]*\)$//')
while IFS= read -r app; do
  [[ "$app" =~ ^[[:space:]]*(#|$) ]] && continue
  found=
  while IFS= read -r name; do
    [[ -n "$name" && "$app" == "$name"* ]] && { found=1; break; }
  done <<< "$installed_mas"
  [[ -n "$found" ]] || echo "$app not installed (run ./init/mas.sh)"
done < "${SCRIPT_DIR}/mas_apps.txt"
