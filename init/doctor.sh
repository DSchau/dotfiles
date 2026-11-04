#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo -e "Checking for installed applications:\n"

bash "$SCRIPT_DIR/check-apps.sh"

echo -e "\nChecking for global dependencies:\n"

has bun nvm node npm

echo -e "\nChecking ~/.cloudflared permissions:\n"

if [ -d "${HOME}/.cloudflared" ] && [ -n "$(find "${HOME}/.cloudflared" ! -user "$(id -u)" -print -quit)" ]; then
  echo "❌ ~/.cloudflared has files not owned by $(whoami); ssh to ssh.dschau.dev will fail."
  echo "   Fix: sudo chown -R \"\$(id -u)\":\"\$(id -g)\" ~/.cloudflared && chmod 700 ~/.cloudflared"
else
  echo "✅ ~/.cloudflared OK"
fi
