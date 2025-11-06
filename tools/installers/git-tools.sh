#!/usr/bin/env bash
# Dependencies: utils.sh (logging), system.sh (PKG_MANAGER, INSTALL_CMD)

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

# Install lazygit
install_lazygit() {
    log_info "Installing lazygit..."

    case $PKG_MANAGER in
        "apt")
            # Check if lazygit is available in official repositories
            if apt-cache show lazygit &> /dev/null; then
                pkg_install lazygit
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
            pkg_install lazygit
            ;;
        "pacman")
            # lazygit is available in official Arch repositories
            pkg_install lazygit
            ;;
        "zypper")
            log_info "Adding devel:languages:go repository..."
            sudo zypper ar https://download.opensuse.org/repositories/devel:/languages:/go/openSUSE_Factory/devel:languages:go.repo
            sudo zypper ref
            sudo zypper in -y lazygit
            ;;
        "brew")
            pkg_install lazygit
            ;;
    esac

    log_success "lazygit installed"
}

# Main function to install all git tools
install_git_tools() {
    install_gah
    install_lazygit
}
