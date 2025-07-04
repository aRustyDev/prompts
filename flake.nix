{
  description = "Claude AI Assistant Configuration System - Comprehensive prompt and workflow management";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };

        # Helper scripts package
        claude-helpers = pkgs.stdenv.mkDerivation rec {
          pname = "claude-helpers";
          version = "1.0.0";
          
          src = ./.claude/helpers;
          
          buildInputs = with pkgs; [ bash ];
          nativeBuildInputs = with pkgs; [ makeWrapper ];
          
          installPhase = ''
            mkdir -p $out/bin
            
            # Install helper scripts with proper paths
            for script in *.sh; do
              install -m755 "$script" "$out/bin/claude-''${script%.sh}"
              
              # Wrap with runtime dependencies
              wrapProgram "$out/bin/claude-''${script%.sh}" \
                --prefix PATH : ${pkgs.lib.makeBinPath [
                  pkgs.git
                  pkgs.coreutils
                  pkgs.findutils
                  pkgs.gnugrep
                  pkgs.gawk
                  pkgs.jq
                  pkgs.ripgrep
                ]}
            done
          '';
          
          meta = with pkgs.lib; {
            description = "Helper scripts for Claude AI assistant configuration";
            license = licenses.mit;
            platforms = platforms.all;
          };
        };
      in
      {
        # Packages
        packages = {
          default = claude-helpers;
          inherit claude-helpers;
        };

        # Development shell
        devShells.default = pkgs.mkShell {
          name = "claude-dev";
          
          buildInputs = with pkgs; [
            # Core tools
            bashInteractive
            coreutils
            findutils
            gnugrep
            gawk
            
            # Git and GitHub
            git
            gh
            
            # Text processing
            ripgrep
            silver-searcher
            jq
            yq-go
            
            # Shell development
            shellcheck
            shfmt
            
            # Documentation
            mdbook
            pandoc
            
            # Nix development
            nil
            nixpkgs-fmt
            nix-tree
            
            # Claude helpers
            claude-helpers
          ];
          
          shellHook = ''
            echo "🤖 Claude Development Environment"
            echo "================================="
            echo ""
            echo "Helper scripts available:"
            echo "  claude-detect-dead-context  - Find obsolete content"
            echo "  claude-analyze-dependencies - Analyze component dependencies"
            echo ""
            echo "Commands:"
            echo "  nix flake check            - Run all checks"
            echo "  nix build                  - Build packages"
            echo "  nix develop                - Enter this shell"
            echo ""
            echo "Configuration directory: .claude/"
            echo ""
            
            # Add .claude/bin to PATH if it exists
            if [ -d ".claude/bin" ]; then
              export PATH="$PATH:$PWD/.claude/bin"
            fi
            
            # Set up useful aliases
            alias audit="claude-detect-dead-context . && claude-analyze-dependencies ."
            alias fmt="nixpkgs-fmt . && shfmt -w .claude/helpers/*.sh"
          '';
        };

        # Apps - quick command runners
        apps = {
          audit = {
            type = "app";
            program = "${claude-helpers}/bin/claude-detect-dead-context";
          };
          
          deps = {
            type = "app";
            program = "${claude-helpers}/bin/claude-analyze-dependencies";
          };
        };

        # Checks
        checks = {
          # Format checking
          formatting = pkgs.runCommand "check-formatting" {
            buildInputs = [ pkgs.nixpkgs-fmt ];
          } ''
            nixpkgs-fmt --check ${./.}
            touch $out
          '';
          
          # Shellcheck
          shellcheck = pkgs.runCommand "shellcheck" {
            buildInputs = [ pkgs.shellcheck ];
          } ''
            shellcheck ${./.claude/helpers}/*.sh
            touch $out
          '';
        };
      }
    ) // {
      # System-independent outputs
      
      # Overlay
      overlays.default = final: prev: {
        claude-helpers = self.packages.${final.system}.claude-helpers;
      };
      
      # Templates for new Claude configurations
      templates = {
        default = {
          path = ./.claude;
          description = "Claude AI configuration template";
        };
      };
    };
}