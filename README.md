# Dotfiles

Personal development environment managed with Nix flakes, providing a complete, reproducible setup across any machine.

## What's Included

### Core Applications
- **Ghostty**: Modern GPU-accelerated terminal emulator with native speed
- **Neovim**: Highly customized editor with LSP, treesitter, and modern plugins
- **Neovide**: Beautiful GUI frontend for Neovim
- **Fish Shell**: Smart shell with autosuggestions and modern syntax
- **Starship**: Fast, minimal prompt with git integration

### Modern Shell Utilities
- **eza**: Modern `ls` replacement with icons and git status
- **zoxide**: Smart `cd` that learns your navigation patterns
- **fzf**: Fuzzy finder for files, history, and commands
- **bat**: Syntax-highlighted `cat` with git integration
- **ripgrep**: Ultra-fast text search
- **fd**: Simple, fast alternative to `find`

### Development Tools
- **mise**: Universal version manager for Node.js, Python, Rust, and more
- **GitHub CLI (gh)**: Complete GitHub workflow from the command line
- **LSP Support**: lua-language-server, nixd, and more via Mason
- **Build Tools**: gcc, nixd

### Pre-configured Runtimes (via mise)
- **Node.js**: Latest LTS version
- **Python**: Latest stable version
- **Rust**: Latest stable (rustc, cargo, rustup)

## Installation

### Quick Install

```bash
cd ~/dotfiles
./install.sh
```

This script will:
1. Install Nix if not already installed
2. Enable flakes
3. Install all packages to your profile
4. Symlink all configuration files
5. Set up mise to auto-install runtimes

### Manual Installation

```bash
# Install packages
nix profile install .#default

# Symlink configs
ln -sf $(pwd)/starship.toml ~/.config/starship.toml
ln -sf $(pwd)/fish/config.fish ~/.config/fish/config.fish
ln -s $(pwd)/nvim ~/.config/nvim
ln -sf $(pwd)/neovide/config.toml ~/.config/neovide/config.toml
ln -sf $(pwd)/ghostty/config ~/.config/ghostty/config
ln -sf $(pwd)/.mise.toml ~/.config/mise/config.toml
```

## Usage

### Run from anywhere

Once installed, everything is in your PATH:

```bash
ghostty      # Launch Ghostty terminal
nvim         # Start Neovim (terminal)
neovide      # Start Neovim GUI (non-blocking)
fish         # Start Fish shell
```

### Handy Aliases

Fish shell comes pre-configured with productivity-boosting aliases:

```bash
# Navigation
ls/ll/la     # eza with icons and git status
lt           # Tree view
cd           # Smart navigation with zoxide (z)
cdi          # Interactive directory picker

# File operations
cat          # Syntax highlighting with bat
grep         # Fast search with ripgrep

# Permissions
own <path>   # Take ownership recursively
ownp         # Own current dir and set 755

# GitHub
ghpr         # List PRs
ghprc        # Create PR
ghi          # List issues
ghs          # Repo status
# ... and many more (see fish/config.fish)
```

### FZF Key Bindings

- `Ctrl+R`: Fuzzy search command history
- `Ctrl+T`: Fuzzy find files
- `Alt+C`: Fuzzy find and cd to directory

### Run from the flake (without installing)

```bash
nix run .#nvim           # Run Neovim
nix run                  # Run default app (Fish)
```

### Update packages

```bash
cd ~/dotfiles
nix flake update
nix profile upgrade '.*'
```

## Directory Structure

```
dotfiles/
├── flake.nix           # Nix flake configuration
├── install.sh          # Installation script
├── README.md           # This file
├── CLAUDE.md           # Claude Code documentation
├── .mise.toml          # Runtime version management
├── nvim/               # Neovim configuration
│   ├── init.lua
│   └── lua/
│       ├── config/     # Options, keymaps, lazy.nvim
│       └── plugins/    # LSP, treesitter, themes, etc.
├── neovide/            # Neovide GUI configuration
│   └── config.toml
├── ghostty/            # Ghostty terminal configuration
│   └── config
├── fish/               # Fish shell configuration
│   └── config.fish
└── starship.toml       # Starship prompt configuration
```

## Setting Fish as Default Shell

```bash
chsh -s $(which fish)
```

## Customization

### Adding Neovim Plugins
Add new plugin files to `nvim/lua/plugins/`. lazy.nvim auto-loads all files in this directory.

### Managing Runtime Versions
Edit `.mise.toml` to change global versions, or create per-project `.mise.toml`:

```bash
mise use node@20.11.0    # Set specific Node version
mise use python@3.12     # Set Python version
mise list                # Show installed versions
```

### Modifying Configurations
- **Ghostty**: Edit `ghostty/config`
- **Neovim**: Edit files in `nvim/` directory
- **Neovide**: Edit `neovide/config.toml`
- **Fish**: Edit `fish/config.fish`
- **Starship**: Edit `starship.toml`
- **mise**: Edit `.mise.toml`

All configs are symlinked to `~/.config/`, so changes take effect immediately.

### Adding Packages
Edit the appropriate array in `flake.nix`:
- **Neovim tools**: `nvimRuntimeDeps`
- **GUI tools/fonts**: `guiTools`
- **Shell utilities**: `shellTools`

After changes:
```bash
nix profile upgrade '.*'
```

## Features Highlights

### Neovim
- **LSP**: Auto-completion, go-to-definition, diagnostics (Mason manages servers)
- **Treesitter**: Advanced syntax highlighting
- **Catppuccin**: Beautiful, consistent theme
- **Harpoon**: Fast file navigation
- **Auto-format**: Configurable per-filetype

### Ghostty Terminal
- Catppuccin Mocha theme matching Neovim
- Vim-style split navigation (Ctrl+H/J/K/L)
- GPU-accelerated rendering
- Fish shell integration

### Fish Shell
- Auto-suggestions based on history
- Syntax highlighting
- Modern utilities pre-configured
- GitHub CLI shortcuts
- mise integration for runtime management

## Cross-Platform Support

Works on:
- x86_64-linux
- aarch64-linux (ARM Linux)
- x86_64-darwin (Intel Mac)
- aarch64-darwin (Apple Silicon)

## Documentation

For detailed architecture and development guidance, see [CLAUDE.md](CLAUDE.md).
