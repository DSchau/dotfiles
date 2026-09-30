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
