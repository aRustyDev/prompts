# Memory Management System

This document describes the memory management architecture for the .claude/ system.

## Overview

The memory system consists of two primary components:

1. **Configuration Memory** (`manifest.md`) - Module loading and management
2. **Runtime Memory** (`.memory/`) - Active session memory

## Configuration Memory

### Module Loading System

Modules are loaded based on:
- **Triggers**: Keywords in conversation
- **Dependencies**: Required modules
- **Scope**: Persistence level
- **Priority**: Loading order

### Memory Limits

- Maximum 15 concurrent modules
- Priority-based unloading
- Scope hierarchy: locked > persistent > context > temporary

### Reinforcement Protocol

- Check loaded modules every 10 interactions
- Verify context alignment
- Prompt for module adjustments if needed

## Runtime Memory

### Memory Layers

1. **Short-term** (`.memory/short.md`)
   - Current task context
   - Active variables
   - Immediate goals

2. **Medium-term** (`.memory/medium.md`)
   - Session objectives
   - Completed tasks
   - Learned patterns

3. **Long-term** (`.memory/long.md`)
   - Project knowledge
   - User preferences
   - Historical patterns

4. **Shared** (`.memory/shared.md`)
   - Cross-session data
   - Common patterns
   - Reusable insights

## Memory Commands

- `!load <module>` - Load a module
- `!unload <module>` - Unload a module
- `!list-modules` - Show loaded modules
- `!lock <module>` - Prevent unloading
- `!unlock <module>` - Allow unloading

## Best Practices

1. Keep modules focused and single-purpose
2. Declare accurate dependencies
3. Use appropriate scopes
4. Monitor memory usage
5. Clean up temporary modules

For more details, see:
- `manifest.md` - Module registry
- `.meta/module-creation-guide.md` - Module development
- `core/loader.md` - Loading implementation
