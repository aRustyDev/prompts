# GitHub MCP Server Integration Guide

## Overview

This repository now supports the GitHub MCP (Model Context Protocol) server as the primary method for GitHub operations, with automatic fallback to the `gh` CLI when MCP is unavailable. This provides better AI integration while maintaining full functionality.

## Architecture

### Components

1. **MCP Detector** (`.claude/core/integrations/github-mcp/mcp-detector.md`)
   - Detects MCP server availability
   - Manages retry attempts (3 max per session)
   - Handles session state persistence

2. **GitHub Interface** (`.claude/core/patterns/github-operations/github-interface.md`)
   - Provides unified API for all GitHub operations
   - Abstracts implementation details
   - Ensures consistent behavior

3. **MCP Implementation** (`.claude/core/patterns/github-operations/mcp-implementation.md`)
   - Implements GitHub operations using MCP server
   - Handles MCP-specific communication
   - Provides structured responses

4. **gh CLI Implementation** (`.claude/core/patterns/github-operations/gh-cli-implementation.md`)
   - Fallback implementation using gh CLI
   - Maintains full feature parity
   - Proven reliability

5. **Operation Router** (`.claude/core/patterns/github-operations/operation-router.md`)
   - Routes operations to appropriate implementation
   - Manages fallback logic
   - Tracks operation statistics

6. **MCP Settings** (`.claude/core/config/mcp-settings.md`)
   - Configurable retry policies
   - Timeout settings
   - Debug options

## How It Works

### Session Flow

1. **Initialization**: When a GitHub operation is first requested, the router initializes
2. **MCP Detection**: Checks if MCP server is available and configured
3. **Operation Routing**: 
   - If MCP available → Use MCP implementation
   - If MCP fails → Increment retry counter
   - After 3 failures → Permanently fall back to gh CLI for session
4. **Session Persistence**: Retry state persists across operations in same session

### Fallback Logic

```
┌─────────────────┐
│ GitHub Operation│
└────────┬────────┘
         │
         ▼
┌─────────────────┐     ┌──────────────┐
│ Check MCP Status├────►│ MCP Available│────► Use MCP Server
└────────┬────────┘     └──────────────┘
         │
         │ Not Available/Failed
         ▼
┌─────────────────┐     ┌──────────────┐
│ Retry Count < 3 ├────►│ Increment    │────► Try Again
└────────┬────────┘     └──────────────┘
         │
         │ Retry Count ≥ 3
         ▼
┌─────────────────┐
│  Use gh CLI     │────► Permanent for Session
└─────────────────┘
```

## Setup

### Prerequisites

1. **For MCP Server**:
   - VS Code 1.101+ with MCP support enabled
   - GitHub MCP server installed (Docker, binary, or remote)
   - GitHub Personal Access Token

2. **For gh CLI** (fallback):
   - gh CLI installed and authenticated
   - Same permissions as MCP token

### MCP Server Installation Options

#### Option 1: Remote Server (Easiest)
- One-click install in VS Code
- No local setup required
- Automatic updates

#### Option 2: Docker
```bash
docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN ghcr.io/github/github-mcp-server
```

#### Option 3: Build from Source
```bash
cd github-mcp-server
go build -o github-mcp-server cmd/github-mcp-server/main.go
GITHUB_PERSONAL_ACCESS_TOKEN=your_token ./github-mcp-server stdio
```

### Configuration

1. **VS Code Settings** (for MCP):
```json
{
  "mcpServers": {
    "github": {
      "command": "github-mcp-server",
      "args": ["stdio"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your_token"
      }
    }
  }
}
```

2. **Environment Variables**:
```bash
# MCP Configuration
export MCP_MAX_ATTEMPTS=3          # Retry attempts before fallback
export MCP_OPERATION_TIMEOUT=30000 # Operation timeout (ms)
export MCP_LOG_LEVEL=info          # Logging level

# Force specific implementation (optional)
export MCP_FALLBACK_ENABLED=false  # Disable fallback to gh CLI
```

## Migration Guide

### For Existing Scripts

1. **Update Script Headers**:
```bash
# Old
#!/bin/bash
# Direct gh CLI usage

# New
#!/bin/bash
# Source the GitHub operations router
source ".claude/core/patterns/github-operations/operation-router.md"
init_github_router
```

2. **Replace Direct Commands**:
```bash
# Old
gh issue create --title "Bug" --body "Description"

# New
github_create_issue "Bug" "Description"
```

3. **Update Error Handling**:
```bash
# Old
if ! gh issue create ...; then
    echo "Failed to create issue"
    exit 1
fi

# New
if ! github_create_issue ...; then
    # Router handles retry/fallback automatically
    handle_error $? "create_issue" "Failed to create issue"
fi
```

### For New Development

Always use the GitHub interface functions:

```bash
# Issues
github_create_issue "title" "body" "labels" "milestone" "assignee"
github_list_issues "state" "labels" "assignee" "limit"
github_update_issue "number" "title" "body" "state" "labels"

# Pull Requests
github_create_pr "title" "body" "base" "head" "draft"
github_list_prs "state" "base" "head" "limit"

# Repository
github_repo_info "owner/repo"
github_clone_repo "owner/repo" "directory"

# Milestones & Labels
github_create_milestone "title" "description" "due_date"
github_create_label "name" "description" "color"
```

## Monitoring

### Check Status
```bash
# View current router status
github_router_status

# Output includes:
# - Current implementation (MCP/gh CLI)
# - Retry count
# - Session state
# - Connection status
```

### Debug Issues
```bash
# Enable debug logging
export MCP_LOG_LEVEL=debug

# Reset session state
reset_mcp_session

# Force specific implementation
export GITHUB_FORCE_IMPLEMENTATION=gh-cli
```

## Troubleshooting

### MCP Server Not Detected

1. Check VS Code settings for MCP configuration
2. Verify MCP server is running: `docker ps | grep github-mcp`
3. Test token: `echo $GITHUB_PERSONAL_ACCESS_TOKEN`
4. Check logs: Enable debug mode

### Constant Fallbacks

1. Verify MCP server connectivity
2. Check authentication token permissions
3. Review MCP server logs
4. Increase timeout: `export MCP_OPERATION_TIMEOUT=60000`

### Performance Issues

1. MCP server may have initial connection overhead
2. Consider increasing operation timeout
3. Check network latency to GitHub

## Benefits

### Why MCP Server?

1. **AI-Optimized**: Designed for LLM interaction
2. **Structured Data**: Returns JSON for easy parsing
3. **Context Aware**: Maintains operation context
4. **Feature Rich**: Access to full GitHub API

### Why Keep gh CLI?

1. **Reliability**: Battle-tested fallback
2. **Offline Work**: Some operations work offline
3. **Debugging**: Easier to debug issues
4. **Compatibility**: Works everywhere

## Best Practices

1. **Let the Router Decide**: Don't force implementations unless testing
2. **Handle Errors Gracefully**: The router manages retries automatically
3. **Monitor Performance**: Use `github_router_status` to check health
4. **Update Regularly**: Keep both MCP server and gh CLI updated

## Future Enhancements

- [ ] Metrics collection for operation performance
- [ ] Configurable retry strategies per operation
- [ ] Cache MCP responses for read operations
- [ ] WebSocket support for real-time updates
- [ ] Batch operation optimization

---

For more information, see:
- [GitHub MCP Server](https://github.com/github/github-mcp-server)
- [Model Context Protocol](https://modelcontextprotocol.io)
- [gh CLI Documentation](https://cli.github.com)