---
name: capture-todos
description: Analyze TODO.md files in the repository and convert them to GitHub issues with proper organization
author: Claude Code
version: 1.2.0
---

# Capture TODOs Command

You will help analyze TODO.md files in this repository and convert them into well-organized GitHub issues. Follow these steps carefully:

## Phase 1: Discovery
1. Search for all TODO.md files in the repository using: `find . -name "TODO.md" -o -name "todo.md" | grep -v node_modules | grep -v .git`
2. List all found files and ask the user to confirm which ones to analyze

## Phase 2: Analysis
For each TODO.md file:
1. Read the file contents
2. Parse TODO items considering various formats:
   - Markdown headers as categories
   - List items (-, *, +, numbered)
   - Checkbox items [ ] (unchecked only)
   - Priority indicators ([HIGH], [!!], etc.)
   - Tags (#tag format)

## Phase 3: Git History Context
For each TODO item:
1. Use `git blame` to find when it was last modified
2. Use `git log -S` to track its evolution
3. Identify related code changes and commits
4. Note the context of when and why it was added

## Phase 4: Deduplication & Grouping
1. Identify similar or duplicate TODOs across files
2. Group related items by:
   - Category/header
   - Similar content
   - Common tags
   - Related functionality
3. Present grouped TODOs showing:
   - Original text
   - File location
   - Git context
   - Suggested grouping

## Phase 5: Interactive Validation
For each TODO or group:
1. Display the TODO with all context
2. If unclear or vague, ask for clarification:
   - "Fix the thing" → What specifically needs fixing?
   - Missing context → What is the goal?
   - Technical jargon → What does this mean?
3. Allow user to:
   - Clarify titles
   - Add descriptions
   - Skip items
   - Merge duplicates

## Phase 6: Issue Planning
Create a structured plan:

### Organizational Units
- **Milestones**: For groups with 5+ related items
- **Projects**: For groups with 10+ items or complex workflows
  - Projects MUST be linked to the current repository
  - Use repository-scoped projects for better integration
- **Labels**: Based on categories, priorities, and tags

### Issue Hierarchy
- **Parent Issues**: For groups of related TODOs
- **Individual Issues**: For each TODO
- **Sub-tasks**: For TODOs with nested items

### Issue Templates
For each issue, include:
- Clear, actionable title
- Description with context
- Source reference (file:line)
- Git history context
- Acceptance criteria
- Labels and categorization

## Phase 7: Plan Presentation
Present the complete plan showing:
```
📋 ISSUE CREATION PLAN
====================

🎯 Milestones to create: X
  - Milestone Name
    Description: ...

📊 Projects to create: Y
  - Project Name
    Description: ...

🐛 Issues to create: Z
  - Parent Issue: Title
    - Child: Specific task
    - Child: Another task
  - Standalone: Independent task

Labels to use: [list of labels]
```

## Phase 8: Approval & Execution
1. Ask: "Ready to create these issues? (y/n)"
2. If approved, execute using `gh` CLI:
   - Create milestones first
   - Create projects and link them to the repository (requires two steps):
     ```bash
     # Step 1: Get repository ID
     REPO_ID=$(gh api repos/:owner/:repo --jq .node_id)
     
     # Step 2: Create project (returns project URL)
     PROJECT_URL=$(gh project create --owner @me --title "Project Name" --format json | jq -r '.url')
     
     # Step 3: Extract project ID from URL
     PROJECT_ID=$(gh api graphql -f query='
       query($url: URI!) {
         resource(url: $url) {
           ... on ProjectV2 {
             id
           }
         }
       }' -f url="$PROJECT_URL" --jq '.data.resource.id')
     
     # Step 4: Link project to repository
     gh api graphql -f query='
       mutation($projectId: ID!, $repoId: ID!) {
         linkProjectV2ToRepository(input: {
           projectId: $projectId
           repositoryId: $repoId
         }) {
           repository {
             name
           }
         }
       }' -f projectId="$PROJECT_ID" -f repoId="$REPO_ID"
     ```
   - Create parent issues
   - Create child issues with parent references
   - Add issues to projects/milestones

## Important Guidelines

### DO:
- Preserve ALL context from git history
- Ask for clarification on vague items
- Group intelligently
- Create hierarchical structure
- Use descriptive titles
- Reference source locations

### DON'T:
- Create issues without approval
- Skip validation for unclear items
- Lose track of source files
- Create duplicate issues
- Ignore git context

## Error Handling
- If `gh` CLI isn't available, provide instructions for installation
- If not in a git repository, skip git analysis
- If no TODO files found, inform user and suggest locations

## Example Interaction
```
User: /project:capture-todos

Claude: 🔍 Searching for TODO.md files...
Found 3 TODO files:
1. ./TODO.md
2. ./docs/TODO.md
3. ./src/TODO.md

Shall I analyze all of these? (y/n)

[User confirms]

📝 Analyzing ./TODO.md...
Found 12 TODO items in 4 categories...

[Continues through all phases]
```

## Project Creation Details

When creating GitHub projects:
1. **Two-step process required**: GitHub CLI doesn't support creating repository-linked projects in one command
2. **Always link to repository**: Use GraphQL API after creation to establish the link
3. **Choose appropriate visibility**: Default to repository visibility
4. **Add useful fields**: Status, Priority, Assignee, Due Date
5. **Create views**: Board view for workflow, Table view for overview

### Complete project creation and linking example:
```bash
# Step 1: Get repository details
OWNER=$(gh repo view --json owner -q .owner.login)
REPO_NAME=$(gh repo view --json name -q .name)
REPO_ID=$(gh api repos/$OWNER/$REPO_NAME --jq .node_id)

# Step 2: Create project at user level (returns project details)
PROJECT_JSON=$(gh project create \
  --owner @me \
  --title "TODO Migration - $(date +%Y-%m-%d)" \
  --format json)

PROJECT_NUMBER=$(echo "$PROJECT_JSON" | jq -r '.number')
PROJECT_URL=$(echo "$PROJECT_JSON" | jq -r '.url')

# Step 3: Get project ID (needed for linking)
PROJECT_ID=$(gh api graphql -f query='
  query($url: URI!) {
    resource(url: $url) {
      ... on ProjectV2 {
        id
      }
    }
  }' -f url="$PROJECT_URL" --jq '.data.resource.id')

# Step 4: Link project to repository
gh api graphql -f query='
  mutation($projectId: ID!, $repoId: ID!) {
    linkProjectV2ToRepository(input: {
      projectId: $projectId
      repositoryId: $repoId
    }) {
      repository {
        name
      }
    }
  }' -f projectId="$PROJECT_ID" -f repoId="$REPO_ID"

echo "✅ Project #$PROJECT_NUMBER created and linked to $OWNER/$REPO_NAME"

# Step 5: Add issues to project
gh project item-add $PROJECT_NUMBER --owner @me --url "$ISSUE_URL"
```

### Why this complexity?
- GitHub CLI's `gh project create` doesn't have a `--repository` flag
- Projects must be created first, then linked via GraphQL API
- This is a current limitation of GitHub's implementation

Remember: The goal is to transform scattered TODO items into a well-organized, actionable issue tracking system that preserves context and facilitates project management.