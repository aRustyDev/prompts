# Report.md Split Analysis
Generated: January 9, 2025
Current size: 609 lines

## Suggested Splits from module-size-validator

### Initial Analysis
The validator suggests splitting into modules including:
- examples.md (80 lines) - Usage examples
- interactive-mode-workflow.md (88 lines) - Interactive workflows
- Additional modules for different report types

## Proposed Structure
```
commands/
  report/
    .meta.md           # Directory metadata
    bug.md             # Bug reports (~120 lines)
    feature.md         # Feature reports (~120 lines)
    improvement.md     # Improvement reports (~120 lines)
    security.md        # Security reports (~120 lines)
    audit.md           # Audit reports (~80 lines)
    _templates.md      # Report templates (~50 lines)
```

## Report Types to Extract
1. **Bug Reports**
   - Bug report templates
   - Reproduction steps
   - Debug information collection
   - Quick vs detailed modes

2. **Feature Reports**
   - Feature proposals
   - Requirements documentation
   - Impact analysis
   - Interactive feature builder

3. **Improvement Reports**
   - Performance improvements
   - Code quality improvements
   - Process improvements
   - Metrics collection

4. **Security Reports**
   - Vulnerability reports
   - Security assessments
   - Mitigation strategies
   - CVE references

5. **Audit Reports**
   - Repository audits
   - Code quality audits
   - Performance audits
   - Compliance checks

## Dependencies to Update
- Files referencing "commands/report.md"
- Report generation workflows
- Template references
- Help documentation