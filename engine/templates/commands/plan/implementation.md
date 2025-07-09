# Plan Command - Implementation Module
Task breakdown and GitHub integration

## Module Info
- Name: implementation
- Type: plan-phase
- Parent: commands/plan
- Dependencies: [design.md, _core.md]

## Description
Handles the implementation phase of planning, including task breakdown, GitHub issue creation, and progress tracking.

## Phase Template

### Task Breakdown
```yaml
task_breakdown:
  description: |
    Break design into executable tasks
  structure:
    - epics: High-level feature groups
    - stories: User-facing functionality
    - tasks: Technical implementation units
    - subtasks: Granular work items
```

### GitHub Integration
```yaml
github_integration:
  description: |
    Create and manage GitHub issues
  features:
    - issue_creation: Automated issue generation
    - label_management: Categorization and filtering
    - milestone_tracking: Progress monitoring
    - project_boards: Visual workflow management
```

### Progress Tracking
```yaml
progress_tracking:
  description: |
    Monitor implementation progress
  metrics:
    - completion_rate: Tasks completed vs total
    - velocity: Work completed per time unit
    - blockers: Impediments to progress
    - burndown: Remaining work over time
```

## Task Templates

### Epic Template
```yaml
epic:
  title: "{{feature_name}}"
  description: |
    ## Overview
    {{overview}}
    
    ## Acceptance Criteria
    {{#each criteria}}
    - [ ] {{this}}
    {{/each}}
    
    ## Child Stories
    {{#each stories}}
    - #{{number}} {{title}}
    {{/each}}
  labels: [epic, {{priority}}]
  milestone: "{{milestone}}"
```

### Story Template
```yaml
story:
  title: "As a {{user}}, I want {{goal}} so that {{benefit}}"
  description: |
    ## User Story
    {{story_details}}
    
    ## Acceptance Criteria
    {{#each criteria}}
    - [ ] {{this}}
    {{/each}}
    
    ## Technical Tasks
    {{#each tasks}}
    - [ ] #{{number}} {{title}}
    {{/each}}
    
    ## Dependencies
    {{#each dependencies}}
    - {{type}}: {{description}}
    {{/each}}
  labels: [story, {{component}}, {{priority}}]
  assignee: "{{assignee}}"
  estimate: {{points}}
```

### Task Template
```yaml
task:
  title: "{{verb}} {{component}}"
  description: |
    ## Description
    {{description}}
    
    ## Implementation Details
    {{#each details}}
    - {{this}}
    {{/each}}
    
    ## Definition of Done
    {{#each done_criteria}}
    - [ ] {{this}}
    {{/each}}
    
    ## Testing Requirements
    {{#each tests}}
    - [ ] {{type}}: {{description}}
    {{/each}}
  labels: [task, {{type}}, {{component}}]
  parent: "#{{story_number}}"
```

## GitHub Commands

### Issue Creation
```bash
# Create epic with stories
claude plan implement create-epic \
  --title "User Authentication" \
  --stories "login,registration,password-reset" \
  --milestone "v1.0"

# Create story with tasks
claude plan implement create-story \
  --title "User Login" \
  --tasks "api-endpoint,ui-form,validation,tests" \
  --epic "#123"

# Bulk create from plan
claude plan implement create-all \
  --plan "implementation-plan.md" \
  --project "MyProject" \
  --dry-run
```

### Project Management
```bash
# Setup project board
claude plan implement setup-board \
  --name "Sprint 1" \
  --columns "Backlog,In Progress,Review,Done"

# Link issues to project
claude plan implement link-issues \
  --project "Sprint 1" \
  --issues "123,124,125"

# Update progress
claude plan implement update-progress \
  --issue "123" \
  --status "in-progress" \
  --comment "Started implementation"
```

## Prompts

### Task Breakdown Prompt
```
Break down the following design into implementation tasks:

Design: {{design_summary}}
Components: {{components}}
Timeline: {{timeline}}

Provide:
1. Epic-level features
2. User stories per epic
3. Technical tasks per story
4. Effort estimates
5. Dependencies
6. Suggested sprint allocation
```

### GitHub Issue Generation Prompt
```
Generate GitHub issues for:

Project: {{project_name}}
Milestone: {{milestone}}
Tasks: {{task_list}}

Format each as:
- Title (clear and actionable)
- Description (context and requirements)
- Labels (type, component, priority)
- Assignee (if specified)
- Estimate (if applicable)
```

## Outputs

### Implementation Plan Template
```markdown
# Implementation Plan: {{project_name}}

## Overview
{{plan_overview}}

## Timeline
- **Start Date**: {{start_date}}
- **Target Completion**: {{end_date}}
- **Sprints**: {{sprint_count}}

## Epics
{{#each epics}}
### {{title}} ({{points}} points)
**Goal**: {{goal}}
**Stories**: {{story_count}}
**Target Sprint**: {{sprint}}
{{/each}}

## Sprint Plan
{{#each sprints}}
### Sprint {{number}}: {{name}}
**Duration**: {{start}} - {{end}}
**Points**: {{total_points}}

#### Goals
{{#each goals}}
- {{this}}
{{/each}}

#### Stories
{{#each stories}}
- {{title}} ({{points}} pts) - {{assignee}}
{{/each}}
{{/each}}

## Task Breakdown
{{#each tasks}}
### {{id}}: {{title}}
**Type**: {{type}}
**Component**: {{component}}
**Estimate**: {{estimate}}
**Dependencies**: {{dependencies}}
**Assignee**: {{assignee}}

#### Description
{{description}}

#### Acceptance Criteria
{{#each criteria}}
- [ ] {{this}}
{{/each}}
{{/each}}

## Risk Mitigation
{{#each risks}}
### {{title}}
**Probability**: {{probability}}
**Impact**: {{impact}}
**Mitigation**: {{mitigation}}
{{/each}}

## Success Metrics
{{#each metrics}}
- **{{name}}**: {{target}} ({{measurement}})
{{/each}}
```

### GitHub Script Template
```bash
#!/bin/bash
# Generated by Claude Plan Implementation

# Configuration
REPO="{{repo}}"
MILESTONE="{{milestone}}"
PROJECT="{{project}}"

# Create milestone
gh api repos/$REPO/milestones \
  -f title="{{milestone}}" \
  -f description="{{milestone_description}}" \
  -f due_on="{{due_date}}"

# Create epics
{{#each epics}}
gh issue create \
  --repo $REPO \
  --title "{{title}}" \
  --body "{{body}}" \
  --label "epic,{{labels}}" \
  --milestone "$MILESTONE"
{{/each}}

# Create stories and tasks
{{#each issues}}
gh issue create \
  --repo $REPO \
  --title "{{title}}" \
  --body "{{body}}" \
  --label "{{labels}}" \
  --assignee "{{assignee}}" \
  --milestone "$MILESTONE"
{{/each}}

# Setup project board
gh project create \
  --owner {{owner}} \
  --title "$PROJECT" \
  --body "{{project_description}}"
```

## Integration Points

### Input from Design
- Architecture blueprints
- API specifications
- Component definitions
- Technology decisions

### Output
- GitHub issues created
- Project board configured
- Sprint plan established
- Progress tracking enabled

## Progress Tracking

### Metrics
```yaml
velocity_tracking:
  daily:
    - tasks_completed
    - points_burned
    - blockers_raised
  
  weekly:
    - sprint_progress
    - velocity_trend
    - risk_assessment
  
  sprint:
    - goals_achieved
    - velocity_average
    - retrospective_items
```

### Reporting Templates
```markdown
## Daily Standup
**Date**: {{date}}
**Sprint**: {{sprint}} (Day {{day}})

### Progress
- Completed: {{completed_count}} tasks ({{completed_points}} points)
- In Progress: {{in_progress_count}} tasks
- Blocked: {{blocked_count}} tasks

### Blockers
{{#each blockers}}
- **#{{issue}}**: {{description}} ({{age}} days)
{{/each}}

### Today's Focus
{{#each focus_items}}
- {{assignee}}: {{task}}
{{/each}}
```

## Best Practices

### Task Breakdown
1. Keep tasks under 8 hours of effort
2. Make tasks independently testable
3. Include clear acceptance criteria
4. Identify dependencies upfront
5. Assign realistic estimates

### GitHub Management
1. Use consistent labeling schemes
2. Link related issues
3. Keep descriptions updated
4. Close issues with commits
5. Regular milestone reviews

### Progress Tracking
1. Update daily
2. Address blockers immediately
3. Communicate delays early
4. Celebrate completions
5. Learn from velocity trends

## See Also
- [design.md](design.md) - Architecture and design phase
- [cleanup.md](cleanup.md) - Plan artifact cleanup
- [_core.md](_core.md) - Core planning utilities