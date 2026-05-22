#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
FONT_NAME="${NERD_FONT_NAME:-JetBrainsMono}"
FONT_URL="${NERD_FONT_URL:-https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip}"
FONT_VARIANT="${NERD_FONT_VARIANT:-JetBrainsMonoNerdFont-Regular.ttf}"
WORK_DIR="${TMPDIR:-/tmp}/nvim-nerd-font"
TERMUX_DIR="${HOME}/.termux"
TARGET_FONT="${TERMUX_DIR}/font.ttf"

usage() {
  cat <<'EOF'
Usage: bash installer/install-nerd-font-termux.sh [options]

Options:
  --dry-run       Print commands without installing font.
  -h, --help      Show help.

Environment overrides:
  NERD_FONT_URL       Zip URL. Defaults to latest JetBrainsMono Nerd Font.
  NERD_FONT_VARIANT   TTF inside zip. Defaults to JetBrainsMonoNerdFont-Regular.ttf.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
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

need_cmd() {
  local exe="$1"
  if command -v "$exe" >/dev/null 2>&1; then
    return
  fi

  echo "Missing required command: $exe" >&2
  if command -v pkg >/dev/null 2>&1; then
    echo "Install it with: pkg install curl unzip" >&2
  fi
  exit 1
}

install_font() {
  local zip_file="${WORK_DIR}/${FONT_NAME}.zip"
  local font_file

  need_cmd curl
  need_cmd unzip

  run mkdir -p "$WORK_DIR" "$TERMUX_DIR"
  run curl -fL "$FONT_URL" -o "$zip_file"
  run unzip -o "$zip_file" -d "$WORK_DIR"

  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[dry-run] find Nerd Font TTF in $WORK_DIR"
    echo "[dry-run] cp selected font to $TARGET_FONT"
    echo "[dry-run] termux-reload-settings"
    return
  fi

  font_file="${WORK_DIR}/${FONT_VARIANT}"
  if [ ! -f "$font_file" ]; then
    font_file="$(find "$WORK_DIR" -type f -name '*NerdFont-Regular.ttf' | head -n 1)"
  fi

  if [ -z "$font_file" ] || [ ! -f "$font_file" ]; then
    echo "Could not find a Nerd Font Regular .ttf in $WORK_DIR" >&2
    exit 1
  fi

  run cp "$font_file" "$TARGET_FONT"

  if command -v termux-reload-settings >/dev/null 2>&1; then
    run termux-reload-settings
  else
    echo "termux-reload-settings not found. Restart Termux manually."
  fi
}

install_font

echo "Installed Nerd Font to $TARGET_FONT"
echo "Restart Termux if the icons do not update immediately."
