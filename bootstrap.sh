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

	# Install nvm and node before pi, which depends on node.
	# PROFILE=/dev/null: .bash_profile already loads nvm, so don't let the installer edit it.
	export NVM_DIR="$HOME/.nvm";
	if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | PROFILE=/dev/null bash;
	fi;
	\. "$NVM_DIR/nvm.sh";
	if ! command -v node >/dev/null; then
		nvm install --lts;
	fi;

	# Install pi (https://pi.dev) if missing
	export PATH="$HOME/.pi/agent/bin:$PATH";
	if ! command -v pi >/dev/null; then
		# Piping through cat makes stdout a non-TTY, so the installer skips its "Start pi now?" prompt
		curl -fsSL https://pi.dev/install.sh | sh | cat;
	fi;

	# Merge pi agent settings (preserves runtime keys pi writes, e.g. lastChangelogVersion)
	mkdir -p ~/.pi/agent;
	if [[ -f ~/.pi/agent/settings.json ]] && command -v jq >/dev/null; then
		jq -s '.[0] * .[1]' ~/.pi/agent/settings.json pi/settings.json > ~/.pi/agent/settings.json.tmp \
			&& mv ~/.pi/agent/settings.json.tmp ~/.pi/agent/settings.json;
	else
		cp pi/settings.json ~/.pi/agent/settings.json;
	fi;
	# Merge pi auth: the OpenRouter key is read from 1Password at runtime, never written to disk
	if [[ -f ~/.pi/agent/auth.json ]] && command -v jq >/dev/null; then
		jq -s '.[0] * .[1]' ~/.pi/agent/auth.json pi/auth.json > ~/.pi/agent/auth.json.tmp \
			&& mv ~/.pi/agent/auth.json.tmp ~/.pi/agent/auth.json;
	else
		cp pi/auth.json ~/.pi/agent/auth.json;
	fi;
	chmod 600 ~/.pi/agent/auth.json;
	# Install packages declared in settings (e.g. pi-open-tui, pi-memory)
	command -v pi >/dev/null && pi update --extensions;
	# Re-apply local patches to those packages (pi update reinstalls them unpatched)
	./pi/patch-packages.sh;

	# Global pi instructions (memory heuristics) and prompt templates (e.g. /memory-promote)
	cp pi/AGENTS.md ~/.pi/agent/AGENTS.md;
	mkdir -p ~/.pi/agent/prompts;
	rsync -avh --no-perms pi/prompts/ ~/.pi/agent/prompts/;

	# qmd powers pi-memory's memory_search; node-llama-cpp's install script is needed for semantic search.
	# pi-memory creates the qmd collection itself on the next session start.
	if ! command -v qmd >/dev/null && command -v npm >/dev/null; then
		npm install -g @tobilu/qmd --allow-scripts=node-llama-cpp;
	fi;

	# Sync Zed settings and keymap (dotfiles are the source of truth; extensions come from auto_install_extensions)
	mkdir -p ~/.config/zed;
	cp init/Zed/settings.json init/Zed/keymap.json ~/.config/zed/;

	# Dracula Pro is paid, so copy it from iCloud rather than committing it
	dracula_zed=~/Library/Mobile\ Documents/com~apple~CloudDocs/Dracula\ Pro\ v2.2.3/themes/zed/dracula-pro.json;
	if [[ -f $dracula_zed ]]; then
		mkdir -p ~/.config/zed/themes;
		cp "$dracula_zed" ~/.config/zed/themes/;
	else
		echo "⚠️  Dracula Pro Zed theme not found in iCloud; Zed will fall back to its default theme";
	fi;

	# Link the Zed CLI so `zed .` works (same as Zed > Install CLI, without sudo)
	if [[ -x /Applications/Zed.app/Contents/MacOS/cli ]]; then
		mkdir -p ~/.local/bin;
		ln -sf /Applications/Zed.app/Contents/MacOS/cli ~/.local/bin/zed;
	fi;

	# Camera ingest on mount: a LaunchAgent runs scripts/media-on-mount.sh whenever a volume mounts; it only
	# runs media.sh when the volume is a camera card with files on it (the camera on USB-C, or its SD card).
	if [[ $(uname) == Darwin ]]; then
		agent=~/Library/LaunchAgents/com.dschau.media-on-mount.plist;
		mkdir -p ~/Library/LaunchAgents ~/logs;
		cat >"$agent" <<-EOF
		<?xml version="1.0" encoding="UTF-8"?>
		<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
		<plist version="1.0">
		<dict>
		  <key>Label</key><string>com.dschau.media-on-mount</string>
		  <key>ProgramArguments</key>
		  <array><string>/bin/bash</string><string>$PWD/scripts/media-on-mount.sh</string></array>
		  <key>StartOnMount</key><true/>
		  <key>EnvironmentVariables</key>
		  <dict><key>PATH</key><string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string></dict>
		  <key>StandardErrorPath</key><string>$HOME/logs/media-on-mount.log</string>
		</dict>
		</plist>
		EOF
		launchctl bootout "gui/$(id -u)/com.dschau.media-on-mount" 2>/dev/null;
		launchctl bootstrap "gui/$(id -u)" "$agent";
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
