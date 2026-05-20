#!/usr/bin/env bash
set -u

missing=0

check() {
  local exe="$1"
  local reason="$2"

  if command -v "$exe" >/dev/null 2>&1; then
    printf '[ok]      %-18s %s\n' "$exe" "$reason"
  else
    printf '[missing] %-18s %s\n' "$exe" "$reason"
    missing=$((missing + 1))
  fi
}

check_any() {
  local label="$1"
  local reason="$2"
  shift 2

  local exe
  for exe in "$@"; do
    if command -v "$exe" >/dev/null 2>&1; then
      printf '[ok]      %-18s %s\n' "$label" "$reason"
      return
    fi
  done

  printf '[missing] %-18s %s\n' "$label" "$reason"
  missing=$((missing + 1))
}

echo "==> Core"
check git "lazy.nvim plugin clone/update"
check nvim "editor"
check curl "downloads and installer scripts"
check unzip "Mason archives"
check tar "archives"
check make "native plugin builds, telescope-fzf-native"
check gcc "native builds"

echo
echo "==> Search / navigation"
check rg "Telescope live_grep, todo-comments"
check_any "fd/fdfind" "Telescope find_files helper" fd fdfind
check fzf "fzf-based pickers"
check lazygit "git TUI"

echo
echo "==> Languages"
check node "JS/TS tooling, liveserver.nvim build"
check npm "JS package manager and global helpers"
check python3 "Python tooling"
check java "JDTLS / Java projects"
check go "Go projects"

echo
echo "==> Database / API"
check sqlite3 "SQLite database work"
check psql "PostgreSQL CLI"
check mysql "MySQL/MariaDB CLI"

echo
echo "==> Optional developer tools"
check pnpm "JS monorepo package manager"
check yarn "JS package manager"
check pipx "isolated Python CLI installs"
check_any "dlv/delve" "Go DAP debugger" dlv delve
check tree-sitter "Treesitter CLI"

echo
if [ "$missing" -eq 0 ]; then
  echo "All checked executables are available."
else
  echo "$missing executable(s) missing. Run the matching installer script or install them manually."
fi

exit "$missing"
