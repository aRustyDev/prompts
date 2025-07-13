#!/bin/bash

# start-work.sh - Start working on a GitHub issue
# Creates appropriate branch and sets up environment for issue-driven development

set -euo pipefail

# Source GitHub operations
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../.claude/core/patterns/github-operations/operation-router.md"
source "$SCRIPT_DIR/../../.claude/core/patterns/git-operations/branch-ops.md"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Usage function
usage() {
    cat << EOF
Usage: $0 <issue-number> [options]

Start working on a GitHub issue by creating an appropriate branch.

Arguments:
    issue-number    The GitHub issue number to work on

Options:
    -t, --type      Branch type (feat|fix|refactor|docs|test|chore|perf|style)
                    If not specified, will be inferred from issue labels
    -p, --parent    Parent issue number (for child issues)
    -n, --no-pull   Don't pull latest changes from main
    -h, --help      Show this help message

Examples:
    $0 123                    # Start work on issue #123
    $0 123 --type fix        # Start work on bug fix #123
    $0 124 --parent 123      # Start work on child issue #124 of #123

EOF
    exit 1
}

# Initialize variables
ISSUE_NUMBER=""
BRANCH_TYPE=""
PARENT_ISSUE=""
NO_PULL=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--type)
            BRANCH_TYPE="$2"
            shift 2
            ;;
        -p|--parent)
            PARENT_ISSUE="$2"
            shift 2
            ;;
        -n|--no-pull)
            NO_PULL=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            if [[ -z "$ISSUE_NUMBER" ]]; then
                ISSUE_NUMBER="$1"
            else
                echo -e "${RED}Error: Unknown argument: $1${NC}"
                usage
            fi
            shift
            ;;
    esac
done

# Validate issue number
if [[ -z "$ISSUE_NUMBER" ]]; then
    echo -e "${RED}Error: Issue number is required${NC}"
    usage
fi

if ! [[ "$ISSUE_NUMBER" =~ ^[0-9]+$ ]]; then
    echo -e "${RED}Error: Issue number must be numeric${NC}"
    exit 1
fi

# Initialize GitHub router
echo -e "${BLUE}Initializing GitHub connection...${NC}"
init_github_router

# Get issue details
echo -e "${BLUE}Fetching issue #${ISSUE_NUMBER}...${NC}"
ISSUE_JSON=$(gh issue view "$ISSUE_NUMBER" --json title,labels,state,assignees,body 2>/dev/null || true)

if [[ -z "$ISSUE_JSON" ]]; then
    echo -e "${RED}Error: Could not fetch issue #${ISSUE_NUMBER}${NC}"
    echo "Make sure the issue exists and you have access to it."
    exit 1
fi

# Check issue state
ISSUE_STATE=$(echo "$ISSUE_JSON" | jq -r '.state')
if [[ "$ISSUE_STATE" != "OPEN" ]]; then
    echo -e "${YELLOW}Warning: Issue #${ISSUE_NUMBER} is ${ISSUE_STATE}${NC}"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

# Extract issue details
ISSUE_TITLE=$(echo "$ISSUE_JSON" | jq -r '.title')
ISSUE_LABELS=$(echo "$ISSUE_JSON" | jq -r '.labels[].name' | tr '\n' ' ')

echo -e "${GREEN}Issue: #${ISSUE_NUMBER} - ${ISSUE_TITLE}${NC}"
echo -e "Labels: ${ISSUE_LABELS}"

# Determine branch type from labels if not specified
if [[ -z "$BRANCH_TYPE" ]]; then
    echo -e "${BLUE}Determining branch type from labels...${NC}"
    
    if echo "$ISSUE_LABELS" | grep -q "bug"; then
        BRANCH_TYPE="fix"
    elif echo "$ISSUE_LABELS" | grep -q "enhancement\|feature"; then
        BRANCH_TYPE="feat"
    elif echo "$ISSUE_LABELS" | grep -q "documentation"; then
        BRANCH_TYPE="docs"
    elif echo "$ISSUE_LABELS" | grep -q "refactor"; then
        BRANCH_TYPE="refactor"
    elif echo "$ISSUE_LABELS" | grep -q "test"; then
        BRANCH_TYPE="test"
    elif echo "$ISSUE_LABELS" | grep -q "chore\|maintenance"; then
        BRANCH_TYPE="chore"
    elif echo "$ISSUE_LABELS" | grep -q "performance"; then
        BRANCH_TYPE="perf"
    else
        # Default to feature
        BRANCH_TYPE="feat"
        echo -e "${YELLOW}No type label found, defaulting to 'feat'${NC}"
    fi
fi

echo -e "${GREEN}Branch type: ${BRANCH_TYPE}${NC}"

# Create branch name
# Sanitize issue title for branch name
SAFE_TITLE=$(echo "$ISSUE_TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//' | cut -c1-50)

# Build branch name
if [[ -n "$PARENT_ISSUE" ]]; then
    BRANCH_NAME="${BRANCH_TYPE}/${PARENT_ISSUE}-${ISSUE_NUMBER}-${SAFE_TITLE}"
else
    BRANCH_NAME="${BRANCH_TYPE}/${ISSUE_NUMBER}-${SAFE_TITLE}"
fi

echo -e "${GREEN}Branch name: ${BRANCH_NAME}${NC}"

# Check if branch already exists
if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
    echo -e "${YELLOW}Branch already exists locally${NC}"
    read -p "Switch to existing branch? (Y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        git checkout "$BRANCH_NAME"
        exit 0
    fi
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    echo -e "${YELLOW}Warning: You have uncommitted changes${NC}"
    echo "Options:"
    echo "  1) Stash changes and continue"
    echo "  2) Commit changes and continue"
    echo "  3) Cancel"
    read -p "Choose option (1-3): " -n 1 -r
    echo
    
    case $REPLY in
        1)
            echo -e "${BLUE}Stashing changes...${NC}"
            git stash push -m "WIP: Before starting work on #${ISSUE_NUMBER}"
            ;;
        2)
            echo -e "${BLUE}Please commit your changes first${NC}"
            exit 1
            ;;
        *)
            echo "Cancelled"
            exit 0
            ;;
    esac
fi

# Get default branch
DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")

# Ensure we're on default branch
echo -e "${BLUE}Switching to ${DEFAULT_BRANCH}...${NC}"
git checkout "$DEFAULT_BRANCH"

# Pull latest changes
if [[ "$NO_PULL" == false ]]; then
    echo -e "${BLUE}Pulling latest changes...${NC}"
    git pull origin "$DEFAULT_BRANCH"
fi

# Create and switch to new branch
echo -e "${BLUE}Creating branch: ${BRANCH_NAME}${NC}"
git checkout -b "$BRANCH_NAME"

# Push branch to track remotely
echo -e "${BLUE}Pushing branch to remote...${NC}"
git push -u origin "$BRANCH_NAME"

# Assign issue to self if not already assigned
ASSIGNEES=$(echo "$ISSUE_JSON" | jq -r '.assignees[].login' | tr '\n' ' ')
CURRENT_USER=$(gh api user -q .login)

if [[ ! "$ASSIGNEES" =~ $CURRENT_USER ]]; then
    echo -e "${BLUE}Assigning issue to self...${NC}"
    gh issue edit "$ISSUE_NUMBER" --add-assignee "@me" || true
fi

# Create initial work tracking file
WORK_DIR=".claude/work"
mkdir -p "$WORK_DIR"
WORK_FILE="$WORK_DIR/issue-${ISSUE_NUMBER}.md"

cat > "$WORK_FILE" << EOF
# Work Log: Issue #${ISSUE_NUMBER}

**Issue**: #${ISSUE_NUMBER} - ${ISSUE_TITLE}
**Branch**: ${BRANCH_NAME}
**Started**: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
$(if [[ -n "$PARENT_ISSUE" ]]; then echo "**Parent Issue**: #${PARENT_ISSUE}"; fi)

## Issue Details
${ISSUE_JSON}

## Work Log
- $(date -u +"%Y-%m-%d %H:%M:%S UTC"): Started work on issue

## Commits
<!-- Commits will be tracked here -->

## Notes
<!-- Add any implementation notes here -->

EOF

# Add work file to git (but don't commit yet)
git add "$WORK_FILE"

# Show summary
echo
echo -e "${GREEN}✓ Ready to work on issue #${ISSUE_NUMBER}${NC}"
echo -e "${GREEN}✓ Branch: ${BRANCH_NAME}${NC}"
echo -e "${GREEN}✓ Tracking: origin/${BRANCH_NAME}${NC}"
echo -e "${GREEN}✓ Work log: ${WORK_FILE}${NC}"
echo
echo "Next steps:"
echo "  1. Make your changes"
echo "  2. Use 'commit-work.sh' for atomic commits"
echo "  3. Use 'finish-work.sh' when done to create PR"
echo
echo -e "${BLUE}Remember:${NC}"
echo "  - Make atomic commits (smallest working change)"
echo "  - Reference issue #${ISSUE_NUMBER} in commit messages"
echo "  - Use 'Fixes #${ISSUE_NUMBER}' in the final commit"