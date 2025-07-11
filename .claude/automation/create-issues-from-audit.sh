#!/bin/bash
# create-issues-from-audit.sh - Create GitHub issues from audit findings

set -e

# Default values
AUDIT_FILE=""
THRESHOLD="high"
DRY_RUN=false
MAX_ISSUES=10

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --audit-file)
            AUDIT_FILE="$2"
            shift 2
            ;;
        --threshold)
            THRESHOLD="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --max-issues)
            MAX_ISSUES="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Validate inputs
if [ -z "$AUDIT_FILE" ] || [ ! -f "$AUDIT_FILE" ]; then
    echo "Error: Valid audit file required (--audit-file)"
    exit 1
fi

# Function to create issue from finding
create_issue() {
    local severity=$1
    local category=$2
    local title=$3
    local description=$4
    local action=$5
    
    # Determine labels based on severity and category
    local labels="audit-finding,$severity"
    case $category in
        "dependencies")
            labels="$labels,dependencies"
            ;;
        "modules")
            labels="$labels,module-quality"
            ;;
        "security")
            labels="$labels,security"
            ;;
        "performance")
            labels="$labels,performance"
            ;;
    esac
    
    # Create issue body
    local body="## Audit Finding

**Severity**: $severity
**Category**: $category
**Date**: $(date +%Y-%m-%d)

### Description
$description

### Recommended Action
$action

### Context
This issue was automatically created from the monthly repository audit.

---
*Generated by Claude Audit System*"

    if $DRY_RUN; then
        echo "DRY RUN - Would create issue:"
        echo "  Title: $title"
        echo "  Labels: $labels"
        echo ""
    else
        gh issue create \
            --title "$title" \
            --body "$body" \
            --label "$labels" || echo "Failed to create issue: $title"
    fi
}

# Function to parse JSON and extract findings
parse_findings() {
    local audit_file=$1
    local threshold=$2
    
    # Use Python to parse JSON and extract findings
    python3 -c "
import json
import sys

with open('$audit_file', 'r') as f:
    audit = json.load(f)

findings = audit.get('findings', [])
threshold_priority = {'critical': 0, 'high': 1, 'medium': 2, 'low': 3}
threshold_val = threshold_priority.get('$threshold', 1)

count = 0
for finding in findings:
    severity = finding.get('severity', 'medium')
    if threshold_priority.get(severity, 2) <= threshold_val and count < $MAX_ISSUES:
        print(f\"{severity}|{finding.get('category', 'general')}|{finding.get('title', 'Untitled')}|{finding.get('description', '')}|{finding.get('action', 'Review and fix')}\")
        count += 1
"
}

# Main execution
echo "🔍 Creating issues from audit findings..."
echo "Audit file: $AUDIT_FILE"
echo "Threshold: $THRESHOLD and above"
echo "Max issues: $MAX_ISSUES"

if $DRY_RUN; then
    echo "Mode: DRY RUN"
fi

echo ""

# Parse findings and create issues
ISSUES_CREATED=0

while IFS='|' read -r severity category title description action; do
    if [ -n "$title" ]; then
        echo "Creating issue for: $title"
        create_issue "$severity" "$category" "$title" "$description" "$action"
        ((ISSUES_CREATED++))
    fi
done < <(parse_findings "$AUDIT_FILE" "$THRESHOLD")

echo ""
echo "✅ Process complete"
echo "Issues created: $ISSUES_CREATED"

# If no issues were created but there were findings, suggest lowering threshold
if [ $ISSUES_CREATED -eq 0 ]; then
    total_findings=$(python3 -c "import json; f=open('$AUDIT_FILE'); print(len(json.load(f).get('findings', [])))")
    if [ "$total_findings" -gt 0 ]; then
        echo "ℹ️  No issues created at threshold '$THRESHOLD'. Total findings: $total_findings"
        echo "   Consider lowering threshold or checking audit results manually."
    fi
fi