# Claude Modular Memory System

## Overview
This directory contains the modular memory system for Claude. Instead of loading a monolithic configuration file, modules are loaded dynamically based on context, reducing memory usage while maintaining full functionality.

## Quick Start

### Module Commands
- `!load <module>` - Load a specific module
- `!unload <module>` - Unload a module (if allowed)
- `!list-modules` - Show currently loaded modules
- `!compare <module1> <module2>` - Compare alternative approaches
- `!reload` - Reload a module from disk
- `!status` - Show system status

### Default Modules
These modules are always loaded:
- `core/principles.md` - Fundamental ALWAYS/NEVER rules
- `shared/patterns/development/tdd-pattern.md` - Default development methodology
- `shared/processes/version-control/commit-standards.md` - Commit conventions

## Directory Structure

```
.claude/
├── manifest.md              # Module registry (always loaded)
├── core/                    # Core system modules
│   ├── principles.md        # ALWAYS/NEVER rules
│   ├── defaults.md          # System configurations
│   └── loader.md            # Module loading logic
├── .config/                # Configuration files
│   ├── project.yaml
│   ├── logging.yaml
│   └── memory.yaml
├── .meta/                  # System management
│   ├── module-creation-guide.md
│   └── module-validation.md
├── shared/                 # Shared resources
│   ├── processes/          # Step-by-step procedures
│   ├── workflows/          # Multi-process orchestrations
│   ├── patterns/           # Development methodologies
│   ├── templates/          # Reusable templates
│   ├── roles/              # Expert role definitions
│   └── schemas/            # Data structures
├── docs/                   # Documentation
│   ├── guides/             # Tool usage guides
│   ├── knowledge/          # Knowledge bases
│   └── examples/           # Example implementations
└── commands/               # Slash commands
```

## Module Types

### Process Modules
Step-by-step procedures for specific tasks
- Example: `shared/processes/testing/tdd.md`
- Scope: Usually context or persistent
- Contains: Detailed steps, integration points

### Workflow Modules
Orchestrate multiple processes
- Example: `shared/workflows/feature-development.md`
- Scope: Context
- Contains: Process sequence, decision points

### Pattern Modules
Define development methodologies
- Example: `shared/patterns/development/tdd-pattern.md`
- Scope: Persistent or context
- Contains: Principles, rules, examples

### Guide Modules
Reference documentation
- Example: `docs/guides/tools/search/ripgrep.md`
- Scope: Temporary
- Contains: Usage examples, tips

### Meta Modules
System management and administration
- Example: `.meta/module-creation-guide.md`
- Scope: Persistent or context
- Contains: Meta-information about the system

## Module Loading

### Automatic Loading
Modules load based on:
1. Keywords in conversation
2. Context detection
3. Dependencies of other modules
4. Default configuration

### Manual Loading
Use commands to explicitly control modules:
```
!load shared/processes/testing/tdd.md
!unload docs/guides/tools/search/ripgrep.md
```

### Scope Rules
- **persistent**: Never automatically unloaded
- **context**: Unloaded when context changes
- **temporary**: Unloaded after N interactions
- **locked**: Only manual control

## Creating New Modules

1. **Determine module type** (process, workflow, pattern, guide, meta)
2. **Create file** in appropriate directory
3. **Add frontmatter** with required fields:
   ```yaml
   ---
   name: Module Name
   module_type: process
   scope: context
   priority: medium
   triggers: ["keyword1", "keyword2"]
   dependencies: []
   conflicts: []
   version: 1.0.0
   ---
   ```
4. **Write content** following type-specific template
5. **Validate** using `!validate <module>`
6. **Update manifest** if needed

## Key Modules

### Development
- `shared/processes/testing/tdd.md` - Test-driven development
- `shared/workflows/feature-development.md` - Feature implementation
- `shared/processes/code-review/codebase-analysis.md` - Code analysis

### Version Control
- `shared/processes/version-control/commit-standards.md` - Commit conventions
- `shared/processes/version-control/workspace-setup.md` - Branch management

### Security
- `shared/processes/security/data-sanitization.md` - Remove sensitive data
- `shared/processes/tooling/tool-selection.md` - Tool fallback chains

### System Management
- `.meta/module-creation-guide.md` - How to create modules
- `.meta/module-validation.md` - Module quality checks

## Best Practices

### Module Design
- Single responsibility per module
- Clear dependencies
- Appropriate scope
- Comprehensive documentation

### System Usage
- Let automatic loading work
- Override when needed
- Monitor loaded modules
- Report issues

## Troubleshooting

### Module Not Loading
1. Check triggers in manifest
2. Verify dependencies available
3. Look for conflicts
4. Try manual load

### System Slow
1. Check loaded module count
2. Unload temporary modules
3. Review module scopes
4. Restart if needed

### Finding Modules
1. Check manifest.md
2. Browse directories
3. Use partial matching
4. Read category _meta.md files

---

The modular system provides flexibility while maintaining consistency. Modules can be added, updated, or removed without affecting the core system, making it maintainable and extensible.