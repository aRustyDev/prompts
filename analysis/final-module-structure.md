# Final Module Structure Design
Generated: January 9, 2025

## Overview
Based on the analysis of the three large command files, here is the final module structure design that ensures all modules are under 200 lines (target: ~150 lines).

## Directory Structure

```
.claude/commands/
├── command/
│   ├── .meta.md              # Directory metadata & routing
│   ├── init.md               # /command init (~120 lines)
│   ├── update.md             # /command update (~100 lines)
│   ├── review.md             # /command review (~100 lines)
│   ├── process-detection.md  # Process detection logic (~80 lines)
│   └── _shared.md            # Shared utilities (~40 lines)
│
├── plan/
│   ├── .meta.md              # Directory metadata & routing
│   ├── discovery.md          # Discovery phase (~140 lines)
│   ├── analysis.md           # Analysis phase (~140 lines)
│   ├── design.md             # Design phase (~140 lines)
│   ├── implementation.md     # Implementation phase (~140 lines)
│   ├── cleanup.md            # Cleanup utilities (~80 lines)
│   └── _core.md              # Core planning logic (~40 lines)
│
└── report/
    ├── .meta.md              # Directory metadata & routing
    ├── bug.md                # Bug reports (~110 lines)
    ├── feature.md            # Feature reports (~110 lines)
    ├── improvement.md        # Improvement reports (~110 lines)
    ├── security.md           # Security reports (~110 lines)
    ├── audit.md              # Audit reports (~90 lines)
    ├── _templates.md         # Report templates (~40 lines)
    └── _interactive.md       # Interactive workflows (~40 lines)
```

## Module Details

### Command Modules (Total: 5 modules from 440 lines)

#### command/.meta.md
```yaml
---
module: CommandManagement
description: Slash command creation, update, and review system
version: 3.1.0
submodules:
  - init.md
  - update.md
  - review.md
  - process-detection.md
  - _shared.md
routing:
  default: init
  subcommands:
    init: init.md
    update: update.md
    review: review.md
---
```

#### Module Breakdown:
1. **init.md** (~120 lines)
   - Interactive command creation
   - Requirements gathering
   - Template selection

2. **update.md** (~100 lines)
   - Command enhancement
   - Feature addition
   - Compatibility checks

3. **review.md** (~100 lines)
   - Quality analysis
   - Reusability assessment
   - Improvement suggestions

4. **process-detection.md** (~80 lines)
   - Existing process scanning
   - Keyword analysis
   - Reuse recommendations

5. **_shared.md** (~40 lines)
   - Common validation
   - Error messages
   - Utility functions

### Plan Modules (Total: 6 modules from 681 lines)

#### plan/.meta.md
```yaml
---
module: ProjectPlanning
description: Comprehensive project planning with GitHub integration
version: 1.2.0
submodules:
  - discovery.md
  - analysis.md
  - design.md
  - implementation.md
  - cleanup.md
  - _core.md
routing:
  default: discovery
  phases:
    discovery: discovery.md
    analysis: analysis.md
    design: design.md
    implementation: implementation.md
  subcommands:
    clean: cleanup.md
---
```

#### Module Breakdown:
1. **discovery.md** (~140 lines)
   - Requirements elicitation
   - Context gathering
   - Initial research

2. **analysis.md** (~140 lines)
   - Problem breakdown
   - Solution exploration
   - Trade-off analysis

3. **design.md** (~140 lines)
   - Architecture planning
   - API design
   - Technical decisions

4. **implementation.md** (~140 lines)
   - Task breakdown
   - GitHub integration
   - Progress tracking

5. **cleanup.md** (~80 lines)
   - Artifact removal
   - GitHub cleanup
   - Session management

6. **_core.md** (~40 lines)
   - Phase transitions
   - Common utilities
   - Session handling

### Report Modules (Total: 7 modules from 609 lines)

#### report/.meta.md
```yaml
---
module: IssueReporting
description: Multi-repository issue creation for bugs, features, and improvements
version: 2.1.0
submodules:
  - bug.md
  - feature.md
  - improvement.md
  - security.md
  - audit.md
  - _templates.md
  - _interactive.md
routing:
  default: feature
  subcommands:
    bug: bug.md
    feature: feature.md
    improvement: improvement.md
    security: security.md
    audit: audit.md
---
```

#### Module Breakdown:
1. **bug.md** (~110 lines)
   - Bug report workflow
   - Reproduction steps
   - Quick vs detailed mode

2. **feature.md** (~110 lines)
   - Feature requests
   - Requirements capture
   - Impact assessment

3. **improvement.md** (~110 lines)
   - Enhancement suggestions
   - Performance improvements
   - UX improvements

4. **security.md** (~110 lines)
   - Security reports
   - CVE references
   - Mitigation strategies

5. **audit.md** (~90 lines)
   - Audit findings
   - Metrics reporting
   - Recommendations

6. **_templates.md** (~40 lines)
   - Issue templates
   - Common sections
   - Formatting helpers

7. **_interactive.md** (~40 lines)
   - Interactive prompts
   - Input validation
   - User guidance

## Implementation Strategy

### Phase Breakdown
1. **Day 2**: Create directory structure and generate templates
2. **Day 3-4**: Extract and split content into modules
3. **Day 5**: Update all dependencies and references
4. **Day 6**: Comprehensive testing
5. **Day 7**: Migration and documentation

### Key Considerations
1. **Backward Compatibility**
   - Main command files will redirect to new structure
   - Gradual deprecation approach

2. **Dependency Management**
   - Each module declares its own dependencies
   - Shared modules minimize duplication

3. **Testing Strategy**
   - Unit tests for each module
   - Integration tests for command routing
   - End-to-end tests for workflows

4. **Performance Goals**
   - 30-40% faster load times
   - Reduced memory footprint
   - Lazy loading of submodules

## Success Metrics
- ✅ All modules < 200 lines (target achieved: all < 150)
- ✅ Clear separation of concerns
- ✅ No circular dependencies
- ✅ Consistent structure across all commands
- ✅ Improved maintainability

## Migration Path
1. Create new structure alongside existing
2. Port functionality module by module
3. Update routing logic
4. Test thoroughly
5. Switch over with fallback option
6. Archive old files after stabilization