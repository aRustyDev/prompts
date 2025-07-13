# Configuration

This directory contains system and project configuration files.

## Configuration Files

- **project.yaml** - Project-specific settings and preferences
- **logging.yaml** - Logging configuration and output settings
- **memory.yaml** - Memory management configuration
- **code.yaml** - Code style and development settings
- **repositories.yaml** - Repository management configuration
- **role-manager.yaml** - Role caching and management settings
- **mcp.json** - Model Context Protocol server configuration

## Configuration Hierarchy

1. **Project Settings** - Override system defaults
2. **User Settings** - Personal preferences
3. **System Defaults** - Base configuration

## Environment Variables

Configuration files support environment variable substitution:
- Use `${VAR_NAME}` syntax
- Falls back to defaults if not set

## Validation

All configuration files are validated against schemas in `shared/schemas/`
