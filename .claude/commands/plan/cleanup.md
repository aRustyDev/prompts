---
module: PlanCleanup  
scope: context
triggers: 
  - "/plan clean"
  - "cleanup plan"
  - "remove plan artifacts"
conflicts: []
dependencies:
  - _core.md
priority: high
---

# PlanCleanup - Plan Artifact Cleanup

## Purpose
Remove artifacts created by the plan command, including local files and GitHub resources with proper confirmation and backup.

## Overview
This module provides safe cleanup functionality for both local planning sessions and GitHub artifacts created by the plan command.

## Cleanup Workflow

### Step 1: Detect Cleanup Scope

```bash
echo "🧹 Plan Cleanup Utility"
echo "====================="
echo ""
echo "What would you like to clean?"
echo "1) Local artifacts only (.plan directory)"
echo "2) GitHub artifacts only (issues, milestones, projects)"
echo "3) Everything (local + GitHub artifacts)"
echo "4) List artifacts without removing"
echo ""
read -p "Select option (1-4): " CLEANUP_SCOPE
```

### Step 2: Handle Cleanup Options

Based on user selection:
- **Option 1**: Clean local artifacts only
- **Option 2**: Clean GitHub artifacts only
- **Option 3**: Clean both local and GitHub artifacts
- **Option 4**: List all artifacts without deletion

## Local Artifact Cleanup

```bash
cleanup_local() {
  if [ -d ".plan" ]; then
    echo "📁 Found local plan directory:"
    du -sh .plan 2>/dev/null || echo "Size calculation unavailable"
    
    # List sessions
    if [ -d ".plan/sessions" ]; then
      echo ""
      echo "Sessions found:"
      ls -la .plan/sessions/
    fi
    
    read -p "Remove all local plan artifacts? (y/n): " CONFIRM
    if [ "$CONFIRM" = "y" ]; then
      rm -rf .plan
      echo "✅ Local artifacts removed"
    else
      echo "❌ Cleanup cancelled"
    fi
  else
    echo "ℹ️ No local artifacts found"
  fi
}
```

## GitHub Artifact Discovery

```bash
discover_github_artifacts() {
  echo "🔍 Scanning for GitHub artifacts created by plan command..."
  
  REPO_OWNER=$(gh repo view --json owner -q .owner.login)
  REPO_NAME=$(gh repo view --json name -q .name)
  
  # Check for plan metadata in sessions
  PLAN_SESSIONS=()
  if [ -d ".plan/sessions" ]; then
    for session in .plan/sessions/*/; do
      if [ -f "$session/plan_draft.json" ]; then
        PLAN_SESSIONS+=("$session")
      fi
    done
  fi
  
  # Find projects with naming pattern
  echo ""
  echo "📊 Projects:"
  gh project list --owner "$REPO_OWNER" --format json | \
    jq -r '.projects[] | select(.title | startswith("'$REPO_NAME' - ")) | 
    "  [\(.number)] \(.title) (items: \(.items.totalCount))"'
  
  # Find milestones
  echo ""
  echo "🎯 Milestones:"
  gh api "repos/$REPO_OWNER/$REPO_NAME/milestones" --paginate | \
    jq -r '.[] | "  [\(.number)] \(.title) (open: \(.open_issues), closed: \(.closed_issues))"'
  
  # Find issues with plan labels
  echo ""
  echo "📝 Issues:"
  echo "  With 'plan-generated' label:"
  gh issue list --label "plan-generated" --limit 100 --json number,title | \
    jq -r '.[] | "    #\(.number) \(.title)"'
  
  # Count total artifacts
  PROJECT_COUNT=$(gh project list --owner "$REPO_OWNER" --format json | \
    jq '[.projects[] | select(.title | startswith("'$REPO_NAME' - "))] | length')
  MILESTONE_COUNT=$(gh api "repos/$REPO_OWNER/$REPO_NAME/milestones" --paginate | jq '. | length')
  ISSUE_COUNT=$(gh issue list --label "plan-generated" --limit 1000 --json number | jq '. | length')
  
  echo ""
  echo "📊 Total artifacts found:"
  echo "  Projects: $PROJECT_COUNT"
  echo "  Milestones: $MILESTONE_COUNT"
  echo "  Issues: $ISSUE_COUNT (with 'plan-generated' label)"
  echo "  Sessions: ${#PLAN_SESSIONS[@]}"
}
```

## GitHub Artifact Removal

```bash
cleanup_github() {
  discover_github_artifacts
  
  echo ""
  echo "⚠️  WARNING: This will permanently delete GitHub artifacts!"
  echo "This action cannot be undone."
  echo ""
  
  read -p "Type 'DELETE' to confirm removal of GitHub artifacts: " CONFIRM
  if [ "$CONFIRM" != "DELETE" ]; then
    echo "❌ GitHub cleanup cancelled"
    return
  fi
  
  # Detailed confirmation for each type
  echo ""
  echo "Select what to delete:"
  echo "1) All artifacts"
  echo "2) Projects only"
  echo "3) Milestones only"
  echo "4) Issues only"
  echo "5) Cancel"
  read -p "Selection: " DELETE_SCOPE
  
  case $DELETE_SCOPE in
    1) delete_all_github_artifacts ;;
    2) delete_projects ;;
    3) delete_milestones ;;
    4) delete_issues ;;
    *) echo "❌ Cancelled" ;;
  esac
}
```

## Deletion Functions

### Delete Projects
```bash
delete_projects() {
  echo "🗑️ Deleting projects..."
  gh project list --owner "$REPO_OWNER" --format json | \
    jq -r '.projects[] | select(.title | startswith("'$REPO_NAME' - ")) | .number' | \
    while read -r PROJECT_NUM; do
      echo "  Deleting project #$PROJECT_NUM..."
      gh project delete "$PROJECT_NUM" --owner "$REPO_OWNER" --yes
    done
  echo "✅ Projects deleted"
}
```

### Delete Milestones
```bash
delete_milestones() {
  echo "🗑️ Deleting milestones..."
  gh api "repos/$REPO_OWNER/$REPO_NAME/milestones" --paginate | \
    jq -r '.[] | .number' | \
    while read -r MILESTONE_NUM; do
      echo "  Deleting milestone #$MILESTONE_NUM..."
      gh api -X DELETE "repos/$REPO_OWNER/$REPO_NAME/milestones/$MILESTONE_NUM"
    done
  echo "✅ Milestones deleted"
}
```

### Delete Issues
```bash
delete_issues() {
  echo "🗑️ Closing and labeling issues for deletion..."
  gh issue list --label "plan-generated" --limit 1000 --json number | \
    jq -r '.[].number' | \
    while read -r ISSUE_NUM; do
      echo "  Processing issue #$ISSUE_NUM..."
      # Close issue and add deletion label
      gh issue close "$ISSUE_NUM"
      gh issue edit "$ISSUE_NUM" --add-label "deleted-by-plan-clean"
    done
  echo "✅ Issues closed and labeled"
  echo "ℹ️ Note: Issues are closed but not deleted (GitHub doesn't allow issue deletion)"
}
```

### Delete All
```bash
delete_all_github_artifacts() {
  echo "🗑️ Deleting all GitHub artifacts..."
  create_backup
  delete_projects
  delete_milestones
  delete_issues
  echo "✅ All GitHub artifacts processed"
}
```

## Backup Creation

Always create backups before deletion:

```bash
create_backup() {
  BACKUP_DIR=".plan/backups/$(date +%Y%m%d_%H%M%S)"
  mkdir -p "$BACKUP_DIR"
  
  echo "💾 Creating backup in $BACKUP_DIR..."
  
  # Export projects
  gh project list --owner "$REPO_OWNER" --format json > "$BACKUP_DIR/projects.json"
  
  # Export milestones
  gh api "repos/$REPO_OWNER/$REPO_NAME/milestones" --paginate > "$BACKUP_DIR/milestones.json"
  
  # Export issues
  gh issue list --label "plan-generated" --limit 1000 --json '*' > "$BACKUP_DIR/issues.json"
  
  echo "✅ Backup created"
}
```

## Safety Features

1. **Preview before deletion**: Always show what will be deleted
2. **Explicit confirmation**: Require typing "DELETE" for GitHub artifacts
3. **Automatic backup**: Create backups before any deletion
4. **Selective deletion**: Allow choosing specific artifact types
5. **Non-destructive issues**: Close issues instead of deleting

## Usage Examples

```bash
# Clean everything (interactive)
/plan clean

# List artifacts without removing
/plan clean --list

# Clean local artifacts only
/plan clean --local

# Clean GitHub artifacts only
/plan clean --github

# Force cleanup without confirmation (dangerous!)
/plan clean --force

# Create backup without deleting
/plan clean --backup-only
```

## Integration

This module:
- Works independently of other plan phases
- Uses utilities from `_core.md`
- Integrates with GitHub CLI for artifact management

## Best Practices

1. **Always backup first**: Never skip the backup step
2. **Review before deletion**: Check what will be removed
3. **Use plan-generated label**: Makes cleanup easier
4. **Document sessions**: Keep records of what was created
5. **Periodic cleanup**: Don't let artifacts accumulate