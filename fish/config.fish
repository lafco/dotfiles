# Fish shell configuration

# Set up Starship prompt
if type -q starship
    starship init fish | source
end

# Initialize zoxide (smart cd replacement)
if type -q zoxide
    zoxide init fish | source
end

# Initialize fzf key bindings
if type -q fzf
    fzf --fish | source
end

# Initialize mise (development environment manager)
if type -q mise
    mise activate fish | source
end

# Environment variables
set -x EDITOR neovide
set -x VISUAL neovide

# eza (ls replacement) aliases
if type -q eza
    alias ls 'eza --color=auto --icons'
    alias ll 'eza -l --icons --git'
    alias la 'eza -la --icons --git'
    alias lt 'eza --tree --level=2 --icons'
    alias lta 'eza --tree --level=2 --icons -a'
else
    alias ls 'ls --color=auto'
    alias ll 'ls -lh'
    alias la 'ls -lAh'
end

# zoxide (cd replacement) aliases
if type -q zoxide
    alias cd 'z'
    alias cdi 'zi'  # Interactive selection
end

# bat (cat replacement) aliases
if type -q bat
    alias cat 'bat --style=auto'
    alias catp 'bat --style=plain'  # Plain output without decorations
end

# ripgrep aliases
if type -q rg
    alias grep 'rg'
end

# GitHub CLI aliases
if type -q gh
    # General GitHub CLI alias
    alias ghl 'gh auth login'

    # Repository operations
    alias ghv 'gh repo view'
    alias ghvc 'gh repo view --web'
    alias ghc 'gh repo clone'
    alias ghcr 'gh repo create'

    # Pull request operations
    alias ghpr 'gh pr list'
    alias ghprc 'gh pr create'
    alias ghprv 'gh pr view'
    alias ghprco 'gh pr checkout'
    alias ghprm 'gh pr merge'

    # Issue operations
    alias ghi 'gh issue list'
    alias ghic 'gh issue create'
    alias ghiv 'gh issue view'

    # Workflow operations
    alias ghw 'gh workflow list'
    alias ghwr 'gh workflow run'
    alias ghwv 'gh workflow view'

    # Other operations
    alias ghs 'gh status'
    alias ghrl 'gh release list'
    alias ghrc 'gh release create'
end

# Editor aliases (run neovide in background without blocking terminal)
alias vim 'neovide &; disown'
alias vi 'neovide &; disown'

# Ownership and permissions
alias own 'sudo chown -R $USER:$USER'
alias ownp 'sudo chown -R $USER:$USER . && sudo chmod -R 755 .'

# Add custom functions directory to fish_function_path if it exists
if test -d ~/.config/fish/functions
    set -p fish_function_path ~/.config/fish/functions
end
