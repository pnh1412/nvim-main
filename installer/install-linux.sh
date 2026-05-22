#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PKG_DIR="$ROOT_DIR/installer/packages"
DRY_RUN=0
INSTALL_OPTIONAL=0
FORCE_NO_SUDO="${NVIM_INSTALLER_NO_SUDO:-0}"

usage() {
  cat <<'EOF'
Usage: bash installer/install-linux.sh [options]

Options:
  --dry-run       Print commands without installing packages.
  --optional      Install optional packages too.
  --no-sudo       Run apt directly. Useful inside proot-distro Ubuntu.
  -h, --help      Show help.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --optional) INSTALL_OPTIONAL=1 ;;
    --no-sudo) FORCE_NO_SUDO=1 ;;
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

sudo_cmd() {
  if [ "$FORCE_NO_SUDO" = "1" ] || [ "$(id -u)" -eq 0 ]; then
    "$@"
    return
  fi

  if command -v sudo >/dev/null 2>&1; then
    sudo "$@"
    return
  fi

  echo "sudo not found and current user is not root. Re-run as root or pass --no-sudo inside proot." >&2
  exit 1
}

run_sudo() {
  if [ "$DRY_RUN" -eq 1 ]; then
    if [ "$FORCE_NO_SUDO" = "1" ] || [ "$(id -u)" -eq 0 ]; then
      printf '[dry-run] %s\n' "$*"
    else
      printf '[dry-run] sudo %s\n' "$*"
    fi
  else
    sudo_cmd "$@"
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
  local package

  while IFS= read -r package; do
    if [ -z "$package" ]; then
      continue
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
      run_sudo apt-get install -y "$package"
      continue
    fi

    if ! sudo_cmd apt-get install -y "$package"; then
      echo "warning: failed to install apt package '$package'; continuing." >&2
    fi
  done < <(read_packages "$@")
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

install_go_globals() {
  if ! command -v go >/dev/null 2>&1; then
    echo "go not found; skipping Go user tools." >&2
    return
  fi

  if ! command -v lazygit >/dev/null 2>&1; then
    run go install github.com/jesseduffield/lazygit@latest
  fi

  if ! command -v dlv >/dev/null 2>&1 && ! command -v delve >/dev/null 2>&1; then
    run go install github.com/go-delve/delve/cmd/dlv@latest
  fi
}

link_go_tool() {
  local exe="$1"
  local source_path
  local target_dir

  if command -v "$exe" >/dev/null 2>&1; then
    return
  fi

  source_path="${GOBIN:-$HOME/go/bin}/$exe"
  if [ ! -x "$source_path" ]; then
    return
  fi

  if [ "$(id -u)" -eq 0 ] || [ "$FORCE_NO_SUDO" = "1" ]; then
    target_dir="/usr/local/bin"
  else
    target_dir="$HOME/.local/bin"
  fi

  run mkdir -p "$target_dir"
  run_sudo ln -sf "$source_path" "$target_dir/$exe"
}

link_tool_alias() {
  local source_bin="$1"
  local target_bin="$2"
  local target_dir

  if command -v "$target_bin" >/dev/null 2>&1; then
    return
  fi

  if ! command -v "$source_bin" >/dev/null 2>&1; then
    return
  fi

  if [ "$(id -u)" -eq 0 ] || [ "$FORCE_NO_SUDO" = "1" ]; then
    target_dir="/usr/local/bin"
  else
    target_dir="$HOME/.local/bin"
  fi

  run mkdir -p "$target_dir"
  run_sudo ln -sf "$(command -v "$source_bin")" "$target_dir/$target_bin"
}

fix_debian_aliases() {
  link_tool_alias fdfind fd
  link_tool_alias batcat bat
}

need_apt

echo "==> Updating apt package database"
run_sudo apt-get update

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

echo "==> Installing Go user helpers"
install_go_globals
link_go_tool lazygit
link_go_tool dlv

echo "==> Fixing Debian/Ubuntu binary aliases"
fix_debian_aliases

echo "==> Done. Run: bash installer/healthcheck.sh"
