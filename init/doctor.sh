#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo -e "Checking for installed applications:\n"

bash "$SCRIPT_DIR/check-apps.sh"

echo -e "\nChecking for global dependencies:\n"

has bun nvm node npm
