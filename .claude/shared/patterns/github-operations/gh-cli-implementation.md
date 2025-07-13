---
module: GHCLIImplementation
scope: persistent
priority: high
triggers: []
dependencies: ["GitHubInterface", "BaseErrorHandler"]
conflicts: []
version: 1.0.0
---

# GitHub CLI (gh) Implementation

## Purpose
Implements GitHub operations using the gh CLI tool as a fallback when MCP server is unavailable.

## Overview
This module provides gh CLI-specific implementations of all GitHub operations defined in the GitHubInterface.

## Issue Operations Implementation

### gh_cli_create_issue
Creates an issue using gh CLI.

```bash
gh_cli_create_issue() {
    local title="$1"
    local body="$2"
    local labels="$3"
    local milestone="$4"
    local assignee="$5"
    
    # Build gh command
    local gh_args=()
    gh_args+=("--title" "$title")
    
    # Add optional arguments
    [ -n "$body" ] && gh_args+=("--body" "$body")
    [ -n "$labels" ] && gh_args+=("--label" "$labels")
    [ -n "$milestone" ] && gh_args+=("--milestone" "$milestone")
    [ -n "$assignee" ] && gh_args+=("--assignee" "$assignee")
    
    # Execute gh command
    if gh issue create "${gh_args[@]}" 2>&1; then
        return 0
    else
        local exit_code=$?
        log_error "gh issue create failed with exit code: $exit_code"
        return $exit_code
    fi
}
```

### gh_cli_list_issues
Lists issues using gh CLI.

```bash
gh_cli_list_issues() {
    local state="$1"
    local labels="$2"
    local assignee="$3"
    local limit="$4"
    
    # Build gh command
    local gh_args=()
    gh_args+=("--state" "$state")
    
    # Add optional filters
    [ -n "$labels" ] && gh_args+=("--label" "$labels")
    [ -n "$assignee" ] && gh_args+=("--assignee" "$assignee")
    [ -n "$limit" ] && gh_args+=("--limit" "$limit")
    
    # Execute gh command
    if gh issue list "${gh_args[@]}" 2>&1; then
        return 0
    else
        local exit_code=$?
        log_error "gh issue list failed with exit code: $exit_code"
        return $exit_code
    fi
}
```

### gh_cli_update_issue
Updates an issue using gh CLI.

```bash
gh_cli_update_issue() {
    local issue_number="$1"
    local title="$2"
    local body="$3"
    local state="$4"
    local labels="$5"
    
    # Build gh command
    local gh_args=()
    
    # Add update arguments
    [ -n "$title" ] && gh_args+=("--title" "$title")
    [ -n "$body" ] && gh_args+=("--body" "$body")
    [ -n "$state" ] && gh_args+=("--state" "$state")
    
    # Handle labels (gh requires separate add/remove commands)
    if [ -n "$labels" ]; then
        # First, remove all labels
        gh issue edit "$issue_number" --remove-label "*" 2>/dev/null || true
        # Then add new labels
        gh_args+=("--add-label" "$labels")
    fi
    
    # Execute gh command if there are updates
    if [ ${#gh_args[@]} -gt 0 ]; then
        if gh issue edit "$issue_number" "${gh_args[@]}" 2>&1; then
            echo "Updated issue #$issue_number"
            return 0
        else
            local exit_code=$?
            log_error "gh issue edit failed with exit code: $exit_code"
            return $exit_code
        fi
    else
        echo "No updates provided for issue #$issue_number"
        return 0
    fi
}
```

## Pull Request Operations Implementation

### gh_cli_create_pr
Creates a pull request using gh CLI.

```bash
gh_cli_create_pr() {
    local title="$1"
    local body="$2"
    local base="$3"
    local head="$4"
    local draft="$5"
    
    # Build gh command
    local gh_args=()
    gh_args+=("--title" "$title")
    
    # Add optional arguments
    [ -n "$body" ] && gh_args+=("--body" "$body")
    [ -n "$base" ] && gh_args+=("--base" "$base")
    [ -n "$head" ] && gh_args+=("--head" "$head")
    [ "$draft" = "true" ] && gh_args+=("--draft")
    
    # Execute gh command
    if gh pr create "${gh_args[@]}" 2>&1; then
        return 0
    else
        local exit_code=$?
        log_error "gh pr create failed with exit code: $exit_code"
        return $exit_code
    fi
}
```

### gh_cli_list_prs
Lists pull requests using gh CLI.

```bash
gh_cli_list_prs() {
    local state="$1"
    local base="$2"
    local head="$3"
    local limit="$4"
    
    # Build gh command
    local gh_args=()
    gh_args+=("--state" "$state")
    
    # Add optional filters
    [ -n "$base" ] && gh_args+=("--base" "$base")
    [ -n "$head" ] && gh_args+=("--head" "$head")
    [ -n "$limit" ] && gh_args+=("--limit" "$limit")
    
    # Execute gh command
    if gh pr list "${gh_args[@]}" 2>&1; then
        return 0
    else
        local exit_code=$?
        log_error "gh pr list failed with exit code: $exit_code"
        return $exit_code
    fi
}
```

## Repository Operations Implementation

### gh_cli_repo_info
Gets repository information using gh CLI.

```bash
gh_cli_repo_info() {
    local repo="$1"
    
    # Build gh command
    local gh_args=()
    [ -n "$repo" ] && gh_args+=("$repo")
    
    # Execute gh command with JSON output for parsing
    local response
    if response=$(gh repo view "${gh_args[@]}" --json name,description,stargazerCount,defaultBranchRef,isPrivate 2>&1); then
        # Format output to match expected format
        echo "$response" | jq -r '
            "Repository: \(.name)",
            "Description: \(.description // "N/A")",
            "Stars: \(.stargazerCount)",
            "Default Branch: \(.defaultBranchRef.name)",
            "Private: \(.isPrivate)"
        '
        return 0
    else
        local exit_code=$?
        log_error "gh repo view failed with exit code: $exit_code"
        return $exit_code
    fi
}
```

### gh_cli_clone_repo
Clones a repository using gh CLI.

```bash
gh_cli_clone_repo() {
    local repo="$1"
    local directory="$2"
    
    # Build gh command
    local gh_args=()
    gh_args+=("$repo")
    [ -n "$directory" ] && gh_args+=("$directory")
    
    # Execute gh command
    if gh repo clone "${gh_args[@]}" 2>&1; then
        return 0
    else
        local exit_code=$?
        log_error "gh repo clone failed with exit code: $exit_code"
        return $exit_code
    fi
}
```

## Milestone and Label Operations

### gh_cli_create_milestone
Creates a milestone using gh CLI.

```bash
gh_cli_create_milestone() {
    local title="$1"
    local description="$2"
    local due_date="$3"
    
    # gh doesn't have direct milestone creation, use API
    local api_payload
    api_payload=$(jq -n \
        --arg title "$title" \
        --arg desc "${description:-}" \
        --arg due "${due_date:-}" \
        '{
            title: $title,
            description: $desc,
            due_on: (if $due != "" then $due else null end)
        }')
    
    # Get current repo
    local repo
    repo=$(gh repo view --json nameWithOwner -q .nameWithOwner)
    
    # Create milestone via API
    if gh api "repos/$repo/milestones" --method POST --input - <<< "$api_payload" 2>&1; then
        echo "Created milestone: $title"
        return 0
    else
        local exit_code=$?
        log_error "gh api milestone creation failed with exit code: $exit_code"
        return $exit_code
    fi
}
```

### gh_cli_create_label
Creates a label using gh CLI.

```bash
gh_cli_create_label() {
    local name="$1"
    local description="$2"
    local color="$3"
    
    # Remove # from color if present
    color="${color#\#}"
    
    # Build gh command
    local gh_args=()
    gh_args+=("--name" "$name")
    [ -n "$description" ] && gh_args+=("--description" "$description")
    gh_args+=("--color" "$color")
    
    # Execute gh command
    if gh label create "${gh_args[@]}" 2>&1; then
        echo "Created label: $name"
        return 0
    else
        local exit_code=$?
        log_error "gh label create failed with exit code: $exit_code"
        return $exit_code
    fi
}
```

## Batch Operations

### gh_cli_bulk_create_issues
Creates multiple issues in batch using gh CLI.

```bash
gh_cli_bulk_create_issues() {
    local issues_file="$1"
    local dry_run="$2"
    
    # Parse issues file (assuming YAML format)
    local issues_count=0
    local created_count=0
    
    # Convert YAML to JSON for easier parsing
    local issues_json
    if ! issues_json=$(cat "$issues_file" | yq -o json 2>/dev/null); then
        log_error "Failed to parse issues file"
        return 1
    fi
    
    # Get number of issues
    issues_count=$(echo "$issues_json" | jq '.issues | length')
    
    if [ "$dry_run" = "true" ]; then
        echo "DRY RUN: Would create $issues_count issues"
        echo "$issues_json" | jq -r '.issues[] | "  - \(.title)"'
        return 0
    fi
    
    # Create each issue
    echo "Creating $issues_count issues..."
    
    local i=0
    while [ $i -lt $issues_count ]; do
        local issue
        issue=$(echo "$issues_json" | jq ".issues[$i]")
        
        # Extract issue fields
        local title=$(echo "$issue" | jq -r '.title')
        local body=$(echo "$issue" | jq -r '.body // ""')
        local labels=$(echo "$issue" | jq -r '.labels // "" | if type == "array" then join(",") else . end')
        local milestone=$(echo "$issue" | jq -r '.milestone // ""')
        local assignee=$(echo "$issue" | jq -r '.assignee // ""')
        
        # Create issue
        if gh_cli_create_issue "$title" "$body" "$labels" "$milestone" "$assignee"; then
            created_count=$((created_count + 1))
            echo "  [$created_count/$issues_count] Created: $title"
        else
            log_error "Failed to create issue: $title"
        fi
        
        i=$((i + 1))
        
        # Small delay to avoid rate limiting
        [ $i -lt $issues_count ] && sleep 0.5
    done
    
    echo "Successfully created $created_count of $issues_count issues"
    [ $created_count -eq $issues_count ] && return 0 || return 1
}
```

## Authentication

### validate_gh_cli_auth
Validates gh CLI authentication.

```bash
validate_gh_cli_auth() {
    # Check gh authentication status
    if gh auth status >/dev/null 2>&1; then
        return 0
    else
        log_error "gh CLI not authenticated. Run 'gh auth login' to authenticate."
        return 1
    fi
}
```

## Utility Functions

### gh_cli_get_current_repo
Gets the current repository name.

```bash
gh_cli_get_current_repo() {
    if gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null; then
        return 0
    else
        log_error "Not in a git repository or repository not found"
        return 1
    fi
}
```

### gh_cli_check_rate_limit
Checks GitHub API rate limit.

```bash
gh_cli_check_rate_limit() {
    local rate_info
    if rate_info=$(gh api rate_limit 2>/dev/null); then
        echo "$rate_info" | jq -r '
            "Core API:",
            "  Limit: \(.resources.core.limit)",
            "  Remaining: \(.resources.core.remaining)",
            "  Reset: \(.resources.core.reset | strftime("%Y-%m-%d %H:%M:%S"))"
        '
        return 0
    else
        log_error "Failed to check rate limit"
        return 1
    fi
}
```

## Error Handling

### gh_cli_handle_error
Handles gh CLI specific errors.

```bash
gh_cli_handle_error() {
    local exit_code="$1"
    local operation="$2"
    
    case $exit_code in
        1) log_error "$operation: General gh CLI error" ;;
        2) log_error "$operation: Authentication required" ;;
        3) log_error "$operation: Repository not found" ;;
        4) log_error "$operation: Network error" ;;
        *) log_error "$operation: Unknown error (exit code: $exit_code)" ;;
    esac
}
```

---
*This implementation provides gh CLI support for all GitHub operations as a reliable fallback.*