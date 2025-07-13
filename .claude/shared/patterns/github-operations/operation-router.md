---
module: GitHubOperationRouter
scope: persistent
priority: critical
triggers: ["github", "issue", "pr", "repository", "milestone", "label"]
dependencies: ["MCPDetector", "GitHubInterface", "MCPImplementation", "GHCLIImplementation"]
conflicts: []
version: 1.0.0
---

# GitHub Operation Router

## Purpose
Routes GitHub operations to the appropriate implementation (MCP server or gh CLI) based on availability and session state.

## Overview
This module acts as the central routing mechanism for all GitHub operations, managing the decision of whether to use MCP server or fall back to gh CLI.

## Router Configuration

### Initialize Router
Sets up the router environment and loads implementations.

```bash
# Source all required modules
source "$(dirname "${BASH_SOURCE[0]}")/github-interface.md"
source "$(dirname "${BASH_SOURCE[0]}")/mcp-implementation.md"
source "$(dirname "${BASH_SOURCE[0]}")/gh-cli-implementation.md"
source "$(dirname "${BASH_SOURCE[0]}")/../../../integrations/github-mcp/mcp-detector.md"

# Global router state
GITHUB_ROUTER_INITIALIZED=false
GITHUB_IMPLEMENTATION="unknown"

# Initialize the router
init_github_router() {
    if [ "$GITHUB_ROUTER_INITIALIZED" = "true" ]; then
        return 0
    fi
    
    # Initialize MCP session state
    init_mcp_session
    
    # Determine initial implementation
    if check_mcp_available; then
        GITHUB_IMPLEMENTATION="mcp"
        log_info "GitHub router: Using MCP server implementation"
    else
        GITHUB_IMPLEMENTATION="gh-cli"
        log_info "GitHub router: Using gh CLI implementation"
    fi
    
    GITHUB_ROUTER_INITIALIZED=true
}
```

## Routing Decision Logic

### determine_implementation
Determines which implementation to use for the current operation.

```bash
determine_implementation() {
    local operation="${1:-}"
    
    # Initialize if needed
    init_github_router
    
    # Check if we've permanently fallen back
    local permanent_fallback=$(get_mcp_session_value "permanent_fallback")
    if [ "$permanent_fallback" = "true" ]; then
        echo "gh-cli"
        return
    fi
    
    # Check MCP availability
    if check_mcp_available; then
        echo "mcp"
    else
        echo "gh-cli"
    fi
}
```

### route_github_operation
Main routing function that executes operations with appropriate implementation.

```bash
route_github_operation() {
    local operation="$1"
    shift
    local args=("$@")
    
    # Determine implementation
    local impl=$(determine_implementation "$operation")
    
    # Log routing decision
    log_debug "Routing $operation to $impl implementation"
    
    # Route to appropriate implementation
    case "$impl" in
        "mcp")
            # Try MCP with error handling
            if ! mcp_${operation} "${args[@]}"; then
                local exit_code=$?
                
                # Record failure
                record_mcp_failure "$operation" "Exit code: $exit_code"
                
                # Check if we should retry with gh CLI
                if [ "$(get_mcp_session_value 'permanent_fallback')" = "true" ]; then
                    log_info "Falling back to gh CLI for $operation"
                    gh_cli_${operation} "${args[@]}"
                    return $?
                fi
                
                return $exit_code
            fi
            ;;
        "gh-cli")
            gh_cli_${operation} "${args[@]}"
            ;;
        *)
            log_error "Unknown implementation: $impl"
            return 1
            ;;
    esac
}
```

## Operation Wrappers

These wrappers ensure all operations go through the router.

### Issue Operations

```bash
# Create issue
create_issue() {
    route_github_operation "create_issue" "$@"
}

# List issues
list_issues() {
    route_github_operation "list_issues" "$@"
}

# Update issue
update_issue() {
    route_github_operation "update_issue" "$@"
}
```

### Pull Request Operations

```bash
# Create PR
create_pr() {
    route_github_operation "create_pr" "$@"
}

# List PRs
list_prs() {
    route_github_operation "list_prs" "$@"
}
```

### Repository Operations

```bash
# Get repo info
repo_info() {
    route_github_operation "repo_info" "$@"
}

# Clone repo
clone_repo() {
    route_github_operation "clone_repo" "$@"
}
```

### Milestone and Label Operations

```bash
# Create milestone
create_milestone() {
    route_github_operation "create_milestone" "$@"
}

# Create label
create_label() {
    route_github_operation "create_label" "$@"
}
```

### Batch Operations

```bash
# Bulk create issues
bulk_create_issues() {
    route_github_operation "bulk_create_issues" "$@"
}
```

## Status and Diagnostics

### github_router_status
Shows current router status and statistics.

```bash
github_router_status() {
    echo "GitHub Operation Router Status"
    echo "=============================="
    echo "Initialized: $GITHUB_ROUTER_INITIALIZED"
    echo "Current Implementation: $GITHUB_IMPLEMENTATION"
    echo ""
    echo "MCP Session State:"
    echo "  Available: $(get_mcp_session_value 'mcp_available')"
    echo "  Retry Count: $(get_mcp_session_value 'retry_count')/3"
    echo "  Permanent Fallback: $(get_mcp_session_value 'permanent_fallback')"
    echo "  Last Check: $(get_mcp_session_value 'last_check')"
    echo ""
    
    # Check actual availability
    echo "Current Availability Check:"
    if mcp_is_configured; then
        echo "  MCP Configured: Yes"
        if test_mcp_connection; then
            echo "  MCP Connection: Success"
        else
            echo "  MCP Connection: Failed"
        fi
    else
        echo "  MCP Configured: No"
    fi
    
    # Check gh CLI
    if command -v gh >/dev/null 2>&1; then
        echo "  gh CLI Available: Yes"
        if validate_gh_cli_auth 2>/dev/null; then
            echo "  gh CLI Auth: Valid"
        else
            echo "  gh CLI Auth: Invalid"
        fi
    else
        echo "  gh CLI Available: No"
    fi
}
```

### reset_github_router
Resets the router state (useful for testing).

```bash
reset_github_router() {
    GITHUB_ROUTER_INITIALIZED=false
    GITHUB_IMPLEMENTATION="unknown"
    reset_mcp_session
    echo "GitHub router state reset"
}
```

## Error Recovery

### handle_implementation_failure
Handles failures and manages fallback logic.

```bash
handle_implementation_failure() {
    local impl="$1"
    local operation="$2"
    local error_code="$3"
    
    case "$impl" in
        "mcp")
            # MCP failure handling is done in route_github_operation
            ;;
        "gh-cli")
            # gh CLI is our fallback, so log the error
            log_error "gh CLI operation failed: $operation (code: $error_code)"
            handle_error 2100 "$operation" "GitHub operation failed with no fallback"
            ;;
    esac
}
```

## Usage Examples

### Direct Operation Usage
```bash
# The router is used transparently through the interface functions
github_create_issue "Bug: Login fails" "Description of the bug"

# Check router status
github_router_status

# Reset router if needed
reset_github_router
```

### Manual Implementation Selection
```bash
# Force specific implementation for testing
GITHUB_FORCE_IMPLEMENTATION="gh-cli" github_create_issue "Test issue" "Body"
```

## Integration with Existing Code

To integrate the router, update existing code to use the interface functions:

```bash
# Old code:
gh issue create --title "Bug" --body "Description"

# New code:
github_create_issue "Bug" "Description"
```

## Performance Considerations

- MCP availability is checked once per session
- Failed MCP operations increment retry counter
- After 3 failures, permanently falls back to gh CLI
- Session state persists across operations

---
*This router ensures seamless GitHub operations with automatic fallback capabilities.*