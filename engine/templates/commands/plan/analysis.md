# Plan Command - Analysis Module
Problem analysis and solution exploration

## Module Info
- Name: analysis
- Type: plan-phase
- Parent: commands/plan
- Dependencies: [discovery.md, _core.md]

## Description
Handles the analysis phase of planning, including problem breakdown, solution exploration, and trade-off analysis.

## Phase Template

### Problem Analysis
```yaml
problem_analysis:
  description: |
    Break down the problem into manageable components
  steps:
    - identify_core_problem: Define the main issue or goal
    - decompose_problem: Break into sub-problems
    - identify_constraints: List technical/business constraints
    - define_success_criteria: What does success look like?
```

### Solution Exploration
```yaml
solution_exploration:
  description: |
    Explore potential solutions and approaches
  steps:
    - brainstorm_solutions: Generate multiple approaches
    - evaluate_feasibility: Assess technical feasibility
    - compare_approaches: Trade-off analysis
    - recommend_solution: Select best approach
```

### Trade-off Analysis
```yaml
trade_off_analysis:
  criteria:
    - complexity: Implementation complexity
    - maintainability: Long-term maintenance burden
    - performance: Runtime performance impact
    - scalability: Growth handling capability
    - cost: Resource and time investment
  output_format: |
    | Approach | Complexity | Maintainability | Performance | Scalability | Cost |
    |----------|------------|-----------------|-------------|-------------|------|
    | {name}   | {score}    | {score}         | {score}     | {score}     | {score} |
```

## Prompts

### Problem Analysis Prompt
```
Analyze the following problem:
- Core issue: {{problem_statement}}
- Context: {{context}}
- Constraints: {{constraints}}

Break this down into:
1. Root cause analysis
2. Component breakdown
3. Dependencies and blockers
4. Success criteria
```

### Solution Exploration Prompt
```
For the problem: {{problem_analysis}}

Generate and evaluate solutions:
1. List 3-5 potential approaches
2. Assess feasibility of each
3. Compare trade-offs
4. Recommend best solution with rationale
```

## Outputs

### Analysis Report Template
```markdown
## Problem Analysis: {{title}}

### Core Problem
{{problem_statement}}

### Breakdown
{{#each components}}
- **{{name}}**: {{description}}
  - Complexity: {{complexity}}
  - Dependencies: {{dependencies}}
{{/each}}

### Constraints
{{#each constraints}}
- {{type}}: {{description}}
{{/each}}

### Success Criteria
{{#each criteria}}
- [ ] {{description}}
{{/each}}

### Recommended Approach
{{recommendation}}

#### Rationale
{{rationale}}

#### Trade-offs
{{trade_offs}}
```

## Integration Points

### Input from Discovery
- Requirements gathered
- Context established
- Initial research completed

### Output to Design
- Selected solution approach
- Identified constraints
- Success criteria defined
- Component breakdown

## Usage Examples

### Basic Analysis
```bash
claude plan analyze --problem "Optimize database queries"
```

### Detailed Analysis
```bash
claude plan analyze \
  --problem "Optimize database queries" \
  --context "High traffic e-commerce site" \
  --constraints "budget:limited,timeline:2-weeks"
```

### With Trade-off Matrix
```bash
claude plan analyze \
  --problem "Choose caching strategy" \
  --compare "redis,memcached,in-memory" \
  --criteria "performance,cost,complexity"
```

## Error Handling

### Common Issues
- Insufficient problem definition
- Missing context
- Unclear success criteria
- Conflicting constraints

### Validation Rules
- Problem statement must be specific
- At least one success criterion required
- Constraints must be measurable
- Trade-offs must be quantifiable

## Best Practices
1. Always define success criteria upfront
2. Consider both technical and business constraints
3. Document assumptions explicitly
4. Include stakeholder perspectives
5. Quantify trade-offs when possible

## See Also
- [discovery.md](discovery.md) - Requirements gathering phase
- [design.md](design.md) - Architecture and design phase
- [_core.md](_core.md) - Core planning utilities