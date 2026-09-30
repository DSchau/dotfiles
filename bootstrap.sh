#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin main;

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".osx" \
		--exclude ".macos" \
    --exclude ".linux" \
		--exclude "brew.sh" \
		--exclude "git.sh" \
		--exclude "git_repos.txt" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
		--exclude "init" \
		--exclude "workflows" \
		--exclude "dotfiles" \
		--exclude "claude-skills" \
		--exclude "pi" \
		-avh --no-perms . ~;

	# Sync Claude Code skills separately (preserves runtime data)
	mkdir -p ~/.claude/commands;
	rsync -avh --no-perms claude-skills/commands/ ~/.claude/commands/;

	# Install pi (https://pi.dev) if missing
	export PATH="$HOME/.pi/agent/bin:$PATH";
	if ! command -v pi >/dev/null; then
		curl -fsSL https://pi.dev/install.sh | sh;
	fi;

	# Merge pi agent settings (preserves runtime keys pi writes, e.g. lastChangelogVersion)
	mkdir -p ~/.pi/agent;
	if [[ -f ~/.pi/agent/settings.json ]] && command -v jq >/dev/null; then
		jq -s '.[0] * .[1]' ~/.pi/agent/settings.json pi/settings.json > ~/.pi/agent/settings.json.tmp \
			&& mv ~/.pi/agent/settings.json.tmp ~/.pi/agent/settings.json;
	else
		cp pi/settings.json ~/.pi/agent/settings.json;
	fi;
	# Install packages declared in settings (e.g. pi-open-tui)
	command -v pi >/dev/null && pi update --extensions;

	# Sync VS Code settings, keybindings and extensions (dotfiles are the source of truth)
	local vscode_user="$HOME/Library/Application Support/Code/User";
	mkdir -p "$vscode_user";
	cp init/VSCode/settings.json init/VSCode/keybindings.json "$vscode_user/";
	if command -v code >/dev/null; then
		local wanted installed ext;
		wanted=$(sed -e 's/#.*//' -e 's/[[:space:]]//g' -e '/^$/d' init/VSCode/extensions.txt | tr '[:upper:]' '[:lower:]');
		installed=$(code --list-extensions | tr '[:upper:]' '[:lower:]');
		for ext in $wanted; do
			grep -qx "$ext" <<< "$installed" || code --install-extension "$ext" || echo "⚠️  couldn't install $ext; install it manually";
		done;
		for ext in $installed; do
			grep -qx "$ext" <<< "$wanted" || code --uninstall-extension "$ext";
		done;
	fi;

	source ~/.bash_profile;
}

if [[ "$1" == "--force" || "$1" == "-f" ]]; then
	doIt;
else
	printf "This may overwrite existing files in your home directory. Are you sure? (y/n) ";
	read -r REPLY;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
