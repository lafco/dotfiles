{
  description = "Personal development environment with Neovim, Fish, and Starship";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f (import nixpkgs { inherit system; }));
    in
    {
      packages = forAllSystems (
        pkgs:
        let
          # Runtime dependencies for Neovim
          nvimRuntimeDeps = with pkgs; [
            gcc
            nixd
            lua-language-server
            ripgrep
            fd
          ];

          # GUI and additional tools
          guiTools = with pkgs; [
            neovide
            ghostty
            jetbrains-mono
          ];

          # Shell enhancement tools
          shellTools = with pkgs; [
            eza       # Modern ls replacement
            zoxide    # Smart cd replacement
            fzf       # Fuzzy finder
            bat       # Better cat with syntax highlighting
            gh        # GitHub CLI
            mise      # Development environment manager
          ];

          # Wrapped Neovim with custom config
          nvim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (
            pkgs.neovimUtils.makeNeovimConfig {
              customRC = ''
                set runtimepath^=${./nvim}
                source ${./nvim}/init.lua
              '';
            }
            // {
              wrapperArgs = [
                "--prefix"
                "PATH"
                ":"
                "${pkgs.lib.makeBinPath nvimRuntimeDeps}"
              ];
            }
          );

          # Fish shell with custom config
          fish = pkgs.writeShellScriptBin "fish-custom" ''
            export FISH_CONFIG_DIR=${./fish}
            exec ${pkgs.fish}/bin/fish --init-command "source ${./fish}/config.fish" "$@"
          '';

          # Starship configured
          starship = pkgs.starship;

        in
        {
          default = pkgs.buildEnv {
            name = "dev-environment";
            paths = [
              nvim
              fish
              starship
            ] ++ nvimRuntimeDeps ++ guiTools ++ shellTools;
          };

          neovim = nvim;
          fish-shell = fish;
        }
      );

      apps = forAllSystems (
        pkgs:
        {
          default = {
            type = "app";
            program = "${pkgs.fish}/bin/fish";
          };
          nvim = {
            type = "app";
            program = "${(pkgs.callPackage ./. { }).packages.${pkgs.system}.neovim}/bin/nvim";
          };
        }
      );
    };
}
