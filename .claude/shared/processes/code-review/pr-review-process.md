---
name: PR Review Process
module_type: process
scope: context
priority: high
triggers: ["pull request", "PR review", "code review", "merge request"]
dependencies: 
  - "../version-control/git-workflow.md"
  - "../issue-tracking/github-issues.md"
conflicts: []
version: 1.0.0
---

# Pull Request Review Process

## Purpose
Ensure all pull requests meet quality standards, properly close related issues, and maintain code integrity through comprehensive review.

## Overview
This process defines how pull requests should be reviewed, what to check for, and how to ensure the PR properly implements the issue requirements.

## PR Review Checklist

### 1. PR Metadata Validation
```yaml
metadata_checks:
  - title: Clear and descriptive
  - description: 
    - Summary of changes
    - Links to related issues
    - Testing performed
  - issue_references:
    - Contains "Fixes #N" or "Closes #N"
    - All related issues linked
    - Parent issues referenced for child tasks
  - labels: Appropriate labels applied
  - milestone: Assigned if applicable
```

### 2. Branch and Commit Review

#### Branch Naming
```bash
# Verify branch follows naming convention
# Format: <type>/<issue-number>-<description>
valid_patterns=(
  "^feat/[0-9]+-[a-z0-9-]+$"
  "^fix/[0-9]+-[a-z0-9-]+$"
  "^refactor/[0-9]+-[a-z0-9-]+$"
  "^docs/[0-9]+-[a-z0-9-]+$"
  "^test/[0-9]+-[a-z0-9-]+$"
  "^chore/[0-9]+-[a-z0-9-]+$"
  "^perf/[0-9]+-[a-z0-9-]+$"
  "^style/[0-9]+-[a-z0-9-]+$"
)
```

#### Commit Quality
- [ ] All commits reference the issue
- [ ] Commits are atomic (one logical change)
- [ ] Commit messages follow conventional format
- [ ] At least one commit contains "Fixes #N"
- [ ] No merge commits from main (prefer rebase)

### 3. Code Quality Review

#### General Code Quality
- [ ] Code follows project style guidelines
- [ ] No commented-out code
- [ ] No debug statements (console.log, print, etc.)
- [ ] Appropriate error handling
- [ ] No hardcoded values that should be configurable

#### Code Organization
- [ ] Functions/methods are focused and single-purpose
- [ ] Files are reasonably sized (< 500 lines)
- [ ] Complex logic is well-documented
- [ ] DRY principle followed (no unnecessary duplication)

#### Security Considerations
- [ ] No exposed secrets or credentials
- [ ] Input validation present where needed
- [ ] No SQL injection vulnerabilities
- [ ] No XSS vulnerabilities
- [ ] Dependencies are from trusted sources

### 4. Test Coverage

#### Test Requirements
- [ ] New features have corresponding tests
- [ ] Bug fixes include regression tests
- [ ] All tests pass in CI
- [ ] Test coverage maintained or improved
- [ ] Edge cases are tested

#### Test Quality
- [ ] Tests are readable and well-named
- [ ] Tests actually test the functionality
- [ ] No flaky tests introduced
- [ ] Integration tests for complex features

### 5. Documentation Review

#### Code Documentation
- [ ] Complex functions have docstrings/comments
- [ ] Public APIs are documented
- [ ] Type hints/annotations present (if applicable)
- [ ] README updated if needed

#### User Documentation
- [ ] User-facing changes documented
- [ ] API documentation updated
- [ ] Migration guide if breaking changes
- [ ] Changelog updated

### 6. Issue Completion Verification

#### Definition of Done
Review the original issue's acceptance criteria:
```markdown
## Acceptance Criteria Checklist
- [ ] All acceptance criteria from issue are met
- [ ] Definition of Done satisfied
- [ ] No scope creep (only implements what's in the issue)
- [ ] Any deviations are documented and justified
```

#### Issue Closure Validation
- [ ] "Fixes #N" will close the correct issue
- [ ] No unintended issue closures
- [ ] Parent issues remain open if children are being closed
- [ ] All related issues are properly linked

## Review Process Steps

### Step 1: Automated Checks
Before manual review, ensure:
- CI/CD pipeline passes
- No merge conflicts
- Required checks complete
- Code coverage acceptable

### Step 2: Initial Review
1. Read the PR description
2. Review linked issues
3. Understand the scope of changes
4. Check file changes summary

### Step 3: Detailed Code Review
```bash
# Review approach for large PRs
1. Start with tests - understand expected behavior
2. Review implementation against tests
3. Check for edge cases
4. Verify error handling
5. Ensure consistent style
```

### Step 4: Functional Review
- [ ] Check out branch locally if needed
- [ ] Test the functionality
- [ ] Verify acceptance criteria
- [ ] Check for regressions

### Step 5: Feedback

#### Providing Feedback
```markdown
## Feedback Categories

### 🚨 Must Fix (Blocking)
- Security issues
- Broken functionality
- Missing tests for critical paths
- Does not meet acceptance criteria

### 🔧 Should Fix (Important)
- Performance concerns
- Missing error handling
- Code style violations
- Missing documentation

### 💭 Consider (Suggestions)
- Alternative approaches
- Future improvements
- Nice-to-have enhancements
- Style preferences
```

#### Feedback Format
```markdown
# Use clear, constructive language
❌ "This code is bad"
✅ "This could be improved by extracting into a separate function for clarity"

# Provide examples when possible
❌ "Handle errors"
✅ "Consider handling the case where `user` is null:
    ```js
    if (!user) {
      throw new Error('User not found');
    }
    ```"
```

### Step 6: Approval Process

#### Approval Criteria
- All "Must Fix" items addressed
- Most "Should Fix" items addressed or justified
- CI/CD passes
- Acceptance criteria met
- No unresolved discussions

#### Approval Types
- **Approve**: Ready to merge
- **Request Changes**: Must address feedback
- **Comment**: Observations but not blocking

### Step 7: Merge Process

#### Pre-Merge Checklist
- [ ] All reviews approved
- [ ] CI/CD green
- [ ] No merge conflicts
- [ ] Branch up-to-date with base
- [ ] Issue will be correctly closed

#### Merge Strategy
Follow project defaults:
- **Squash and merge**: For feature branches with many commits
- **Rebase and merge**: For clean, atomic commit history
- **Merge commit**: For preserving complete history

## Review Best Practices

### DO
- ✅ Review promptly (within 1-2 business days)
- ✅ Be constructive and specific
- ✅ Acknowledge good code
- ✅ Consider the bigger picture
- ✅ Test locally for complex changes
- ✅ Check issue requirements thoroughly

### DON'T
- ❌ Approve without reading the code
- ❌ Nitpick on style if auto-formatting exists
- ❌ Block on personal preferences
- ❌ Approve with unaddressed "Must Fix" items
- ❌ Skip testing because CI passed

## Special Scenarios

### Hotfix PRs
- Expedited review process
- Focus on fix correctness
- Ensure no additional changes
- Fast-track if critical

### Large PRs
- Consider requesting split into smaller PRs
- Review in logical chunks
- Focus on architecture first
- May need multiple reviewers

### Dependency Updates
- Check changelog for breaking changes
- Verify tests still pass
- Check for security advisories
- Ensure compatibility

## Metrics and Monitoring

Track these metrics:
- Time to first review
- Time to approval
- Number of review cycles
- Issues caught in review
- Post-merge issues

## Integration Points
- Links to: Issue tracking for verification
- Links to: Git workflow for standards
- Links to: Testing standards
- Triggers: CI/CD on approval
- Updates: Issue status on merge

---
*Quality reviews ensure code integrity and successful issue completion.*