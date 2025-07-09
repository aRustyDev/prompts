# Dependency Mapping for Command Files
Generated: January 9, 2025

## Current Dependencies

### command.md Dependencies
```yaml
dependencies:
  - meta/slash-command-principles.md
  - processes/meta/determine-prompt-reusability.md
```

### plan.md Dependencies
```yaml
# No explicit dependencies in frontmatter
```

### report.md Dependencies
```yaml
# No explicit dependencies in frontmatter
```

## References Analysis

### Files That May Reference These Commands
Based on the module loading system in CLAUDE.md, these commands would be loaded when users use command-related triggers.

### Module Registry References
The commands are likely referenced in:
1. Module manifest/registry (implicit loading)
2. Help system documentation
3. Command index files
4. Workflow files that use these commands

### Internal Cross-References
Within each command file:
- Subcommands reference shared utilities
- Help text references other subcommands
- Error handling references common patterns

## Dependency Update Plan

### When Splitting Files
1. **Update Module References**
   - Change `commands/command.md` → `commands/command/init.md` (etc.)
   - Change `commands/plan.md` → `commands/plan/discovery.md` (etc.)
   - Change `commands/report.md` → `commands/report/bug.md` (etc.)

2. **Create Directory Metadata**
   Each new directory needs a `.meta.md` file:
   ```yaml
   ---
   module: CommandSubcommands
   description: Modular command system
   submodules:
     - init.md
     - update.md
     - review.md
     - _shared.md
   ---
   ```

3. **Update Cross-Module Dependencies**
   - Shared utilities will be in `_shared.md` or `_core.md`
   - Each submodule must declare dependency on shared module
   - Submodules may have dependencies on each other

4. **External References**
   Search and update any files that reference:
   - `/command` → May need to update help text
   - `/plan` → May need to update workflow references
   - `/report` → May need to update template references

## Dependency Graph

### Current State
```
command.md
  ├── meta/slash-command-principles.md
  └── processes/meta/determine-prompt-reusability.md

plan.md
  └── (no explicit dependencies)

report.md
  └── (no explicit dependencies)
```

### Future State (After Split)
```
commands/command/
  ├── .meta.md
  ├── init.md
  │   ├── _shared.md
  │   ├── meta/slash-command-principles.md
  │   └── processes/meta/determine-prompt-reusability.md
  ├── update.md
  │   ├── _shared.md
  │   └── meta/slash-command-principles.md
  ├── review.md
  │   ├── _shared.md
  │   └── meta/slash-command-principles.md
  └── _shared.md

commands/plan/
  ├── .meta.md
  ├── discovery.md
  │   └── _core.md
  ├── analysis.md
  │   └── _core.md
  ├── design.md
  │   └── _core.md
  ├── implementation.md
  │   └── _core.md
  └── _core.md

commands/report/
  ├── .meta.md
  ├── bug.md
  │   └── _templates.md
  ├── feature.md
  │   └── _templates.md
  ├── improvement.md
  │   └── _templates.md
  ├── security.md
  │   └── _templates.md
  └── _templates.md
```

## Update Checklist
- [ ] Update module loading triggers in CLAUDE.md (if needed)
- [ ] Update help documentation
- [ ] Update any workflow files
- [ ] Update command index/registry
- [ ] Test command routing after split
- [ ] Verify all dependencies resolve correctly