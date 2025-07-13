---
name: Git Workflow
module_type: process
scope: persistent
priority: critical
triggers: ["git workflow", "branch strategy", "development flow", "issue driven"]
dependencies: 
  - "../issue-tracking/github-issues.md"
  - "commit-standards.md"
  - "../../core/patterns/github-operations/operation-router.md"
  - "../../core/patterns/git-operations/branch-ops.md"
conflicts: []
version: 1.0.0
---

# Git Workflow Process - Issue-Driven Development

## Purpose
Defines the complete development workflow from issue creation to merged pull request, ensuring all work is tracked, atomic, and properly linked to issues.

## Core Principles

1. **Issue-First Development**: Every piece of work starts with an issue
2. **Atomic Commits**: Each commit represents the smallest working change
3. **Clear Traceability**: Every commit links to its originating issue
4. **Definition of Done**: Issues define completion criteria upfront
5. **Clean History**: Meaningful commit messages and logical progression

## Workflow Overview

```
Issue Created ’ Branch Created ’ Work + Commits ’ Final Commit (Fixes) ’ PR Created ’ Review ’ Merge
     “               “                “                    “                “           “        “
  Define DoD    Issue# in name   Atomic changes      Closes issue      Links issues  Validates  Clean
```

## Branch Naming Conventions

### Format
```
<type>/<issue-number>-<brief-description>
```

### Types
- `feat/` - New features
- `fix/` - Bug fixes
- `refactor/` - Code refactoring
- `docs/` - Documentation changes
- `test/` - Test additions/modifications
- `chore/` - Maintenance tasks
- `perf/` - Performance improvements
- `style/` - Code style changes

### Examples
```bash
feat/123-user-authentication
fix/456-login-timeout
refactor/789-payment-service
docs/234-api-documentation
```

### Child Issues
For child issues, include parent reference:
```bash
feat/123-124-oauth-integration  # Child 124 of parent 123
fix/456-457-session-handling    # Child 457 of parent 456
```

## Issue-Driven Development Process

### Step 1: Issue Creation
```bash
# Every work item starts with an issue
# Issue must include:
# - Clear description of the problem/feature
# - Acceptance criteria (Definition of Done)
# - Labels for categorization
# - Milestone if applicable

# Example issue body:
"""
## Description
Implement user authentication system with email/password login

## Acceptance Criteria
- [ ] User can register with email/password
- [ ] User can login with credentials
- [ ] Session persists across browser refresh
- [ ] Failed login shows appropriate error
- [ ] Password is securely hashed
- [ ] Tests cover all auth flows
- [ ] API documentation updated

## Technical Notes
- Use bcrypt for password hashing
- JWT for session management
- Rate limit login attempts
"""
```

### Step 2: Start Work on Issue
```bash
# 1. Ensure you have the issue number
ISSUE_NUMBER=123
ISSUE_TITLE="user-authentication"

# 2. Update main branch
git checkout main
git pull origin main

# 3. Create feature branch
git checkout -b feat/${ISSUE_NUMBER}-${ISSUE_TITLE}

# 4. Push branch to track remotely
git push -u origin feat/${ISSUE_NUMBER}-${ISSUE_TITLE}
```

### Step 3: Development with Atomic Commits

#### What is an Atomic Commit?
- One logical change
- Code still compiles/runs
- Tests still pass (or are updated)
- Can be understood in isolation

#### Commit Process
```bash
# 1. Make a small, focused change
# Edit files...

# 2. Stage only related changes
git add -p  # Interactively stage chunks
# or
git add specific_file.js

# 3. Commit with descriptive message
git commit -m "feat(auth): add password hashing utility

Implements bcrypt-based password hashing with configurable
salt rounds. Will be used for user registration.

Related to #123"
```

#### Commit Message Format
```
<type>(<scope>): <description>

[optional body]

Related to #<issue-number>
[Co-authored-by: Name <email>]
```

### Step 4: Final Commit to Close Issue
```bash
# The last commit that completes the issue MUST include "Fixes"
git commit -m "feat(auth): complete login flow implementation

Adds final login form validation and error handling.
All acceptance criteria now met.

Fixes #123"
```

### Step 5: Create Pull Request

#### Pre-PR Checklist
```bash
# 1. Ensure all commits reference the issue
git log --oneline | grep "#123"

# 2. Verify tests pass
npm test  # or appropriate test command

# 3. Update from main
git checkout main
git pull origin main
git checkout feat/123-user-authentication
git rebase main  # or merge if preferred

# 4. Push final changes
git push origin feat/123-user-authentication
```

#### PR Creation
```bash
# Using GitHub CLI
gh pr create \
  --title "feat: Add user authentication system" \
  --body "## Summary
Implements complete user authentication system with email/password login.

## Changes
- User registration endpoint
- Login/logout functionality  
- Session management with JWT
- Password hashing with bcrypt
- Rate limiting on login attempts

## Testing
- Unit tests for auth service
- Integration tests for auth flow
- Manual testing checklist completed

Fixes #123
Related to #120 (parent epic)

## Checklist
- [x] Tests pass
- [x] Documentation updated
- [x] No console.logs or debug code
- [x] Follows code style guidelines" \
  --base main
```

## Workflow for Different Scenarios

### Working on Multiple Issues
```bash
# If your PR addresses multiple issues
git commit -m "feat(auth): add OAuth provider support

Implements Google and GitHub OAuth strategies.

Fixes #124
Fixes #125
Related to #123"
```

### Child Issues Under Parent
```bash
# Branch naming shows relationship
git checkout -b feat/123-124-oauth-google

# Commits reference both
git commit -m "feat(auth): add Google OAuth provider

Implements Google OAuth2 strategy for social login.

Related to #124 (child of #123)"

# Final commit closes child
git commit -m "feat(auth): complete Google OAuth integration

Adds callback handling and user profile mapping.

Fixes #124
Related to #123"
```

### Hotfixes
```bash
# Hotfixes branch from main/production
git checkout main
git pull origin main
git checkout -b fix/456-critical-auth-bypass

# Single commit often sufficient
git commit -m "fix(auth): prevent authentication bypass

Adds missing session validation in middleware.

Fixes #456"

# Fast-track PR
gh pr create --title "HOTFIX: Authentication bypass" --body "Fixes #456"
```

## Best Practices

### DO
-  Create issue before starting work
-  Include issue number in branch name
-  Reference issue in every commit
-  Make atomic commits
-  Use "Fixes #X" in final commit
-  Keep commits focused and small
-  Write clear commit messages
-  Update from main before PR

### DON'T
- L Work without an issue
- L Create branches without issue numbers
- L Make large, unfocused commits
- L Forget to link issues in PR
- L Mix unrelated changes
- L Commit broken code
- L Skip testing before PR

## Commit Size Guidelines

### Atomic Commit Examples

####  Good - Atomic Commits
```bash
# Commit 1: Add data model
git commit -m "feat(users): add User model schema

Related to #123"

# Commit 2: Add service layer
git commit -m "feat(users): add UserService with CRUD operations

Related to #123"

# Commit 3: Add API endpoints
git commit -m "feat(users): add REST endpoints for user management

Related to #123"

# Commit 4: Add tests
git commit -m "test(users): add unit tests for UserService

Related to #123"

# Commit 5: Complete feature
git commit -m "feat(users): add input validation and error handling

Completes user management feature with all acceptance criteria.

Fixes #123"
```

#### L Bad - Non-Atomic Commits
```bash
# Everything in one commit
git commit -m "Add user management

Fixes #123"
# This includes model, service, API, tests, etc. - too large!
```

## Integration with GitHub

### Issue Templates
Issues should use templates that include:
- Problem description
- Acceptance criteria checklist
- Technical considerations
- Related issues/dependencies

### PR Templates
PRs should include:
- Summary of changes
- Issue references (Fixes/Related to)
- Testing performed
- Checklist for code quality

### Labels
Use labels to categorize and track:
- `type:*` - Type of work
- `priority:*` - Urgency level
- `status:*` - Current state
- `size:*` - Estimated effort

## Automation Helpers

### Check Commit Atomicity
```bash
# Show files changed in last commit
git show --name-only --pretty=""

# If more than 5-7 files, consider splitting
```

### Verify Issue References
```bash
# Check all commits reference issues
git log --grep="#[0-9]\+" --oneline

# Find commits missing issue references
git log --invert-grep --grep="#[0-9]\+" --oneline
```

### Pre-PR Validation
```bash
# Ensure branch is up to date
git fetch origin
git log HEAD..origin/main --oneline

# Check for fixup commits to squash
git log --oneline | grep -i "fixup\|squash"
```

## Troubleshooting

### Forgot to Reference Issue
```bash
# Amend last commit
git commit --amend -m "Original message

Related to #123"
```

### Need to Split Large Commit
```bash
# Interactive rebase
git rebase -i HEAD~1
# Mark commit as 'edit'
git reset HEAD^
# Now stage and commit atomically
```

### Wrong Branch Name
```bash
# Rename local branch
git branch -m old-name feat/123-correct-name

# Update remote
git push origin --delete old-name
git push -u origin feat/123-correct-name
```

---
*This workflow ensures every change is tracked, atomic, and traceable from issue to deployment.*