# Changelog

All notable changes to the .claude/ system will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Complete directory restructuring for better organization
- New `.config/` directory for centralized configuration
- New `.memory/` directory for runtime memory management
- New `.log/` directory for event recording
- New `mcp/` directory for Model Context Protocol integrations
- New `charter/` directory for principles and standards
- INDEX.md for directory overview
- MEMORY.md for memory management documentation

### Changed
- Consolidated meta files under `.meta/`
- Moved all shared resources to `shared/` directory
- Reorganized documentation under `docs/`
- Moved utilities to `utils/` directory

### Removed
- Removed auditor-optimization-report.md
- Removed nix-flake-migration-plan.md
- Removed archive/ directory (moved to .log/archive/)
