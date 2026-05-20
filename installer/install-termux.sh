#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PKG_DIR="$ROOT_DIR/installer/packages"
DRY_RUN=0
INSTALL_OPTIONAL=0

usage() {
  cat <<'EOF'
Usage: bash installer/install-termux.sh [options]

Options:
  --dry-run       Print commands without installing packages.
  --optional      Install optional packages too.
  -h, --help      Show help.

After this script:
  nvim
  :Lazy sync
  :MasonToolsInstall
  :TSInstallConfigured
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

need_termux() {
  if ! command -v pkg >/dev/null 2>&1; then
    if [ "$DRY_RUN" -eq 1 ]; then
      echo "[dry-run] pkg not found here; continuing because this is only a preview."
      return
    fi

    echo "This script expects Termux and the 'pkg' command." >&2
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
  run pkg install -y $packages
}

install_java() {
  if command -v java >/dev/null 2>&1; then
    echo "java already available: $(java -version 2>&1 | head -n 1)"
    return
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[dry-run] pkg install -y openjdk-21 || pkg install -y openjdk-17"
    return
  fi

  pkg install -y openjdk-21 || pkg install -y openjdk-17
}

install_node_globals() {
  if ! command -v npm >/dev/null 2>&1; then
    echo "npm not found; skipping global JS tooling." >&2
    return
  fi

  run npm install -g pnpm yarn neovim tree-sitter-cli
}

install_python_globals() {
  if ! command -v python >/dev/null 2>&1; then
    echo "python not found; skipping Python user tools." >&2
    return
  fi

  if command -v pipx >/dev/null 2>&1; then
    run pipx ensurepath
  else
    run python -m pip install --user pipx
    run python -m pipx ensurepath
  fi
}

need_termux

echo "==> Updating Termux package database"
run pkg update -y
run pkg upgrade -y

echo "==> Installing core Termux packages"
install_packages "$PKG_DIR/termux-core.txt"

if [ "$INSTALL_OPTIONAL" -eq 1 ]; then
  echo "==> Installing optional Termux packages"
  install_packages "$PKG_DIR/termux-optional.txt"
fi

echo "==> Installing Java"
install_java

echo "==> Installing JS global helpers"
install_node_globals

echo "==> Installing Python user helpers"
install_python_globals

echo "==> Done. Run: bash installer/healthcheck.sh"
