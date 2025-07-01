---
module: CodebaseReview
scope: context
triggers: ["review codebase", "analyze code", "before planning", "understand project"]
conflicts: []
dependencies: ["issue-tracking"]
priority: high
---

# Codebase Review Process

## Purpose
Systematically analyze a codebase before planning any implementation to understand structure, patterns, dependencies, and risks.

## Trigger
Execute BEFORE planning any:
- New feature implementation
- Bug fix
- Refactoring task
- Architecture changes

## Prerequisites
- Access to project repository
- Understanding of the requested change
- List of potentially affected areas

## Steps

### Step 1: Initial Context Gathering
```
1.1 Identify the scope of the requested change
1.2 List keywords related to the change:
    - Component names
    - Function names
    - Business concepts
    - Technical terms
1.3 Determine which parts of the codebase might be affected
1.4 Create initial hypothesis about implementation areas
```

### Step 2: Project Structure Analysis
```
2.1 Review project directory structure:
    ${version_control} ls-tree -r HEAD --name-only | head -50

2.2 Identify key directories:
    - Source code locations (src/, lib/, app/)
    - Test directories (test/, spec/, __tests__/)
    - Configuration files (config/, .*)
    - Documentation (docs/, README*)

2.3 Note the technology stack:
    - Programming languages (by file extensions)
    - Frameworks (from config files)
    - Build tools (package.json, pom.xml, etc.)

2.4 Check for build/deployment configurations:
    - CI/CD files (.github/workflows/, .gitlab-ci.yml)
    - Dockerfiles or container configs
    - Deployment scripts
```

### Step 3: Architecture Discovery
```
3.1 Identify architectural patterns:
    - MVC (controllers/, models/, views/)
    - Clean Architecture (domain/, infrastructure/)
    - Microservices (separate service directories)
    - Monolith (single application structure)

3.2 Map component relationships:
    - Entry points (main.*, index.*, app.*)
    - Core business logic locations
    - Data flow patterns
    - API boundaries

3.3 Document service boundaries:
    - Internal APIs
    - External integrations
    - Database interactions
    - Message queues or event systems
```

### Step 4: Code Pattern Analysis
```
4.1 Identify coding conventions:
    - Naming patterns:
        * camelCase vs snake_case
        * File naming conventions
        * Class/function prefixes
    - File organization:
        * One class per file?
        * Grouped by feature or type?
        * Test file locations

4.2 Recognize common patterns:
    - Error handling:
        * Try-catch patterns
        * Error types used
        * Logging approaches
    - State management:
        * Global state locations
        * State update patterns
        * Immutability practices
    - Authentication/Authorization:
        * Middleware locations
        * Permission checking patterns
        * Session management

4.3 Note custom utilities:
    - Helper functions
    - Common abstractions
    - Shared components
```

### Step 5: Dependency Analysis
```
5.1 Review dependency files:
    - package.json (Node.js)
    - requirements.txt/Pipfile (Python)
    - pom.xml/build.gradle (Java)
    - go.mod (Go)
    - Gemfile (Ruby)

5.2 Categorize dependencies:
    - Core framework dependencies
    - Utility libraries
    - Development dependencies
    - Security-related packages

5.3 Check for outdated packages:
    - Note deprecated warnings
    - Identify unmaintained packages
    - Check for security advisories

5.4 Note internal dependencies:
    - Custom packages
    - Internal libraries
    - Shared modules
```

### Step 6: Test Infrastructure Review
```
6.1 Locate test files:
    - Unit test locations
    - Integration test directories
    - E2E test suites

6.2 Identify testing approach:
    - Testing frameworks used
    - Mocking strategies
    - Test data management
    - Coverage tools

6.3 Assess test quality:
    - Test naming conventions
    - Assertion patterns
    - Setup/teardown approaches

6.4 Note testing gaps:
    - Untested components
    - Missing test types
    - Low coverage areas
```

### Step 7: Related Feature Analysis
```
7.1 Find similar implementations:
    - Search for similar feature keywords
    - Review related components
    - Study existing patterns

7.2 Analyze implementation approach:
    - Code structure used
    - Design patterns applied
    - Integration methods

7.3 Identify reusable components:
    - Shared utilities
    - Common interfaces
    - Base classes

7.4 Check for documented decisions:
    - ADRs (Architecture Decision Records)
    - Code comments explaining "why"
    - README notes about choices
```

### Step 8: Risk Assessment
```
8.1 Identify high-risk areas:
    - Core business logic:
        * Payment processing
        * User authentication
        * Data validation
    - Security-sensitive code:
        * Encryption/decryption
        * Access control
        * Input sanitization
    - Performance-critical paths:
        * Database queries
        * API endpoints
        * Algorithm implementations

8.2 Note technical debt:
    - TODO/FIXME comments
    - Deprecated code usage
    - Temporary workarounds

8.3 Flag legacy code:
    - Old patterns
    - Outdated dependencies
    - Unmaintained sections

8.4 Assess change impact:
    - Tightly coupled components
    - Wide-reaching interfaces
    - Breaking change potential
```

### Step 9: Documentation Review
```
9.1 README analysis:
    - Setup instructions
    - Architecture overview
    - Contribution guidelines

9.2 Inline documentation:
    - Comment quality
    - API documentation
    - Complex logic explanation

9.3 External documentation:
    - Wiki pages
    - Architecture diagrams
    - API specifications

9.4 Development guides:
    - Onboarding documents
    - Style guides
    - Best practices
```

### Step 10: Create Review Summary
```
10.1 Compile findings:
    - Key insights
    - Important patterns
    - Critical risks
    - Reusable components

10.2 Structure summary:
    - Use standard template
    - Highlight action items
    - Note questions
    - Suggest approach

10.3 Prepare for planning:
    - Link findings to task
    - Identify constraints
    - Suggest solutions
    - Estimate complexity
```

## Output

### Review Summary Structure:
```markdown
### Codebase Review Summary

#### Project Overview
- **Structure**: [monorepo/standard/microservices]
- **Stack**: [languages and frameworks]
- **Architecture**: [patterns identified]
- **Test Coverage**: [general assessment]

#### Relevant Context for [Task Name]
- **Affected Areas**:
  - [Component/Module 1]: [why relevant]
  - [Component/Module 2]: [why relevant]

- **Similar Implementations**:
  - [Feature]: [location] - [approach used]
  - [Feature]: [location] - [approach used]

- **Key Patterns to Follow**:
  - [Pattern]: [example usage]
  - [Pattern]: [example usage]

#### Dependencies & Constraints
- **Must Use**: [required dependencies/patterns]
- **Must Avoid**: [deprecated patterns/anti-patterns]
- **External Dependencies**: [relevant packages]

#### Risk Analysis
- **High Risk Areas**:
  - [Area]: [risk type] - [mitigation strategy]
- **Technical Debt**:
  - [Debt item]: [impact] - [recommendation]
- **Test Coverage**:
  - [Area]: [coverage status]

#### Recommendations
1. [Specific approach for the task]
2. [Components to reuse]
3. [Patterns to follow]
4. [Risks to mitigate]

#### Questions for Clarification
- [Question about requirements]
- [Question about constraints]
- [Question about preferences]
```

## Conditional Execution

### For Feature Implementation:
```
FOCUS ON:
- Step 3: Architecture Discovery (DETAILED)
- Step 4: Code Pattern Analysis (DETAILED)
- Step 7: Related Feature Analysis (CRITICAL)
LIGHTER ON:
- Step 5: Dependency Analysis (QUICK CHECK)
```

### For Bug Fix:
```
FOCUS ON:
- Step 7: Related Feature Analysis (CRITICAL)
- Step 8: Risk Assessment (DETAILED)
- Step 6: Test Infrastructure (DETAILED)
LIGHTER ON:
- Step 3: Architecture Discovery (BASIC)
```

### For Refactoring:
```
FOCUS ON:
- Step 4: Code Pattern Analysis (CRITICAL)
- Step 6: Test Infrastructure (CRITICAL)
- Step 8: Risk Assessment (DETAILED)
- Step 5: Dependency Analysis (DETAILED)
```

## Integration Points

- **Feeds into**: Process: ImplementationPlanning
- **Feeds into**: Process: TaskBreakdown
- **Triggers**: Process: RiskMitigation (if high risks found)
- **Updates**: Issue tracker with review findings

## Time Estimates

- Minimal Review (tiny fixes): 2-3 minutes
- Standard Review (default): 5-10 minutes
- Deep Review (major changes): 15-20 minutes

## Best Practices

### Do's
- ✅ Always review before planning
- ✅ Use findings to inform approach
- ✅ Document questions immediately
- ✅ Share summary with team
- ✅ Update review if scope changes

### Don'ts
- ❌ Skip review for "simple" changes
- ❌ Make assumptions about patterns
- ❌ Ignore test infrastructure
- ❌ Overlook documentation
- ❌ Review without clear scope
