# Modular CLAUDE.md System Implementation Request

## CRITICAL INSTRUCTIONS FOR CLAUDE

### Execution Approach
1. **DO NOT load the CLAUDE.md file** from either the `main` or `modular` branch for any purpose other than analysis in pursuit of this plan's goal
2. **Think hard and step by step** wherever possible - show your reasoning
3. **Read this entire plan through first**, then review the existing code
4. **Ask questions about the plan** and reiterate your understanding for my approval before proceeding
5. **Ask questions whenever unsure** about any aspect of implementation
6. **Ask clarifying questions** whenever something is ambiguous or unclear
7. **Use the original CLAUDE.md from the `main` branch** as source material and make all updates to the `modular` branch
8. **Review your work when complete** and identify areas for improvement

### Required Workflow
1. First, read and analyze this entire plan
2. Summarize your understanding of what needs to be built
3. Ask any clarifying questions about the requirements
4. Get explicit approval before starting implementation
5. Use step-by-step thinking throughout implementation
6. Self-review and suggest improvements when done

## Context
I have a large CLAUDE.md file that contains all my development processes, workflows, and configurations. It's becoming too large and consuming too much of Claude's memory by default. I want to split it into a modular system where components are loaded conditionally based on context.

## Current System Overview
My CLAUDE.md contains:
- Development workflows (Feature Development, Bug Fix, Refactoring)
- Processes (TDD, Code Review, Issue Tracking, Pre-commit management)
- Tool configurations (git, grep, etc.)
- Principles (ALWAYS/NEVER rules)
- Data sanitization procedures
- Pre-commit hook management

## Requirements
1. Create a modular system with files stored in ~/.claude/
2. Minimize default memory usage while retaining full functionality
3. Use hybrid approach: context-based automatic loading + project-type detection
4. Some modules should load by default (like TDD), others on-demand
5. Modules should be organized by function in directory structure
6. Support different memory scopes:
   - Persistent: Always loaded (like TDD)
   - Context: Loaded for specific work domains
   - Temporary: Loaded for specific tasks then unloaded
   - Locked: Never unloaded unless explicitly unlocked
7. Include commands like !load, !unload, !list-modules, !compare
8. Create meta-modules for:
   - How to create new modules
   - How to validate modules
   - How to review system architecture

## Directory Structure Needed
```
~/.claude/
├── manifest.md            # Always loaded - registry of all modules
├── core/
│   ├── principles.md      # ALWAYS/NEVER rules
│   ├── defaults.md        # Default configurations
│   └── loader.md          # Module loading logic
├── processes/
│   ├── testing/
│   │   ├── tdd.md
│   │   ├── cdd.md
│   │   ├── bdd.md
│   │   └── _meta.md      # Testing category metadata
│   ├── version-control/
│   │   ├── git-workflow.md
│   │   ├── commit-standards.md
│   │   ├── pre-commit-management.md
│   │   └── _meta.md
│   ├── issue-tracking/
│   │   ├── github-issues.md
│   │   ├── project-management.md
│   │   └── _meta.md
│   └── code-review/
│       ├── codebase-analysis.md
│       ├── review-checklist.md
│       └── _meta.md
├── workflows/
│   ├── feature-development.md
│   ├── bug-fix.md
│   ├── refactoring.md
│   └── _meta.md
├── patterns/
│   ├── development/
│   │   ├── tdd-pattern.md
│   │   ├── cdd-pattern.md
│   │   └── _meta.md
│   └── architecture/
│       ├── single-responsibility.md
│       └── _meta.md
├── guides/
│   └── tools/
│       ├── search/
│       │   ├── grep.md
│       │   ├── ripgrep.md
│       │   └── awk.md
│       ├── sanitization/
│       │   ├── sed.md
│       │   ├── python-sanitize.md
│       │   └── jq.md
│       └── _meta.md
└── templates/
    ├── reports/
    │   ├── bug-analysis.md
    │   └── feature-planning.md
    └── outputs/
        ├── commit-message.md
        └── pr-description.md
```
## Module Structure Requirements
Each module needs:
- YAML frontmatter with: module name, scope, triggers, conflicts, dependencies, priority
- Clear purpose statement
- Structured content based on type (Process/Workflow/Pattern/Guide)
- Integration points with other modules

## Specific Conversions Needed
Please convert these existing processes into modules:

1. **TestDrivenDevelopment** (from my CLAUDE.md)
   - Should be persistent scope
   - Default development pattern
   - Must enforce commits after each red-green-refactor cycle
   - Must push changes after successful commits
   - Must handle pre-commit hook failures with issue tracking
   - Must prevent orphaned issues

2. **CodebaseReview** (from my CLAUDE.md)
   - Context scope
   - Executes before any planning
   - Has conditional execution based on task type (Feature/Bug/Refactor)

3. **PreCommitConfiguration** and **PreCommitHookContribution**
   - Must check for .pre-commit-config.yaml on repository setup
   - Must identify recurring problems that could be solved by hooks
   - Must contribute valuable hooks back to github.com/aRustyDev/pre-commit-hooks

4. **DataSanitization**
   - Must sanitize all outputs before posting to GitHub
   - Must use configurable tools (sed, awk, perl, python, jq)
   - Must handle PII, credentials, system paths, etc.

5. **FeatureDevelopment** workflow
   - Shows how workflows orchestrate processes
   - Includes decision points and checkpoints

6. **Tool guides** (like ripgrep)
   - Temporary scope
   - Load only when needed

## Key Features to Implement

### Memory Management
- Persistent modules stay loaded
- Context modules load/unload based on work domain
- Temporary modules unload after use
- Memory reinforcement every 10 interactions
- Core principles NEVER unload

### Conflict Prevention
- Conflicting modules (like TDD vs CDD) can't load simultaneously
- System prompts for comparison when appropriate
- User must approve loading competing patterns

### Data Sanitization Integration
The data sanitization process needs configurable tools:
```yaml
sanitization_tools:
  text: [sed, awk, perl, python]
  json: [jq, python]
  structured_logs: [awk, python]
```
With patterns for:

Email addresses, usernames, paths
SSH keys, API tokens, passwords
UUIDs, GUIDs, IP addresses
Database URLs, credentials

Module Loading Logic

Automatic loading based on keywords/context
Explicit loading via commands
Dependencies auto-load
Conflicts prevent dual loading
Comparison prompts when uncertainty exists

Deliverables Needed

Core CLAUDE.md file (minimal, always loaded)

Universal principles (ALWAYS ask for clarification, etc.)
Configuration (tools, defaults)
Module management commands
Module registry/manifest


Meta-modules (in core/meta/):

module-creation-guide.md: Templates and standards for new modules
module-validation.md: 4-level validation process
architecture-review.md: System health checking


Converted modules as examples:

patterns/development/tdd-pattern.md
processes/code-review/codebase-analysis.md
processes/version-control/pre-commit-management.md
processes/security/data-sanitization.md
workflows/feature-development.md
guides/tools/search/ripgrep.md


Implementation notes explaining:

How the system works
Benefits of the modular approach
Migration strategy from monolithic to modular
How to extend the system



Important Constraints

Modules must follow Single Responsibility Principle
Issue tracking must capture all problems/solutions/lessons learned
Pre-commit configurations should NEVER be edited without permission
All development work must be rigorously tracked in GitHub issues
No orphaned issues allowed
Data must be sanitized before posting to public repositories
Tool selections must be configurable, not hard-coded

Git Branch Strategy

Source material: Read CLAUDE.md from main branch
All new modular files: Create on modular branch
Preserve original CLAUDE.md unchanged on main
Create clear commit messages for each module added

Questions to Answer Before Starting
Before you begin implementation, please:

Confirm you understand the modular loading strategy
Clarify any ambiguous requirements
Verify the directory structure makes sense
Ask about any missing specifications
Summarize the implementation plan for approval

Please create this complete modular system with all files and documentation needed for implementation, thinking step-by-step through each component.
