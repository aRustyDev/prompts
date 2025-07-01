---
module: FeatureDevelopmentWorkflow
scope: context
triggers: ["new feature", "implement feature", "feature development", "add functionality"]
conflicts: []
dependencies: ["CodebaseReview", "TestDrivenDevelopment", "CommitStandards", "IssueTracking"]
priority: high
---

# Feature Development Workflow

## Purpose
Orchestrate the complete process of implementing a new feature from initial request through deployment-ready code, ensuring quality, documentation, and team coordination.

## Workflow Trigger
- Product owner requests new functionality
- User story created for feature
- Feature identified during planning
- Enhancement issue opened

## Workflow Steps

### Phase 1: Setup and Analysis
```
1.1 Execute: Process: WorkspaceSetup
    - Creates feature branch
    - Initializes issue tracking
    - Configures pre-commit hooks

1.2 Execute: Process: CodebaseReview
    Focus: Feature Implementation
    - Understand existing architecture
    - Identify integration points
    - Find reusable components

1.3 Checkpoint: Review Understanding
    - Confirm codebase analysis complete
    - Questions documented
    - Approach forming
```

### Phase 2: Planning
```
2.1 Execute: Process: FeaturePlanning
    Inputs:
    - Requirements from issue/story
    - Codebase review findings
    - Technical constraints

2.2 Decision Point: Project Tracking
    IF feature_complexity == "high":
        Create GitHub Project
    ELIF subtasks > 5:
        Create Milestone
    ELSE:
        Use single issue tracking

2.3 Checkpoint: Plan Approval
    - Present plan to stakeholder
    - Get confirmation on approach
    - Adjust based on feedback
```

### Phase 3: Implementation
```
3.1 Load Development Pattern:
    Default: Process: TestDrivenDevelopment
    Alternative: Based on ${active_pattern}

3.2 Implementation Loop:
    WHILE tasks_remaining:
        - Select next atomic task
        - Execute active development pattern
        - Commit and push changes
        - Update issue tracking

3.3 Progress Monitoring:
    - CI/CD status after each push
    - Test coverage tracking
    - Performance benchmarks
```

### Phase 4: Quality Assurance
```
4.1 Execute: Process: CodeQualityReview
    - Automated checks pass
    - Manual review complete
    - Security considerations addressed

4.2 Integration Testing:
    - Feature works with existing code
    - No regressions introduced
    - Edge cases handled

4.3 Documentation Update:
    - API docs if applicable
    - README updates
    - User-facing documentation
```

### Phase 5: Finalization
```
5.1 Execute: Process: WorkspaceCleanup
    - All changes committed
    - Final issue updates
    - Metrics recorded

5.2 Execute: Process: SubmitWork
    - Create pull request
    - Link to issue/project
    - Request reviews

5.3 Monitor Review Process:
    - Respond to feedback
    - Make requested changes
    - Ensure CI/CD passing
```

## Decision Points

### Development Pattern Selection
```
IF requirements.exploration_needed:
    Consider: "This feature requires exploration.
             Load CoverageDrivenDevelopment for spike work?"

ELIF requirements.behavior_focused:
    Consider: "This feature has complex behaviors.
             Load BehaviorDrivenDevelopment instead?"

ELSE:
    Continue with TestDrivenDevelopment
```

### Complexity Assessment
```
AFTER FeaturePlanning:
    IF estimated_effort > 1_week:
        Recommend: Create GitHub Project
        Reason: "Multi-week features benefit from project boards"

    ELIF subtasks > 10:
        Recommend: Create Milestone
        Reason: "Many subtasks need grouping for tracking"
```

### Risk Mitigation
```
IF CodebaseReview.risks == "high":
    Insert: Process: RiskMitigationPlanning
    Before: Implementation phase
    Reason: "High-risk changes need mitigation strategy"
```

## Completion Criteria

The workflow is complete when:
- All planned functionality implemented
- All tests passing (unit, integration, e2e)
- Code review approved
- Documentation updated
- Pull request merged
- Issue closed with summary

## Workflow Variations

### Spike/Prototype Variation
For exploratory features:
1. Skip detailed planning
2. Use CoverageDrivenDevelopment
3. Focus on learning objectives
4. Document findings
5. Discard or refactor code

### Emergency Feature Variation
For urgent features:
1. Abbreviated CodebaseReview
2. Minimal planning documentation
3. Focus on critical path
4. Extensive post-implementation review
5. Technical debt logged

### Large Feature Variation
For multi-week features:
1. Extended planning phase
2. Create GitHub Project
3. Daily progress updates
4. Weekly stakeholder sync
5. Phased implementation

## Integration Points

### Required Processes
- Process: WorkspaceSetup (start)
- Process: CodebaseReview (analysis)
- Process: FeaturePlanning (planning)
- Process: [DevelopmentPattern] (implementation)
- Process: SubmitWork (completion)

### Optional Processes
- Process: RiskMitigation (if high risk)
- Process: PerformanceOptimization (if needed)
- Process: SecurityAudit (if sensitive)

### Triggered Workflows
- May trigger: Workflow: BugFix (if issues found)
- May trigger: Workflow: Refactoring (if debt identified)

## Metrics and Tracking

### Success Metrics
- Feature delivered on schedule
- Test coverage maintained/improved
- No production incidents
- Stakeholder satisfaction
- Code quality metrics

### Progress Tracking
- Daily updates in issue
- Commit frequency
- PR review turnaround
- CI/CD success rate

### Learning Capture
- Challenges documented
- Solutions recorded
- Patterns identified
- Process improvements suggested

## Common Pitfalls

### Planning Paralysis
⚠️ Spending too long in planning phase
✅ Timebox planning to 1-2 hours for most features

### Scope Creep
⚠️ Adding "just one more thing" during implementation
✅ Defer additions to separate issues

### Incomplete Testing
⚠️ Skipping tests to meet deadline
✅ Tests are part of the feature, not optional

### Documentation Lag
⚠️ Leaving docs for "later"
✅ Update docs with each commit

## Troubleshooting

### Blocked on Requirements
1. Document specific questions
2. Schedule stakeholder sync
3. Make reasonable assumptions
4. Document assumptions clearly

### Technical Roadblock
1. Research similar implementations
2. Consult team/documentation
3. Consider alternative approaches
4. Document decision rationale

### Time Pressure
1. Identify MVP functionality
2. Negotiate scope reduction
3. Plan phased delivery
4. Document technical debt

## Example Execution

```
User: "Implement user avatar upload feature"

Claude's workflow execution:
1. ✅ Created branch: feature/123-avatar-upload
2. ✅ Reviewed codebase: Found existing image handling in lib/uploads
3. ✅ Planned approach: Reuse upload service, add avatar constraints
4. ✅ Created milestone: 7 subtasks identified
5. 🔄 Implementing with TDD:
   - ✅ Avatar model with size constraints
   - ✅ Upload endpoint with validation
   - 🔄 Frontend component (in progress)
   - ⏳ Integration with user profile
6. 📊 Progress: 3/7 tasks complete, all tests passing
```

Remember: This workflow provides structure while maintaining flexibility. Adapt phases based on feature complexity and constraints, but never skip quality checks or documentation.
