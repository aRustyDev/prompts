---
module: TestDrivenDevelopment
scope: persistent
triggers: ["TDD", "test driven", "red green refactor", "test first"]
conflicts: ["CoverageDrivenDevelopment", "BehaviorDrivenDevelopment"]
dependencies: ["commit-standards", "issue-tracking"]
priority: high
---

# Test Driven Development Pattern

## Purpose
Implement code using the red-green-refactor cycle with continuous integration to ensure quality, maintain test coverage, and prevent regressions.

## When to Use
- Default development pattern for all new features
- When fixing bugs (write test to reproduce first)
- When refactoring (ensure tests exist first)
- When exploring new APIs (test documents understanding)

## Implementation

### The TDD Cycle
```
1. RED: Write a failing test that defines desired behavior
2. GREEN: Write minimal code to make the test pass
3. REFACTOR: Improve code structure while keeping tests green
4. COMMIT: Save progress to version control
5. PUSH: Share with team and trigger CI/CD
```

### Detailed Process

#### Step 1: Select Next Task
```
1.1 From plan, identify next atomic task
1.2 Confirm task is truly atomic
1.3 Create task-specific branch if needed:
    ${version_control} checkout -b ${current_branch}-${task_id}
```

#### Step 2: Write Failing Test
```
2.1 Create test file if needed
2.2 Write test that describes desired behavior
2.3 Test should fail for the right reason
2.4 Document test purpose: "// Test: ${what_and_why}"
2.5 Run test, confirm failure
2.6 Commit the failing test:
    - Message: "test(${scope}): add failing test for ${behavior}"
    - This documents our intention before implementation
```

#### Step 3: Minimal Implementation
```
3.1 Write ONLY enough code to pass test
3.2 Avoid premature optimization
3.3 Run test, confirm passes
3.4 Run ALL tests, confirm no regression
```

#### Step 4: Commit Working Code
```
4.1 Stage test and implementation together
4.2 Execute: Process: CommitWork
    Message: "feat(${scope}): implement ${behavior}"
4.3 IF commit_succeeds:
    - Continue to step 5
4.4 ELSE handle_commit_failure:
    - Create or update issue for failure pattern
    - Fix issues identified by pre-commit
    - Document solution in issue
    - Retry commit until success
    - Ensure issue is linked to current work
```

#### Step 5: Push Changes
```
5.1 Push to remote: ${version_control} push
5.2 IF push_fails:
    - Execute: Process: PushFailureResolution
    - Document resolution in issue tracker
    - Retry push until success
5.3 Verify CI/CD pipeline triggered
5.4 Monitor for any CI/CD failures
```

#### Step 6: Document Progress
```
6.1 Execute: Process: IssueUpdate
    Context: "TDD Cycle completed for ${task}"
    Include:
    - Test written and what it validates
    - Implementation approach
    - Any pre-commit issues encountered
    - CI/CD status
```

#### Step 7: Refactor (if needed)
```
7.1 Improve code structure
7.2 Extract common patterns
7.3 Enhance readability
7.4 Add implementation comments
7.5 Run all tests after each change
7.6 IF refactoring_done:
    Execute: Process: CommitWork
    Message: "refactor(${scope}): ${improvement_description}"
    Then: Push changes
```

#### Step 8: Task Completion Check
```
8.1 IF atomic_task_complete:
    - Update issue with task completion
    - Check for any open sub-issues
    - Close any resolved pre-commit issues
8.2 ELSE:
    - Return to Step 1 for next test
```

#### Step 9: Issue Hygiene
```
9.1 Review all issues created during this task
9.2 Ensure all are either:
    - Closed with resolution documented
    - Linked to parent issue for tracking
    - Assigned for follow-up if still open
9.3 No orphaned issues allowed
```

## Examples

### Example: Adding Email Validation
```python
# Step 1: Write failing test
def test_email_validation_accepts_valid_emails():
    # Test: Should accept standard email formats
    assert is_valid_email("user@example.com") == True
    assert is_valid_email("user.name+tag@example.co.uk") == True

# Step 2: Run test - it fails (is_valid_email doesn't exist)

# Step 3: Minimal implementation
def is_valid_email(email):
    return "@" in email and "." in email.split("@")[1]

# Step 4: Test passes - commit both files together
# Commit message: "feat(validation): implement basic email validation"

# Step 5: Refactor for better validation
import re
def is_valid_email(email):
    pattern = r'^[\w\.-]+@[\w\.-]+\.\w+$'
    return re.match(pattern, email) is not None

# Step 6: Tests still pass - commit refactor
# Commit message: "refactor(validation): improve email regex pattern"
```

## Anti-patterns to Avoid

### Writing Implementation First
❌ Writing code then adding tests later
✅ Always write the test first - it defines the interface

### Giant Test Steps
❌ Writing tests for entire features at once
✅ One small test for one small behavior

### Skipping the Refactor Step
❌ Moving to next feature immediately after green
✅ Always consider: "Can this be clearer?"

### Delayed Commits
❌ Waiting until "done" to commit
✅ Commit after every red-green-refactor cycle

### Working in Isolation
❌ Not pushing until feature complete
✅ Push frequently for continuous integration

## Integration Points

- **Links to**: Process: CommitWork (handles version control)
- **Links to**: Process: IssueUpdate (maintains tracking)
- **Links to**: Process: PushFailureResolution (handles push issues)
- **Requires**: Active issue tracking for documentation
- **Triggers**: CI/CD pipeline on each push

## Success Metrics
- All new code has tests written first
- Test coverage increases or maintains
- Commits are small and focused
- No orphaned issues from development
- Continuous integration never broken

## Troubleshooting

### Tests Won't Fail Properly
- Ensure test actually tests new behavior
- Check test isn't accidentally passing
- Verify assertions are correct

### Can't Write Minimal Code
- Break down the test further
- Focus on making just this test pass
- Ignore edge cases until tested

### Too Many Tests Failing
- Check for unintended side effects
- Review recent changes
- Consider rolling back and smaller steps
