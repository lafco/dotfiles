#!/usr/bin/env bash

set -e

# Detect script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source library files (order matters)
source "$SCRIPT_DIR/tools/lib/utils.sh"
source "$SCRIPT_DIR/tools/lib/system.sh"
source "$SCRIPT_DIR/tools/lib/config.sh"

# Source all installer files
for installer in "$SCRIPT_DIR/tools/installers"/*.sh; do
    source "$installer"
done

# Show usage information
help() {
    echo "Usage: $0 [OPTIONS] [FUNCTION_NAME]"
    echo ""
    echo "Options:"
    echo "  -q, --quiet     Enable quiet mode (suppress package manager output)"
    echo "  -v, --verbose   Enable verbose mode (show all commands)"
    echo "  -h, --help      Show this help message"
    echo ""
    echo "Available functions:"
    echo "  core            - Install core development tools (git, curl, etc.)"
    echo "  git_tools       - Install git tools (GAH, lazygit)"
    echo "  shell           - Install modern shell tools (ripgrep, fd, bat, etc.)"
    echo "  runtimes        - Install development runtimes (Node.js, Python, Rust)"
    echo "  fonts           - Install fonts (JetBrains Mono, FiraCode Nerd Fonts)"
    echo "  gui             - Install GUI applications (Neovim, Starship)"
    echo "  system          - Install additional system tools (btop)"
    echo "  terminal        - Install terminal tools (tmux, wezterm)"
    echo "  database        - Install and configure PostgreSQL"
    echo "  configs         - Set up configuration files"
    echo "  fix_ppas        - Fix broken PPAs (Ubuntu only)"
    echo ""
    echo "Legacy function names (backward compatibility):"
    echo "  core_tools      - Alias for 'core'"
    echo "  shell_tools     - Alias for 'shell'"
    echo "  gui_apps        - Alias for 'gui'"
    echo "  system_tools    - Alias for 'system'"
    echo "  lazygit         - Install only lazygit"
    echo "  tmux            - Install only tmux"
    echo "  wezterm         - Install only wezterm"
    echo "  zellij          - Install only zellij"
    echo "  postgresql      - Alias for 'database'"
    echo ""
    echo "Examples:"
    echo "  $0                    # Run full installation"
    echo "  $0 --quiet            # Run full installation in quiet mode"
    echo "  $0 core               # Install only core tools"
    echo "  $0 --quiet git_tools  # Install git tools in quiet mode"
    echo ""
}

# Run a specific function
run_function() {
    local func_name="$1"

    # Always run system detection first
    detect_system

    case "$func_name" in
        "core_tools"|"core")
            detect_and_fix_broken_ppas
            install_core
            ;;
        "git_tools"|"git"|"gah")
            install_git_tools
            ;;
        "lazygit")
            install_lazygit
            ;;
        "shell_tools"|"shell")
            install_shell
            ;;
        "runtimes")
            install_runtimes
            ;;
        "fonts")
            install_fonts
            ;;
        "gui_apps"|"gui")
            install_gui
            ;;
        "system_tools"|"system")
            install_system
            ;;
        "terminal")
            install_terminal
            ;;
        "tmux")
            install_tmux
            ;;
        "wezterm")
            install_wezterm
            ;;
        "zellij")
            install_zellij
            ;;
        "database"|"postgresql")
            install_database
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
    install_core
    install_shell
    install_runtimes
    install_fonts
    install_gui
    install_system
    install_git_tools
    install_terminal
    install_database
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
    echo "   Edit files in $SCRIPT_DIR to modify configurations"
}

# Parse command line arguments
FUNC_NAME=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -q|--quiet)
            QUIET_MODE=true
            shift
            ;;
        -v|--verbose)
            set -x
            shift
            ;;
        -h|--help)
            help
            exit 0
            ;;
        *)
            FUNC_NAME="$1"
            shift
            ;;
    esac
done

# Execute
if [[ -z "$FUNC_NAME" ]]; then
    main
else
    run_function "$FUNC_NAME"
fi
