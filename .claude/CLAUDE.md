# CLAUDE Configuration - Modular System

## Module System Overview
This is the core configuration file for Claude's modular memory system. Detailed processes, workflows, and guides are stored in `~/.claude/` and loaded dynamically based on context and need. This approach minimizes default memory usage while maintaining access to comprehensive documentation.

## Universal Principles (Always Active)
These principles are never unloaded and apply to all interactions:

- ALWAYS ask for clarification on ambiguous or unclear requests
- ALWAYS state understanding of requests before proceeding
- ALWAYS follow the loaded development pattern rigorously
- NEVER edit .pre-commit-config.yaml without explicit confirmation
- NEVER proceed with destructive operations without confirmation
- ALWAYS maintain module scope rules (locked modules cannot be unloaded)

## Active Configuration
```yaml
# Core Settings
default_development_pattern: TestDrivenDevelopment
module_check_interval: 10  # interactions between memory reinforcement

# Default Tools
tools:
  version_control: git
  issue_tracker: github
  project_management: github_projects
  search_tool: grep
  branch_prefix: feature/
  commit_style: conventional
```

## Module Management Commands
Claude recognizes these commands for module management:

- `!load <module-path>` - Explicitly load a specific module
- `!unload <module-path>` - Remove module from context (unless locked)
- `!list-modules` - Display all currently loaded modules with their scopes
- `!compare <module1> <module2>` - Load and analyze two alternative approaches
- `!reload-manifest` - Scan ~/.claude/ directory and update the module registry
- `!validate <module-path>` - Check a module for correctness
- `!lock <module-path>` - Prevent a module from being unloaded
- `!unlock <module-path>` - Allow a locked module to be unloaded
- `!review-architecture` - Perform full system architecture analysis

## Memory Reinforcement Protocol
Every 10 interactions, Claude should:
1. Silently verify all persistent modules are still loaded
2. Check if current context matches loaded context modules
3. If context has shifted significantly, ask: "I notice we've moved from [previous context] to [current context]. Should I adjust the loaded modules?"
4. Ensure no module conflicts have emerged

## Module Loading Rules

### Automatic Loading Triggers
Modules load automatically based on keywords and context. The system follows these precedence rules:
1. Locked modules are never unloaded
2. Persistent modules remain loaded unless explicitly unloaded
3. Context modules load based on conversation topic
4. Temporary modules unload after their immediate use
5. Conflicting modules trigger a comparison prompt

### Scope Definitions
- **locked**: Never unloads unless explicitly unlocked (highest priority)
- **persistent**: Remains loaded throughout conversation (default for core workflows)
- **context**: Loaded while working in a specific domain
- **temporary**: Loaded for specific task then automatically unloaded

## Module Registry

### Auto-Loaded Modules (Active by Default)
These modules load when Claude starts a conversation:
```yaml
defaults:
  - path: patterns/development/tdd-pattern.md
    scope: persistent
    reason: "Default development methodology"

  - path: processes/version-control/commit-standards.md
    scope: persistent
    reason: "Universal commit standards"

  - path: core/meta/module-creation-guide.md
    scope: persistent
    reason: "Needed for consistent module development"
```

### Context-Based Loading
Modules that load when specific contexts are detected:
```yaml
contexts:
  development:
    triggers: ["implement", "develop", "code", "feature", "fix", "refactor"]
    loads:
      - workflows/feature-development.md
      - processes/testing/*
      - processes/version-control/*
    scope: context

  testing:
    triggers: ["test", "TDD", "coverage", "unit test", "integration test"]
    loads:
      - processes/testing/*
    scope: context

  issue-management:
    triggers: ["issue", "ticket", "project", "milestone", "tracking"]
    loads:
      - processes/issue-tracking/*
    scope: context

  code-review:
    triggers: ["review", "analyze codebase", "code quality", "PR"]
    loads:
      - processes/code-review/*
    scope: context

  security:
    triggers: ["security", "pentest", "vulnerability", "sanitize"]
    loads:
      - processes/security/*
      - guides/tools/sanitization/*
    scope: context

  auditing:
    triggers: ["audit", "analyze repository", "find duplicates", "optimization", "dead context", "repository health"]
    loads:
      - processes/auditing/*
      - workflows/repository-audit.yaml
      - roles/base/prompt-auditor.yaml
    scope: context
```

### Tool-Specific Loading
Temporary modules for specific tools:
```yaml
tools:
  search:
    triggers: ["grep", "search", "find", "rg", "ripgrep", "awk"]
    loads:
      - guides/tools/search/*
    scope: temporary

  sanitization:
    triggers: ["sanitize", "redact", "clean output", "remove sensitive"]
    loads:
      - guides/tools/sanitization/*
    scope: temporary
```

### Comparison Triggers
Situations that prompt loading multiple modules for comparison:
```yaml
comparisons:
  development-pattern:
    triggers: ["not sure about TDD", "alternative to", "compare development", "which pattern"]
    options:
      - patterns/development/tdd-pattern.md
      - patterns/development/cdd-pattern.md
      - patterns/development/bdd-pattern.md
    prompt: "I notice you're considering different development approaches. Would you like me to load and compare {options} to determine the best fit for your current situation?"
```

## Module Directory Structure
```
~/.claude/
├── manifest.md                    # This file (always loaded)
├── core/
│   ├── meta/                     # Meta-modules for system management
│   │   ├── module-creation-guide.md
│   │   ├── module-validation.md
│   │   └── architecture-review.md
│   ├── principles.md
│   └── loader.md
├── processes/
│   ├── testing/
│   ├── version-control/
│   ├── issue-tracking/
│   ├── code-review/
│   └── security/
├── workflows/
├── patterns/
├── guides/
└── templates/
```

## Conflict Resolution
When modules conflict, Claude follows these rules:
1. Locked modules always win conflicts
2. Higher scope modules override lower (locked > persistent > context > temporary)
3. If same scope, prompt user for resolution
4. Document conflict resolution for future reference

## Module Interface Contract
Every module must follow the standard structure defined in `core/meta/module-creation-guide.md`. Modules failing validation cannot be loaded.

## System Health Monitoring
Claude tracks:
- Module load/unload frequency
- Conflict occurrences
- Failed module loads
- Time spent in each context

This data informs architecture reviews and system improvements.

---
*Note: Run `!reload-manifest` after adding new modules to ~/.claude/*
