# Plan Command - Cleanup Module
Plan artifact cleanup utilities

## Module Info
- Name: cleanup
- Type: plan-utility
- Parent: commands/plan
- Dependencies: [_core.md]

## Description
Provides utilities for cleaning up planning artifacts, including temporary files, completed plans, and GitHub resources.

## Cleanup Functions

### File Cleanup
```yaml
file_cleanup:
  description: |
    Remove temporary planning files
  targets:
    - plan_artifacts: "*.plan.md, *.plan.tmp"
    - analysis_files: "*-analysis.md"
    - design_drafts: "*-design-draft.md"
    - old_versions: "*.plan.v*.md"
  options:
    - archive: Move to archive instead of delete
    - force: Skip confirmation prompts
    - dry_run: Show what would be deleted
```

### GitHub Cleanup
```yaml
github_cleanup:
  description: |
    Clean up GitHub planning resources
  targets:
    - draft_issues: Issues in draft state
    - empty_projects: Project boards with no cards
    - old_milestones: Completed/cancelled milestones
    - stale_branches: Planning branches
  safety:
    - confirm_each: Require confirmation per item
    - backup_first: Export data before deletion
    - grace_period: Days before considering stale
```

### Archive Management
```yaml
archive_management:
  description: |
    Archive completed plans
  structure:
    - by_date: YYYY/MM/project-name/
    - by_project: project-name/YYYY-MM-DD/
    - by_type: plans/epics/stories/tasks/
  compression:
    - format: tar.gz
    - include_metadata: true
    - preserve_structure: true
```

## Cleanup Commands

### Basic Cleanup
```bash
# Clean plan artifacts
claude plan cleanup
# Removes: *.plan.md, *.plan.tmp, *-analysis.md

# With confirmation
claude plan cleanup --interactive
# Prompts for each file

# Dry run
claude plan cleanup --dry-run
# Shows what would be deleted without deleting
```

### Selective Cleanup
```bash
# Clean specific types
claude plan cleanup --type "analysis"
claude plan cleanup --type "design-drafts"
claude plan cleanup --type "old-versions"

# Clean by age
claude plan cleanup --older-than 30d
claude plan cleanup --older-than 1w

# Clean by pattern
claude plan cleanup --pattern "*-draft.md"
claude plan cleanup --pattern "temp-*"
```

### GitHub Cleanup
```bash
# Clean draft issues
claude plan cleanup github --draft-issues

# Clean completed milestones
claude plan cleanup github --completed-milestones

# Clean stale project boards
claude plan cleanup github --empty-projects

# Full GitHub cleanup
claude plan cleanup github --all --dry-run
```

### Archive Operations
```bash
# Archive current plan
claude plan archive --name "project-v1"

# Archive with compression
claude plan archive --compress --format tar.gz

# Archive to specific location
claude plan archive --output ~/archives/plans/

# List archives
claude plan archive --list

# Restore from archive
claude plan archive --restore "2024-01-15-project-v1"
```

## Cleanup Strategies

### Immediate Cleanup
```yaml
immediate:
  when: "After plan completion"
  what:
    - temporary_files
    - draft_documents
    - working_copies
  keeps:
    - final_plan
    - implementation_issues
    - documentation
```

### Periodic Cleanup
```yaml
periodic:
  schedule: "Weekly"
  targets:
    - files_older_than: 14d
    - orphaned_documents: true
    - duplicate_versions: keep_latest
  notifications:
    - before_cleanup: true
    - summary_after: true
```

### Project Completion Cleanup
```yaml
completion:
  triggers:
    - all_issues_closed
    - milestone_completed
    - manual_trigger
  actions:
    - archive_plans
    - close_project_board
    - generate_summary
    - cleanup_branches
```

## Safety Features

### Confirmation Prompts
```
About to delete 15 planning artifacts:
- 5 analysis files (*-analysis.md)
- 7 draft plans (*-draft.md)
- 3 temporary files (*.tmp)

Total size: 1.2 MB

Continue? [y/N]:
```

### Backup Before Delete
```bash
# Auto-backup before cleanup
claude plan cleanup --backup-first

# Specify backup location
claude plan cleanup --backup-to ~/backups/plans/
```

### Recovery Options
```bash
# List recently deleted
claude plan cleanup --show-deleted

# Recover deleted files
claude plan cleanup --recover "implementation-plan.md"

# Recover from trash
claude plan cleanup --recover-all --from-trash
```

## Cleanup Rules

### Default Exclusions
```yaml
never_delete:
  - README.md
  - .gitignore
  - active_plan.md
  - "**/.git/**"
  
protect_if:
  - modified_within: 24h
  - has_uncommitted_changes: true
  - referenced_by_issue: true
  - tagged_as_permanent: true
```

### Custom Rules
```yaml
custom_rules:
  - name: "Keep sprint plans"
    pattern: "sprint-*.md"
    action: "archive"
    
  - name: "Delete old drafts"
    pattern: "*-draft.md"
    older_than: "7d"
    action: "delete"
    
  - name: "Compress large analyses"
    pattern: "*-analysis.md"
    size_greater_than: "1MB"
    action: "compress"
```

## Integration Scripts

### Cleanup Hook
```bash
#!/bin/bash
# .git/hooks/post-plan

# Auto-cleanup after plan completion
if [ -f ".plan-complete" ]; then
    echo "Plan completed. Running cleanup..."
    claude plan cleanup --type "working-files"
    claude plan archive --name "$(basename $PWD)-$(date +%Y%m%d)"
    rm .plan-complete
fi
```

### Scheduled Cleanup
```bash
#!/bin/bash
# cron: 0 2 * * 0  # Weekly at 2 AM Sunday

# Weekly planning cleanup
claude plan cleanup \
    --older-than 14d \
    --type "all" \
    --backup-first \
    --log-to ~/logs/plan-cleanup.log
```

## Best Practices

### Regular Maintenance
1. Run cleanup after each planning session
2. Archive before major cleanups
3. Review before bulk deletion
4. Keep cleanup logs
5. Test with dry-run first

### Archive Organization
1. Use consistent naming schemes
2. Include metadata in archives
3. Document archive contents
4. Regular archive audits
5. Offsite backup of archives

### Safety First
1. Always confirm destructive operations
2. Maintain backup retention policy
3. Test recovery procedures
4. Log all cleanup operations
5. Protect active work

## Troubleshooting

### Common Issues
```yaml
file_in_use:
  error: "Cannot delete file in use"
  solution: "Close editors and retry"
  
permission_denied:
  error: "Permission denied"
  solution: "Check file ownership"
  
github_rate_limit:
  error: "API rate limit exceeded"
  solution: "Wait or use token with higher limits"
```

### Recovery Procedures
```bash
# If wrong files deleted
claude plan cleanup --recover-from-log cleanup.log

# If archive corrupted
claude plan archive --verify "archive-name"
claude plan archive --repair "archive-name"

# If GitHub resources deleted
gh api repos/:owner/:repo/issues/:number \
  --method PATCH \
  -f state=open
```

## See Also
- [_core.md](_core.md) - Core planning utilities
- [implementation.md](implementation.md) - Implementation phase
- Archive best practices in knowledge base