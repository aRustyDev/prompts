---
module: Plan_core  
scope: context
triggers: []
conflicts: []
dependencies: []
priority: high
---

# Plan Core - Shared Utilities

## Purpose
Core planning logic and shared utilities used by all plan subcommands.

## Overview
This module provides common functionality for session management, error handling, and utilities shared across all planning phases.

## Session Management

### Session Directory Structure
```
.plan/
├── sessions/
│   ├── 20240109_143022/
│   │   ├── requirements.md
│   │   ├── task-breakdown.yaml
│   │   ├── dependencies.md
│   │   ├── mvp-scope.md
│   │   ├── issues.json
│   │   ├── milestones.json
│   │   ├── projects.json
│   │   ├── labels.json
│   │   ├── execute_plan.sh
│   │   └── summary.md
│   └── [other sessions]/
├── backups/
│   └── [timestamp]/
└── templates/
    └── [custom templates]/
```

### Session Functions

#### Create Session
```bash
create_session() {
  SESSION_ID=$(date +%Y%m%d_%H%M%S)
  SESSION_DIR=".plan/sessions/$SESSION_ID"
  mkdir -p "$SESSION_DIR"
  echo "$SESSION_DIR"
}
```

#### Load Session
```bash
load_session() {
  local session_id=$1
  if [ -d ".plan/sessions/$session_id" ]; then
    SESSION_DIR=".plan/sessions/$session_id"
    echo "✅ Loaded session: $session_id"
    return 0
  else
    echo "❌ Session not found: $session_id"
    return 1
  fi
}
```

#### List Sessions
```bash
list_sessions() {
  if [ -d ".plan/sessions" ] && [ "$(ls -A .plan/sessions)" ]; then
    echo "📁 Available sessions:"
    for session in .plan/sessions/*/; do
      session_name=$(basename "$session")
      created=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$session" 2>/dev/null || echo "Unknown")
      echo "  • $session_name (created: $created)"
    done
  else
    echo "ℹ️ No sessions found"
  fi
}
```

## Common Variables

```bash
# Repository information
get_repo_info() {
  REPO_OWNER=$(gh repo view --json owner -q .owner.login)
  REPO_NAME=$(gh repo view --json name -q .name)
  REPO_URL=$(gh repo view --json url -q .url)
}

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
```

## Error Handling

### Error Types
```bash
# Error codes
readonly ERR_NO_GH_CLI=1
readonly ERR_NOT_GIT_REPO=2
readonly ERR_NO_GH_AUTH=3
readonly ERR_NO_REPO_ACCESS=4
readonly ERR_INVALID_SUBCOMMAND=5
readonly ERR_SESSION_NOT_FOUND=6
readonly ERR_FILE_NOT_FOUND=7
```

### Error Handler
```bash
handle_error() {
  local error_code=$1
  local error_message=$2
  
  echo -e "${RED}❌ Error: ${error_message}${NC}" >&2
  
  case $error_code in
    $ERR_NO_GH_CLI)
      echo "Please install GitHub CLI: https://cli.github.com" >&2
      ;;
    $ERR_NOT_GIT_REPO)
      echo "Run this command from within a git repository" >&2
      ;;
    $ERR_NO_GH_AUTH)
      echo "Run: gh auth login" >&2
      ;;
    $ERR_NO_REPO_ACCESS)
      echo "Check repository permissions" >&2
      ;;
  esac
  
  exit $error_code
}
```

### Validation Functions

#### Check Prerequisites
```bash
check_prerequisites() {
  # Check for gh CLI
  if ! command -v gh &> /dev/null; then
    handle_error $ERR_NO_GH_CLI "GitHub CLI not found"
  fi
  
  # Check for git repository
  if ! git rev-parse --git-dir &> /dev/null; then
    handle_error $ERR_NOT_GIT_REPO "Not in a git repository"
  fi
  
  # Check GitHub authentication
  if ! gh auth status &>/dev/null; then
    handle_error $ERR_NO_GH_AUTH "Not authenticated with GitHub"
  fi
  
  # Check repository access
  if ! gh repo view &>/dev/null; then
    handle_error $ERR_NO_REPO_ACCESS "Cannot access repository"
  fi
}
```

## Templates System

### Load Template
```bash
load_template() {
  local template_name=$1
  local template_file=".plan/templates/${template_name}.json"
  
  if [ -f "$template_file" ]; then
    cat "$template_file"
  else
    echo "{}" # Return empty object if template not found
  fi
}
```

### Save Template
```bash
save_template() {
  local template_name=$1
  local template_data=$2
  
  mkdir -p .plan/templates
  echo "$template_data" > ".plan/templates/${template_name}.json"
  echo "✅ Template saved: $template_name"
}
```

## Import/Export Functions

### Import from Markdown
```bash
import_from_markdown() {
  local markdown_file=$1
  local session_dir=$2
  
  # Parse markdown for task items
  grep -E "^- \[ \]" "$markdown_file" | while read -r line; do
    # Extract task title
    task_title=$(echo "$line" | sed 's/^- \[ \] //')
    echo "$task_title"
  done > "$session_dir/imported_tasks.txt"
}
```

### Export to Markdown
```bash
export_to_markdown() {
  local session_dir=$1
  local output_file=$2
  
  cat > "$output_file" << EOF
# Project Plan
Generated: $(date)

## Issues
$(jq -r '.[] | "- [ ] \(.title)"' "$session_dir/issues.json")

## Milestones
$(jq -r '.[] | "### \(.title)\n\(.description)\n"' "$session_dir/milestones.json")
EOF
}
```

## Utility Functions

### Format Duration
```bash
format_duration() {
  local seconds=$1
  local hours=$((seconds / 3600))
  local minutes=$(( (seconds % 3600) / 60 ))
  local secs=$((seconds % 60))
  
  if [ $hours -gt 0 ]; then
    printf "%dh %dm %ds" $hours $minutes $secs
  elif [ $minutes -gt 0 ]; then
    printf "%dm %ds" $minutes $secs
  else
    printf "%ds" $secs
  fi
}
```

### Progress Bar
```bash
show_progress() {
  local current=$1
  local total=$2
  local width=50
  
  local progress=$((current * width / total))
  local percentage=$((current * 100 / total))
  
  printf "\r["
  printf "%${progress}s" | tr ' ' '='
  printf "%$((width - progress))s" | tr ' ' '-'
  printf "] %d%%" $percentage
}
```

## Integration Points

This core module is used by:
- `discovery.md` - Session creation and management
- `analysis.md` - Data storage and retrieval
- `design.md` - Template handling
- `implementation.md` - Progress tracking
- `cleanup.md` - Session listing and removal

All plan modules should import this for:
1. Session management
2. Error handling
3. Common utilities
4. Repository information
5. Template operations