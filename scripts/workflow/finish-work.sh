#!/bin/bash

# finish-work.sh - Complete work on an issue and create a pull request
# Ensures all commits reference the issue and creates a comprehensive PR

set -euo pipefail

# Source GitHub operations
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../.claude/core/patterns/github-operations/operation-router.md"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Usage function
usage() {
    cat << EOF
Usage: $0 [options]

Complete work on an issue by creating a pull request.

Options:
    -t, --title     PR title (defaults to generated from commits)
    -b, --body      PR body (defaults to generated from commits and issue)
    -d, --draft     Create as draft PR
    -B, --base      Base branch (defaults to main/master)
    -m, --milestone Add to milestone
    -l, --labels    Comma-separated labels to add
    -r, --reviewers Comma-separated reviewers to request
    -n, --no-push   Don't push before creating PR
    -h, --help      Show this help message

The script will:
1. Verify all commits reference the issue
2. Check for "Fixes #N" in at least one commit
3. Push latest changes
4. Create a comprehensive PR
5. Link related issues

EOF
    exit 1
}

# Initialize variables
PR_TITLE=""
PR_BODY=""
IS_DRAFT=false
BASE_BRANCH=""
MILESTONE=""
LABELS=""
REVIEWERS=""
NO_PUSH=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--title)
            PR_TITLE="$2"
            shift 2
            ;;
        -b|--body)
            PR_BODY="$2"
            shift 2
            ;;
        -d|--draft)
            IS_DRAFT=true
            shift
            ;;
        -B|--base)
            BASE_BRANCH="$2"
            shift 2
            ;;
        -m|--milestone)
            MILESTONE="$2"
            shift 2
            ;;
        -l|--labels)
            LABELS="$2"
            shift 2
            ;;
        -r|--reviewers)
            REVIEWERS="$2"
            shift 2
            ;;
        -n|--no-push)
            NO_PUSH=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo -e "${RED}Error: Unknown argument: $1${NC}"
            usage
            ;;
    esac
done

# Initialize GitHub router
echo -e "${BLUE}Initializing GitHub connection...${NC}"
init_github_router

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)

# Extract issue number from branch
if [[ "$CURRENT_BRANCH" =~ ^[a-z]+/([0-9]+)- ]]; then
    ISSUE_NUMBER="${BASH_REMATCH[1]}"
    PARENT_ISSUE=""
elif [[ "$CURRENT_BRANCH" =~ ^[a-z]+/([0-9]+)-([0-9]+)- ]]; then
    # Child issue format: type/parent-child-description
    PARENT_ISSUE="${BASH_REMATCH[1]}"
    ISSUE_NUMBER="${BASH_REMATCH[2]}"
else
    echo -e "${RED}Error: Could not extract issue number from branch name${NC}"
    echo "Current branch: $CURRENT_BRANCH"
    echo "Expected format: <type>/<issue>-<description> or <type>/<parent>-<child>-<description>"
    exit 1
fi

echo -e "${GREEN}Working on issue #${ISSUE_NUMBER}${NC}"
[[ -n "$PARENT_ISSUE" ]] && echo -e "${GREEN}Parent issue: #${PARENT_ISSUE}${NC}"

# Get default branch if not specified
if [[ -z "$BASE_BRANCH" ]]; then
    BASE_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    echo -e "${YELLOW}Warning: You have uncommitted changes${NC}"
    git status --short
    echo
    read -p "Continue without committing? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Please commit or stash your changes first"
        exit 1
    fi
fi

# Get commit information
echo -e "${BLUE}Analyzing commits...${NC}"

# Get all commits on this branch
COMMITS=$(git log "$BASE_BRANCH".."$CURRENT_BRANCH" --pretty=format:"%h %s" --reverse)
COMMIT_COUNT=$(echo "$COMMITS" | wc -l | xargs)

if [[ $COMMIT_COUNT -eq 0 ]]; then
    echo -e "${RED}Error: No commits found on this branch${NC}"
    exit 1
fi

echo -e "${GREEN}Found $COMMIT_COUNT commits${NC}"

# Check that all commits reference the issue
COMMITS_WITHOUT_ISSUE=$(git log "$BASE_BRANCH".."$CURRENT_BRANCH" --pretty=format:"%h %s" --invert-grep --grep="#${ISSUE_NUMBER}")
if [[ -n "$COMMITS_WITHOUT_ISSUE" ]]; then
    echo -e "${YELLOW}Warning: Some commits don't reference issue #${ISSUE_NUMBER}:${NC}"
    echo "$COMMITS_WITHOUT_ISSUE"
    echo
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Please amend commits to include issue reference"
        exit 1
    fi
fi

# Check for "Fixes #N" in commits
HAS_FIXES=$(git log "$BASE_BRANCH".."$CURRENT_BRANCH" --grep="Fixes #${ISSUE_NUMBER}" --pretty=format:"%h")
if [[ -z "$HAS_FIXES" ]]; then
    echo -e "${YELLOW}Warning: No commit contains 'Fixes #${ISSUE_NUMBER}'${NC}"
    echo "The issue won't be automatically closed when the PR is merged."
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Use 'commit-work.sh --fixes' for your final commit"
        exit 1
    fi
fi

# Push changes if needed
if [[ "$NO_PUSH" == false ]]; then
    echo -e "${BLUE}Pushing latest changes...${NC}"
    git push origin "$CURRENT_BRANCH"
fi

# Generate PR title if not provided
if [[ -z "$PR_TITLE" ]]; then
    # Get the most significant commit
    FIRST_COMMIT=$(git log "$BASE_BRANCH".."$CURRENT_BRANCH" --pretty=format:"%s" --reverse | head -1)
    PR_TITLE="$FIRST_COMMIT"
    
    # Clean up the title (remove issue references)
    PR_TITLE=$(echo "$PR_TITLE" | sed 's/Related to #[0-9]*//g' | sed 's/Fixes #[0-9]*//g' | xargs)
fi

# Generate PR body if not provided
if [[ -z "$PR_BODY" ]]; then
    echo -e "${BLUE}Generating PR description...${NC}"
    
    # Get issue details
    ISSUE_JSON=$(gh issue view "$ISSUE_NUMBER" --json title,body,labels)
    ISSUE_TITLE=$(echo "$ISSUE_JSON" | jq -r '.title')
    ISSUE_BODY=$(echo "$ISSUE_JSON" | jq -r '.body // ""')
    
    # Extract acceptance criteria from issue body if present
    ACCEPTANCE_CRITERIA=$(echo "$ISSUE_BODY" | sed -n '/## Acceptance Criteria/,/^##/p' | sed '1d;$d' | grep -E "^- \[.\]" || true)
    
    # Build PR body
    PR_BODY="## Summary
This PR implements #${ISSUE_NUMBER} - ${ISSUE_TITLE}

## Changes"
    
    # Add commit summary
    while IFS= read -r commit; do
        COMMIT_MSG=$(echo "$commit" | cut -d' ' -f2-)
        # Skip if it's just issue reference
        if [[ ! "$COMMIT_MSG" =~ ^(Related to|Fixes) ]]; then
            PR_BODY="$PR_BODY
- $COMMIT_MSG"
        fi
    done <<< "$COMMITS"
    
    # Add acceptance criteria if found
    if [[ -n "$ACCEPTANCE_CRITERIA" ]]; then
        PR_BODY="$PR_BODY

## Acceptance Criteria
$ACCEPTANCE_CRITERIA"
    fi
    
    # Add testing section
    PR_BODY="$PR_BODY

## Testing
- [ ] All tests pass
- [ ] Manual testing completed
- [ ] No regressions identified"
    
    # Add issue references
    if [[ -n "$HAS_FIXES" ]]; then
        PR_BODY="$PR_BODY

Fixes #${ISSUE_NUMBER}"
    else
        PR_BODY="$PR_BODY

Related to #${ISSUE_NUMBER}"
    fi
    
    if [[ -n "$PARENT_ISSUE" ]]; then
        PR_BODY="$PR_BODY
Related to #${PARENT_ISSUE} (parent epic)"
    fi
    
    # Add checklist
    PR_BODY="$PR_BODY

## Checklist
- [x] Code follows project style guidelines
- [x] Self-review completed
- [x] Tests added/updated as needed
- [x] Documentation updated as needed
- [ ] Ready for review"
fi

# Show PR preview
echo
echo -e "${BLUE}Pull Request Preview:${NC}"
echo "----------------------------------------"
echo -e "${CYAN}Title:${NC} $PR_TITLE"
echo -e "${CYAN}Base:${NC} $BASE_BRANCH ← $CURRENT_BRANCH"
[[ "$IS_DRAFT" == true ]] && echo -e "${CYAN}Status:${NC} Draft"
[[ -n "$LABELS" ]] && echo -e "${CYAN}Labels:${NC} $LABELS"
[[ -n "$MILESTONE" ]] && echo -e "${CYAN}Milestone:${NC} $MILESTONE"
[[ -n "$REVIEWERS" ]] && echo -e "${CYAN}Reviewers:${NC} $REVIEWERS"
echo "----------------------------------------"
echo "$PR_BODY"
echo "----------------------------------------"

# Confirm PR creation
echo
read -p "Create pull request? (Y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo "PR creation cancelled"
    exit 0
fi

# Build PR command
PR_CMD="gh pr create"
PR_CMD="$PR_CMD --title \"$PR_TITLE\""
PR_CMD="$PR_CMD --body \"$PR_BODY\""
PR_CMD="$PR_CMD --base \"$BASE_BRANCH\""
[[ "$IS_DRAFT" == true ]] && PR_CMD="$PR_CMD --draft"
[[ -n "$LABELS" ]] && PR_CMD="$PR_CMD --label \"$LABELS\""
[[ -n "$MILESTONE" ]] && PR_CMD="$PR_CMD --milestone \"$MILESTONE\""
[[ -n "$REVIEWERS" ]] && PR_CMD="$PR_CMD --reviewer \"$REVIEWERS\""

# Create PR
echo -e "${BLUE}Creating pull request...${NC}"
PR_URL=$(eval "$PR_CMD")

if [[ $? -eq 0 ]]; then
    echo
    echo -e "${GREEN}✓ Pull request created successfully!${NC}"
    echo -e "${GREEN}$PR_URL${NC}"
    
    # Update work log
    WORK_FILE=".claude/work/issue-${ISSUE_NUMBER}.md"
    if [[ -f "$WORK_FILE" ]]; then
        echo "
## Pull Request
- $(date -u +"%Y-%m-%d %H:%M:%S UTC"): Created PR - $PR_URL" >> "$WORK_FILE"
        
        # Commit work log update
        git add "$WORK_FILE"
        git commit -m "docs: update work log with PR link

Related to #${ISSUE_NUMBER}" || true
        git push origin "$CURRENT_BRANCH" || true
    fi
    
    echo
    echo "Next steps:"
    echo "  1. Wait for CI checks to pass"
    echo "  2. Request reviews if needed"
    echo "  3. Address any feedback"
    echo "  4. Merge when approved"
    
    if [[ -n "$HAS_FIXES" ]]; then
        echo
        echo -e "${GREEN}Issue #${ISSUE_NUMBER} will be automatically closed when this PR is merged.${NC}"
    fi
else
    echo -e "${RED}Failed to create pull request${NC}"
    exit 1
fi