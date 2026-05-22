# Neovim Environment Installer

Automation scripts for bootstrapping this Neovim config on a fresh machine,
especially Termux on Android tablets.

The installer focuses on system packages that Neovim, lazy.nvim plugins,
Telescope, Mason tools, Java, JS/TS, Python, Go, SQL and DAP workflows need.
Language servers and formatters are still managed by Mason inside Neovim.

## Quick Start: Termux

Install Termux from F-Droid or GitHub, not the old Google Play build.

```sh
cd ~/.config/nvim
bash installer/install-termux.sh --dry-run
bash installer/install-termux.sh
```

After packages are installed:

```sh
nvim
:Lazy sync
:MasonToolsInstall
:TSInstallConfigured
:checkhealth
```

## Quick Start: Ubuntu/Debian

```sh
cd ~/.config/nvim
bash installer/install-linux.sh --dry-run
bash installer/install-linux.sh
```

## Quick Start: Ubuntu In Termux / proot-distro

On the Termux host, install `proot-distro` first:

```sh
pkg install proot-distro
proot-distro install ubuntu
proot-distro login ubuntu
```

Inside Ubuntu:

```sh
cd ~/.config/nvim
bash installer/install-ubuntu-proot.sh --dry-run
bash installer/install-ubuntu-proot.sh
```

This wrapper runs the apt installer without `sudo`, which matches the default
root shell used by `proot-distro login ubuntu`.

## Health Check

```sh
bash installer/healthcheck.sh
```

The healthcheck reports missing executables used by this config, such as
`git`, `nvim`, `node`, `npm`, `python3`, `java`, `go`, `rg`, `fd`, `fzf`,
`lazygit`, `sqlite3`, `make`, `gcc`, `unzip`, and `curl`.

## Package Groups

Default groups:

- core: shell/editor basics and build tools
- search: ripgrep, fd, fzf
- web: node/npm/pnpm/yarn
- python: python and pipx
- java: OpenJDK
- go: Go toolchain and Delve
- database: sqlite and database CLIs
- docs: markdown/help utilities

Termux packages are listed in:

- `installer/packages/termux-core.txt`
- `installer/packages/termux-optional.txt`

Linux apt packages are listed in:

- `installer/packages/apt-core.txt`
- `installer/packages/apt-optional.txt`

## Notes For Android / Termux

- Java package names can vary by repository. The Termux script tries
  `openjdk-21` first, then falls back to `openjdk-17`.
- On Ubuntu/Debian, `fd-find` may expose the binary as `fdfind`. Install or
  symlink `fd` manually if a tool specifically requires the `fd` executable.
- `install-linux.sh` now creates `fd -> fdfind` and `bat -> batcat` aliases
  when needed.
- Some Mason tools may not ship binaries for Android. If one Mason package
  fails, keep the system dependency installed and use project-local tools
  through npm/pnpm/go/pip where possible.
- Heavy Java/Spring projects may be more comfortable on a remote machine via
  SSH, but this installer gives the tablet a useful local workstation base.
