# Command.md Split Analysis
Generated: January 9, 2025
Current size: 440 lines

## Suggested Splits from module-size-validator

### Module 1: examples.md (6 lines)
```markdown
## Usage

```
/project:command [init|update|review]
```
```

### Module 2: phase-2-process-detection-analysis.md (73 lines)
Contains process detection and analysis logic

### Module 3: phase-3-requirements-gathering.md (estimated ~80 lines)
Requirements gathering phase logic

### Module 4: phase-4-implementation.md (estimated ~90 lines)
Implementation phase logic

### Module 5: shared-utilities.md (estimated ~60 lines)
Common utilities and helper functions

## Proposed Structure
```
commands/
  command/
    .meta.md           # Directory metadata
    init.md            # /command init subcommand
    update.md          # /command update subcommand
    review.md          # /command review subcommand
    process-detection.md  # Process detection logic
    _shared.md         # Shared utilities
```

## Dependencies to Update
- Any files referencing "commands/command.md"
- Module registry in manifest.md
- Help documentation