---
module: PlanDesign  
scope: context
triggers: 
  - "organization structure"
  - "script generation"
  - "github planning"
conflicts: []
dependencies:
  - analysis.md
  - _core.md
priority: high
---

# PlanDesign - Organization Structure & Script Generation

## Purpose
Design the GitHub organization structure and generate scripts for creating issues, milestones, and projects.

## Overview
This module takes the analyzed tasks and creates the organizational structure, then generates executable scripts for GitHub integration.

## Phase 4: Organization Structure

### Step 1: Identify Projects (10+ related tasks)
Projects group major feature areas or initiatives:

#### Project Structure
```yaml
project:
  name: "[RepoName] - [Purpose]"
  description: |
    Clear project goals including:
    - What this project achieves
    - Key deliverables
    - Success metrics
  repository: "owner/repo"
  columns:
    - "To Do"
    - "In Progress"
    - "Review"
    - "Done"
```

#### When to Create a Project
- 10 or more related issues
- Major feature area or initiative
- Cross-functional work requiring coordination
- Long-term effort (multiple sprints)

### Step 2: Identify Milestones (5+ related tasks)
Milestones represent achievable goals with deadlines:

#### Milestone Structure
```yaml
milestone:
  title: "v1.0 - MVP Release"
  description: |
    Milestone goals:
    - Core functionality complete
    - Basic documentation
    - Deployment ready
  due_date: "YYYY-MM-DD"
  issues: ["issue-1", "issue-2", ...]
```

#### Milestone Guidelines
- Logical groupings of functionality
- Clear completion criteria
- Realistic timelines (2-6 weeks typical)
- Measurable outcomes

### Step 3: Identify Parent-Child Relationships
Structure complex work hierarchically:

#### Parent Issues (Epics)
```yaml
parent_issue:
  title: "[EPIC] User Authentication System"
  body: |
    ## Overview
    Complete authentication system implementation
    
    ## Child Tasks
    - [ ] #1 Database schema for users
    - [ ] #2 Login endpoint
    - [ ] #3 Registration endpoint
    - [ ] #4 Password reset flow
    
    ## Acceptance Criteria
    - Users can register, login, and reset passwords
    - Secure token-based authentication
    - Rate limiting implemented
```

#### Child Issues
- Specific implementation tasks
- Can be completed independently
- Clear scope and deliverables
- Reference parent in description

### Step 4: Create Labels
Comprehensive labeling strategy:

#### Priority Labels
- `p0-critical`: Immediate action required
- `p1-high`: Core functionality
- `p2-medium`: Important features
- `p3-low`: Nice to have

#### Component Labels
- `backend`: Server-side code
- `frontend`: Client-side code
- `database`: Schema and queries
- `infrastructure`: DevOps and deployment
- `api`: API endpoints and contracts

#### Type Labels
- `enhancement`: New features
- `bug`: Something broken
- `documentation`: Docs needed
- `testing`: Test coverage
- `refactor`: Code improvement

#### Effort Labels
- `effort-S`: < 4 hours
- `effort-M`: 4-16 hours
- `effort-L`: 16-40 hours
- `effort-XL`: > 40 hours

#### Special Labels
- **`plan-generated`**: ALWAYS add to all issues for easy cleanup
- `good-first-issue`: For newcomers
- `help-wanted`: Need assistance
- `blocked`: Waiting on dependency

## Phase 5: Script Generation

### Step 1: Generate Temporary Files
```bash
TEMP_DIR=$(mktemp -d /tmp/plan.XXXXXX)
echo "📁 Generating files in: $TEMP_DIR"

# Repository information
REPO_OWNER=$(gh repo view --json owner -q .owner.login)
REPO_NAME=$(gh repo view --json name -q .name)
```

### Step 2: Create Script Files

#### labels.json
```json
[
  {"name": "plan-generated", "color": "0E8A16", "description": "Created by plan command"},
  {"name": "p0-critical", "color": "B60205", "description": "Immediate action required"},
  {"name": "p1-high", "color": "D93F0B", "description": "High priority"},
  // ... all labels
]
```

#### milestones.json
```json
[
  {
    "title": "Milestone Title",
    "description": "Milestone description",
    "due_on": "2024-12-31T23:59:59Z"
  }
]
```

#### issues.json
```json
[
  {
    "title": "Issue Title",
    "body": "Issue description with markdown",
    "labels": ["plan-generated", "enhancement", "p1-high"],
    "milestone": 1,
    "assignees": []
  }
]
```

#### projects.json
```json
[
  {
    "name": "Project Name",
    "body": "Project description",
    "columns": ["To Do", "In Progress", "Review", "Done"]
  }
]
```

#### execute_plan.sh
```bash
#!/bin/bash
set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🚀 Executing GitHub plan..."

# Create labels
echo "🏷️  Creating labels..."
# ... label creation logic

# Create milestones
echo "🎯 Creating milestones..."
# ... milestone creation logic

# Create issues
echo "📝 Creating issues..."
# ... issue creation logic

# Create projects
echo "📊 Creating projects..."
# ... project creation logic

echo "✅ Plan execution complete!"
```

### Step 3: Save Session Data
```bash
# Copy all artifacts to session directory
cp "$TEMP_DIR"/*.json "$SESSION_DIR/"
cp "$TEMP_DIR"/*.sh "$SESSION_DIR/"

# Create summary
cat > "$SESSION_DIR/summary.md" << EOF
# Planning Session Summary
- Date: $(date)
- Issues: $(jq length issues.json)
- Milestones: $(jq length milestones.json)
- Projects: $(jq length projects.json)
- Labels: $(jq length labels.json)
EOF
```

## Integration

This module:
- Receives task breakdown from `analysis.md`
- Provides scripts to `implementation.md`
- Uses utilities from `_core.md`

## Best Practices

1. **Logical grouping**: Keep related work together
2. **Clear hierarchies**: Use parent-child relationships
3. **Consistent labeling**: Apply all relevant labels
4. **Realistic planning**: Don't overcommit milestones
5. **Always use plan-generated**: For easy cleanup