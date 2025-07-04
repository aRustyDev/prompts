---
name: Bug Fix Workflow
module_type: workflow
scope: context
priority: high
triggers: ["fix bug", "debug", "error", "issue", "broken", "not working", "regression", "hotfix"]
dependencies: ["processes/version-control/workspace-setup.md", "processes/code-review/codebase-analysis.md", "patterns/development/tdd-pattern.md", "processes/testing/regression-testing.md", "processes/version-control/commit-standards.md"]
conflicts: []
version: 1.0.0
---

# Bug Fix Workflow

## Purpose
Systematically diagnose, fix, and prevent bugs while ensuring no new issues are introduced. This workflow emphasizes understanding root causes and preventing future occurrences.

## Trigger
- Bug report received
- Error identified during development
- Test failure discovered
- Production issue reported
- Regression detected

## Workflow Steps

### 1. Process: WorkspaceSetup
**Purpose**: Create isolated environment for bug investigation
**Focus**: Clean workspace on appropriate branch
**Output**: Working branch for bug fix

**Customization**:
- Branch naming: `fix/${issue_number}-${brief_description}`
- If hotfix: branch from main/master
- If standard fix: branch from develop

### 2. Process: BugAnalysis
**Purpose**: Understand the bug thoroughly before attempting fixes
**Focus**: Root cause identification

**Steps**:
1. **Reproduce the bug**
   ```
   Can the bug be reproduced?
     Yes � Document exact steps
     No � Gather more information
     Intermittent � Identify conditions
   ```

2. **Collect evidence**
   - Error messages (sanitized)
   - Stack traces
   - Logs from failure
   - System state when failing
   - Recent changes that might relate

3. **Determine scope**
   - Affected components
   - User impact severity
   - Data integrity concerns
   - Security implications

4. **Root cause analysis**
   - Use "5 Whys" technique
   - Check recent commits
   - Review related issues
   - Identify introduction point

**Output**: Clear understanding of bug cause and impact

### 3. Decision Point: Bug Complexity
```
Is this a simple, isolated fix?
  Simple (< 1 hour) � Proceed to quick fix
  Complex � Full TDD approach
  Architectural � Escalate to team
  Security � Follow security protocol
```

### 4. Process: TestCreation
**Purpose**: Write tests that demonstrate the bug
**Focus**: Failing tests for current behavior

**Actions**:
1. Write minimal failing test that reproduces bug
2. Verify test fails for the right reason
3. Add edge case tests around the bug
4. Document what correct behavior should be

**Critical**: Tests must fail before fix is applied

### 5. Process: ImplementFix
**Purpose**: Apply minimal fix that resolves the issue
**Focus**: Targeted solution without side effects

**Guidelines**:
1. **Minimal change principle**
   - Fix only what's broken
   - Resist refactoring temptation
   - Document why fix works

2. **Safety checks**
   - No hardcoded values
   - No commented-out code
   - No debug statements

3. **Fix verification**
   - All new tests pass
   - Existing tests still pass
   - Manual testing confirms fix

### 6. Process: RegressionPrevention
**Purpose**: Ensure bug doesn't reoccur
**Focus**: Comprehensive test coverage

**Actions**:
1. **Expand test coverage**
   - Add integration tests
   - Test related functionality
   - Add performance tests if relevant

2. **Code hardening**
   - Add input validation
   - Improve error handling
   - Add defensive checks

3. **Documentation updates**
   - Update code comments
   - Add warning comments
   - Document assumptions

### 7. Decision Point: Side Effects Check
```
Do all existing tests pass?
  Yes � Continue to review
  No, related failure � Expand fix scope
  No, unrelated � Investigate coupling
  Performance degraded � Optimize approach
```

### 8. Process: CodeQualityReview
**Purpose**: Ensure fix meets quality standards
**Focus**: Maintainability and clarity

**Checks**:
- Fix is understandable
- No code duplication introduced
- Follows existing patterns
- Performance acceptable
- Security implications addressed

### 9. Process: BugDocumentation
**Purpose**: Capture knowledge for future reference
**Focus**: Learning from the incident

**Document**:
1. **Bug summary**
   - What broke and why
   - How it was discovered
   - Impact assessment

2. **Fix explanation**
   - What was changed
   - Why this approach
   - Alternative considered

3. **Prevention notes**
   - How to avoid similar bugs
   - Testing improvements made
   - Monitoring additions

### 10. Process: WorkspaceCleanup
**Purpose**: Prepare for merge
**Focus**: Clean history and complete documentation
**Output**: Ready for review

### 11. Process: SubmitWork
**Purpose**: Create PR with comprehensive context
**Focus**: Clear communication of fix

**PR Template**:
```markdown
## Bug Fix: ${description}

### Problem
${what_was_broken}

### Root Cause
${why_it_broke}

### Solution
${how_it_was_fixed}

### Testing
- [ ] Reproducer test added
- [ ] Edge cases covered
- [ ] Regression tests pass
- [ ] Manual testing completed

### Impact
- Severity: ${High/Medium/Low}
- Users affected: ${estimate}
- Data impact: ${None/Minimal/Significant}

Fixes #${issue_number}
```

## Success Criteria
- [ ] Bug no longer reproducible
- [ ] Tests prevent regression
- [ ] No new issues introduced
- [ ] Root cause documented
- [ ] Knowledge captured for team

## Integration Points
### Required Processes
- WorkspaceSetup (branch management)
- TestDrivenDevelopment (test-first fixing)
- CommitStandards (clear history)
- IssueUpdate (progress tracking)

### Optional Processes
- PerformanceProfiling (if performance bug)
- SecurityReview (if security implications)
- DataMigration (if data fix needed)

### May Trigger
- Refactoring workflow (if tech debt discovered)
- Documentation update (if docs incorrect)
- Monitoring enhancement (if observability gap)

## Variations

### Hotfix Variation
When production is broken:
1. Branch from main/master directly
2. Minimal fix only
3. Expedited review process
4. Cherry-pick to develop
5. Full fix in next sprint

### Investigation Variation
When bug cannot be reproduced:
1. Add extensive logging
2. Deploy instrumented version
3. Wait for occurrence
4. Analyze captured data
5. Proceed with fix

### Data Fix Variation
When bug corrupted data:
1. Assess data damage
2. Create backup
3. Write migration script
4. Test on copy
5. Apply with rollback plan

## Anti-Patterns

### Scope Creep
L "While I'm here, let me refactor this entire class"
 Fix the bug, note refactoring needs separately

### Incomplete Testing
L "The manual test works, ship it"
 Automated tests prevent regression

### Poor Documentation
L "Fix bug" commit message
 Detailed explanation of what and why

### Blame Culture
L "Find who wrote this bug"
 Focus on prevention and learning

## Best Practices

### DO
-  Reproduce before fixing
-  Write test first
-  Keep fixes minimal
-  Document thoroughly
-  Learn from bugs

### DON'T
- L Fix symptoms not causes
- L Skip regression tests
- L Combine with features
- L Rush hotfixes
- L Hide mistakes

## Metrics
- Time to reproduction
- Fix development time
- Review cycle time
- Regression rate
- Similar bug recurrence

---
*Every bug is an opportunity to improve the system's resilience and the team's knowledge.*