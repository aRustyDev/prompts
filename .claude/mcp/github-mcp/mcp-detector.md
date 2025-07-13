---
module: MCPDetector
scope: persistent
priority: critical
triggers: ["github", "issue", "pr", "mcp", "gh"]
dependencies: ["BaseErrorHandler"]
conflicts: []
version: 1.0.0
---

# MCP Detector

## Purpose
Detects and validates GitHub MCP server availability, managing retry attempts and fallback decisions for the current session.

## Overview
This module provides functions to check if the GitHub MCP server is available and properly configured. It maintains session state for retry attempts and determines when to fall back to gh CLI.

## Session State Management
```bash
# Session state file location
MCP_SESSION_STATE="${CLAUDE_SESSION_DIR:-/tmp/.claude-session}/mcp-state"

# Initialize session state
init_mcp_session() {
    local session_dir="$(dirname "$MCP_SESSION_STATE")"
    mkdir -p "$session_dir"
    
    # Initialize state if not exists
    if [ ! -f "$MCP_SESSION_STATE" ]; then
        echo "mcp_available=unknown" > "$MCP_SESSION_STATE"
        echo "retry_count=0" >> "$MCP_SESSION_STATE"
        echo "last_check=0" >> "$MCP_SESSION_STATE"
        echo "permanent_fallback=false" >> "$MCP_SESSION_STATE"
    fi
}

# Get session value
get_mcp_session_value() {
    local key="$1"
    init_mcp_session
    grep "^${key}=" "$MCP_SESSION_STATE" | cut -d'=' -f2
}

# Set session value
set_mcp_session_value() {
    local key="$1"
    local value="$2"
    init_mcp_session
    
    # Update or add value
    if grep -q "^${key}=" "$MCP_SESSION_STATE"; then
        sed -i.bak "s/^${key}=.*/${key}=${value}/" "$MCP_SESSION_STATE"
    else
        echo "${key}=${value}" >> "$MCP_SESSION_STATE"
    fi
}
```

## MCP Detection Functions

### check_mcp_available
Main function to determine if MCP server should be used.

```bash
check_mcp_available() {
    # Check if permanently fallen back
    local permanent_fallback=$(get_mcp_session_value "permanent_fallback")
    if [ "$permanent_fallback" = "true" ]; then
        return 1  # Use gh CLI
    fi
    
    # Check retry count
    local retry_count=$(get_mcp_session_value "retry_count")
    if [ "${retry_count:-0}" -ge 3 ]; then
        set_mcp_session_value "permanent_fallback" "true"
        log_info "MCP server failed 3 times, permanently falling back to gh CLI for this session"
        return 1
    fi
    
    # Check if MCP is configured
    if ! mcp_is_configured; then
        return 1
    fi
    
    # Test MCP connection
    if test_mcp_connection; then
        set_mcp_session_value "mcp_available" "true"
        set_mcp_session_value "last_check" "$(date +%s)"
        return 0
    else
        # Increment retry count
        local new_count=$((retry_count + 1))
        set_mcp_session_value "retry_count" "$new_count"
        log_warning "MCP server check failed (attempt $new_count/3)"
        return 1
    fi
}
```

### mcp_is_configured
Checks if MCP server is configured in the environment.

```bash
mcp_is_configured() {
    # Check for MCP server in VS Code settings or environment
    if [ -n "${GITHUB_MCP_SERVER_COMMAND}" ] || [ -n "${MCP_GITHUB_AVAILABLE}" ]; then
        return 0
    fi
    
    # Check VS Code settings.json
    local vscode_settings="${HOME}/.config/Code/User/settings.json"
    if [ -f "$vscode_settings" ] && grep -q '"github".*"command"' "$vscode_settings"; then
        return 0
    fi
    
    # Check for Docker-based MCP
    if command -v docker >/dev/null 2>&1 && docker ps 2>/dev/null | grep -q "github-mcp-server"; then
        return 0
    fi
    
    # Check for local MCP binary
    if command -v github-mcp-server >/dev/null 2>&1; then
        return 0
    fi
    
    return 1
}
```

### test_mcp_connection
Tests actual connection to MCP server.

```bash
test_mcp_connection() {
    # This is a placeholder for actual MCP testing
    # In a real implementation, this would attempt to communicate with the MCP server
    # For now, we'll check if the MCP environment indicates it's available
    
    if [ "${MCP_GITHUB_AVAILABLE}" = "true" ]; then
        return 0
    fi
    
    # Try a simple MCP operation (this would be replaced with actual MCP protocol)
    # For example, checking if we can get repository info
    if [ -n "${GITHUB_MCP_TEST_MODE}" ]; then
        return 0
    fi
    
    return 1
}
```

### record_mcp_failure
Records an MCP operation failure and updates retry count.

```bash
record_mcp_failure() {
    local operation="$1"
    local error_details="$2"
    
    local retry_count=$(get_mcp_session_value "retry_count")
    local new_count=$((retry_count + 1))
    set_mcp_session_value "retry_count" "$new_count"
    
    log_error "MCP operation failed: $operation (attempt $new_count/3)"
    log_debug "Error details: $error_details"
    
    if [ "$new_count" -ge 3 ]; then
        set_mcp_session_value "permanent_fallback" "true"
        log_info "MCP server failed 3 times, permanently falling back to gh CLI"
    fi
}
```

### reset_mcp_session
Resets MCP session state (useful for testing or manual recovery).

```bash
reset_mcp_session() {
    rm -f "$MCP_SESSION_STATE"
    init_mcp_session
    log_info "MCP session state reset"
}
```

## Usage Examples

### Basic Usage
```bash
# Check if MCP is available for use
if check_mcp_available; then
    echo "Using GitHub MCP server"
    # Use MCP operations
else
    echo "Using gh CLI"
    # Use gh CLI operations
fi
```

### With Error Handling
```bash
# Attempt MCP operation with fallback
perform_github_operation() {
    if check_mcp_available; then
        if ! mcp_create_issue "$@" 2>/dev/null; then
            record_mcp_failure "create_issue" "$?"
            # Fallback to gh
            gh issue create "$@"
        fi
    else
        gh issue create "$@"
    fi
}
```

## Logging Functions

```bash
log_info() {
    echo "[INFO] $*" >&2
}

log_warning() {
    echo "[WARNING] $*" >&2
}

log_error() {
    echo "[ERROR] $*" >&2
}

log_debug() {
    [ -n "${DEBUG}" ] && echo "[DEBUG] $*" >&2
}
```

## Integration Points
- Called by GitHub operation router before each operation
- Updates session state on failures
- Provides clear fallback path to gh CLI
- Integrates with error handling framework

---
*This module ensures reliable GitHub operations by managing MCP availability and fallback logic.*