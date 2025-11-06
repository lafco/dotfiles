#!/usr/bin/env bash
# Dependencies: utils.sh (logging), system.sh (PKG_MANAGER, INSTALL_CMD)

# Install tmux
install_tmux() {
    log_info "Installing tmux..."

    case $PKG_MANAGER in
        "apt"|"dnf"|"pacman"|"zypper")
            pkg_install tmux
            ;;
        "brew")
            pkg_install tmux
            ;;
    esac

    log_success "tmux installed"
}

# Install WezTerm
install_wezterm() {
    log_info "Installing WezTerm..."

    case $PKG_MANAGER in
        "apt")
            log_info "Installing WezTerm AppImage..."
            curl -LO https://github.com/wez/wezterm/releases/download/nightly/WezTerm-nightly-Ubuntu20.04.AppImage
            chmod u+x WezTerm-nightly-Ubuntu20.04.AppImage
            sudo mkdir -p /usr/local/bin
            sudo mv WezTerm-nightly-Ubuntu20.04.AppImage /usr/local/bin/wezterm

            # Extract icon from AppImage
            log_info "Extracting WezTerm icon..."
            mkdir -p ~/.local/share/icons/hicolor/128x128/apps
            /usr/local/bin/wezterm --extract-icon > ~/.local/share/icons/hicolor/128x128/apps/wezterm.png 2>/dev/null || \
                curl -L -o ~/.local/share/icons/hicolor/128x128/apps/wezterm.png https://raw.githubusercontent.com/wez/wezterm/main/assets/icon/terminal.png

            # Create desktop entry
            log_info "Creating desktop entry..."
            mkdir -p ~/.local/share/applications
            cat > ~/.local/share/applications/wezterm.desktop <<EOF
[Desktop Entry]
Name=WezTerm
Comment=Wez's Terminal Emulator
Exec=/usr/local/bin/wezterm start
Icon=wezterm
Type=Application
Categories=System;TerminalEmulator;
Terminal=false
StartupNotify=true
EOF
            chmod +x ~/.local/share/applications/wezterm.desktop

            # Update desktop database
            if command -v update-desktop-database &> /dev/null; then
                update-desktop-database ~/.local/share/applications
            fi
            ;;
        "dnf")
            log_info "Installing WezTerm from Copr..."
            sudo dnf copr enable wezfurlong/wezterm-nightly -y
            pkg_install wezterm
            ;;
        "pacman")
            # WezTerm is available in the AUR and community repos
            pkg_install wezterm
            ;;
        "zypper")
            log_warning "WezTerm installation on openSUSE requires manual download"
            log_info "Visit: https://wezfurlong.org/wezterm/install/linux.html"
            ;;
        "brew")
            pkg_install --cask wezterm
            ;;
    esac

    log_success "WezTerm installed"
}

# Main function to install all terminal tools
install_terminal() {
    install_tmux
    install_wezterm
}
