---
name: create-command
description: Interactive command creator that guides you through building custom slash commands with comprehensive requirements analysis
author: Claude Code
version: 1.0.0
---

# Create Command - Interactive Slash Command Builder

I'll help you create a custom slash command by thoroughly understanding your needs and building a solution that exceeds your expectations. Let's work through this step-by-step.

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

## Phase 2: Requirements Gathering 📋

Based on the goal, I'll generate comprehensive requirements:

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

## Phase 3: Deep Analysis 🔬

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

## Phase 4: Challenge Identification 🚧

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

## Phase 5: Ambiguity Resolution 🔍

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

## Phase 6: Pattern Recognition 🔄

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

## Phase 7: Solution Design 📐

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

## Phase 8: Validation & Approval ✅

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

## Phase 9: Command Creation 🛠️

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

2. **Gather requirements systematically**, asking clarifying questions at each step

3. **Think deeply** about the problem, showing my analysis process

4. **Identify challenges** and propose solutions

5. **Resolve ambiguities** through targeted questions

6. **Recognize patterns** and suggest optimizations

7. **Design a complete solution** with all details

8. **Present for approval** with clear summary

9. **Create the command** upon approval or iterate based on feedback

Remember: The goal is to create commands that not only meet requirements but exceed expectations through thoughtful design and comprehensive implementation.