---
module: CommitStandards
scope: persistent
triggers: ["commit", "commit message", "version control", "git commit"]
conflicts: []
dependencies: ["DataSanitization", "IssueTracking"]
priority: high
---

# Commit Standards Process

## Purpose
Ensure all commits follow conventional standards, include proper issue references, handle pre-commit hooks gracefully, and maintain a clean, traceable git history.

## Trigger
Execute whenever code changes need to be committed to version control.

## Prerequisites
- Changes staged for commit
- Issue number available (if applicable)
- Pre-commit hooks configured

## Steps

### Step 1: Pre-commit Preparation
```
1.1 Review changes to be committed:
    ${version_control} diff --staged

1.2 Ensure changes are atomic:
    - One logical change per commit
    - Related files committed together
    - Unrelated changes separated

1.3 Determine commit impact:
    - Will this close an issue?
    - Is this a breaking change?
    - Does this need documentation?
```

### Step 2: Commit Classification
```
2.1 Identify commit type:
    - feat: New feature
    - fix: Bug fix
    - refactor: Code improvement (no behavior change)
    - test: Adding/updating tests
    - docs: Documentation only
    - style: Formatting (no code change)
    - perf: Performance improvement
    - chore: Build process/auxiliary tools
    - ci: CI/CD configuration

2.2 Determine scope:
    - Component affected (auth, api, ui)
    - Module name
    - Feature area

2.3 Check if breaking change:
    - API changes
    - Config format changes
    - Behavior changes
```

### Step 3: Message Composition
```
3.1 Format header line:
    ${type}(${scope}): ${description}

    Rules:
    - Maximum 72 characters
    - Present tense ("add" not "added")
    - No period at end
    - Clear and specific

3.2 Add body if needed:
    - Blank line after header
    - Explain what and why (not how)
    - Wrap at 72 characters
    - Use bullet points if multiple items

3.3 Add footer references:
    IF closes_issue:
        Add: "Fixes #${issue_number}"
    IF relates_to_issue:
        Add: "Related to #${issue_number}"
    IF breaking_change:
        Add: "BREAKING CHANGE: ${description}"
```

### Step 4: Sanitization Check
```
4.1 Execute: Process: DataSanitization
    Input: Commit message and diff

4.2 Review sanitized content:
    - No sensitive data exposed
    - No credentials in message
    - No internal paths leaked
```

### Step 5: Execute Commit
```
5.1 Run commit command:
    ${version_control} commit

5.2 IF pre_commit_hooks_fail:
    5.2.1 Capture failure output
    5.2.2 Identify failure type:
        - Linting errors
        - Test failures
        - Security issues
        - Formatting problems

    5.2.3 Create/update tracking issue:
        Execute: Process: IssueTracking
        Title: "Pre-commit: ${failure_type}"
        Labels: ['pre-commit', 'tooling']

    5.2.4 Document in issue:
        - Full error message
        - Files affected
        - Attempted fixes

    5.2.5 Fix the issues:
        - Apply suggested fixes
        - Re-run failed checks locally
        - Verify fixes work

    5.2.6 Update issue with solution:
        - What caused the problem
        - How it was fixed
        - Lessons learned

    5.2.7 Check for pattern:
        Execute: Process: RecurringProblemIdentification
        Context: Pre-commit failure pattern

    5.2.8 Retry commit

5.3 ELSE commit_succeeds:
    Continue to step 6
```

### Step 6: Push Changes
```
6.1 Push to remote:
    ${version_control} push

6.2 IF push_fails:
    Execute: Process: PushFailureResolution

6.3 Verify push succeeded:
    - Check remote repository
    - Confirm CI/CD triggered
    - Monitor initial status
```

### Step 7: Post-commit Tasks
```
7.1 Update issue tracking:
    - Add commit reference to issue
    - Update progress if applicable
    - Close issue if completed

7.2 If created pre-commit fix:
    - Close pre-commit issue
    - Link to main issue
    - Document for future reference
```

## Message Examples

### Feature Commit
```
feat(auth): add two-factor authentication support

Implement TOTP-based 2FA with QR code generation for enhanced
account security. Users can now enable 2FA in account settings.

- Add TOTP library integration
- Create QR code generation endpoint
- Update auth middleware for 2FA checks

Fixes #234
```

### Bug Fix Commit
```
fix(api): handle null values in user profile update

Previous implementation threw NullPointerException when optional
fields were cleared. Now properly handles null values and empty
strings.

Fixes #456
```

### Breaking Change Commit
```
refactor(config): restructure database configuration format

BREAKING CHANGE: Database config now uses nested structure
instead of flat keys. Migration guide in docs/migration-v2.md.

Old format:
  db_host: localhost
  db_port: 5432

New format:
  database:
    host: localhost
    port: 5432

Related to #789
```

## Pre-commit Hook Patterns

### Common Failures and Fixes

#### Linting Errors
```
Problem: ESLint/Pylint violations
Fix approach:
1. Run linter with --fix flag
2. Manual fix remaining issues
3. Update code style guide if needed
```

#### Import Sorting
```
Problem: Imports not alphabetically sorted
Fix approach:
1. Use isort (Python) or import-sort (JS)
2. Configure IDE to sort on save
3. Add to pre-commit config
```

#### Trailing Whitespace
```
Problem: Lines end with spaces/tabs
Fix approach:
1. Configure editor to trim on save
2. Use pre-commit's trailing-whitespace hook
3. Run: find . -type f -exec sed -i 's/[ \t]*$//' {} \;
```

## Integration Points

- **Uses**: Process: DataSanitization (for security)
- **Uses**: Process: IssueTracking (for pre-commit issues)
- **Uses**: Process: RecurringProblemIdentification (for patterns)
- **Uses**: Process: PushFailureResolution (for push issues)
- **Triggers**: CI/CD pipeline on successful push
- **Updates**: Issue tracker with progress

## Best Practices

### Do's
- ✅ Commit early and often
- ✅ Make atomic commits
- ✅ Write clear, descriptive messages
- ✅ Reference issues consistently
- ✅ Fix pre-commit issues immediately

### Don'ts
- ❌ Commit commented-out code
- ❌ Mix refactoring with features
- ❌ Use generic messages like "fix bug"
- ❌ Skip pre-commit hooks
- ❌ Commit sensitive data

## Troubleshooting

### Pre-commit Keeps Failing
1. Run hooks manually: `pre-commit run --all-files`
2. Check hook versions: `pre-commit autoupdate`
3. Verify configuration syntax
4. Test hooks individually

### Can't Push After Commit
1. Check if remote has diverged
2. Verify branch permissions
3. Ensure authentication works
4. Check for pre-push hooks

### Wrong Issue Referenced
1. Amend commit: `${version_control} commit --amend`
2. Update message with correct issue
3. Force push if already pushed (carefully!)

Remember: Good commit messages are a gift to your future self and your team. They provide context that code alone cannot convey.
