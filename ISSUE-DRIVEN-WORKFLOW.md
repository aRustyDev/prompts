# Issue-Driven Development Workflow

## Overview

This repository now implements a comprehensive issue-driven development workflow where:
- **Every piece of work starts with an issue**
- **Issues define scope and completion criteria**
- **All commits are atomic and reference their issue**
- **PRs automatically close issues when merged**

## Quick Start

### 1. Start Working on an Issue
```bash
# Start work on issue #123
./scripts/workflow/start-work.sh 123

# This creates branch: feat/123-description
# And sets up tracking
```

### 2. Make Atomic Commits
```bash
# Stage and commit changes atomically
./scripts/workflow/commit-work.sh -m "Add user model" -t feat

# Final commit that closes the issue
./scripts/workflow/commit-work.sh -m "Complete user authentication" --fixes
```

### 3. Create Pull Request
```bash
# Create PR with all the right links
./scripts/workflow/finish-work.sh
```

## Workflow Components

### 1. **Git Workflow Documentation**
- Location: `.claude/processes/version-control/git-workflow.md`
- Defines complete process from issue to merge
- Branch naming conventions
- Commit requirements
- PR guidelines

### 2. **Automation Scripts**

#### `start-work.sh`
- Creates branch from issue
- Names branch with issue number
- Sets up remote tracking
- Creates work log

#### `commit-work.sh`
- Validates atomic commits
- Ensures issue references
- Checks commit size
- Interactive staging support

#### `finish-work.sh`
- Verifies all commits reference issue
- Checks for "Fixes #N"
- Creates comprehensive PR
- Links all related issues

### 3. **Updated Processes**

#### Commit Standards
- Now requires issue references in all commits
- Atomic commit guidelines
- "Related to #N" for WIP
- "Fixes #N" for completion

#### PR Review Process
- Validates issue completion
- Checks acceptance criteria
- Ensures proper linking
- Quality gates

### 4. **GitHub Templates**

#### Issue Templates
- Feature requests
- Bug reports
- Tasks
- All include acceptance criteria and DoD

#### PR Template
- Links issues
- Verification checklists
- Testing confirmation
- Auto-close validation

## Branch Naming Conventions

### Format
```
<type>/<issue-number>-<brief-description>
```

### Types
- `feat/` - New features
- `fix/` - Bug fixes
- `refactor/` - Code refactoring
- `docs/` - Documentation
- `test/` - Testing
- `chore/` - Maintenance
- `perf/` - Performance
- `style/` - Code style

### Examples
```
feat/123-user-authentication
fix/456-login-timeout
refactor/789-payment-service
```

## Commit Requirements

### Every Commit Must:
1. Reference the issue number
2. Be atomic (one logical change)
3. Leave code in working state
4. Follow conventional format

### Commit Message Format
```
<type>(<scope>): <description>

[body]

Related to #<issue>  // For WIP commits
Fixes #<issue>       // For final commit
```

## Complete Example

### 1. Create Issue
```bash
gh issue create --title "Add password reset" --body "..."
# Creates issue #124
```

### 2. Start Work
```bash
./scripts/workflow/start-work.sh 124
# Creates branch: feat/124-add-password-reset
```

### 3. Development
```bash
# First commit
vim src/auth/reset.js
./scripts/workflow/commit-work.sh -m "Add password reset token generation" -t feat

# Second commit  
vim src/api/auth.js
./scripts/workflow/commit-work.sh -m "Add reset endpoint" -t feat -s api

# Final commit
vim tests/reset.test.js
./scripts/workflow/commit-work.sh -m "Complete password reset flow" -t feat --fixes
```

### 4. Create PR
```bash
./scripts/workflow/finish-work.sh
# Creates PR that will close #124 when merged
```

## Benefits

1. **Complete Traceability**: Every change linked to requirements
2. **Automated Workflows**: Scripts reduce manual work
3. **Quality Enforcement**: Multiple validation points
4. **Clear History**: Atomic commits tell the story
5. **Automatic Closure**: Issues close on merge

## Configuration

### Default Settings
Located in `.claude/core/defaults.md`:
- Branch prefixes
- Commit style
- Issue tracking settings

### Module Loading
The workflow loads automatically when you:
- Use terms like "start work", "implement", "develop"
- Work with issues or PRs
- Use the workflow scripts

## Integration

### With GitHub Operations
- Uses MCP server when available
- Falls back to gh CLI
- Consistent interface

### With Existing Tools
- Works with your editor
- Compatible with git GUIs
- Enhances, doesn't replace

## Troubleshooting

### Forgot Issue Reference?
```bash
git commit --amend -m "Original message

Related to #123"
```

### Need to Split Commit?
```bash
git reset HEAD~1
# Now stage and commit atomically
```

### Wrong Branch Name?
```bash
git branch -m old-name feat/123-new-name
```

## Best Practices

### DO
- ✅ Create issue before starting
- ✅ Use descriptive branch names
- ✅ Make atomic commits
- ✅ Reference issue in every commit
- ✅ Use "Fixes #N" to close issues
- ✅ Keep PRs focused

### DON'T
- ❌ Work without an issue
- ❌ Make large commits
- ❌ Forget issue references
- ❌ Mix unrelated changes
- ❌ Skip the workflow

---

This workflow ensures every change is purposeful, tracked, and properly implemented from conception to deployment.