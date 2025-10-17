# Personal Development Environment

#### One-Line Installation
```bash
curl -fsSL https://raw.githubusercontent.com/lafco/dotfiles/main/install-remote.sh | bash
```

#### Manual Installation
```bash
git clone https://github.com/lafco/dotfiles.git
cd dotfiles
./install.sh
```
### Development Tools
- **Ghostty**: Modern GPU-accelerated terminal emulator with native speed
- **Fish Shell**: Smart shell with autosuggestions and modern syntax
- **Starship**: Fast, minimal prompt with git integration
- **Neovide**: Beautiful GUI frontend for Neovim
- **mise**: Universal version manager for Node.js, Python, Rust, and more
- **GitHub CLI (gh)**: Complete GitHub workflow from the command line
- **LSP Support**: lua-language-server, nixd, and more via Mason

### Shell Utilities
- **eza**: Modern `ls` replacement with icons and git status
- **zoxide**: Smart `cd` that learns your navigation patterns
- **fzf**: Fuzzy finder for files, history, and commands
- **bat**: Syntax-highlighted `cat` with git integration
- **ripgrep**: Ultra-fast text search
- **fd**: Simple, fast alternative to `find`

### Aliases
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
```
### FZF Key Bindings
- `Ctrl+R`: Fuzzy search command history
- `Ctrl+T`: Fuzzy find files
- `Alt+C`: Fuzzy find and cd to directory

## Setting Fish as Default Shell
```bash
chsh -s $(which fish)
```

### Managing Runtime Versions
Edit `.mise.toml` to change global versions, or create per-project `.mise.toml`:

```bash
mise use node@20.11.0    # Set specific Node version
mise use python@3.12     # Set Python version
mise list                # Show installed versions
```
