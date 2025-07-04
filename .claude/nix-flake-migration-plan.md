# Nix Flake Migration Plan for .claude/

## Executive Summary

This plan outlines the migration of the `.claude/` directory into a Nix flake, transforming it into a reproducible, version-controlled, and declarative system that can be easily shared and deployed across different environments.

## Goals

1. **Reproducibility**: Ensure consistent Claude behavior across all systems
2. **Modularity**: Leverage Nix's module system for Claude components
3. **Portability**: Easy installation via `nix profile install`
4. **Development**: Provide development shells with all required tools
5. **Integration**: Support for home-manager and NixOS modules

## Architecture Overview

```
.claude/
├── flake.nix                 # Main flake definition
├── flake.lock               # Pinned dependencies
├── nix/
│   ├── modules/             # Nix modules for Claude components
│   │   ├── commands.nix
│   │   ├── processes.nix
│   │   ├── roles.nix
│   │   ├── workflows.nix
│   │   └── knowledge.nix
│   ├── packages/            # Nix packages for helper scripts
│   │   ├── detect-dead-context.nix
│   │   ├── analyze-dependencies.nix
│   │   └── default.nix
│   ├── overlays/            # Custom overlays
│   │   └── default.nix
│   └── lib/                 # Helper functions
│       └── default.nix
├── modules/                 # Existing Claude modules (unchanged)
├── commands/                # Existing commands (unchanged)
└── ...                      # Other existing directories
```

## Phase 1: Foundation (Week 1)

### 1.1 Create Basic Flake Structure

**flake.nix**:
```nix
{
  description = "Claude AI Assistant Configuration System";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    
    # For shell script validation
    shellcheck-py.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
      in
      {
        # Packages
        packages = {
          default = self.packages.${system}.claude-cli;
          claude-cli = pkgs.callPackage ./nix/packages/claude-cli.nix { };
          claude-helpers = pkgs.callPackage ./nix/packages/helpers.nix { };
        };

        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Shell scripting
            bashInteractive
            shellcheck
            shfmt
            
            # Git tools
            git
            gh
            
            # Text processing
            ripgrep
            jq
            yq
            
            # Documentation
            mdbook
            pandoc
            
            # Nix tools
            nil
            nixpkgs-fmt
            nix-tree
          ];
        };

        # Apps
        apps.default = {
          type = "app";
          program = "${self.packages.${system}.claude-cli}/bin/claude";
        };
      }) // {
        # System-independent outputs
        
        # Overlays
        overlays.default = final: prev: {
          claude-utils = self.packages.${final.system}.claude-helpers;
        };

        # NixOS module
        nixosModules.default = ./nix/modules/nixos.nix;
        
        # Home-manager module
        homeManagerModules.default = ./nix/modules/home-manager.nix;
        
        # Flake checks
        checks = forAllSystems (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            formatting = pkgs.runCommand "check-formatting" {} ''
              ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}
              touch $out
            '';
          });
      };
}
```

### 1.2 Package Helper Scripts

**nix/packages/helpers.nix**:
```nix
{ stdenv, lib, bash, git, coreutils, findutils, gnugrep, gawk, jq }:

stdenv.mkDerivation rec {
  pname = "claude-helpers";
  version = "1.0.0";

  src = ../../helpers;

  buildInputs = [ bash ];
  
  nativeBuildInputs = [ ];

  installPhase = ''
    mkdir -p $out/bin
    
    # Install helper scripts
    for script in *.sh; do
      install -m755 $script $out/bin/claude-''${script%.sh}
      
      # Patch shebang and add runtime dependencies
      substituteInPlace $out/bin/claude-''${script%.sh} \
        --replace '#!/bin/bash' '#!${bash}/bin/bash' \
        --replace 'git' '${git}/bin/git' \
        --replace 'find' '${findutils}/bin/find' \
        --replace 'grep' '${gnugrep}/bin/grep' \
        --replace 'awk' '${gawk}/bin/awk' \
        --replace 'jq' '${jq}/bin/jq'
    done
  '';

  meta = with lib; {
    description = "Helper scripts for Claude AI assistant";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
```

## Phase 2: Module System (Week 2)

### 2.1 Create Nix Module for Claude Configuration

**nix/modules/claude-config.nix**:
```nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.claude;
  
  claudeModule = types.submodule {
    options = {
      enable = mkEnableOption "module";
      path = mkOption {
        type = types.path;
        description = "Path to the module file";
      };
      scope = mkOption {
        type = types.enum [ "locked" "persistent" "context" "temporary" ];
        default = "context";
        description = "Module loading scope";
      };
      triggers = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Keywords that trigger module loading";
      };
    };
  };
in
{
  options.services.claude = {
    enable = mkEnableOption "Claude AI assistant configuration";
    
    configDir = mkOption {
      type = types.path;
      default = "${config.home.homeDirectory}/.claude";
      description = "Claude configuration directory";
    };
    
    modules = mkOption {
      type = types.attrsOf claudeModule;
      default = {};
      description = "Claude modules configuration";
    };
    
    defaultDevelopmentPattern = mkOption {
      type = types.str;
      default = "TestDrivenDevelopment";
      description = "Default development pattern";
    };
    
    tools = mkOption {
      type = types.attrs;
      default = {
        version_control = "git";
        issue_tracker = "github";
        search_tool = "grep";
      };
      description = "Default tools configuration";
    };
  };

  config = mkIf cfg.enable {
    # Generate CLAUDE.md from Nix configuration
    home.file."${cfg.configDir}/CLAUDE.md".text = ''
      # CLAUDE Configuration - Nix Managed
      
      This configuration is managed by Nix. Do not edit directly.
      
      ## Active Configuration
      ```yaml
      default_development_pattern: ${cfg.defaultDevelopmentPattern}
      
      tools:
        ${concatStringsSep "\n  " (mapAttrsToList (n: v: "${n}: ${v}") cfg.tools)}
      ```
      
      ## Loaded Modules
      ${concatStringsSep "\n" (mapAttrsToList (n: v: "- ${n}: ${v.path}") cfg.modules)}
    '';
    
    # Install helper scripts
    home.packages = [ pkgs.claude-utils ];
  };
}
```

### 2.2 Home-Manager Integration

**nix/modules/home-manager.nix**:
```nix
{ config, lib, pkgs, ... }:

{
  imports = [ ./claude-config.nix ];
  
  config = {
    # Example configuration
    services.claude = {
      enable = true;
      
      modules = {
        tdd-pattern = {
          enable = true;
          path = ./patterns/development/tdd-pattern.md;
          scope = "persistent";
        };
        
        audit-workflow = {
          enable = true;
          path = ./workflows/repository-audit.yaml;
          scope = "context";
          triggers = [ "audit" "analyze repository" ];
        };
      };
    };
  };
}
```

## Phase 3: Development Environment (Week 3)

### 3.1 Enhanced Development Shell

**nix/shells/dev.nix**:
```nix
{ pkgs }:

pkgs.mkShell {
  name = "claude-dev";
  
  buildInputs = with pkgs; [
    # Claude helpers
    claude-utils
    
    # Development tools
    bashInteractive
    shellcheck
    shfmt
    
    # Documentation
    mdbook
    vale  # Prose linter
    
    # Testing
    bats  # Bash testing framework
    
    # Formatting
    prettier
    yamllint
  ];
  
  shellHook = ''
    echo "Claude Development Environment"
    echo "=============================="
    echo "Available commands:"
    echo "  claude-detect-dead-context - Find obsolete content"
    echo "  claude-analyze-dependencies - Analyze dependencies"
    echo "  make test - Run all tests"
    echo "  make docs - Build documentation"
    
    # Set up aliases
    alias cdc="claude-detect-dead-context"
    alias cad="claude-analyze-dependencies"
    
    # Add local scripts to PATH
    export PATH="$PWD/helpers:$PATH"
  '';
}
```

### 3.2 Testing Infrastructure

**nix/packages/tests.nix**:
```nix
{ stdenv, bats, claude-helpers }:

stdenv.mkDerivation {
  pname = "claude-tests";
  version = "1.0.0";
  
  src = ../../tests;
  
  buildInputs = [ bats claude-helpers ];
  
  checkPhase = ''
    bats tests/
  '';
  
  installPhase = ''
    mkdir -p $out
    cp -r test-results $out/
  '';
}
```

## Phase 4: Distribution (Week 4)

### 4.1 Installation Methods

**1. Flake-enabled Nix**:
```bash
# Direct installation
nix profile install github:aRustyDev/prompts#claude-cli

# Development shell
nix develop github:aRustyDev/prompts

# Run without installing
nix run github:aRustyDev/prompts
```

**2. Home-Manager**:
```nix
{
  imports = [
    inputs.claude.homeManagerModules.default
  ];
  
  services.claude.enable = true;
}
```

**3. NixOS Module**:
```nix
{
  imports = [
    inputs.claude.nixosModules.default
  ];
  
  services.claude = {
    enable = true;
    systemWide = true;
  };
}
```

### 4.2 Documentation

**docs/nix-usage.md**:
```markdown
# Using Claude with Nix

## Quick Start

```bash
# Enter development shell
nix develop

# Run audit
nix run .#claude-cli -- audit

# Install globally
nix profile install .#claude-cli
```

## Configuration

Claude can be configured through:
1. Nix modules (recommended)
2. Traditional CLAUDE.md (for non-Nix users)
3. Environment variables

## Development

```bash
# Run tests
nix flake check

# Build all packages
nix build

# Update dependencies
nix flake update
```
```

## Phase 5: CI/CD Integration (Week 5)

### 5.1 GitHub Actions

**.github/workflows/nix-ci.yml**:
```yaml
name: Nix CI

on:
  push:
    paths:
      - '**.nix'
      - 'flake.lock'
      - '.claude/**'
  pull_request:

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: cachix/install-nix-action@v22
        with:
          extra_nix_config: |
            experimental-features = nix-command flakes
      
      - name: Check flake
        run: nix flake check
      
      - name: Build packages
        run: nix build .#claude-cli .#claude-helpers
      
      - name: Run tests
        run: nix develop -c make test
```

### 5.2 Binary Cache

```nix
# flake.nix addition
{
  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://claude.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:..."
      "claude.cachix.org-1:..."
    ];
  };
}
```

## Migration Timeline

### Week 1: Foundation
- [ ] Create flake.nix with basic structure
- [ ] Package helper scripts
- [ ] Set up development shell
- [ ] Test basic functionality

### Week 2: Modules
- [ ] Create Nix module system for Claude components
- [ ] Implement configuration generation
- [ ] Add home-manager module
- [ ] Test module loading

### Week 3: Development
- [ ] Enhance development environment
- [ ] Add testing infrastructure
- [ ] Create documentation tooling
- [ ] Implement flake checks

### Week 4: Distribution
- [ ] Document installation methods
- [ ] Create usage guides
- [ ] Set up binary cache
- [ ] Test cross-platform support

### Week 5: Integration
- [ ] Add CI/CD pipelines
- [ ] Implement automated testing
- [ ] Create release process
- [ ] Migration guide for existing users

## Benefits

1. **Reproducibility**: Exact same environment everywhere
2. **Declarative**: Configuration as code
3. **Composable**: Mix and match Claude modules
4. **Cacheable**: Binary caching for fast installations
5. **Testable**: Automated testing of all components
6. **Versioned**: Pin to specific Claude versions

## Considerations

1. **Learning Curve**: Nix has a steep learning curve
2. **Compatibility**: Maintain backward compatibility
3. **Documentation**: Comprehensive guides needed
4. **Community**: Build Nix user community

## Success Metrics

- All helper scripts packaged and functional
- Development shell provides all required tools
- CI/CD passes all checks
- Installation time < 30 seconds with cache
- Zero regression in functionality

This plan provides a structured approach to migrating the Claude configuration system to Nix flakes while maintaining all existing functionality and adding new capabilities.