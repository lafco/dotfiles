#!/usr/bin/env bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS and package manager
detect_system() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt &> /dev/null; then
            OS="ubuntu"
            PKG_MANAGER="apt"
            INSTALL_CMD="sudo apt install -y"
            UPDATE_CMD="sudo apt update"
        elif command -v dnf &> /dev/null; then
            OS="fedora"
            PKG_MANAGER="dnf"
            INSTALL_CMD="sudo dnf install -y"
            UPDATE_CMD="sudo dnf update"
        elif command -v pacman &> /dev/null; then
            OS="arch"
            PKG_MANAGER="pacman"
            INSTALL_CMD="sudo pacman -S --noconfirm"
            UPDATE_CMD="sudo pacman -Sy"
        elif command -v zypper &> /dev/null; then
            OS="opensuse"
            PKG_MANAGER="zypper"
            INSTALL_CMD="sudo zypper install -y"
            UPDATE_CMD="sudo zypper refresh"
        else
            log_error "Unsupported Linux distribution"
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        if ! command -v brew &> /dev/null; then
            log_info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        PKG_MANAGER="brew"
        INSTALL_CMD="brew install"
        UPDATE_CMD="brew update"
    else
        log_error "Unsupported operating system: $OSTYPE"
        exit 1
    fi
    
    log_info "Detected OS: $OS"
    log_info "Package manager: $PKG_MANAGER"
}

# Install packages based on OS
install_core_tools() {
    log_info "Installing core development tools..."
    
    case $PKG_MANAGER in
        "apt")
            $UPDATE_CMD
            $INSTALL_CMD curl wget git tree htop unzip jq build-essential
            ;;
        "dnf")
            $UPDATE_CMD
            $INSTALL_CMD curl wget git tree htop unzip jq gcc gcc-c++ make
            ;;
        "pacman")
            $UPDATE_CMD
            $INSTALL_CMD curl wget git tree htop unzip jq base-devel
            ;;
        "zypper")
            $UPDATE_CMD
            $INSTALL_CMD curl wget git tree htop unzip jq gcc gcc-c++ make
            ;;
        "brew")
            $UPDATE_CMD
            $INSTALL_CMD curl wget git tree htop jq
            ;;
    esac
    
    log_success "Core tools installed"
}

# Install modern shell tools
install_shell_tools() {
    log_info "Installing modern shell tools..."
    
    case $PKG_MANAGER in
        "apt")
            # Install from repositories where available
            $INSTALL_CMD ripgrep fd-find bat exa fish
            # Install zoxide manually
            curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
            ;;
        "dnf")
            $INSTALL_CMD ripgrep fd-find bat exa fish zoxide
            ;;
        "pacman")
            $INSTALL_CMD ripgrep fd bat exa fish zoxide fzf
            ;;
        "zypper")
            $INSTALL_CMD ripgrep fd bat fish
            # Install zoxide manually
            curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
            ;;
        "brew")
            $INSTALL_CMD ripgrep fd bat eza fish zoxide fzf gh
            ;;
    esac
    
    # Install fzf if not available through package manager
    if ! command -v fzf &> /dev/null; then
        log_info "Installing fzf..."
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all
    fi
    
    # Install GitHub CLI if not available
    if ! command -v gh &> /dev/null; then
        case $PKG_MANAGER in
            "apt")
                curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
                sudo apt update
                sudo apt install gh
                ;;
            "dnf")
                sudo dnf install gh
                ;;
            "pacman")
                sudo pacman -S github-cli
                ;;
        esac
    fi
    
    log_success "Shell tools installed"
}

# Install development runtimes
install_runtimes() {
    log_info "Installing development runtimes..."
    
    # Install mise (formerly rtx)
    if ! command -v mise &> /dev/null; then
        log_info "Installing mise..."
        curl https://mise.run | sh
        echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
        export PATH="$HOME/.local/bin:$PATH"
    fi
    
    # Install Rust
    if ! command -v rustc &> /dev/null; then
        log_info "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source ~/.cargo/env
    fi
    
    # Install Node.js via mise
    log_info "Installing Node.js LTS via mise..."
    ~/.local/bin/mise install node@lts
    ~/.local/bin/mise global node@lts
    
    # Install Python via mise
    log_info "Installing Python latest via mise..."
    ~/.local/bin/mise install python@latest
    ~/.local/bin/mise global python@latest
    
    log_success "Development runtimes installed"
}

# Install fonts
install_fonts() {
    log_info "Installing fonts..."
    
    # Create fonts directory
    if [[ "$OS" == "macos" ]]; then
        FONT_DIR="$HOME/Library/Fonts"
    else
        FONT_DIR="$HOME/.local/share/fonts"
    fi
    
    mkdir -p "$FONT_DIR"
    
    # Download and install JetBrains Mono Nerd Font
    log_info "Installing JetBrains Mono Nerd Font..."
    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip"
    TEMP_DIR=$(mktemp -d)
    
    curl -L -o "$TEMP_DIR/JetBrainsMono.zip" "$FONT_URL"
    unzip -q "$TEMP_DIR/JetBrainsMono.zip" -d "$TEMP_DIR"
    cp "$TEMP_DIR"/*.ttf "$FONT_DIR"
    
    # Download and install FiraCode Nerd Font
    log_info "Installing FiraCode Nerd Font..."
    FIRA_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip"
    
    curl -L -o "$TEMP_DIR/FiraCode.zip" "$FIRA_URL"
    unzip -q "$TEMP_DIR/FiraCode.zip" -d "$TEMP_DIR/fira"
    cp "$TEMP_DIR/fira"/*.ttf "$FONT_DIR"
    
    # Refresh font cache on Linux
    if [[ "$OS" != "macos" ]]; then
        if command -v fc-cache &> /dev/null; then
            fc-cache -fv
        fi
    fi
    
    rm -rf "$TEMP_DIR"
    log_success "Fonts installed"
}

# Install GUI applications
install_gui_apps() {
    log_info "Installing GUI applications..."
    
    case $PKG_MANAGER in
        "apt")
            # Install Neovim
            if ! command -v nvim &> /dev/null; then
                log_info "Installing Neovim..."
                curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
                chmod u+x nvim.appimage
                sudo mv nvim.appimage /usr/local/bin/nvim
            fi
            ;;
        "dnf")
            $INSTALL_CMD neovim
            ;;
        "pacman")
            $INSTALL_CMD neovim
            ;;
        "zypper")
            $INSTALL_CMD neovim
            ;;
        "brew")
            $INSTALL_CMD neovim
            # Install GUI apps on macOS
            brew install --cask neovide
            ;;
    esac
    
    # Install Neovide on Linux
    if [[ "$OS" != "macos" ]] && ! command -v neovide &> /dev/null; then
        log_info "Installing Neovide..."
        case $PKG_MANAGER in
            "pacman")
                sudo pacman -S neovide
                ;;
            *)
                # Install from releases for other distros
                NEOVIDE_URL="https://github.com/neovide/neovide/releases/latest/download/neovide.tar.gz"
                TEMP_DIR=$(mktemp -d)
                curl -L -o "$TEMP_DIR/neovide.tar.gz" "$NEOVIDE_URL"
                tar -xzf "$TEMP_DIR/neovide.tar.gz" -C "$TEMP_DIR"
                sudo cp "$TEMP_DIR/neovide" /usr/local/bin/
                rm -rf "$TEMP_DIR"
                ;;
        esac
    fi
    
    # Install Starship prompt
    if ! command -v starship &> /dev/null; then
        log_info "Installing Starship..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi
    
    log_success "GUI applications installed"
}

# Install btop if available
install_system_tools() {
    log_info "Installing additional system tools..."
    
    case $PKG_MANAGER in
        "apt")
            # btop might not be available in older Ubuntu versions
            if apt-cache show btop &> /dev/null; then
                $INSTALL_CMD btop
            else
                log_warning "btop not available in repositories, skipping..."
            fi
            ;;
        "dnf"|"pacman"|"zypper")
            $INSTALL_CMD btop
            ;;
        "brew")
            $INSTALL_CMD btop
            ;;
    esac
    
    log_success "System tools installed"
}

# Install PostgreSQL
install_postgresql() {
    log_info "Installing PostgreSQL..."
    
    case $PKG_MANAGER in
        "apt")
            $INSTALL_CMD postgresql postgresql-contrib
            # Start and enable PostgreSQL service
            sudo systemctl start postgresql
            sudo systemctl enable postgresql
            ;;
        "dnf")
            $INSTALL_CMD postgresql postgresql-server postgresql-contrib
            # Initialize database and start service
            sudo postgresql-setup --initdb
            sudo systemctl start postgresql
            sudo systemctl enable postgresql
            ;;
        "pacman")
            $INSTALL_CMD postgresql
            # Initialize database
            sudo -u postgres initdb -D /var/lib/postgres/data
            sudo systemctl start postgresql
            sudo systemctl enable postgresql
            ;;
        "zypper")
            $INSTALL_CMD postgresql postgresql-server postgresql-contrib
            # Initialize database and start service
            sudo systemctl start postgresql
            sudo systemctl enable postgresql
            ;;
        "brew")
            $INSTALL_CMD postgresql
            # Start PostgreSQL service
            brew services start postgresql
            ;;
    esac
    
    # Create a database user with the same name as the current user
    if [[ "$OS" != "macos" ]]; then
        log_info "Creating PostgreSQL user: $USER"
        sudo -u postgres createuser --superuser $USER 2>/dev/null || log_warning "User $USER already exists in PostgreSQL"
        sudo -u postgres createdb $USER 2>/dev/null || log_warning "Database $USER already exists"
    else
        log_info "Creating PostgreSQL user: $USER"
        createuser --superuser $USER 2>/dev/null || log_warning "User $USER already exists in PostgreSQL"
        createdb $USER 2>/dev/null || log_warning "Database $USER already exists"
    fi
    
    log_success "PostgreSQL installed and configured"
    log_info "You can connect to PostgreSQL with: psql"
}

# Set up configuration files
setup_configs() {
    log_info "Setting up configuration files..."
    
    # Create config directories
    mkdir -p ~/.config/{fish,nvim,starship,neovide,ghostty,mise}
    
    # Set up Starship config
    if [ -f "$(pwd)/starship.toml" ]; then
        ln -sf "$(pwd)/starship.toml" ~/.config/starship.toml
        log_success "Starship config linked"
    fi
    
    # Set up Fish config
    if [ -f "$(pwd)/fish/config.fish" ]; then
        ln -sf "$(pwd)/fish/config.fish" ~/.config/fish/config.fish
        log_success "Fish config linked"
    fi
    
    # Set up Neovim config
    if [ -d "$(pwd)/nvim" ]; then
        if [ -d ~/.config/nvim ]; then
            log_warning "Backing up existing Neovim config to ~/.config/nvim.backup"
            mv ~/.config/nvim ~/.config/nvim.backup
        fi
        ln -sf "$(pwd)/nvim" ~/.config/nvim
        log_success "Neovim config linked"
    fi
    
    # Set up Neovide config
    if [ -f "$(pwd)/neovide/config.toml" ]; then
        ln -sf "$(pwd)/neovide/config.toml" ~/.config/neovide/config.toml
        log_success "Neovide config linked"
    fi
    
    # Set up mise config
    if [ -f "$(pwd)/.mise.toml" ]; then
        ln -sf "$(pwd)/.mise.toml" ~/.config/mise/config.toml
        log_success "Mise config linked"
    fi
    
    # Set up Ghostty config if available
    if [ -f "$(pwd)/ghostty/config" ]; then
        ln -sf "$(pwd)/ghostty/config" ~/.config/ghostty/config
        log_success "Ghostty config linked"
    fi
}

# Add shell integrations
setup_shell_integrations() {
    log_info "Setting up shell integrations..."
    
    # Add Fish to /etc/shells if not already there
    if command -v fish &> /dev/null; then
        FISH_PATH=$(which fish)
        if ! grep -q "$FISH_PATH" /etc/shells; then
            echo "$FISH_PATH" | sudo tee -a /etc/shells
        fi
    fi
    
    # Add mise activation to shell profiles
    if [ -f ~/.bashrc ]; then
        if ! grep -q "mise activate" ~/.bashrc; then
            echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
        fi
    fi
    
    if [ -f ~/.zshrc ]; then
        if ! grep -q "mise activate" ~/.zshrc; then
            echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
        fi
    fi
    
    log_success "Shell integrations set up"
}

# Main installation function
main() {
    log_info "Starting dotfiles installation..."
    
    detect_system
    install_core_tools
    install_shell_tools
    install_runtimes
    install_fonts
    install_gui_apps
    install_system_tools
    install_postgresql
    setup_configs
    setup_shell_integrations

    chsh -s \$(which fish)

    echo ""
    log_success "Installation complete!"
    echo ""
    echo "=== Development Environment Setup ==="
    echo ""
    echo "📦 Installed applications:"
    echo "  - nvim (Neovim with custom config)"
    echo "  - neovide (GUI Neovim) [if available]"
    echo "  - fish (Fish shell)"
    echo "  - starship (Cross-shell prompt)"
    echo "  - Essential dev tools: git, ripgrep, fd, eza, bat, etc."
    echo ""
    echo "🚀 Development runtimes:"
    echo "  - Node.js (LTS) via mise"
    echo "  - Python (latest) via mise" 
    echo "  - Rust (latest stable)"
    echo ""
    echo "🗄️  Database:"
    echo "  - PostgreSQL (with user '$USER' created)"
    echo "  - Connect with: psql"
    echo ""
    echo "📚 Next steps:"
    echo "  - Restart your terminal or run: source ~/.bashrc"
    echo "  - To set Fish as default shell: chsh -s \$(which fish)"
    echo "  - Run 'mise install' to ensure runtimes are available"
    echo "  - Start Neovim with 'nvim' or GUI with 'neovide'"
    echo "  - Connect to PostgreSQL with 'psql'"
    echo ""
    echo "🔧 Configuration files are linked to ~/.config/"
    echo "   Edit files in $(pwd) to modify configurations"
}

# Run main function
main "$@"
