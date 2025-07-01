# Module Registry

This manifest tracks all available modules and their loading conditions. It is always loaded and serves as the central registry for Claude's modular memory system.

## Module Loading Status
- Last Reinforcement Check: [Interaction 0]
- Total Modules Available: [Dynamic]
- Currently Loaded: [To be tracked]

## Auto-Load Modules (Default Active)
These modules load automatically when Claude starts a conversation:

### Core Modules
- patterns/development/tdd-pattern.md [scope: persistent, priority: critical]
  - Reason: Default development methodology enforcing TDD rigor
- core/principles.md [scope: persistent, priority: critical]
  - Reason: Universal ALWAYS/NEVER rules that must never be forgotten
- processes/version-control/commit-standards.md [scope: persistent, priority: high]
  - Reason: Ensures consistent commit practices across all work

## Context Triggers
Modules that load based on conversation context and keywords:

### testing
- keywords: ["test", "TDD", "coverage", "unit test", "integration test", "pytest", "jest", "mocha"]
- loads: ["processes/testing/*"]
- scope: context
- priority: high

### version-control
- keywords: ["commit", "git", "push", "branch", "merge", "rebase", "cherry-pick"]
- loads: ["processes/version-control/*"]
- scope: context
- priority: high

### issue-management
- keywords: ["issue", "ticket", "project", "milestone", "tracking", "github issue", "jira"]
- loads: ["processes/issue-tracking/*"]
- scope: context
- priority: medium

### code-review
- keywords: ["review", "analyze codebase", "code quality", "PR", "pull request", "merge request"]
- loads: ["processes/code-review/*"]
- scope: context
- priority: medium

### security
- keywords: ["security", "pentest", "vulnerability", "sanitize", "redact", "sensitive data"]
- loads: ["processes/security/*", "guides/tools/sanitization/*"]
- scope: context
- priority: highest

### feature-development
- keywords: ["implement", "develop", "new feature", "add functionality", "create component"]
- loads: ["workflows/feature-development.md", "processes/testing/*", "processes/version-control/*"]
- scope: context
- priority: high

### bug-fixing
- keywords: ["bug", "fix", "error", "broken", "regression", "debug"]
- loads: ["workflows/bug-fix.md", "processes/testing/*"]
- scope: context
- priority: high

### refactoring
- keywords: ["refactor", "clean up", "improve code", "technical debt", "restructure"]
- loads: ["workflows/refactoring.md", "processes/code-review/*"]
- scope: context
- priority: medium

## Explicit Overrides
Special modules with override behavior:

### pentest-rules
- scope: locked  # Never unload unless explicit
- priority: critical  # Overrides all other modules
- loads: ["processes/security/pentest-guidelines.md"]
- trigger: Manual load only

### emergency-recovery
- scope: locked
- priority: critical
- loads: ["processes/tooling/emergency-procedures.md"]
- trigger: Manual load only

## Tool Guides (Load on Demand)
Temporary modules that load for specific tool usage:

### search-tools
- triggers: ["grep", "search", "find pattern", "rg", "ripgrep", "ack", "ag"]
- loads: ["guides/tools/search/*"]
- scope: temporary
- unload-after: 3 interactions

### sanitization-tools
- triggers: ["sanitize output", "redact", "clean data", "remove PII", "mask sensitive"]
- loads: ["guides/tools/sanitization/*", "processes/security/data-sanitization.md"]
- scope: temporary
- unload-after: 5 interactions

### pre-commit-tools
- triggers: ["pre-commit", "hook", ".pre-commit-config.yaml", "pre-commit install"]
- loads: ["processes/tooling/pre-commit-management.md", "processes/tooling/hook-contribution.md"]
- scope: context
- priority: high

## Module Conflicts
Modules that cannot be loaded simultaneously:

### Development Patterns
- conflicting-modules: ["patterns/development/tdd-pattern.md", "patterns/development/cdd-pattern.md", "patterns/development/bdd-pattern.md"]
- resolution: prompt-for-selection
- exception: comparison-mode

### Architecture Styles
- conflicting-modules: ["patterns/architecture/monolithic.md", "patterns/architecture/microservices.md", "patterns/architecture/serverless.md"]
- resolution: prompt-for-selection
- exception: comparison-mode

## Comparison Triggers
Keywords that trigger module comparison mode:

### development-methodology
- triggers: ["which development pattern", "compare TDD", "alternative to TDD", "TDD vs", "not sure about TDD"]
- loads-for-comparison: ["patterns/development/tdd-pattern.md", "patterns/development/cdd-pattern.md", "patterns/development/bdd-pattern.md"]
- prompt: "I notice you're evaluating development methodologies. Would you like me to load and compare TDD, CDD, and BDD to help determine the best fit?"

### tool-selection
- triggers: ["which tool for", "compare tools", "tool alternatives", "best tool for"]
- action: identify-category-then-load
- prompt: "I'll help you compare tools. What type of tool are you looking for? (search, sanitization, version control, etc.)"

## Priority Levels
Module loading priority (highest to lowest):
1. **critical**: Core functionality, never unloaded (principles, TDD default)
2. **highest**: Security and override modules
3. **high**: Active development patterns and version control
4. **medium**: Supporting processes and workflows
5. **low**: Optional guides and templates

## Memory Management Rules
1. Persistent modules with priority "critical" are NEVER unloaded
2. Context modules unload when context switches (unless locked)
3. Temporary modules auto-unload after specified interactions
4. Maximum concurrent modules: 15 (to preserve memory)
5. When limit reached, unload lowest priority temporary modules first

## Module Validation Requirements
All modules must include:
- YAML frontmatter with: name, scope, priority, triggers, dependencies
- Clear purpose statement
- Structured content appropriate to type
- Integration points with other modules
- No circular dependencies

## Reinforcement Protocol
Every 10 interactions:
1. Check all critical and persistent modules are loaded
2. Verify no conflicts have emerged
3. Unload stale temporary modules
4. Log module usage statistics
5. Silent operation unless context shift detected

## Commands
- `!load <module>` - Load specific module
- `!unload <module>` - Unload module (if allowed)
- `!list-modules` - Show currently loaded modules
- `!compare <module1> <module2>` - Enter comparison mode
- `!reload` - Reload a module from disk
- `!lock <module>` - Prevent module from being unloaded
- `!unlock <module>` - Allow module to be unloaded
- `!status` - Show memory usage and module statistics

---
*Last updated: Initial creation*
*Module count: 0 modules defined, awaiting population*