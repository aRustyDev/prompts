#!/bin/bash

# Script to create all GitHub issues for the Dotfiles Evolution project
# Updated to use GitHub operations abstraction layer with MCP support

# Source the GitHub operations router
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../.claude/core/patterns/github-operations/operation-router.md"

echo "Creating GitHub issues for Dotfiles Evolution project..."
echo "Checking GitHub integration status..."

# Initialize router and show status
init_github_router
github_router_status

# Configuration Review Issues (Milestone 1)
echo ""
echo "Creating Configuration Review issues..."

# Issue 1
github_create_issue \
  "Review: nix-darwin/flake.nix" \
  "## Module: nix-darwin/flake.nix

### Current State
- [ ] Configuration location identified
- [ ] Dependencies documented
- [ ] Current functionality verified

### Analysis
- [ ] Pain points identified
- [ ] Improvement opportunities noted
- [ ] Security concerns addressed

### Recommendations
- [ ] mkOutOfStoreSymlink candidacy evaluated
- [ ] Hybrid approach considered
- [ ] Documentation needs identified

### Implementation Notes
Core flake configuration that drives the entire nix-darwin setup. This is the entry point for all system configuration.

### Related Files
- nix-darwin/flake.nix
- nix-darwin/flake.lock

### Key Areas to Review
- Input management and versioning
- System configuration integration
- Home-manager module inclusion
- Output structure and organization" \
  "review,configuration" \
  "1"

# Issue 2
github_create_issue \
  "Review: nix-darwin/configuration.nix" \
  "## Module: nix-darwin/configuration.nix

### Current State
- [ ] System packages identified
- [ ] Services configuration documented
- [ ] Security settings reviewed

### Analysis
- [ ] Package redundancy checked
- [ ] Service necessity evaluated
- [ ] Performance impact assessed

### Recommendations
- [ ] Unused packages identified for removal
- [ ] Service optimizations proposed
- [ ] Security hardening suggestions

### Implementation Notes
Main system configuration file containing package declarations, service configurations, and system-wide settings.

### Related Files
- nix-darwin/configuration.nix
- nix-darwin/home.nix

### Key Areas to Review
- Package management strategy
- Service configuration approach
- System defaults and overrides
- Integration with home-manager" \
  "review,configuration" \
  "1"

# Issue 3
github_create_issue \
  "Review: nix-darwin/home.nix" \
  "## Module: nix-darwin/home.nix

### Current State
- [ ] User-specific configurations mapped
- [ ] Dotfile management approach documented
- [ ] Application settings cataloged

### Analysis
- [ ] Duplication with system config identified
- [ ] User vs system boundary clarified
- [ ] Portability constraints noted

### Recommendations
- [ ] Clear separation of concerns proposed
- [ ] Symlink strategy defined
- [ ] Migration path outlined

### Implementation Notes
Home-manager configuration managing user-specific settings, dotfiles, and application configurations.

### Related Files
- nix-darwin/home.nix
- modules/*.nix

### Key Areas to Review
- Dotfile management strategy
- Application configuration approach
- User environment variables
- Shell and tool configurations" \
  "review,configuration" \
  "1"

# Show completion status
echo ""
echo "Issue creation completed!"
echo ""
echo "Final GitHub integration status:"
github_router_status

# If any MCP failures occurred, provide guidance
if [ "$(get_mcp_session_value 'permanent_fallback')" = "true" ]; then
    echo ""
    echo "Note: MCP server was not available, all operations used gh CLI."
    echo "To enable MCP server support:"
    echo "  1. Install the GitHub MCP server"
    echo "  2. Configure it in your VS Code settings"
    echo "  3. Set GITHUB_MCP_SERVER_COMMAND environment variable"
fi