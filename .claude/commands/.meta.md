# Commands Directory Metadata

## Overview
This directory contains Claude command definitions that extend functionality through slash commands.

## Available Commands

### /hunt
- **Purpose**: Advanced multi-tool code search interface
- **Version**: 1.0.0
- **Dependencies**: 
  - guides/tools/search/ripgrep.md
  - guides/tools/search/grep.md
  - guides/tools/search/awk.md
  - templates/reports/search-results.md
- **Capabilities**: Pattern matching, regex search, structure-aware search, history search
- **Primary Tools**: ripgrep, grep, awk, git grep

### /capture-todos
- **Purpose**: Capture and organize TODO items from code
- **Status**: Active

### /create-command
- **Purpose**: Scaffold new command definitions
- **Status**: Active

### /dojira
- **Purpose**: Jira integration and management
- **Status**: Active

## Command Structure
Each command file should include:
1. Command syntax and overview
2. Options and parameters
3. Examples
4. Implementation details
5. Integration points
6. Error handling
7. Metadata block

## Adding New Commands
Use the `/create-command` to scaffold new commands with the proper structure.