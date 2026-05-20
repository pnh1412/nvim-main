#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PKG_DIR="$ROOT_DIR/installer/packages"
DRY_RUN=0
INSTALL_OPTIONAL=0

usage() {
  cat <<'EOF'
Usage: bash installer/install-linux.sh [options]

Options:
  --dry-run       Print commands without installing packages.
  --optional      Install optional packages too.
  -h, --help      Show help.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --optional) INSTALL_OPTIONAL=1 ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 2
      ;;
  esac
  shift
done

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '[dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

need_apt() {
  if ! command -v apt-get >/dev/null 2>&1; then
    if [ "$DRY_RUN" -eq 1 ]; then
      echo "[dry-run] apt-get not found here; continuing because this is only a preview."
      return
    fi

    echo "This script expects apt-get. Use it on Ubuntu/Debian-like systems." >&2
    exit 1
  fi
}

read_packages() {
  sed -e 's/#.*$//' -e '/^[[:space:]]*$/d' "$@"
}

install_packages() {
  local packages
  packages="$(read_packages "$@")"
  if [ -z "$packages" ]; then
    return
  fi

  # shellcheck disable=SC2086
  run sudo apt-get install -y $packages
}

install_node_globals() {
  if ! command -v npm >/dev/null 2>&1; then
    echo "npm not found; skipping global JS tooling." >&2
    return
  fi

  run npm install -g pnpm yarn neovim tree-sitter-cli
}

install_python_globals() {
  if ! command -v python3 >/dev/null 2>&1; then
    echo "python3 not found; skipping Python user tools." >&2
    return
  fi

  if command -v pipx >/dev/null 2>&1; then
    run pipx ensurepath
  else
    run python3 -m pip install --user pipx
    run python3 -m pipx ensurepath
  fi
}

need_apt

echo "==> Updating apt package database"
run sudo apt-get update

echo "==> Installing core apt packages"
install_packages "$PKG_DIR/apt-core.txt"

if [ "$INSTALL_OPTIONAL" -eq 1 ]; then
  echo "==> Installing optional apt packages"
  install_packages "$PKG_DIR/apt-optional.txt"
fi

echo "==> Installing JS global helpers"
install_node_globals

echo "==> Installing Python user helpers"
install_python_globals

echo "==> Done. Run: bash installer/healthcheck.sh"
