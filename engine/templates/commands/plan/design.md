# Plan Command - Design Module
Architecture and design decisions

## Module Info
- Name: design
- Type: plan-phase
- Parent: commands/plan
- Dependencies: [analysis.md, _core.md]

## Description
Handles the design phase of planning, including architecture design, API design, and implementation planning.

## Phase Template

### Architecture Design
```yaml
architecture_design:
  description: |
    Define system architecture and component structure
  components:
    - high_level_design: System overview and boundaries
    - component_design: Individual component specifications
    - data_flow: How data moves through the system
    - integration_points: External system interfaces
```

### API Design
```yaml
api_design:
  description: |
    Design interfaces and contracts
  elements:
    - endpoints: REST/GraphQL/RPC endpoints
    - data_models: Request/response schemas
    - authentication: Security and access control
    - versioning: API evolution strategy
```

### Implementation Planning
```yaml
implementation_planning:
  description: |
    Plan the implementation approach
  sections:
    - development_phases: Incremental delivery plan
    - technology_stack: Tools and frameworks
    - testing_strategy: Test types and coverage
    - deployment_plan: Release and rollout strategy
```

## Design Patterns

### Architectural Patterns
```yaml
patterns:
  microservices:
    when: "Need independent scaling and deployment"
    pros: ["Scalability", "Technology diversity", "Fault isolation"]
    cons: ["Complexity", "Network overhead", "Data consistency"]
    
  monolithic:
    when: "Simple domain, small team, rapid prototyping"
    pros: ["Simplicity", "Easy debugging", "Fast development"]
    cons: ["Scaling limitations", "Technology lock-in"]
    
  serverless:
    when: "Event-driven, variable load, cost optimization"
    pros: ["No infrastructure", "Auto-scaling", "Pay per use"]
    cons: ["Vendor lock-in", "Cold starts", "Debugging challenges"]
```

## Prompts

### Architecture Design Prompt
```
Design the architecture for: {{solution}}

Consider:
- Scale requirements: {{scale}}
- Performance needs: {{performance}}
- Security requirements: {{security}}
- Integration points: {{integrations}}

Provide:
1. High-level architecture diagram (ASCII/Mermaid)
2. Component responsibilities
3. Data flow description
4. Technology recommendations
```

### API Design Prompt
```
Design APIs for: {{system_name}}

Requirements:
{{#each requirements}}
- {{this}}
{{/each}}

Include:
1. Endpoint definitions
2. Data models (JSON Schema)
3. Authentication approach
4. Error handling strategy
5. Versioning plan
```

## Outputs

### Architecture Document Template
```markdown
# Architecture Design: {{project_name}}

## Overview
{{overview}}

## Architecture Diagram
```mermaid
{{diagram}}
```

## Components
{{#each components}}
### {{name}}
**Purpose**: {{purpose}}
**Technology**: {{technology}}
**Responsibilities**:
{{#each responsibilities}}
- {{this}}
{{/each}}
**Interfaces**:
{{#each interfaces}}
- {{type}}: {{description}}
{{/each}}
{{/each}}

## Data Flow
{{data_flow_description}}

## Technology Stack
{{#each stack}}
- **{{layer}}**: {{technology}} - {{rationale}}
{{/each}}

## Security Considerations
{{security_design}}

## Scalability Plan
{{scalability_approach}}

## Deployment Architecture
{{deployment_design}}
```

### API Specification Template
```markdown
# API Design: {{api_name}}

## Overview
{{api_overview}}

## Authentication
{{auth_method}}

## Endpoints
{{#each endpoints}}
### {{method}} {{path}}
**Description**: {{description}}
**Authentication**: {{auth_required}}
**Request**:
```json
{{request_schema}}
```
**Response**:
```json
{{response_schema}}
```
**Errors**:
{{#each errors}}
- {{code}}: {{description}}
{{/each}}
{{/each}}

## Data Models
{{#each models}}
### {{name}}
```json
{{schema}}
```
{{/each}}

## Versioning Strategy
{{versioning_approach}}
```

## Integration Points

### Input from Analysis
- Selected solution approach
- Identified constraints
- Component breakdown
- Success criteria

### Output to Implementation
- Architecture blueprints
- API specifications
- Technology decisions
- Implementation phases

## Usage Examples

### Basic Design
```bash
claude plan design --solution "microservices-approach"
```

### With Architecture Pattern
```bash
claude plan design \
  --solution "user-service" \
  --pattern "microservices" \
  --stack "node,postgres,redis"
```

### API-First Design
```bash
claude plan design \
  --type "api-first" \
  --spec "openapi" \
  --endpoints "users,products,orders"
```

## Validation Rules

### Architecture Validation
- All components must have clear boundaries
- Data flow must be unidirectional where possible
- Security must be addressed at each layer
- Scalability approach must be defined

### API Validation
- All endpoints must have error handling
- Authentication method must be specified
- Data models must include validation rules
- Versioning strategy required

## Best Practices

### Architecture Best Practices
1. Keep components loosely coupled
2. Design for failure and recovery
3. Make security a first-class concern
4. Document decision rationale
5. Plan for monitoring and observability

### API Best Practices
1. Use consistent naming conventions
2. Version from the start
3. Design idempotent operations
4. Provide comprehensive error messages
5. Document with examples

## Design Checklist
- [ ] Architecture diagram created
- [ ] Components clearly defined
- [ ] Interfaces documented
- [ ] Data flow mapped
- [ ] Security addressed
- [ ] Scalability planned
- [ ] API contracts defined
- [ ] Error handling designed
- [ ] Deployment strategy outlined

## See Also
- [analysis.md](analysis.md) - Problem analysis phase
- [implementation.md](implementation.md) - Implementation phase
- [_core.md](_core.md) - Core planning utilities