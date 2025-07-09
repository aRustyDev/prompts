# Plan Command - Core Module
Core planning logic and phase management

## Module Info
- Name: _core
- Type: plan-core
- Parent: commands/plan
- Dependencies: []

## Description
Core utilities and shared functionality for all planning phases. Manages phase transitions, state persistence, and common operations.

## Core Components

### Phase Manager
```yaml
phase_manager:
  description: |
    Orchestrates planning phases and transitions
  phases:
    - discovery: Initial research and requirements
    - analysis: Problem breakdown and solutions
    - design: Architecture and specifications
    - implementation: Task creation and tracking
  transitions:
    discovery->analysis:
      requires: ["requirements_gathered", "context_defined"]
    analysis->design:
      requires: ["solution_selected", "constraints_identified"]
    design->implementation:
      requires: ["architecture_approved", "apis_defined"]
```

### State Management
```yaml
state_management:
  description: |
    Persist and manage planning state
  storage:
    location: ".claude/plan/state.json"
    format: "json"
    versioned: true
  state_data:
    - current_phase: Active planning phase
    - completed_phases: List of completed phases
    - phase_outputs: Results from each phase
    - metadata: Timestamps, versions, users
```

### Common Operations
```yaml
common_operations:
  validation:
    - check_prerequisites
    - validate_inputs
    - verify_outputs
  
  formatting:
    - markdown_generation
    - template_rendering
    - output_formatting
  
  integration:
    - github_api_calls
    - file_operations
    - git_operations
```

## Phase Flow Control

### Phase Initialization
```javascript
function initPhase(phaseName, context) {
  // Validate prerequisites
  const prereqs = checkPrerequisites(phaseName);
  if (!prereqs.satisfied) {
    throw new Error(`Missing prerequisites: ${prereqs.missing.join(', ')}`);
  }
  
  // Load phase template
  const template = loadPhaseTemplate(phaseName);
  
  // Initialize state
  const state = {
    phase: phaseName,
    startTime: new Date(),
    context: context,
    outputs: {}
  };
  
  saveState(state);
  return state;
}
```

### Phase Completion
```javascript
function completePhase(phaseName, outputs) {
  // Validate outputs
  const validation = validatePhaseOutputs(phaseName, outputs);
  if (!validation.valid) {
    throw new Error(`Invalid outputs: ${validation.errors.join(', ')}`);
  }
  
  // Update state
  const state = loadState();
  state.completedPhases.push(phaseName);
  state.phaseOutputs[phaseName] = outputs;
  state.lastCompleted = new Date();
  
  // Check next phase
  const nextPhase = determineNextPhase(phaseName);
  if (nextPhase) {
    state.currentPhase = nextPhase;
  } else {
    state.status = 'completed';
  }
  
  saveState(state);
  return { nextPhase, outputs };
}
```

## State Schema

### Planning State
```json
{
  "version": "1.0",
  "id": "uuid",
  "project": {
    "name": "project-name",
    "description": "project description",
    "repository": "owner/repo"
  },
  "status": "in-progress|completed|cancelled",
  "currentPhase": "discovery|analysis|design|implementation",
  "completedPhases": ["discovery", "analysis"],
  "phaseOutputs": {
    "discovery": {
      "requirements": [],
      "context": {},
      "research": []
    },
    "analysis": {
      "problems": [],
      "solutions": [],
      "recommendation": {}
    }
  },
  "metadata": {
    "created": "2024-01-15T10:00:00Z",
    "updated": "2024-01-15T14:30:00Z",
    "author": "username",
    "version": "1.0"
  }
}
```

### Phase Output Schema
```yaml
phase_output:
  discovery:
    requirements:
      - id: string
      - description: string
      - priority: high|medium|low
      - source: string
    context:
      - domain: string
      - constraints: array
      - assumptions: array
      - stakeholders: array
  
  analysis:
    problems:
      - id: string
      - description: string
      - impact: string
      - components: array
    solutions:
      - id: string
      - approach: string
      - pros: array
      - cons: array
      - feasibility: number
    recommendation:
      - selected: string
      - rationale: string
      - risks: array
  
  design:
    architecture:
      - components: array
      - interactions: array
      - technologies: array
    specifications:
      - apis: array
      - models: array
      - interfaces: array
  
  implementation:
    tasks:
      - epics: array
      - stories: array
      - tasks: array
    schedule:
      - sprints: array
      - milestones: array
      - dependencies: array
```

## Common Utilities

### Template Rendering
```javascript
function renderTemplate(templateName, data) {
  const template = loadTemplate(templateName);
  
  // Handle includes
  const withIncludes = processIncludes(template);
  
  // Render with handlebars
  const compiled = Handlebars.compile(withIncludes);
  const output = compiled(data);
  
  // Post-process
  return formatOutput(output);
}
```

### Validation Framework
```yaml
validators:
  required_fields:
    description: "Ensure required fields are present"
    rules:
      - field: "project.name"
        type: "string"
        required: true
      - field: "requirements"
        type: "array"
        minLength: 1
  
  phase_outputs:
    description: "Validate phase completion outputs"
    rules:
      discovery:
        - "requirements.length > 0"
        - "context.domain != null"
      analysis:
        - "solutions.length >= 2"
        - "recommendation.selected != null"
      design:
        - "architecture.components.length > 0"
        - "specifications.apis.length > 0"
      implementation:
        - "tasks.tasks.length > 0"
        - "schedule.sprints.length > 0"
```

### Error Handling
```javascript
class PlanError extends Error {
  constructor(message, phase, details) {
    super(message);
    this.phase = phase;
    this.details = details;
    this.timestamp = new Date();
  }
}

function handleError(error, context) {
  // Log error
  logger.error({
    error: error.message,
    phase: error.phase || context.phase,
    details: error.details,
    stack: error.stack
  });
  
  // Update state
  const state = loadState();
  state.errors = state.errors || [];
  state.errors.push({
    timestamp: error.timestamp,
    phase: error.phase,
    message: error.message
  });
  saveState(state);
  
  // Determine recovery
  if (error.recoverable) {
    return { retry: true, suggestion: error.suggestion };
  }
  return { retry: false, abort: true };
}
```

## Integration Helpers

### GitHub API Wrapper
```javascript
async function githubOperation(operation, params) {
  const config = loadGithubConfig();
  
  try {
    switch(operation) {
      case 'createIssue':
        return await gh.issues.create(params);
      case 'createMilestone':
        return await gh.milestones.create(params);
      case 'createProject':
        return await gh.projects.create(params);
      default:
        throw new Error(`Unknown operation: ${operation}`);
    }
  } catch (error) {
    if (error.status === 429) {
      // Rate limit - wait and retry
      await wait(error.headers['retry-after'] * 1000);
      return githubOperation(operation, params);
    }
    throw error;
  }
}
```

### File Operations
```javascript
const fileOps = {
  async saveOutput(phase, filename, content) {
    const dir = `.claude/plan/outputs/${phase}`;
    await ensureDir(dir);
    const path = `${dir}/${filename}`;
    await writeFile(path, content);
    return path;
  },
  
  async loadTemplate(name) {
    const path = `.claude/plan/templates/${name}.md`;
    return await readFile(path);
  },
  
  async archivePlan(name) {
    const source = '.claude/plan';
    const dest = `.claude/plan/archives/${name}-${Date.now()}`;
    await copyDir(source, dest);
    return dest;
  }
};
```

## Configuration

### Default Settings
```yaml
defaults:
  output_format: markdown
  state_format: json
  template_engine: handlebars
  github_integration: true
  auto_save: true
  validation_strict: false
  
phase_timeouts:
  discovery: 3600  # 1 hour
  analysis: 7200   # 2 hours
  design: 7200     # 2 hours
  implementation: 3600  # 1 hour
  
output_limits:
  max_file_size: 1048576  # 1MB
  max_issues_per_batch: 50
  max_tasks_per_story: 10
```

### User Preferences
```yaml
preferences:
  confirmations:
    before_github_operations: true
    before_file_deletion: true
    before_phase_transition: false
  
  notifications:
    phase_complete: true
    errors: true
    warnings: true
  
  formatting:
    use_emoji: false
    include_timestamps: true
    verbose_output: false
```

## Phase Coordination

### Inter-phase Communication
```javascript
const phaseConnectors = {
  'discovery->analysis': (discoveryOutput) => ({
    requirements: discoveryOutput.requirements,
    context: discoveryOutput.context,
    constraints: discoveryOutput.context.constraints
  }),
  
  'analysis->design': (analysisOutput) => ({
    selectedSolution: analysisOutput.recommendation.selected,
    components: analysisOutput.problems.flatMap(p => p.components),
    constraints: analysisOutput.recommendation.risks
  }),
  
  'design->implementation': (designOutput) => ({
    architecture: designOutput.architecture,
    apis: designOutput.specifications.apis,
    components: designOutput.architecture.components
  })
};
```

### Phase Dependencies
```yaml
dependencies:
  analysis:
    requires:
      from_discovery:
        - requirements: "At least one requirement defined"
        - context: "Project context established"
    
  design:
    requires:
      from_analysis:
        - recommendation: "Solution approach selected"
        - feasibility: "Feasibility assessed"
  
  implementation:
    requires:
      from_design:
        - architecture: "System architecture defined"
        - specifications: "Component specs completed"
```

## Best Practices

### State Management
1. Always persist state after changes
2. Version state for rollback capability
3. Clean up old state files periodically
4. Validate state on load
5. Handle corruption gracefully

### Error Recovery
1. Log all errors with context
2. Provide actionable error messages
3. Implement retry logic for transient failures
4. Save progress before risky operations
5. Offer rollback options

### Performance
1. Lazy load templates and modules
2. Cache frequently used data
3. Batch API operations
4. Stream large outputs
5. Clean up temporary files

## See Also
- Individual phase modules for specific functionality
- [cleanup.md](cleanup.md) - Cleanup utilities
- Template documentation in knowledge base