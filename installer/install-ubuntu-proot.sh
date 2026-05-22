#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export NVIM_INSTALLER_NO_SUDO=1

exec bash "$SCRIPT_DIR/install-linux.sh" --no-sudo "$@"
