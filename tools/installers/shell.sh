#!/usr/bin/env bash
# Dependencies: utils.sh (logging), system.sh (PKG_MANAGER, INSTALL_CMD)

install_shell() {
    log_info "Installing modern shell tools..."

    case $PKG_MANAGER in
        "apt")
            # Install GAH for GitHub releases
            install_gah

            # Install from repositories where available
            pkg_install ripgrep fd-find bat eza fish

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
            pkg_install ripgrep fd-find bat eza fish zoxide
            ;;
        "pacman")
            pkg_install ripgrep fd bat eza fish zoxide fzf
            ;;
        "zypper")
            pkg_install ripgrep fd bat fish
            # Install zoxide manually
            curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
            ;;
        "brew")
            pkg_install ripgrep fd bat eza fish zoxide fzf gh
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
