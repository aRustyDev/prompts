---
module: GitHubInterface
scope: persistent
priority: high
triggers: ["github", "issue", "pr", "repository"]
dependencies: ["MCPDetector", "BaseErrorHandler"]
conflicts: []
version: 1.0.0
---

# GitHub Operations Interface

## Purpose
Provides a unified interface for all GitHub operations, abstracting the underlying implementation (MCP server or gh CLI).

## Overview
This module defines the standard interface that all GitHub operations must follow, ensuring consistent behavior regardless of the backend used.

## Core Interface Functions

### Issue Operations

#### github_create_issue
Creates a new GitHub issue.

```bash
github_create_issue() {
    local title="$1"
    local body="$2"
    local labels="${3:-}"
    local milestone="${4:-}"
    local assignee="${5:-}"
    
    # Validate inputs
    if [ -z "$title" ]; then
        handle_error 1001 "github_create_issue" "Title is required"
        return 1
    fi
    
    # Route to appropriate implementation
    if check_mcp_available; then
        mcp_create_issue "$title" "$body" "$labels" "$milestone" "$assignee"
    else
        gh_cli_create_issue "$title" "$body" "$labels" "$milestone" "$assignee"
    fi
}
```

#### github_list_issues
Lists issues with optional filters.

```bash
github_list_issues() {
    local state="${1:-open}"  # open, closed, all
    local labels="$2"
    local assignee="$3"
    local limit="${4:-30}"
    
    if check_mcp_available; then
        mcp_list_issues "$state" "$labels" "$assignee" "$limit"
    else
        gh_cli_list_issues "$state" "$labels" "$assignee" "$limit"
    fi
}
```

#### github_update_issue
Updates an existing issue.

```bash
github_update_issue() {
    local issue_number="$1"
    local title="$2"
    local body="$3"
    local state="$4"
    local labels="$5"
    
    if [ -z "$issue_number" ]; then
        handle_error 1002 "github_update_issue" "Issue number is required"
        return 1
    fi
    
    if check_mcp_available; then
        mcp_update_issue "$issue_number" "$title" "$body" "$state" "$labels"
    else
        gh_cli_update_issue "$issue_number" "$title" "$body" "$state" "$labels"
    fi
}
```

### Pull Request Operations

#### github_create_pr
Creates a new pull request.

```bash
github_create_pr() {
    local title="$1"
    local body="$2"
    local base="${3:-main}"
    local head="$4"
    local draft="${5:-false}"
    
    if [ -z "$title" ]; then
        handle_error 1003 "github_create_pr" "Title is required"
        return 1
    fi
    
    if check_mcp_available; then
        mcp_create_pr "$title" "$body" "$base" "$head" "$draft"
    else
        gh_cli_create_pr "$title" "$body" "$base" "$head" "$draft"
    fi
}
```

#### github_list_prs
Lists pull requests with filters.

```bash
github_list_prs() {
    local state="${1:-open}"
    local base="$2"
    local head="$3"
    local limit="${4:-30}"
    
    if check_mcp_available; then
        mcp_list_prs "$state" "$base" "$head" "$limit"
    else
        gh_cli_list_prs "$state" "$base" "$head" "$limit"
    fi
}
```

### Repository Operations

#### github_repo_info
Gets repository information.

```bash
github_repo_info() {
    local repo="${1:-}"  # owner/repo format or current if empty
    
    if check_mcp_available; then
        mcp_repo_info "$repo"
    else
        gh_cli_repo_info "$repo"
    fi
}
```

#### github_clone_repo
Clones a repository.

```bash
github_clone_repo() {
    local repo="$1"
    local directory="$2"
    
    if [ -z "$repo" ]; then
        handle_error 1004 "github_clone_repo" "Repository is required"
        return 1
    fi
    
    if check_mcp_available; then
        mcp_clone_repo "$repo" "$directory"
    else
        gh_cli_clone_repo "$repo" "$directory"
    fi
}
```

### Project and Milestone Operations

#### github_create_milestone
Creates a new milestone.

```bash
github_create_milestone() {
    local title="$1"
    local description="$2"
    local due_date="$3"
    
    if [ -z "$title" ]; then
        handle_error 1005 "github_create_milestone" "Title is required"
        return 1
    fi
    
    if check_mcp_available; then
        mcp_create_milestone "$title" "$description" "$due_date"
    else
        gh_cli_create_milestone "$title" "$description" "$due_date"
    fi
}
```

### Label Operations

#### github_create_label
Creates a new label.

```bash
github_create_label() {
    local name="$1"
    local description="$2"
    local color="${3:-#0366d6}"
    
    if [ -z "$name" ]; then
        handle_error 1006 "github_create_label" "Label name is required"
        return 1
    fi
    
    if check_mcp_available; then
        mcp_create_label "$name" "$description" "$color"
    else
        gh_cli_create_label "$name" "$description" "$color"
    fi
}
```

## Error Handling

All interface functions follow consistent error handling:

```bash
# Wrapper for operations with error handling
github_operation_wrapper() {
    local operation="$1"
    shift
    
    # Pre-operation validation
    validate_github_auth || return 1
    
    # Execute operation
    if ! "$operation" "$@"; then
        local exit_code=$?
        handle_github_error "$operation" "$exit_code"
        return $exit_code
    fi
    
    return 0
}

# Validate GitHub authentication
validate_github_auth() {
    if check_mcp_available; then
        validate_mcp_auth
    else
        validate_gh_cli_auth
    fi
}

# Handle GitHub operation errors
handle_github_error() {
    local operation="$1"
    local exit_code="$2"
    
    case $exit_code in
        1) handle_error 2001 "$operation" "Authentication failed" ;;
        2) handle_error 2002 "$operation" "Network error" ;;
        3) handle_error 2003 "$operation" "Permission denied" ;;
        4) handle_error 2004 "$operation" "Resource not found" ;;
        *) handle_error 2000 "$operation" "Unknown error (code: $exit_code)" ;;
    esac
}
```

## Batch Operations

### github_bulk_create_issues
Creates multiple issues from a structured input.

```bash
github_bulk_create_issues() {
    local issues_file="$1"
    local dry_run="${2:-false}"
    
    if [ ! -f "$issues_file" ]; then
        handle_error 1007 "github_bulk_create_issues" "Issues file not found: $issues_file"
        return 1
    fi
    
    if check_mcp_available; then
        mcp_bulk_create_issues "$issues_file" "$dry_run"
    else
        gh_cli_bulk_create_issues "$issues_file" "$dry_run"
    fi
}
```

## Usage Examples

### Creating an Issue
```bash
# Simple issue creation
github_create_issue "Bug: Login fails" "Users cannot log in after session timeout"

# Issue with metadata
github_create_issue "Feature: Add export" \
    "Add ability to export data as CSV" \
    "enhancement,priority:high" \
    "v2.0" \
    "@username"
```

### Working with PRs
```bash
# Create a PR
github_create_pr "Add user authentication" \
    "This PR implements OAuth2 authentication" \
    "main" \
    "feature/auth"

# List open PRs
github_list_prs "open" "main"
```

## Integration Points
- All GitHub operations in the system should use these interface functions
- Implementations must handle both success and failure cases
- Error codes are standardized across implementations
- Supports both interactive and batch operations

---
*This interface ensures consistent GitHub operations regardless of the underlying implementation.*