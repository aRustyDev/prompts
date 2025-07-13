#!/bin/bash

# commit-work.sh - Helper for creating atomic commits with issue references
# Ensures commits are atomic and properly linked to issues

set -euo pipefail

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

Create an atomic commit with proper issue reference.

Options:
    -m, --message   Commit message (required)
    -t, --type      Commit type (feat|fix|docs|style|refactor|perf|test|chore)
    -s, --scope     Commit scope (optional)
    -i, --issue     Issue number (will be auto-detected if not provided)
    -f, --fixes     Mark this as the final commit that fixes the issue
    -a, --all       Stage all changes (git add -A)
    -p, --patch     Interactive staging (git add -p)
    -d, --dry-run   Show what would be committed without committing
    -h, --help      Show this help message

Examples:
    $0 -m "Add user authentication" -t feat -s auth
    $0 -m "Fix login timeout" -t fix --fixes
    $0 -m "Update README" -t docs -a

The script will:
1. Check for atomic commit (reasonable size)
2. Ensure proper commit message format
3. Add issue reference if missing
4. Update work log

EOF
    exit 1
}

# Initialize variables
COMMIT_MESSAGE=""
COMMIT_TYPE=""
COMMIT_SCOPE=""
ISSUE_NUMBER=""
IS_FIXES=false
STAGE_ALL=false
STAGE_PATCH=false
DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -m|--message)
            COMMIT_MESSAGE="$2"
            shift 2
            ;;
        -t|--type)
            COMMIT_TYPE="$2"
            shift 2
            ;;
        -s|--scope)
            COMMIT_SCOPE="$2"
            shift 2
            ;;
        -i|--issue)
            ISSUE_NUMBER="$2"
            shift 2
            ;;
        -f|--fixes)
            IS_FIXES=true
            shift
            ;;
        -a|--all)
            STAGE_ALL=true
            shift
            ;;
        -p|--patch)
            STAGE_PATCH=true
            shift
            ;;
        -d|--dry-run)
            DRY_RUN=true
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

# Validate required arguments
if [[ -z "$COMMIT_MESSAGE" ]]; then
    echo -e "${RED}Error: Commit message is required${NC}"
    usage
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)

# Try to extract issue number from branch name if not provided
if [[ -z "$ISSUE_NUMBER" ]]; then
    if [[ "$CURRENT_BRANCH" =~ ^[a-z]+/([0-9]+)- ]]; then
        ISSUE_NUMBER="${BASH_REMATCH[1]}"
        echo -e "${BLUE}Detected issue #${ISSUE_NUMBER} from branch name${NC}"
    elif [[ "$CURRENT_BRANCH" =~ ^[a-z]+/[0-9]+-([0-9]+)- ]]; then
        # Child issue format: type/parent-child-description
        ISSUE_NUMBER="${BASH_REMATCH[1]}"
        echo -e "${BLUE}Detected child issue #${ISSUE_NUMBER} from branch name${NC}"
    else
        echo -e "${YELLOW}Warning: Could not detect issue number from branch name${NC}"
        echo "Branch: $CURRENT_BRANCH"
        read -p "Enter issue number (or press Enter to skip): " ISSUE_NUMBER
    fi
fi

# Auto-detect commit type from branch if not provided
if [[ -z "$COMMIT_TYPE" ]]; then
    if [[ "$CURRENT_BRANCH" =~ ^([a-z]+)/ ]]; then
        BRANCH_PREFIX="${BASH_REMATCH[1]}"
        case "$BRANCH_PREFIX" in
            feat) COMMIT_TYPE="feat" ;;
            fix) COMMIT_TYPE="fix" ;;
            docs) COMMIT_TYPE="docs" ;;
            refactor) COMMIT_TYPE="refactor" ;;
            test) COMMIT_TYPE="test" ;;
            chore) COMMIT_TYPE="chore" ;;
            perf) COMMIT_TYPE="perf" ;;
            style) COMMIT_TYPE="style" ;;
            *) COMMIT_TYPE="feat" ;;  # Default
        esac
        echo -e "${BLUE}Using commit type '${COMMIT_TYPE}' based on branch prefix${NC}"
    else
        COMMIT_TYPE="feat"  # Default
    fi
fi

# Check staging area
if [[ "$STAGE_ALL" == true ]]; then
    echo -e "${BLUE}Staging all changes...${NC}"
    git add -A
elif [[ "$STAGE_PATCH" == true ]]; then
    echo -e "${BLUE}Interactive staging...${NC}"
    git add -p
fi

# Check if there are staged changes
if ! git diff --cached --quiet; then
    STAGED_FILES=$(git diff --cached --name-only | wc -l | xargs)
    STAGED_STATS=$(git diff --cached --shortstat)
    echo -e "${GREEN}Staged changes: ${STAGED_FILES} files${NC}"
    echo -e "${CYAN}${STAGED_STATS}${NC}"
else
    echo -e "${RED}Error: No staged changes${NC}"
    echo "Use -a to stage all changes or -p for interactive staging"
    exit 1
fi

# Check for atomic commit (warn if too large)
CHANGED_FILES=$(git diff --cached --name-only | wc -l | xargs)
INSERTIONS=$(git diff --cached --numstat | awk '{sum+=$1} END {print sum}')
DELETIONS=$(git diff --cached --numstat | awk '{sum+=$2} END {print sum}')
TOTAL_CHANGES=$((INSERTIONS + DELETIONS))

echo
echo -e "${BLUE}Commit size analysis:${NC}"
echo "  Files changed: $CHANGED_FILES"
echo "  Lines added: $INSERTIONS"
echo "  Lines removed: $DELETIONS"
echo "  Total changes: $TOTAL_CHANGES"

# Warn if commit seems too large
if [[ $CHANGED_FILES -gt 10 ]] || [[ $TOTAL_CHANGES -gt 200 ]]; then
    echo
    echo -e "${YELLOW}Warning: This commit might not be atomic${NC}"
    echo "Consider splitting into smaller commits if it contains multiple logical changes."
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Commit cancelled. Consider using 'git reset' to unstage and split changes."
        exit 0
    fi
fi

# Build commit message
if [[ -n "$COMMIT_SCOPE" ]]; then
    FULL_MESSAGE="${COMMIT_TYPE}(${COMMIT_SCOPE}): ${COMMIT_MESSAGE}"
else
    FULL_MESSAGE="${COMMIT_TYPE}: ${COMMIT_MESSAGE}"
fi

# Add issue reference
if [[ -n "$ISSUE_NUMBER" ]]; then
    if [[ "$IS_FIXES" == true ]]; then
        FULL_MESSAGE="${FULL_MESSAGE}

Fixes #${ISSUE_NUMBER}"
    else
        FULL_MESSAGE="${FULL_MESSAGE}

Related to #${ISSUE_NUMBER}"
    fi
fi

# Show what will be committed
echo
echo -e "${BLUE}Commit message:${NC}"
echo "----------------------------------------"
echo "$FULL_MESSAGE"
echo "----------------------------------------"

# Show diff if not too large
if [[ $TOTAL_CHANGES -lt 100 ]]; then
    echo
    echo -e "${BLUE}Changes to be committed:${NC}"
    git diff --cached --color
fi

# Dry run mode
if [[ "$DRY_RUN" == true ]]; then
    echo
    echo -e "${YELLOW}Dry run mode - no commit created${NC}"
    exit 0
fi

# Confirm commit
echo
read -p "Create commit? (Y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo "Commit cancelled"
    exit 0
fi

# Create commit
echo -e "${BLUE}Creating commit...${NC}"
git commit -m "$FULL_MESSAGE"

# Update work log if it exists
WORK_FILE=".claude/work/issue-${ISSUE_NUMBER}.md"
if [[ -f "$WORK_FILE" ]]; then
    COMMIT_HASH=$(git rev-parse --short HEAD)
    COMMIT_DATE=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
    
    # Add commit to work log
    sed -i.bak '/## Commits/a\
- '"$COMMIT_DATE"': '"$COMMIT_HASH"' - '"$FULL_MESSAGE" "$WORK_FILE"
    rm "${WORK_FILE}.bak"
    
    echo -e "${GREEN}✓ Updated work log${NC}"
fi

# Show success
echo
echo -e "${GREEN}✓ Commit created successfully!${NC}"
echo -e "Commit: $(git rev-parse --short HEAD)"

# Check if this was the final commit
if [[ "$IS_FIXES" == true ]]; then
    echo
    echo -e "${GREEN}This commit fixes issue #${ISSUE_NUMBER}${NC}"
    echo "When you push and create a PR, the issue will be automatically closed."
    echo
    echo "Next step: Use 'finish-work.sh' to create the pull request"
else
    REMAINING_CHANGES=$(git status --porcelain | wc -l | xargs)
    if [[ $REMAINING_CHANGES -gt 0 ]]; then
        echo
        echo -e "${YELLOW}You still have uncommitted changes${NC}"
        echo "Continue making atomic commits until the feature is complete."
        echo "Use --fixes flag on the final commit to close the issue."
    fi
fi