#!/usr/bin/env bash

set -e

echo "Installing dotfiles..."

# Check if Nix is installed
if ! command -v nix &> /dev/null; then
    echo "Nix is not installed. Installing Nix..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

    # Source Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
fi

# Enable flakes if not already enabled
if ! nix --version &> /dev/null || ! nix flake --help &> /dev/null 2>&1; then
    echo "Enabling Nix flakes..."
    mkdir -p ~/.config/nix
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi

# Install the packages
echo "Installing development environment..."
nix profile install .#default

# Set up Starship config
echo "Setting up Starship configuration..."
mkdir -p ~/.config
ln -sf "$(pwd)/starship.toml" ~/.config/starship.toml

# Set up Fish config
echo "Setting up Fish configuration..."
mkdir -p ~/.config/fish
if [ -f ~/.config/fish/config.fish ]; then
    echo "Backing up existing Fish config to ~/.config/fish/config.fish.backup"
    cp ~/.config/fish/config.fish ~/.config/fish/config.fish.backup
fi
ln -sf "$(pwd)/fish/config.fish" ~/.config/fish/config.fish

# Set up Neovim config
echo "Setting up Neovim configuration..."
if [ -d ~/.config/nvim ]; then
    echo "Backing up existing Neovim config to ~/.config/nvim.backup"
    mv ~/.config/nvim ~/.config/nvim.backup
fi
ln -s "$(pwd)/nvim" ~/.config/nvim

# Set up Neovide config
echo "Setting up Neovide configuration..."
mkdir -p ~/.config/neovide
if [ -f ~/.config/neovide/config.toml ]; then
    echo "Backing up existing Neovide config to ~/.config/neovide/config.toml.backup"
    cp ~/.config/neovide/config.toml ~/.config/neovide/config.toml.backup
fi
ln -sf "$(pwd)/neovide/config.toml" ~/.config/neovide/config.toml

# Set up mise config
echo "Setting up mise configuration..."
mkdir -p ~/.config/mise
if [ -f ~/.config/mise/config.toml ]; then
    echo "Backing up existing mise config to ~/.config/mise/config.toml.backup"
    cp ~/.config/mise/config.toml ~/.config/mise/config.toml.backup
fi
ln -sf "$(pwd)/.mise.toml" ~/.config/mise/config.toml

# Set up Ghostty config
echo "Setting up Ghostty configuration..."
mkdir -p ~/.config/ghostty
if [ -f ~/.config/ghostty/config ]; then
    echo "Backing up existing Ghostty config to ~/.config/ghostty/config.backup"
    cp ~/.config/ghostty/config ~/.config/ghostty/config.backup
fi
ln -sf "$(pwd)/ghostty/config" ~/.config/ghostty/config

echo ""
echo "Installation complete!"
echo ""
echo "To use your new environment:"
echo "  - Run 'ghostty' to start Ghostty terminal"
echo "  - Run 'nvim' to start Neovim (terminal)"
echo "  - Run 'neovide' to start Neovim (GUI)"
echo "  - Run 'fish' to start Fish shell"
echo "  - Run 'nix run .#nvim' from this directory to run Neovim from the flake"
echo ""
echo "To set Fish as your default shell:"
echo "  chsh -s \$(which fish)"
echo ""
echo "Note: mise will automatically install Node.js (LTS), Python (latest), and Rust (latest)"
echo "when you first start Fish. You can modify versions in ~/.config/mise/config.toml"
