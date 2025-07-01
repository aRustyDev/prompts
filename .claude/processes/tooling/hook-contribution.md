---
module: PreCommitHookContribution
scope: context
triggers: ["contribute hook", "share hook", "upstream contribution", "hook to community"]
conflicts: []
dependencies: ["IssueTracking", "DataSanitization", "CommitStandards"]
priority: medium
---

# Pre-commit Hook Contribution Process

## Purpose
Share custom pre-commit hooks that solve general problems back to the community repository, transforming local solutions into reusable tools that benefit developers everywhere.

## Trigger
When a custom hook has proven valuable locally and could benefit other projects facing similar issues.

## Prerequisites
- Custom hook running successfully for at least 5 commits
- Hook solves a generalizable problem
- Hook is well-tested and documented
- Time available for contribution process

## Steps

### Step 1: Hook Generalization
```
1.1 Remove project-specific logic:
    Review hook for:
    - Hardcoded paths or names
    - Project-specific conventions
    - Internal terminology
    - Custom business logic

    Transform to:
    - Configurable parameters
    - Common conventions
    - Generic terminology
    - Widely applicable logic

1.2 Add configuration options:
    Original project-specific:
    """
    if 'src/api' in filepath:
        special_check()
    """

    Generalized configurable:
    """
    # In .pre-commit-config.yaml
    args: ['--include-paths', 'src/api']

    # In hook
    parser.add_argument('--include-paths', nargs='*',
                       help='Paths requiring special checks')
    """

1.3 Ensure cross-platform compatibility:
    - Path separators: Use pathlib or os.path
    - Line endings: Handle both \n and \r\n
    - Shell commands: Avoid platform-specific
    - File permissions: Test on Windows/Mac/Linux

1.4 Add sensible defaults:
    - Work out-of-box for common cases
    - Make configuration optional
    - Provide example configurations
    - Document all options clearly
```

### Step 2: Comprehensive Documentation
```
2.1 Write detailed README:
    Structure:
    """
    # ${hook_name}

    ## What it does
    ${clear_one_paragraph_description}

    ## Why you need it
    ${problem_it_solves_with_examples}

    ## Installation
    Add to your `.pre-commit-config.yaml`:
    ```yaml
    - repo: https://github.com/aRustyDev/pre-commit-hooks
      rev: main
      hooks:
        - id: ${hook_id}
    ```

    ## Examples

    ### What it catches
    ❌ This will fail:
    ```${language}
    ${bad_example_code}
    ```

    ✅ This will pass:
    ```${language}
    ${good_example_code}
    ```

    ## Configuration

    ### Basic usage
    No configuration needed for default behavior.

    ### Advanced options
    ```yaml
    - id: ${hook_id}
      args: [
        '--strict',  # Enable strict mode
        '--fix',     # Auto-fix issues
        '--exclude', 'legacy/'  # Skip legacy code
      ]
    ```

    ### All available options
    - `--strict`: ${what_strict_does}
    - `--fix`: Enable automatic fixing
    - `--exclude PATTERN`: Skip files matching pattern

    ## How it works
    ${technical_explanation_for_contributors}

    ## Contributing
    Issues and PRs welcome! See CONTRIBUTING.md
    """

2.2 Create usage examples:
    - Common use case
    - Advanced configuration
    - Integration with other hooks
    - Troubleshooting section

2.3 Document edge cases:
    - Known limitations
    - Performance considerations
    - When NOT to use it
    - Compatibility notes
```

### Step 3: Issue Creation in Target Repository
```
3.1 Navigate to target repository:
    Open: https://github.com/aRustyDev/pre-commit-hooks

3.2 Search for existing similar issues:
    - Check open issues
    - Check closed issues
    - Review existing hooks
    - Avoid duplication

3.3 Create detailed issue:
    Title: "New Hook: ${descriptive_hook_name}"

    Body:
    """
    ## Hook Proposal: ${hook_name}

    ### Problem it solves
    ${detailed_problem_description}

    This is a common issue that affects many projects because:
    - ${reason_1}
    - ${reason_2}

    ### How the hook works
    ${high_level_algorithm_description}

    Example detection:
    ```
    ${simple_example_of_what_it_catches}
    ```

    ### Implementation approach
    - Language: ${python/bash/etc}
    - Detection method: ${regex/AST/parsing}
    - Performance: ${typical_runtime}
    - Auto-fix capable: ${yes/no}

    ### Why it's generally useful
    ${explanation_of_broad_applicability}

    ### Testing
    I've been using this hook in production for ${timeframe} and it has:
    - Caught ${number} issues
    - Saved approximately ${time_estimate}
    - No false positives in ${usage_period}

    ### Example configuration
    ```yaml
    ${example_pre_commit_config}
    ```

    I'm ready to submit a PR with full implementation, tests, and documentation.
    Would this be a valuable addition to the repository?
    """

3.4 Record issue number:
    Save: Issue #${number} for tracking

3.5 Wait for maintainer feedback:
    - Address questions
    - Clarify implementation
    - Adjust approach if needed
    - Get green light to proceed
```

### Step 4: Fork and Implementation
```
4.1 Fork the repository:
    - Go to https://github.com/aRustyDev/pre-commit-hooks
    - Click "Fork" button
    - Clone your fork locally:
      git clone https://github.com/${your_username}/pre-commit-hooks
      cd pre-commit-hooks

4.2 Create feature branch:
    Branch name: add-${hook_name}-hook
    ```bash
    git checkout -b add-${hook_name}-hook
    ```

4.3 Study repository structure:
    Understand:
    - How hooks are organized
    - Naming conventions used
    - Test framework (if any)
    - Documentation standards

4.4 Add hook implementation:
    Create hook file:
    - Place in appropriate directory
    - Follow naming convention
    - Include file header/comments
    - Make executable if needed

    Update .pre-commit-hooks.yaml:
    """
    - id: ${hook_id}
      name: ${human_readable_name}
      description: ${one_line_description}
      entry: hooks/${hook_script}
      language: ${language}
      types: [${file_types}]
      require_serial: ${true_if_needed}
      minimum_pre_commit_version: ${version_if_needed}
    """

4.5 Add tests (if framework exists):
    - Test passing cases
    - Test failing cases
    - Test edge cases
    - Test configuration options
    - Test performance

4.6 Update repository documentation:
    - Add to main README hook list
    - Update any index files
    - Add to category lists
    - Include in examples
```

### Step 5: Testing and Validation
```
5.1 Test from your fork:
    Update test project config:
    """
    repos:
      - repo: https://github.com/${your_username}/pre-commit-hooks
        rev: ${your_branch}
        hooks:
          - id: ${hook_id}
    """

    Run comprehensive tests:
    - Various file types
    - Edge cases
    - Performance testing
    - Configuration options

5.2 Test on multiple projects:
    - Different languages
    - Different project sizes
    - Different configurations
    - Verify no regressions

5.3 Run repository test suite:
    ```bash
    # If tests exist
    make test
    # or
    pytest
    # or
    ./run-tests.sh
    ```

5.4 Verify documentation:
    - All links work
    - Examples are accurate
    - Configuration documented
    - No typos or errors
```

### Step 6: Pull Request Submission
```
6.1 Commit changes:
    Execute: Process: CommitStandards

    Commit message:
    """
    feat: add ${hook_name} hook

    Implements detection for ${problem_description}.
    This hook helps prevent ${specific_issue} by ${method}.

    Tested on multiple projects with zero false positives.
    Includes comprehensive documentation and examples.

    Resolves #${issue_number}
    """

6.2 Push to your fork:
    ```bash
    git push origin add-${hook_name}-hook
    ```

6.3 Create pull request:
    Title: "Add ${hook_name} hook - Fixes #${issue_number}"

    Body:
    """
    ## Description
    This PR adds the `${hook_id}` hook as discussed in #${issue_number}.

    ## What it does
    ${brief_description}

    ## Implementation details
    - ${implementation_point_1}
    - ${implementation_point_2}

    ## Testing
    - ✅ Tested on ${number} different projects
    - ✅ All existing tests pass
    - ✅ Documentation complete
    - ✅ Examples provided

    ## Example usage
    ```yaml
    ${example_config}
    ```

    ## Performance
    Average runtime: ${time} on ${file_count} files

    Closes #${issue_number}
    """

6.4 Link PR to issue:
    Comment on issue: "Pull request submitted: #${pr_number}"
```

### Step 7: Review Process Management
```
7.1 Monitor PR for feedback:
    - Check daily for comments
    - Respond promptly to questions
    - Make requested changes

7.2 Address review comments:
    For each comment:
    - Understand the concern
    - Implement changes
    - Respond explaining what was done
    - Push updates

7.3 Track iterations:
    Update issue with progress:
    """
    Review iteration ${n}:
    - Feedback: ${summary}
    - Changes made: ${list}
    - Status: ${pending/approved}
    """

7.4 Maintain CI/CD compliance:
    - Ensure all checks pass
    - Fix any failing tests
    - Address linting issues
    - Resolve conflicts
```

### Step 8: Post-Merge Activities
```
8.1 After merge confirmation:
    Local project updates:
    - Update .pre-commit-config.yaml to use official version
    - Remove local hook copy
    - Update team documentation

8.2 Final issue update:
    Execute: Process: IssueUpdate

    Include:
    """
    ## Contribution Complete! 🎉

    The ${hook_name} hook is now available in the official repository.

    ### Summary
    - PR merged as: #${pr_number}
    - Commit: ${merge_commit_sha}
    - Available in version: ${version}

    ### Usage
    Projects can now use:
    ```yaml
    repos:
      - repo: https://github.com/aRustyDev/pre-commit-hooks
        rev: ${version}
        hooks:
          - id: ${hook_id}
    ```

    ### Lessons Learned
    - ${lesson_1}
    - ${lesson_2}

    ### Time Investment
    - Development: ${dev_hours} hours
    - Contribution process: ${contrib_hours} hours
    - Total: ${total_hours} hours

    ### Estimated Impact
    - Helps projects avoid: ${problem}
    - Saves approximately: ${time_per_occurrence}
    - Potential reach: Any project using ${language/tool}
    """

8.3 Close tracking issue:
    - Mark as resolved
    - Add "contributed" label
    - Link to upstream PR

8.4 Announce to team:
    Share success:
    - What was contributed
    - How to use it
    - Recognition for effort
```

### Step 9: Maintenance and Support
```
9.1 Monitor hook usage:
    - Watch for issues filed
    - Check for bug reports
    - Note feature requests

9.2 Provide support:
    - Answer usage questions
    - Help debug problems
    - Consider improvements

9.3 Track adoption:
    - GitHub search for usage
    - Star/fork metrics
    - Community feedback

9.4 Plan improvements:
    If issues found:
    - Create fix PR
    - Update documentation
    - Maintain quality
```

## Integration Points

- **Triggered by**: Process: PreCommitHookResolution (when hook is generally useful)
- **Uses**: Process: DataSanitization (for all public content)
- **Uses**: Process: CommitStandards (for commits)
- **Uses**: Process: IssueTracking (throughout process)
- **Results in**: Community-available hook
- **Updates**: Local configuration to use official version

## Success Metrics

A successful contribution:
- Gets merged within reasonable time
- Receives positive feedback
- Gets adopted by other projects
- Generates no major bug reports
- Saves time for many developers

## Best Practices

### Do's
- ✅ Generalize thoroughly before contributing
- ✅ Test extensively on various projects
- ✅ Document comprehensively
- ✅ Respond quickly to feedback
- ✅ Support your contribution after merge

### Don'ts
- ❌ Submit project-specific hooks
- ❌ Skip testing on other projects
- ❌ Ignore maintainer guidelines
- ❌ Abandon PR during review
- ❌ Forget to update local usage

## Example Contributions

### Successful: Import Grouping Checker
Started as internal tool to enforce import grouping standards, generalized to support multiple Python import styles, now used by hundreds of projects.

### Learning Experience: Database Migration Checker
Too specific to Django projects, required significant generalization, eventually split into framework-specific repository.

Remember: Contributing your solutions back to the community creates a positive cycle where everyone's development experience improves. Your solution to a recurring problem could save thousands of developer hours across the industry.
