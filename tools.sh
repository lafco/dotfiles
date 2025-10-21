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

# Detect and handle broken PPAs on Ubuntu
detect_and_fix_broken_ppas() {
    if [[ "$PKG_MANAGER" == "apt" ]]; then
        log_info "Checking for broken PPAs..."
        
        # Create a temporary file to capture apt update errors
        local temp_log=$(mktemp)
        
        # Run apt update and capture errors
        if ! sudo apt update 2>"$temp_log"; then
            log_warning "apt update failed, checking for broken PPAs..."
            
            # Parse the error log for broken repositories
            local broken_repos=()
            while IFS= read -r line; do
                if [[ "$line" =~ "não tem um arquivo Release" ]] || [[ "$line" =~ "does not have a Release file" ]] || [[ "$line" =~ "Release file" ]]; then
                    # Extract repository URL from error message
                    if [[ "$line" =~ https?://[^[:space:]]+ ]]; then
                        local repo_url="${BASH_REMATCH[0]}"
                        broken_repos+=("$repo_url")
                        log_warning "Found broken repository: $repo_url"
                    fi
                fi
            done < "$temp_log"
            
            # Try to disable broken repositories
            for repo in "${broken_repos[@]}"; do
                disable_broken_repo "$repo"
            done
            
            # Try apt update again after disabling broken repos
            if [ ${#broken_repos[@]} -gt 0 ]; then
                log_info "Retrying apt update after disabling broken repositories..."
                if sudo apt update; then
                    log_success "apt update succeeded after fixing broken repositories"
                else
                    log_warning "apt update still has issues, but continuing with installation..."
                fi
            fi
        else
            log_success "Package lists updated successfully"
        fi
        
        # Clean up temp file
        rm -f "$temp_log"
    fi
}

# Disable a broken repository
disable_broken_repo() {
    local repo_url="$1"
    log_info "Attempting to disable broken repository: $repo_url"
    
    # Look for source list files that contain this URL
    local sources_dir="/etc/apt/sources.list.d"
    if [ -d "$sources_dir" ]; then
        for file in "$sources_dir"/*.list; do
            if [ -f "$file" ] && grep -q "$repo_url" "$file"; then
                local filename=$(basename "$file")
                log_warning "Disabling broken repository file: $filename"
                
                # Create backup and disable the file
                sudo cp "$file" "$file.broken-backup-$(date +%Y%m%d)"
                sudo mv "$file" "$file.disabled"
                
                log_success "Disabled $filename (backup created)"
                return 0
            fi
        done
    fi
    
    # Also check main sources.list
    if grep -q "$repo_url" /etc/apt/sources.list 2>/dev/null; then
        log_warning "Found broken repository in main sources.list"
        log_info "You may need to manually edit /etc/apt/sources.list to remove: $repo_url"
    fi
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
            # Package lists already updated in detect_and_fix_broken_ppas
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

# Install GAH (GitHub Apt Helper)
install_gah() {
    if command -v gah &> /dev/null; then
        log_info "GAH is already installed"
        return 0
    fi

    log_info "Installing GAH (GitHub Apt Helper)..."

    # Install GAH
    if bash -c "$(curl -fsSL https://raw.githubusercontent.com/marverix/gah/refs/heads/master/tools/install.sh)"; then
        # Ensure ~/.local/bin is in PATH for current session
        export PATH="$HOME/.local/bin:$PATH"
        log_success "GAH installed successfully"
    else
        log_warning "GAH installation failed, falling back to manual installations"
        return 1
    fi
}

# Install modern shell tools
install_shell_tools() {
    log_info "Installing modern shell tools..."

    case $PKG_MANAGER in
        "apt")
            # Install GAH for GitHub releases
            install_gah

            # Install from repositories where available
            $INSTALL_CMD ripgrep fd-find bat eza fish

            # Install tools via GAH if available
            if command -v gah &> /dev/null; then
                log_info "Installing zoxide via GAH..."
                gah install zoxide --unattended || curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

                log_info "Installing fzf via GAH..."
                gah install fzf --unattended || (git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all)

                log_info "Installing gh via GAH..."
                gah install gh --unattended
            else
                # Fallback to manual installation
                curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
                git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all
            fi
            ;;
        "dnf")
            $INSTALL_CMD ripgrep fd-find bat eza fish zoxide
            ;;
        "pacman")
            $INSTALL_CMD ripgrep fd bat eza fish zoxide fzf
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
    if ! command -v fzf &> /dev/null && [[ "$PKG_MANAGER" != "apt" ]]; then
        log_info "Installing fzf..."
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all
    fi

    # Install GitHub CLI if not available
    if ! command -v gh &> /dev/null && [[ "$PKG_MANAGER" != "apt" ]]; then
        case $PKG_MANAGER in
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
    if ! command -v mise &> /dev/null && [ ! -f "$HOME/.local/bin/mise" ]; then
        log_info "Installing mise..."
        curl https://mise.run | sh
        # Add mise activation to shell profiles
        if [ -f ~/.bashrc ] && ! grep -q "mise activate" ~/.bashrc; then
            echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
        fi
        if [ -f ~/.zshrc ] && ! grep -q "mise activate" ~/.zshrc; then
            echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
        fi
        # Give mise a moment to finish installation
        sleep 2
    fi
    
    # Ensure mise is in PATH
    export PATH="$HOME/.local/bin:$PATH"
    
    # Install Rust
    if ! command -v rustc &> /dev/null; then
        log_info "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source ~/.cargo/env
    fi
    
    # Check if mise is available
    if [ -f "$HOME/.local/bin/mise" ]; then
        MISE_CMD="$HOME/.local/bin/mise"
        log_info "Found mise at: $MISE_CMD"
    elif command -v mise &> /dev/null; then
        MISE_CMD="mise"
        log_info "Found mise in PATH: $(which mise)"
    else
        log_error "mise installation failed, skipping runtime installation"
        log_info "Checked: $HOME/.local/bin/mise and PATH"
        return
    fi
    
    # Verify mise is executable
    if ! "$MISE_CMD" --version &> /dev/null; then
        log_error "mise command failed, skipping runtime installation"
        return
    fi
    
    # Install Node.js via mise
    log_info "Installing Node.js LTS via mise..."
    if "$MISE_CMD" install node@lts; then
        "$MISE_CMD" global node@lts || log_warning "Failed to set Node.js as global"
        log_success "Node.js LTS installed"
    else
        log_warning "Failed to install Node.js"
    fi
    
    # Install Python via mise
    log_info "Installing Python latest via mise..."
    if "$MISE_CMD" install python@latest; then
        "$MISE_CMD" global python@latest || log_warning "Failed to set Python as global"
        log_success "Python latest installed"
    else
        log_warning "Failed to install Python"
    fi
    
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
            log_info "Installing Neovim..."
            curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
            chmod u+x nvim-linux-x86_64.appimage
            sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
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

# Install lazygit
install_lazygit() {
    log_info "Installing lazygit..."

    case $PKG_MANAGER in
        "apt")
            # Check if lazygit is available in official repositories
            if apt-cache show lazygit &> /dev/null; then
                $INSTALL_CMD lazygit
            else
                # Try installing via GAH first (no sudo required)
                if command -v gah &> /dev/null; then
                    log_info "Installing lazygit via GAH..."
                    if gah install lazygit --unattended; then
                        log_success "lazygit installed via GAH"
                        return 0
                    else
                        log_warning "GAH installation failed, trying PPA..."
                    fi
                fi

                # Fallback to PPA for older Ubuntu versions
                log_info "Adding lazygit PPA..."
                sudo add-apt-repository ppa:lazygit-team/release -y
                if ! sudo apt update; then
                    log_warning "Package update had issues, but continuing..."
                fi
                sudo apt install lazygit -y
            fi
            ;;
        "dnf")
            log_info "Enabling lazygit Copr repository..."
            sudo dnf copr enable atim/lazygit -y
            $INSTALL_CMD lazygit
            ;;
        "pacman")
            # lazygit is available in official Arch repositories
            $INSTALL_CMD lazygit
            ;;
        "zypper")
            log_info "Adding devel:languages:go repository..."
            sudo zypper ar https://download.opensuse.org/repositories/devel:/languages:/go/openSUSE_Factory/devel:languages:go.repo
            sudo zypper ref
            sudo zypper in -y lazygit
            ;;
        "brew")
            $INSTALL_CMD lazygit
            ;;
    esac

    log_success "lazygit installed"
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
    
    log_success "Shell integrations set up"
}

# Show usage information
help() {
    echo "Usage: $0 [FUNCTION_NAME]"
    echo ""
    echo "Available functions:"
    echo "  core_tools      - Install core development tools (git, curl, etc.)"
    echo "  gah             - Install GAH (GitHub Apt Helper) for easy GitHub releases installation"
    echo "  shell_tools     - Install modern shell tools (ripgrep, fd, bat, etc.)"
    echo "  runtimes        - Install development runtimes (Node.js, Python, Rust)"
    echo "  fonts           - Install fonts (JetBrains Mono, FiraCode Nerd Fonts)"
    echo "  gui_apps        - Install GUI applications (Neovim, Neovide, Starship)"
    echo "  system_tools    - Install additional system tools (btop)"
    echo "  lazygit         - Install lazygit terminal UI for git"
    echo "  postgresql      - Install and configure PostgreSQL"
    echo "  configs         - Set up configuration files"
    echo "  fix_ppas        - Fix broken PPAs (Ubuntu only)"
    echo ""
    echo "Examples:"
    echo "  $0                   # Run full installation"
    echo "  $0 gah               # Install only GAH"
    echo "  $0 gui_apps          # Install only GUI applications"
    echo "  $0 lazygit           # Install only lazygit"
    echo "  $0 postgresql        # Install only PostgreSQL"
    echo "  $0 fonts             # Install only fonts"
    echo ""
}

# Run a specific function
run_function() {
    local func_name="$1"

    # Always run system detection first
    detect_system

    case "$func_name" in
        "core_tools")
            detect_and_fix_broken_ppas
            install_core_tools
            ;;
        "gah")
            install_gah
            ;;
        "shell_tools")
            install_shell_tools
            ;;
        "runtimes")
            install_runtimes
            ;;
        "fonts")
            install_fonts
            ;;
        "gui_apps")
            install_gui_apps
            ;;
        "system_tools")
            install_system_tools
            ;;
        "lazygit")
            install_lazygit
            ;;
        "postgresql")
            install_postgresql
            ;;
        "configs")
            setup_configs
            ;;
        "fix_ppas")
            detect_and_fix_broken_ppas
            ;;
        *)
            log_error "Unknown function: $func_name"
            help
            exit 1
            ;;
    esac

    log_success "Function '$func_name' completed!"
}

# Main installation function
main() {
    log_info "Starting dotfiles installation..."

    detect_system
    detect_and_fix_broken_ppas
    install_core_tools
    install_shell_tools
    install_runtimes
    install_fonts
    install_gui_apps
    install_system_tools
    install_lazygit
    install_postgresql
    setup_configs
    setup_shell_integrations

    # Only change shell to fish if it's not already the default
    if command -v fish &> /dev/null; then
        CURRENT_SHELL=$(basename "$SHELL")
        if [[ "$CURRENT_SHELL" != "fish" ]]; then
            log_info "Setting fish as default shell..."
            chsh -s $(which fish)
            log_success "Default shell changed to fish"
        else
            log_info "Fish is already the default shell"
        fi
    fi

    echo ""
    log_success "Installation complete!"
    echo "  - To set Fish as default shell: chsh -s \$(which fish)"
    echo "  - Run 'mise install' to ensure runtimes are available"
    echo "  - Connect to PostgreSQL with 'psql'"
    echo "  - Use 'lazygit' for an interactive git UI"
    echo ""
    echo "   Configuration files are linked to ~/.config/"
    echo "   Edit files in $(pwd) to modify configurations"
}

# Handle command line arguments
if [ $# -eq 0 ]; then
    # No arguments - run full installation
    main "$@"
elif [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    # Show help
    help
elif [ $# -eq 1 ]; then
    # Single argument - run specific function
    run_function "$1"
else
    # Multiple arguments - show usage
    log_error "Too many arguments"
    help
    exit 1
fi
