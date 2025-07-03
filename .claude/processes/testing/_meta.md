---
category: Testing Processes
description: Modules related to software testing methodologies and practices
default_scope: context
default_priority: high
---

# Testing Process Modules

This directory contains modules for various testing methodologies and approaches. These modules are typically loaded in development contexts when testing is required.

## Available Modules

### Test-Driven Development (TDD)
- **File**: `tdd.md`
- **Purpose**: Red-green-refactor cycle with continuous integration
- **Default**: Yes (persistent scope)

### Coverage-Driven Development (CDD)
- **File**: `cdd.md`
- **Purpose**: Development focused on coverage metrics
- **Conflicts with**: TDD, BDD

### Behavior-Driven Development (BDD)
- **File**: `bdd.md`
- **Purpose**: Scenario-based development approach
- **Conflicts with**: TDD, CDD

## Common Dependencies
All testing modules depend on:
- `processes/version-control/commit-standards.md`
- `processes/issue-tracking/issue-management.md`

## Loading Rules
- Only one primary testing methodology can be active at a time
- Exception: Comparison mode allows multiple for evaluation
- TDD is loaded by default as persistent module