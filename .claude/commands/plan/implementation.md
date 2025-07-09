---
module: PlanImplementation  
scope: context
triggers: 
  - "plan execution"
  - "github integration"
  - "preview approval"
conflicts: []
dependencies:
  - design.md
  - _core.md
priority: high
---

# PlanImplementation - Preview, Approval & Execution

## Purpose
Handle the preview, approval, and execution phases of the planning process, including GitHub integration.

## Overview
This module manages the final phases where users review the generated plan and execute it to create GitHub resources.

## Phase 6: Preview & Approval

### Step 1: Generate Preview Report

Create comprehensive preview showing what will be created:

```bash
echo "📋 Plan Preview"
echo "=============="
echo ""
echo "📊 Projects: $(jq length projects.json)"
jq -r '.[] | "  • \(.name)"' projects.json
echo ""
echo "🎯 Milestones: $(jq length milestones.json)"
jq -r '.[] | "  • \(.title) (due: \(.due_on | split("T")[0]))"' milestones.json
echo ""
echo "📝 Issues: $(jq length issues.json)"
echo "  By Priority:"
echo "    • P0 (Critical): $(jq '[.[] | select(.labels | contains(["p0-critical"]))] | length' issues.json)"
echo "    • P1 (High): $(jq '[.[] | select(.labels | contains(["p1-high"]))] | length' issues.json)"
echo "    • P2 (Medium): $(jq '[.[] | select(.labels | contains(["p2-medium"]))] | length' issues.json)"
echo "    • P3 (Low): $(jq '[.[] | select(.labels | contains(["p3-low"]))] | length' issues.json)"
echo ""
echo "🏷️  Labels: $(jq length labels.json)"
```

### Step 2: Display Sample Issues

Show a few example issues for review:

```bash
echo "📄 Sample Issues (first 3):"
echo "=========================="
jq -r '.[:3] | .[] | "
Title: \(.title)
Labels: \(.labels | join(", "))
Priority: \(.labels[] | select(startswith("p")))
Effort: \(.labels[] | select(startswith("effort")))
---"' issues.json
```

### Step 3: Approval Prompt

```bash
echo ""
echo "🤔 Review the plan above. Options:"
echo "1) Execute - Create all items in GitHub"
echo "2) Preview files - See generated JSON files"
echo "3) Edit - Modify the plan"
echo "4) Cancel - Exit without creating anything"
echo ""
read -p "Choose option (1-4): " choice
```

### Step 4: Handle User Choice

#### Option 1: Execute
Proceed to Phase 7 execution

#### Option 2: Preview Files
```bash
echo "📁 Generated files in: $TEMP_DIR"
ls -la "$TEMP_DIR"
echo ""
echo "View a specific file? (or press Enter to continue)"
read -p "Filename: " filename
if [ -n "$filename" ]; then
    cat "$TEMP_DIR/$filename" | jq .
fi
```

#### Option 3: Edit
Allow modifications:
- Edit issue titles/descriptions
- Adjust priorities
- Modify labels
- Update milestones

#### Option 4: Cancel
Clean up and exit:
```bash
echo "❌ Plan cancelled. Cleaning up..."
rm -rf "$TEMP_DIR"
echo "✅ Cleanup complete. No changes made to GitHub."
```

## Phase 7: Execution & Tracking

### Step 1: Pre-execution Checks

```bash
# Verify GitHub CLI is authenticated
if ! gh auth status &>/dev/null; then
    echo "❌ Error: Not authenticated with GitHub CLI"
    echo "Run: gh auth login"
    exit 1
fi

# Verify we're in a git repository
if ! git rev-parse --git-dir &>/dev/null; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

# Check repository access
if ! gh repo view &>/dev/null; then
    echo "❌ Error: Cannot access repository"
    exit 1
fi
```

### Step 2: Execute Plan

Run the generated script:

```bash
echo "🚀 Starting execution..."
bash "$TEMP_DIR/execute_plan.sh"
```

### Step 3: Track Progress

The execution script should:

#### Create Labels
```bash
echo "🏷️  Creating labels..."
for label in $(jq -r '.[] | @base64' labels.json); do
    _jq() {
        echo ${label} | base64 --decode | jq -r ${1}
    }
    
    name=$(_jq '.name')
    color=$(_jq '.color')
    description=$(_jq '.description')
    
    if gh label create "$name" --color "$color" --description "$description" 2>/dev/null; then
        echo "  ✅ Created label: $name"
    else
        echo "  ⏭️  Label exists: $name"
    fi
done
```

#### Create Milestones
```bash
echo "🎯 Creating milestones..."
milestone_map="{}"
index=1
for milestone in $(jq -r '.[] | @base64' milestones.json); do
    _jq() {
        echo ${milestone} | base64 --decode | jq -r ${1}
    }
    
    title=$(_jq '.title')
    description=$(_jq '.description')
    due_on=$(_jq '.due_on')
    
    number=$(gh api repos/:owner/:repo/milestones \
        --method POST \
        --field title="$title" \
        --field description="$description" \
        --field due_on="$due_on" \
        --jq '.number')
    
    milestone_map=$(echo $milestone_map | jq ". + {\"$index\": $number}")
    echo "  ✅ Created milestone: $title (#$number)"
    ((index++))
done
```

#### Create Issues
```bash
echo "📝 Creating issues..."
for issue in $(jq -r '.[] | @base64' issues.json); do
    _jq() {
        echo ${issue} | base64 --decode | jq -r ${1}
    }
    
    title=$(_jq '.title')
    body=$(_jq '.body')
    labels=$(_jq '.labels | join(",")')
    milestone_index=$(_jq '.milestone // 0')
    
    # Map milestone index to actual number
    if [ "$milestone_index" -ne 0 ]; then
        milestone_number=$(echo $milestone_map | jq -r ".\"$milestone_index\"")
        milestone_flag="--milestone $milestone_number"
    else
        milestone_flag=""
    fi
    
    number=$(gh issue create \
        --title "$title" \
        --body "$body" \
        --label "$labels" \
        $milestone_flag \
        --repo $REPO_OWNER/$REPO_NAME | grep -o '[0-9]*$')
    
    echo "  ✅ Created issue: $title (#$number)"
done
```

### Step 4: Post-execution

```bash
# Save execution results
cat > "$SESSION_DIR/execution-results.md" << EOF
# Execution Results
- Date: $(date)
- Repository: $REPO_OWNER/$REPO_NAME
- Labels created: $(gh label list --json name | jq '. | length')
- Milestones created: $(gh api repos/:owner/:repo/milestones | jq '. | length')
- Issues created: $(gh issue list --label plan-generated --json number | jq '. | length')
EOF

# Show summary
echo ""
echo "✅ Plan execution complete!"
echo ""
echo "📊 Summary:"
cat "$SESSION_DIR/execution-results.md"
echo ""
echo "🔗 View in GitHub:"
echo "  • Issues: https://github.com/$REPO_OWNER/$REPO_NAME/issues?q=label:plan-generated"
echo "  • Milestones: https://github.com/$REPO_OWNER/$REPO_NAME/milestones"
echo "  • Projects: https://github.com/$REPO_OWNER/$REPO_NAME/projects"
```

## Error Recovery

Handle common errors gracefully:
- Network failures: Retry with exponential backoff
- Rate limiting: Pause and resume
- Duplicate items: Skip and continue
- Partial completion: Save state for resume

## Integration

This module:
- Receives scripts from `design.md`
- Uses utilities from `_core.md`
- Integrates with GitHub via CLI

## Best Practices

1. **Always preview first**: Let users review before execution
2. **Provide escape routes**: Allow cancellation at any point
3. **Track progress**: Show what's being created
4. **Handle errors gracefully**: Don't leave partial state
5. **Save everything**: Keep records of what was created