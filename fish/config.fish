# Fish shell configuration
set fish_greeting ""

# Get the directory where this config file is located
set -l config_dir (dirname (status --current-filename))

# Set up Starship prompt
if type -q starship
    starship init fish | source
end

# Initialize zoxide (smart cd replacement)
if type -q zoxide
    zoxide init fish | source
end

# Initialize mise (development environment manager)
if type -q mise
    mise activate fish | source
end

# Load additional configuration files
source $config_dir/aliases.fish
source $config_dir/aliases-gh.fish
source $config_dir/functions.fish

# Add custom functions directory to fish_function_path if it exists
if test -d ~/.config/fish/functions
    set -p fish_function_path ~/.config/fish/functions
end

# Add ~/.local/bin to PATH for user-installed binaries (like zellij)
if test -d ~/.local/bin
    set -gx PATH ~/.local/bin $PATH
end

# Auto-start tmux for interactive shells
# if status is-interactive
#     and not set -q TMUX
#     and command -v tmux &> /dev/null
#     exec tmux new-session -A -s main
# end
