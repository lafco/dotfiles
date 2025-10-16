# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles managed with Nix flakes, providing a reproducible development environment for Ghostty terminal, Neovim, Neovide (GUI), Fish shell, Starship prompt, modern shell utilities (eza, zoxide, fzf, bat, gh), and runtime version management (mise with Node.js and Python).

## Installation and Setup

### Initial Installation
```bash
./install.sh
```
This installs Nix (if needed), enables flakes, installs packages, and symlinks configurations.

### Manual Installation
```bash
# Install packages to your profile
nix profile install .#default

# Symlink configurations
ln -sf $(pwd)/starship.toml ~/.config/starship.toml
ln -sf $(pwd)/fish/config.fish ~/.config/fish/config.fish
ln -s $(pwd)/nvim ~/.config/nvim
ln -sf $(pwd)/neovide/config.toml ~/.config/neovide/config.toml
ln -sf $(pwd)/ghostty/config ~/.config/ghostty/config
ln -sf $(pwd)/.mise.toml ~/.config/mise/config.toml
```

### Running Without Installing
```bash
nix run .#nvim    # Run Neovim
nix run           # Run Fish shell
```

### Updating Packages
```bash
nix flake update
nix profile upgrade '.*'
```

## Architecture

### Nix Flake Structure (flake.nix)

The flake defines four main component groups:

1. **Neovim wrapper** (`nvimRuntimeDeps`): Wraps neovim-unwrapped with custom config and runtime dependencies (gcc, nixd, lua-language-server, ripgrep, fd). The config is loaded from `./nvim` directory via `runtimepath`.

2. **Fish shell wrapper**: Shell script that sources custom Fish config from `./fish/config.fish`.

3. **GUI Tools** (`guiTools`): Ghostty terminal emulator, Neovide (GUI frontend for Neovim), and JetBrains Mono font.

4. **Shell Tools** (`shellTools`): Modern CLI utilities for enhanced shell experience:
   - **eza**: Modern `ls` replacement with icons and git integration
   - **zoxide**: Smart `cd` replacement that learns your habits
   - **fzf**: Fuzzy finder for files, history, and more
   - **bat**: Better `cat` with syntax highlighting
   - **gh**: GitHub CLI for repository, PR, and issue management
   - **mise**: Polyglot runtime version manager (replaces nvm, pyenv, rbenv, etc.)

5. **Default package**: `buildEnv` combining all tools and dependencies into a single installable unit.

Cross-platform support for x86_64-linux, aarch64-linux, x86_64-darwin, aarch64-darwin.

### Neovim Configuration (nvim/)

**Plugin Manager**: lazy.nvim (auto-bootstrapped on first run)

**Entry Point**: `init.lua` loads three modules:
- `config.options`: Vim options
- `config.lazy`: Plugin manager setup (loads all plugins from `lua/plugins/`)
- `config.keymaps`: Key mappings and leader key (`<Space>`)

**Plugin Organization** (`lua/plugins/`):
- `lsp.lua`: LSP configuration with Mason, nvim-lspconfig, nvim-cmp autocomplete
- `treesitter.lua`: Syntax highlighting
- `catppuccin.lua`: Color scheme
- `harpoon.lua`: File navigation
- `snacks.lua`: UI components
- `utility.lua`: General utilities

**LSP Setup**:
- Mason auto-installs: lua_ls, intelephense, ts_ls, eslint, pyright
- Auto-format on save for Lua files
- LSP keybindings set via LspAttach autocmd (K=hover, gd=definition, F2=rename, F3=format, F4=code action)

**Custom Keybindings** (nvim/lua/config/keymaps.lua):
- Leader: `<Space>`
- Insert mode: `<C-hjkl>` for movement, `<C-c>` to escape
- Normal mode: `<C-hjkl>` for split navigation, `<Tab>/<S-Tab>` for buffer navigation
- Resize splits: `<A-hjkl>`
- Visual mode: `<C-jk>` to move lines up/down

### Fish Configuration (fish/config.fish)

**Initializations**:
- Starship prompt integration
- Zoxide init (smart directory jumping)
- FZF key bindings (Ctrl+R for history, Ctrl+T for files, Alt+C for directories)
- mise activation (runtime version management)

**Environment Variables**:
- Default editor/visual: neovide

**Aliases**:
- **ls/ll/la**: eza with icons and git status (fallback to standard ls if not available)
- **lt/lta**: Tree view with eza
- **cd**: Aliased to `z` (zoxide) for smart navigation
- **cdi**: Interactive directory selection with zoxide
- **cat**: Aliased to `bat` for syntax highlighting
- **catp**: Plain bat output without decorations
- **grep**: Aliased to `rg` (ripgrep)
- **vim/vi**: Aliased to neovide (runs in background, doesn't block terminal)
- **Ownership/Permissions**:
  - **own**: `sudo chown -R $USER:$USER <path>` - Take ownership of files/directories recursively
  - **ownp**: Take ownership of current directory and set permissions to 755
- **GitHub CLI shortcuts**:
  - **ghv/ghvc**: View repo (terminal/web)
  - **ghc/ghcr**: Clone/create repo
  - **ghpr/ghprc/ghprv/ghprco/ghprm**: PR list/create/view/checkout/merge
  - **ghi/ghic/ghiv**: Issue list/create/view
  - **ghw/ghwr/ghwv**: Workflow list/run/view
  - **ghs**: Repository status
  - **ghrl/ghrc**: Release list/create

### Neovide Configuration (neovide/config.toml)

- Frame: none (borderless window)
- Font: JetBrains Mono, size 11.0
- Symlinked to `~/.config/neovide/config.toml`

### Ghostty Configuration (ghostty/config)

**Theme & Appearance**:
- Theme: Catppuccin Mocha
- Font: JetBrains Mono, size 11
- Window: No decoration (borderless), padding 20px
- Background: 99% opacity with 100px blur radius

**Features**:
- Shell integration: Fish
- Cursor: Block style, no blinking
- Mouse hides while typing
- Auto-update disabled
- No close confirmation

**Key Bindings**:
- `Ctrl+T`: Toggle fullscreen
- `Ctrl+U`: Clear screen
- `Ctrl+Q`: Close surface
- **Split navigation**: `Ctrl+H/J/K/L` (goto split), `Ctrl+Shift+H/J/K/L` (new split)
- **Split resize**: `Alt+Arrow keys` (resize by 10)

Symlinked to `~/.config/ghostty/config`

### mise Configuration (.mise.toml)

**Global Runtime Versions** (symlinked to `~/.config/mise/config.toml`):
- **Node.js**: `lts` - Automatically tracks latest LTS version
- **Python**: `latest` - Automatically tracks latest stable version
- **Rust**: `latest` - Automatically tracks latest stable version (includes rustc, cargo, rustup)

**Settings**:
- `auto_install = true` - Automatically installs missing tools
- Supports per-project overrides via local `.mise.toml` or `.tool-versions` files

**Supported Runtimes** (add to `.mise.toml` as needed):
- Node.js, Python, Bun, Deno, Go, Rust, Ruby, Java, and 100+ other tools

## Key Points for Development

### Adding Neovim Plugins
Add new plugin files to `nvim/lua/plugins/`. lazy.nvim automatically loads all files in this directory.

### Adding Runtime Dependencies
- **Neovim tools**: Edit `nvimRuntimeDeps` array in `flake.nix`
- **GUI tools/fonts**: Edit `guiTools` array in `flake.nix`
- **Shell utilities**: Edit `shellTools` array in `flake.nix`
- After changes: Run `nix profile upgrade '.*'`

### Modifying Configurations
- **Ghostty**: Edit `ghostty/config`
- **Neovim**: Edit files in `nvim/` directory
- **Neovide**: Edit `neovide/config.toml`
- **Fish**: Edit `fish/config.fish`
- **Starship**: Edit `starship.toml`
- **mise**: Edit `.mise.toml` for global versions, or create per-project `.mise.toml`

All configs are symlinked to `~/.config/`, so changes take effect immediately.

### Managing Runtime Versions with mise

**Check installed versions**:
```bash
mise list
```

**Install specific version**:
```bash
mise use node@20.11.0    # Specific version
mise use python@3.12     # Major.minor version
```

**Per-project versions**: Create `.mise.toml` in project directory:
```toml
[tools]
node = "18.19.0"
python = "3.11.7"
```

**Available commands**:
- `mise install` - Install all tools from config
- `mise upgrade` - Upgrade tools to latest versions
- `mise current` - Show current tool versions
- `mise doctor` - Diagnose issues

### LSP Servers
Managed by Mason in `nvim/lua/plugins/lsp.lua:100-106`. Add new servers to `ensure_installed` array.

### Auto-format Configuration
Edit `autoformat_filetypes` table in `nvim/lua/plugins/lsp.lua:18-20` to enable/disable auto-format on save per filetype.
