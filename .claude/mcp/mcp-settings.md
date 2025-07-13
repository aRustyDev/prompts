---
module: MCPSettings
scope: persistent
priority: high
triggers: ["mcp", "github mcp", "mcp config"]
dependencies: []
conflicts: []
version: 1.0.0
---

# MCP Settings Configuration

## Purpose
Defines configuration settings for GitHub MCP server integration, including retry policies, timeouts, and fallback behavior.

## Overview
This module provides centralized configuration for MCP server behavior, allowing customization of retry attempts, timeouts, and other operational parameters.

## Default Configuration

```yaml
# MCP Server Configuration
mcp_server:
  # Retry Configuration
  retry:
    max_attempts: 3              # Maximum retry attempts before permanent fallback
    retry_delay: 1000           # Delay between retries in milliseconds
    exponential_backoff: true   # Use exponential backoff for retries
    
  # Timeout Configuration
  timeouts:
    connection_timeout: 5000    # Connection timeout in milliseconds
    operation_timeout: 30000    # Operation timeout in milliseconds
    idle_timeout: 60000         # Idle connection timeout
    
  # Session Configuration
  session:
    persist_state: true         # Persist session state across operations
    state_location: "${CLAUDE_SESSION_DIR:-/tmp/.claude-session}/mcp-state"
    reset_on_error: false       # Reset session on critical errors
    
  # Fallback Configuration
  fallback:
    enabled: true               # Enable fallback to gh CLI
    permanent_after_limit: true # Permanently fallback after retry limit
    log_fallbacks: true         # Log fallback events
    
  # Debug Configuration
  debug:
    log_level: "info"           # Log level: debug, info, warning, error
    log_mcp_traffic: false      # Log raw MCP protocol traffic
    save_failed_requests: true  # Save failed requests for debugging
```

## Configuration Functions

### load_mcp_config
Loads MCP configuration from environment and files.

```bash
load_mcp_config() {
    # Default values
    export MCP_MAX_ATTEMPTS="${MCP_MAX_ATTEMPTS:-3}"
    export MCP_RETRY_DELAY="${MCP_RETRY_DELAY:-1000}"
    export MCP_CONNECTION_TIMEOUT="${MCP_CONNECTION_TIMEOUT:-5000}"
    export MCP_OPERATION_TIMEOUT="${MCP_OPERATION_TIMEOUT:-30000}"
    export MCP_FALLBACK_ENABLED="${MCP_FALLBACK_ENABLED:-true}"
    export MCP_LOG_LEVEL="${MCP_LOG_LEVEL:-info}"
    
    # Load from config file if exists
    local config_file="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/mcp-config.yaml"
    if [ -f "$config_file" ]; then
        load_yaml_config "$config_file"
    fi
    
    # Load from project-specific config
    local project_config=".claude/mcp-config.yaml"
    if [ -f "$project_config" ]; then
        load_yaml_config "$project_config"
    fi
}

# Helper to load YAML config
load_yaml_config() {
    local config_file="$1"
    
    # Extract values using yq or similar
    if command -v yq >/dev/null 2>&1; then
        eval "$(yq eval -o=shell '.mcp_server.retry.max_attempts // empty' "$config_file" | sed 's/^/MCP_MAX_ATTEMPTS=/')"
        eval "$(yq eval -o=shell '.mcp_server.retry.retry_delay // empty' "$config_file" | sed 's/^/MCP_RETRY_DELAY=/')"
        eval "$(yq eval -o=shell '.mcp_server.timeouts.connection_timeout // empty' "$config_file" | sed 's/^/MCP_CONNECTION_TIMEOUT=/')"
        eval "$(yq eval -o=shell '.mcp_server.timeouts.operation_timeout // empty' "$config_file" | sed 's/^/MCP_OPERATION_TIMEOUT=/')"
        eval "$(yq eval -o=shell '.mcp_server.fallback.enabled // empty' "$config_file" | sed 's/^/MCP_FALLBACK_ENABLED=/')"
        eval "$(yq eval -o=shell '.mcp_server.debug.log_level // empty' "$config_file" | sed 's/^/MCP_LOG_LEVEL=/')"
    fi
}
```

### get_mcp_setting
Gets a specific MCP configuration value.

```bash
get_mcp_setting() {
    local setting="$1"
    local default="${2:-}"
    
    # Ensure config is loaded
    [ -z "${MCP_CONFIG_LOADED:-}" ] && load_mcp_config && MCP_CONFIG_LOADED=true
    
    case "$setting" in
        "max_attempts") echo "${MCP_MAX_ATTEMPTS:-3}" ;;
        "retry_delay") echo "${MCP_RETRY_DELAY:-1000}" ;;
        "connection_timeout") echo "${MCP_CONNECTION_TIMEOUT:-5000}" ;;
        "operation_timeout") echo "${MCP_OPERATION_TIMEOUT:-30000}" ;;
        "fallback_enabled") echo "${MCP_FALLBACK_ENABLED:-true}" ;;
        "log_level") echo "${MCP_LOG_LEVEL:-info}" ;;
        *) echo "${default}" ;;
    esac
}
```

## Environment Variables

The following environment variables can be used to override configuration:

| Variable | Description | Default |
|----------|-------------|---------|
| `MCP_MAX_ATTEMPTS` | Maximum retry attempts | 3 |
| `MCP_RETRY_DELAY` | Delay between retries (ms) | 1000 |
| `MCP_CONNECTION_TIMEOUT` | Connection timeout (ms) | 5000 |
| `MCP_OPERATION_TIMEOUT` | Operation timeout (ms) | 30000 |
| `MCP_FALLBACK_ENABLED` | Enable gh CLI fallback | true |
| `MCP_LOG_LEVEL` | Logging level | info |
| `MCP_SIMULATION_MODE` | Enable simulation mode | false |
| `GITHUB_MCP_SERVER_COMMAND` | MCP server command | (auto-detect) |
| `MCP_GITHUB_AVAILABLE` | Force MCP availability | (auto-detect) |

## Configuration Profiles

### Development Profile
```bash
export MCP_LOG_LEVEL="debug"
export MCP_LOG_MCP_TRAFFIC="true"
export MCP_SAVE_FAILED_REQUESTS="true"
export MCP_RETRY_DELAY="500"
```

### Production Profile
```bash
export MCP_LOG_LEVEL="warning"
export MCP_LOG_MCP_TRAFFIC="false"
export MCP_RETRY_DELAY="2000"
export MCP_MAX_ATTEMPTS="5"
```

### Testing Profile
```bash
export MCP_SIMULATION_MODE="true"
export MCP_MAX_ATTEMPTS="1"
export MCP_FALLBACK_ENABLED="false"
```

## Dynamic Configuration

### update_mcp_setting
Updates MCP configuration at runtime.

```bash
update_mcp_setting() {
    local setting="$1"
    local value="$2"
    
    case "$setting" in
        "max_attempts") export MCP_MAX_ATTEMPTS="$value" ;;
        "retry_delay") export MCP_RETRY_DELAY="$value" ;;
        "connection_timeout") export MCP_CONNECTION_TIMEOUT="$value" ;;
        "operation_timeout") export MCP_OPERATION_TIMEOUT="$value" ;;
        "fallback_enabled") export MCP_FALLBACK_ENABLED="$value" ;;
        "log_level") export MCP_LOG_LEVEL="$value" ;;
        *)
            log_error "Unknown MCP setting: $setting"
            return 1
            ;;
    esac
    
    log_info "Updated MCP setting: $setting=$value"
}
```

### reset_mcp_config
Resets MCP configuration to defaults.

```bash
reset_mcp_config() {
    unset MCP_MAX_ATTEMPTS
    unset MCP_RETRY_DELAY
    unset MCP_CONNECTION_TIMEOUT
    unset MCP_OPERATION_TIMEOUT
    unset MCP_FALLBACK_ENABLED
    unset MCP_LOG_LEVEL
    unset MCP_CONFIG_LOADED
    
    log_info "MCP configuration reset to defaults"
}
```

## Usage Examples

### Loading Configuration
```bash
# Load MCP configuration
load_mcp_config

# Get specific setting
max_attempts=$(get_mcp_setting "max_attempts")
echo "Max MCP attempts: $max_attempts"
```

### Customizing for a Session
```bash
# Set aggressive retry for important operations
update_mcp_setting "max_attempts" "10"
update_mcp_setting "retry_delay" "5000"

# Perform operations
github_create_issue "Important issue" "This must succeed"

# Reset to defaults
reset_mcp_config
```

### Project-Specific Configuration
Create `.claude/mcp-config.yaml` in your project:

```yaml
mcp_server:
  retry:
    max_attempts: 5
    retry_delay: 2000
  timeouts:
    operation_timeout: 60000
  debug:
    log_level: "debug"
```

## Integration Points

- MCP Detector uses these settings for retry logic
- Operation Router respects timeout configurations
- Error handlers use log levels for output control
- Session management uses state location settings

---
*This configuration module ensures flexible and customizable MCP server behavior.*