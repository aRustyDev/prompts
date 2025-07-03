---
name: create-command
description: Interactive command creator that guides you through building custom slash commands with comprehensive requirements analysis
author: Claude Code
version: 2.0.0
---

# Create Command - Interactive Slash Command Builder with Process Detection

I'll help you create a custom slash command by thoroughly understanding your needs, detecting reusable processes, and building a solution that leverages existing modules while exceeding your expectations. Let's work through this step-by-step.

## Phase 1: Goal Discovery 🎯

First, I need to understand what you want to accomplish:

1. **Ask the primary question**: "What would you like your new command to accomplish?"
2. **Listen actively** to the response
3. **Ask follow-up questions** to understand:
   - The specific problem being solved
   - Who will use this command
   - How often it will be used
   - The expected outcome

### Clarifying Questions:
- Can you give me a specific example of when you'd use this command?
- What currently takes too much time or is error-prone?
- What would success look like for this command?

## Phase 2: Process Detection & Analysis 🔍

Before gathering new requirements, I'll analyze if any existing processes match your needs:

### Process Scanning
1. **Analyze description keywords** to identify potential process matches
2. **Search ~/.claude/processes** for relevant modules:
   - Version control processes (commits, branches, PRs)
   - Testing processes (TDD, BDD, CDD)
   - Issue tracking workflows
   - Code review procedures
   - Security protocols
   - Tool selection patterns

### Process Matching Algorithm
For each potential match:
1. Calculate relevance score based on:
   - Keyword overlap
   - Workflow similarity
   - Input/output compatibility
   - Tool requirements alignment

2. Present high-confidence matches:
   ```
   Found potential process match:
   - Process: [process-name]
   - Relevance: [score]%
   - Description: [what it does]
   - Key features: [list]
   ```

3. Ask for confirmation:
   "Would you like to use the existing [process-name] process for [specific functionality]?
   
   Benefits of reusing:
   - Consistent behavior across commands
   - Well-tested implementation
   - Automatic updates when process improves
   
   [View process details] [Use this process] [Create custom instead]"

### Conflict Detection
If choosing to use existing process:
1. **Identify conflicts** between desired behavior and existing process
2. **Present each conflict** for resolution:
   ```
   Conflict detected:
   - You described: [user's description]
   - Process does: [existing behavior]
   
   How would you like to resolve this?
   1. Use existing behavior
   2. Create command-specific override
   3. Propose change to shared process
   ```

### Missing Feature Detection
Identify features you want that aren't in the shared process:
1. **List missing capabilities**
2. **For each missing feature, ask**:
   ```
   The [process-name] process doesn't include [feature].
   
   Would you like to:
   1. Add this to the shared process (benefits all commands)
   2. Create a conditional extension (only your command uses it)
   3. Implement separately in your command
   4. Skip this feature
   
   If adding to shared process:
   - Should this be always active?
   - Or activated by a flag/condition?
   ```

## Phase 3: Requirements Gathering 📋

Based on the goal and process analysis, I'll generate comprehensive requirements:

### Functional Requirements
- What specific actions must the command perform?
- What are the core features vs nice-to-haves?
- What's the expected workflow from start to finish?

### Input/Output Requirements
- What information does the command need from the user?
- What format should inputs be in?
- What output should be produced?
- Where should output be saved/displayed?

### Integration Requirements
- What tools or APIs need to be accessed?
- What file formats need to be handled?
- What external dependencies exist?

### Constraints & Limitations
- Are there performance requirements?
- Any security considerations?
- Platform-specific limitations?
- User permission requirements?

### Success Criteria
- How do we measure if the command works correctly?
- What constitutes a successful execution?
- What error conditions need handling?

## Phase 4: Deep Analysis 🔬

### Step-by-Step Workflow Analysis
I'll think through the entire process:
1. Map each step from invocation to completion
2. Identify decision points
3. Consider alternative paths
4. Plan error recovery

### Research & Best Practices
- Look for similar existing commands
- Identify proven patterns
- Research relevant documentation
- Consider industry standards

### Exceeding Expectations
Ways to make the command exceptional:
- **Automation**: What repetitive tasks can be eliminated?
- **Intelligence**: Can the command learn or adapt?
- **Performance**: How to make it fast and efficient?
- **User Experience**: How to make it delightful to use?
- **Robustness**: How to handle edge cases gracefully?

## Phase 5: Challenge Identification 🚧

### Technical Challenges
- Complex integrations
- Performance bottlenecks
- Platform differences
- API limitations

### User Experience Challenges
- Confusing workflows
- Too many options
- Unclear error messages
- Difficult setup

### Maintenance Challenges
- Changing dependencies
- Version compatibility
- Documentation updates
- Testing complexity

### Edge Cases
- Unusual inputs
- System failures
- Concurrent usage
- Resource limitations

## Phase 6: Ambiguity Resolution 🔍

### Process-Specific Ambiguities
When using shared processes, also resolve:
- "The shared process does X, but you mentioned Y. Did you mean:
  a) Replace X with Y entirely
  b) Do X first, then Y
  c) Choose between X and Y based on context
  d) Something else?"

- "This process integrates with [tool]. Will your command:
  a) Always use this tool
  b) Sometimes use it (what conditions?)
  c) Use a different tool
  d) Make it optional?"

I'll identify and resolve all unclear aspects:

### Questions to Ask:
- "When you say X, do you mean Y or Z?"
- "In this scenario [example], what should happen?"
- "Which is more important: [option A] or [option B]?"
- "Can you clarify what you mean by [vague term]?"

### Document Assumptions
For each assumption made:
- State it clearly
- Explain the reasoning
- Ask for confirmation
- Document alternatives

## Phase 7: Pattern Recognition 🔄

### Process Composition Patterns
- Identify how multiple processes can work together
- Find common process chains (e.g., test → commit → push)
- Recognize where process handoffs occur
- Spot opportunities for process orchestration

### Automation Opportunities
- Repetitive sequences that can be scripted
- Common parameter combinations
- Predictable decision trees
- Batch processing possibilities

### Reusable Components
- Common validation logic
- Shared utility functions
- Template structures
- Configuration patterns

### Workflow Optimization
- Parallel processing opportunities
- Caching possibilities
- Short-circuit evaluations
- Batch operations

## Phase 8: Solution Design 📐

### Process Integration Design
```yaml
name: [command-name]
description: [clear, concise description]
author: [your name]
version: 1.0.0

# Process Dependencies
processes:
  - name: version-control/commit-standards
    version: ">=1.0.0"
    usage: "For creating standardized commits"
    overrides:
      - feature: "commit-message-format"
        condition: "when flag --custom-format is used"
        implementation: "Use user-provided format"
  
  - name: testing/tdd-pattern
    version: ">=1.0.0"
    usage: "For test-driven implementation"
    extensions:
      - feature: "parallel-test-execution"
        condition: "when flag --parallel is used"
        implementation: "Run tests in parallel using pytest-xdist"
```

### Command Structure
```yaml
name: [command-name]
description: [clear, concise description]
author: [your name]
version: 1.0.0
```

### Workflow Design
1. **Initialization**: Setup and validation
2. **Input Gathering**: Interactive or parameter-based
3. **Processing**: Core logic execution
4. **Output Generation**: Results formatting
5. **Cleanup**: Resource management

### User Interaction Design
- Clear prompts
- Helpful defaults
- Progress indicators
- Confirmation steps
- Error guidance

### Feedback Mechanisms
- Status updates
- Progress bars
- Completion summaries
- Error explanations
- Success confirmations

## Phase 9: Validation & Approval ✅

### Process Usage Summary
Show which shared processes will be used:

**Shared Processes:**
- ✅ `version-control/commit-standards` - For commit creation
- ✅ `testing/tdd-pattern` - For test-driven development
- ❌ `code-review/analysis` - Not needed for this command

**Process Modifications:**
- `commit-standards`: Added custom format option
- `tdd-pattern`: Extended with parallel execution

**Custom Implementations:**
- [Feature X]: Implemented locally (no suitable shared process)

### Present the Complete Plan

I'll show you:

**Command Overview:**
- Name: `[chosen-name]`
- Purpose: [clear description]
- Usage: `/project:[chosen-name] [options]`

**Workflow Summary:**
[Step-by-step workflow]

**Key Features:**
- [Feature 1]: [Description]
- [Feature 2]: [Description]
- etc.

**Identified Challenges & Solutions:**
- Challenge: [Description] → Solution: [Approach]
- etc.

**Automation & Optimizations:**
- [Optimization 1]: [Benefit]
- etc.

**Example Usage:**
```
/project:[chosen-name]
[Example interaction]
```

### Get Approval
"Does this plan meet your needs? Would you like me to:
1. Proceed with creating this command
2. Refine specific aspects (please specify)
3. Start over with a different approach"

## Phase 10: Command Creation 🛠️

### Process Reference Generation
For each used process, generate proper references:

```markdown
## Process: Commit Standards
This command uses the shared commit standards process.
See: ~/.claude/processes/version-control/commit-standards.md

Overrides:
- When --custom-format flag is used, the command will accept a custom format string
  instead of using conventional commits format.

## Process: TDD Pattern  
This command follows the TDD pattern for implementation.
See: ~/.claude/processes/testing/tdd-pattern.md

Extensions:
- When --parallel flag is used, tests will run in parallel using pytest-xdist
```

### Conditional Gate Implementation
For process extensions with conditions:

```markdown
# Check if using extended feature
if [[ "$1" == "--parallel" ]]; then
    echo "Using parallel test execution (command-specific extension)"
    # Command-specific parallel implementation
    pytest -n auto
else
    # Use standard TDD process
    !load ~/.claude/processes/testing/tdd-pattern.md
    # Follow standard TDD workflow
fi
```

### Directory Detection
```bash
# Check for local .claude directory first
if [ -d "./.claude/commands" ]; then
    TARGET_DIR="./.claude/commands"
elif [ -d "~/.claude/commands" ]; then
    TARGET_DIR="~/.claude/commands"
else
    # Create directory
    mkdir -p ~/.claude/commands
    TARGET_DIR="~/.claude/commands"
fi
```

### File Creation
Create `$TARGET_DIR/[command-name].md` with:
- Complete command implementation
- Inline documentation
- Usage examples
- Error handling
- Best practices

### Post-Creation
- Confirm file creation
- Provide usage instructions
- Suggest testing approach
- Offer to create related commands

## Interactive Script

When invoked, I will:

1. **Start with goal discovery**: "I'll help you create a custom slash command. What would you like your new command to accomplish?"

2. **Detect existing processes** that match your described functionality:
   - Search ~/.claude/processes for relevant modules
   - Present matches with relevance scores
   - Get approval to use shared processes

3. **Resolve process conflicts** through interactive dialogue:
   - Present each difference clearly
   - Offer resolution options
   - Document decisions

4. **Identify missing features** and determine how to add them:
   - To shared process (with or without conditions)
   - As command-specific extensions
   - As separate implementations

5. **Gather remaining requirements** not covered by shared processes

6. **Think deeply** about the complete solution

7. **Identify challenges** and propose solutions

8. **Resolve all ambiguities** through targeted questions

9. **Recognize patterns** and suggest optimizations

10. **Design solution** with process integration

11. **Present for approval** with process usage summary

12. **Create the command** with proper process references and conditional gates

Remember: The goal is to create commands that:
- Leverage existing processes for consistency and reliability
- Only create custom logic when truly unique functionality is needed  
- Resolve conflicts thoughtfully to maintain system coherence
- Exceed expectations through thoughtful integration and design
- Document process usage clearly for future maintenance

## Process Detection Keywords

Common keywords that trigger process detection:

### Version Control
- commit, git, branch, merge, push, pull, version, changes

### Testing  
- test, TDD, BDD, coverage, unit, integration, pytest, jest

### Issue Tracking
- issue, ticket, bug, feature, milestone, project, github

### Code Review
- review, analyze, quality, standards, lint, format

### Security
- sanitize, redact, security, sensitive, credentials, secrets

### Development Patterns
- implement, develop, create, build, design, architecture