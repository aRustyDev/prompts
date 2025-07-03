---
name: report
description: Create GitHub issues for bugs and feature requests in the prompts repository
author: Claude
version: 1.0.0
---

# Command: /report

Create GitHub issues to report bugs or request features for the slash-command system in https://github.com/aRustyDev/prompts.

## Usage
```
/report <subcommand> [options]
```

## Subcommands
- `bug` - Report something broken or unexpected about Claude's behavior with prompts
- `feature` - Request new slash-commands, concepts, roles, guides, patterns, etc.

## Process Dependencies
```yaml
processes:
  - name: issue-tracking/github-issues
    version: ">=1.0.0"
    usage: "Core issue creation and management"
    
  - name: data-sanitization
    version: ">=1.0.0" 
    usage: "Sanitize conversation context before including in issues"
```

## Subcommand: bug

Report issues with Claude's behavior when using slash-commands.

### Usage
```
/report bug [--quick] [--type <bug-type>] [--command <command-name>]
```

### Options
- `--quick` - Skip interactive prompts, use defaults where possible
- `--type` - Specify bug type (execution-error, unexpected-behavior, missing-behavior, performance, documentation, logic-order, other)
- `--command` - Specify the command that exhibited the bug

### Interactive Mode Workflow

1. **Context Collection**
   ```bash
   # Auto-detect current command context
   CURRENT_COMMAND=$(echo "$CONVERSATION_CONTEXT" | grep -E "^/[a-zA-Z]+" | tail -1)
   
   # Capture environment
   CLAUDE_VERSION="${CLAUDE_MODEL:-unknown}"
   PROMPTS_VERSION=$(cd ~/.claude && git rev-parse --short HEAD 2>/dev/null || echo "unknown")
   ```

2. **Bug Type Selection**
   ```
   What type of bug are you reporting?
   1) Command execution error
   2) Unexpected behavior
   3) Missing expected behavior
   4) Performance issue
   5) Documentation mismatch
   6) Logical order issue
   7) Other
   ```

3. **Information Gathering**
   Based on bug type, load appropriate template from `templates/issues/bugs/`:
   - `execution-error.md`
   - `unexpected-behavior.md`
   - `missing-behavior.md`
   - `performance-issue.md`
   - `documentation-mismatch.md`
   - `logic-order.md`
   - `other-bug.md`

4. **Context Sanitization**
   ```bash
   # Use data-sanitization process
   SANITIZED_CONTEXT=$(echo "$CONVERSATION_CONTEXT" | \
     ~/.claude/processes/data-sanitization.sh --remove-pii --truncate 1000)
   ```

5. **Issue Creation**
   ```bash
   # Create issue using gh CLI
   gh issue create \
     --repo "aRustyDev/prompts" \
     --title "$ISSUE_TITLE" \
     --body "$ISSUE_BODY" \
     --label "bug,$BUG_TYPE_LABEL" \
     --assignee "@me"
   ```

### Quick Mode Workflow

```bash
# Example usage
/report bug --quick --type execution-error --command "/test"

# Automatically:
# 1. Uses execution-error template
# 2. Captures last 500 lines of context
# 3. Creates issue with minimal prompts
```

## Subcommand: feature

Request new functionality for the slash-command system.

### Usage
```
/report feature [--quick] [--type <feature-type>] [--title <title>]
```

### Options
- `--quick` - Skip interactive prompts where possible
- `--type` - Feature type (command, pattern, role, guide, process, workflow, helper, template, meta, other)
- `--title` - Feature title for quick mode

### Interactive Mode Workflow

1. **Feature Type Selection**
   ```
   What type of feature are you requesting?
   1) command - New slash command
   2) pattern - Development or design pattern
   3) role - Expert role or persona
   4) guide - How-to documentation
   5) process - Reusable process/procedure
   6) workflow - Multi-step workflow
   7) helper - Utility or helper function
   8) template - Reusable template
   9) meta - Meta-level improvement
   10) other - Create new type
   ```

2. **Type-Specific Templates**
   Load template from `templates/issues/features/`:
   - `command-request.md`
   - `pattern-request.md`
   - `role-request.md`
   - `guide-request.md`
   - `process-request.md`
   - `workflow-request.md`
   - `helper-request.md`
   - `template-request.md`
   - `meta-request.md`
   - `other-feature.md`

3. **Context Enhancement**
   ```bash
   # Detect related commands/processes
   RELATED_ITEMS=$(find ~/.claude -name "*.md" | xargs grep -l "$FEATURE_KEYWORDS" | head -5)
   ```

4. **Label Assignment**
   ```bash
   # Auto-apply labels based on type
   LABELS="enhancement,$FEATURE_TYPE"
   
   # Add additional context labels
   if [[ "$FEATURE_TYPE" == "command" ]]; then
     LABELS="$LABELS,slash-command"
   fi
   ```

5. **Issue Creation**
   ```bash
   gh issue create \
     --repo "aRustyDev/prompts" \
     --title "$FEATURE_TITLE" \
     --body "$ISSUE_BODY" \
     --label "$LABELS"
   ```

### Creating New Types

When "other" is selected:
```bash
read -p "Enter the new type name: " NEW_TYPE
read -p "Describe this type: " TYPE_DESCRIPTION

# Create new directory if needed
mkdir -p "~/.claude/$NEW_TYPE"

# Create template
cat > "~/.claude/templates/issues/features/${NEW_TYPE}-request.md" << EOF
# ${NEW_TYPE^} Request Template

## Description
$TYPE_DESCRIPTION

## Details
[Provide specific details about the $NEW_TYPE]

## Use Cases
[When and why would this be used?]

## Examples
[Provide examples if applicable]
EOF
```

## Implementation Details

### Environment Detection
```bash
# Function to gather environment info
gather_environment() {
  echo "## Environment"
  echo "- Claude Model: ${CLAUDE_MODEL:-unknown}"
  echo "- Claude Version: ${CLAUDE_VERSION:-unknown}"
  echo "- Prompts Version: $(cd ~/.claude && git describe --tags --always 2>/dev/null || echo 'unknown')"
  echo "- Platform: $(uname -s)"
  echo "- Date: $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
  echo "- Session ID: ${CLAUDE_SESSION_ID:-unknown}"
}
```

### Context Capture
```bash
# Function to capture and sanitize context
capture_context() {
  local LINES="${1:-500}"
  
  # Get recent conversation context
  if [ -n "$CLAUDE_CONVERSATION_FILE" ]; then
    tail -n "$LINES" "$CLAUDE_CONVERSATION_FILE" | \
      ~/.claude/processes/data-sanitization.sh --remove-pii
  else
    echo "[No conversation context available]"
  fi
}
```

### Template Population
```bash
# Function to populate template variables
populate_template() {
  local TEMPLATE="$1"
  
  # Replace all template variables
  sed -e "s/\${COMMAND}/$CURRENT_COMMAND/g" \
      -e "s/\${CLAUDE_VERSION}/$CLAUDE_VERSION/g" \
      -e "s/\${PROMPTS_VERSION}/$PROMPTS_VERSION/g" \
      -e "s/\${TIMESTAMP}/$(date -u)/g" \
      -e "s/\${USER}/${USER:-unknown}/g" \
      "$TEMPLATE"
}
```

## Error Handling

- Check for `gh` CLI installation
- Verify GitHub authentication
- Validate repository access
- Handle network failures gracefully
- Provide fallback to clipboard copy if issue creation fails

## Success Metrics

- Issue creation time < 30 seconds
- All required context captured automatically
- 90%+ of issues have sufficient detail for action
- Proper categorization and labeling

## Implementation

When this command is invoked, Claude will:

1. **Parse Arguments**: Determine subcommand and options
2. **Gather Context**: Automatically collect environment and conversation data
3. **Interactive Flow**: Guide through appropriate template selection
4. **Populate Template**: Fill in all variables with gathered information
5. **Create Issue**: Use GitHub CLI to create the issue immediately

### Example Execution Flow

For bug reporting:
```
User: /report bug
Claude: I'll help you report a bug. Let me gather some context first...

Auto-detected command: /cicd
Environment: Claude Opus 4, Prompts v1.2.3

What type of bug are you reporting?
1) Command execution error
2) Unexpected behavior
3) Missing expected behavior
4) Performance issue
5) Documentation mismatch
6) Logical order issue
7) Other

User: 2
Claude: I'll use the unexpected behavior template. Please describe what unexpected behavior you encountered...

[Claude guides through template completion]

Creating issue on GitHub...
✅ Issue created: https://github.com/aRustyDev/prompts/issues/123
```

For feature requests:
```
User: /report feature --quick --type command --title "Add /analyze command"
Claude: Creating feature request for new command...
✅ Issue created: https://github.com/aRustyDev/prompts/issues/124
```