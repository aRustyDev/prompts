---
name: Commit Standards
module_type: process
scope: persistent
priority: high
triggers: ["commit", "git commit", "commit message", "conventional commits"]
dependencies: ["core/defaults.md", "processes/security/data-sanitization.md"]
conflicts: []
version: 1.0.0
---

# Commit Standards Process

## Purpose
Ensure all commits follow conventional standards, include proper issue references, handle pre-commit hooks gracefully, and maintain a clean, traceable git history.

## Trigger
Execute whenever code changes need to be committed to version control.

## Commit Message Format

### Structure
```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Type (Required)
Must be one of:
- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that do not affect code meaning (formatting, missing semicolons, etc)
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **perf**: Code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **build**: Changes affecting build system or external dependencies
- **ci**: Changes to CI configuration files and scripts
- **chore**: Other changes that don't modify src or test files
- **revert**: Reverts a previous commit

### Scope (Optional)
Component or area affected: auth, api, ui, core, etc.

### Description (Required)
- Use imperative mood: "add" not "added" or "adds"
- Don't capitalize first letter
- No period at the end
- Maximum 72 characters

### Issue Reference (Required)
- Every commit MUST reference its originating issue
- Use "Related to #<issue-number>" for work-in-progress commits
- Use "Fixes #<issue-number>" for the final commit that completes the issue
- For child issues, reference both: "Related to #124 (child of #123)"

## Process Steps

### 1. Stage Changes
```bash
# Review what will be committed
${version_control} diff

# Stage atomic changes
${version_control} add ${files}

# Verify staged changes
${version_control} status
```

**Ensure**:
- Changes are atomic (one logical change)
- Related files committed together
- Unrelated changes separated

### 2. Determine Commit Type
Analyze changes to select appropriate type:
- New functionality → feat
- Bug correction → fix
- Code improvement without behavior change → refactor
- Test additions/updates → test

Check if this:
- Closes an issue → Add "Fixes #X" (required for final commit)
- Relates to issue → Add "Related to #X" (required for all other commits)
- Breaking change → Add "BREAKING CHANGE:" footer
- Child of another issue → Add both references

### 3. Write Commit Message

#### Header Line
Format: `<type>(<scope>): <description>`

Example: `feat(auth): add password reset functionality`

#### Body (if needed)
- Blank line after header
- Explain what and why (not how)
- Wrap at 72 characters
- Use bullet points for multiple items

#### Footer
- Issue references: `Fixes #123`
- Breaking changes: `BREAKING CHANGE: explanation`
- Co-authors: `Co-authored-by: Name <email>`

### 4. Execute Commit

#### Pre-commit Preparation
```bash
# If message contains sensitive data
Execute: Process: DataSanitization
Input: Commit message content
```

#### Run Commit
```bash
${version_control} commit
```

#### If Pre-commit Hooks Fail

1. **Capture Failure**
   - Record full error output
   - Identify failure type (lint, test, format)

2. **Create Tracking Issue**
   ```
   Title: "Pre-commit: ${failure_type} in ${context}"
   Labels: ['pre-commit', 'tooling']
   Body: 
   - Error message (sanitized)
   - Files affected
   - Attempted solutions
   ```

3. **Fix Issues**
   - Apply suggested fixes
   - Re-run failed checks locally
   - Document solution in issue

4. **Check for Pattern**
   If similar failure occurred before:
   - Execute: Process: RecurringProblemIdentification
   - Consider creating custom hook

5. **Retry Commit**
   - Stage fixes
   - Attempt commit again

### 5. Push Changes
```bash
${version_control} push
```

If push fails:
- Execute: Process: PushFailureResolution
- Document resolution
- Retry until successful

### 6. Verify Success
- Check remote repository
- Ensure CI/CD triggered
- Monitor pipeline status

## Atomic Commit Guidelines

### What is an Atomic Commit?
- **One logical change**: Each commit should represent a single, coherent change
- **Self-contained**: The codebase should work after each commit
- **Understandable**: Can be reviewed and understood in isolation
- **Revertable**: Can be reverted without affecting unrelated functionality

### Atomic Commit Size Guidelines
- **Ideal**: 1-5 files, < 100 lines changed
- **Acceptable**: 5-10 files, 100-200 lines changed
- **Too large**: > 10 files or > 200 lines (consider splitting)

### Examples of Atomic Commits
1. Add a new function with its tests
2. Fix a specific bug
3. Refactor a single component
4. Update documentation for a feature
5. Add a new dependency and its configuration

## Message Examples

### Work-in-Progress Commits
```
feat(api): add user search data model

Related to #234
```

```
feat(api): implement search service layer

Adds UserSearchService with full-text search logic.

Related to #234
```

### Final Commit (Closes Issue)
```
feat(api): complete user search endpoint

Add REST endpoint with pagination and sorting.
All acceptance criteria now met.

Fixes #234
```

### Bug Fix
```
fix(auth): prevent session timeout during active use

Sessions were expiring even when user was actively using
the system. Now properly extends session on each request.

Fixes #567
```

### Child Issue Example
```
feat(auth): add OAuth Google provider

Implements Google OAuth2 integration as part of
social login feature.

Related to #124 (child of #123)
```

### Breaking Change
```
refactor(api)!: change response format to camelCase

BREAKING CHANGE: All API responses now use camelCase
instead of snake_case. Update clients accordingly.

Migration guide: docs/migrations/v2-api-changes.md
```

### Test-Driven Development
```
test(utils): add failing test for date parsing edge case

Documents expected behavior for leap year handling.
Part of TDD red phase.
```

## Pre-commit Hook Patterns

### Common Failures

#### Linting Errors
```bash
# Auto-fix when possible
npm run lint:fix
# or
black . --line-length 100
```

#### Import Sorting
```bash
# Python
isort .

# JavaScript
npx import-sort-cli --write '**/*.js'
```

#### Trailing Whitespace
```bash
# Remove trailing whitespace
find . -type f -name "*.py" -exec sed -i 's/[ \t]*$//' {} +
```

## Integration Points
- Links to: Process: DataSanitization (message security)
- Links to: Process: IssueUpdate (tracking commits)
- Links to: Process: PushFailureResolution (push issues)
- Triggers: CI/CD pipeline on successful push

## Best Practices

### DO
- ✅ Commit early and often
- ✅ Keep commits atomic
- ✅ Write descriptive messages
- ✅ Reference related issues
- ✅ Fix pre-commit issues immediately

### DON'T
- ❌ Mix unrelated changes
- ❌ Use vague messages like "fix stuff"
- ❌ Skip pre-commit hooks
- ❌ Commit sensitive data
- ❌ Leave broken tests

## Troubleshooting

### Amending Commits
```bash
# Fix the last commit message
${version_control} commit --amend

# Add forgotten files to last commit
${version_control} add forgotten_file
${version_control} commit --amend --no-edit
```

### Reverting Commits
```bash
# Create a revert commit
${version_control} revert <commit-sha>
# Message: "revert: <original message>"
```

---
*Consistent commit messages enable automation, improve collaboration, and create meaningful project history.*