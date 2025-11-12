# Dotfiles Installation Commands

This directory contains installation scripts for setting up a complete development environment. Use these commands from the project root.

## Main Installation

```bash
./install.sh              # Complete installation (all categories)
./install.sh --quiet       # Silent installation
./install.sh --help        # Show help
```

## Category Installation

| Command | Installs |
|---------|----------|
| `./install.sh core` | curl, wget, git, tree, htop, unzip, jq, build-essential |
| `./install.sh shell` | ripgrep, fd-find, bat, eza, fish, zoxide, fzf, gh |
| `./install.sh git_tools` | GAH (GitHub Apt Helper), lazygit |
| `./install.sh runtimes` | mise, Rust, Node.js LTS, Python latest |
| `./install.sh fonts` | JetBrains Mono Nerd Font, FiraCode Nerd Font |
| `./install.sh gui` | Neovim, Starship prompt |
| `./install.sh system` | btop |
| `./install.sh terminal` | tmux, wezterm, zellij |
| `./install.sh database` | PostgreSQL + configuration |
| `./install.sh configs` | Link configuration files to ~/.config/ |

## Individual Tool Installation

| Command | Tool |
|---------|------|
| `./install.sh tmux` | tmux terminal multiplexer |
| `./install.sh wezterm` | WezTerm terminal emulator |
| `./install.sh zellij` | Zellij terminal multiplexer |
| `./install.sh lazygit` | lazygit TUI for git |

## Legacy Aliases

| Command | Same As |
|---------|---------|
| `./install.sh core_tools` | `core` |
| `./install.sh shell_tools` | `shell` |
| `./install.sh gui_apps` | `gui` |
| `./install.sh system_tools` | `system` |
| `./install.sh postgresql` | `database` |

## Utilities

| Command | Purpose |
|---------|---------|
| `./install.sh fix_ppas` | Fix broken PPAs (Ubuntu only) |

## Remote Installation

```bash
# One-command remote setup
curl -fsSL https://raw.githubusercontent.com/lafco/dotfiles/main/remote-install.sh | bash
```

## Configuration Structure

- **installers/**: Individual installation scripts
- **lib/**: Shared utilities (logging, system detection, config linking)
- Configuration files are automatically linked to `~/.config/` when using `configs`