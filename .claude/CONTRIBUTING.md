# Contributing to .claude/

Thank you for your interest in contributing to the .claude/ system!

## Module Development Guidelines

### Creating New Modules

1. **Follow the Module Interface Contract**
   - All modules must include proper YAML frontmatter
   - See `.meta/module-creation-guide.md` for detailed requirements

2. **Module Types**
   - **Commands**: New slash commands go in `commands/`
   - **Processes**: Step-by-step procedures go in `shared/processes/`
   - **Workflows**: Multi-process orchestrations go in `shared/workflows/`
   - **Patterns**: Reusable patterns go in `shared/patterns/`
   - **Guides**: Documentation goes in `docs/guides/`

3. **Testing**
   - Add tests for new modules in `utils/tests/`
   - Validate modules using the validation framework

### Directory Structure

- Use `shared/` for rigorous, reusable definitions
- Use `docs/` for descriptive, informative content
- Keep configuration in `.config/`
- Store runtime data in `.log/` and `.memory/`

### Pull Request Process

1. Create a feature branch
2. Make your changes
3. Update relevant documentation
4. Test your changes
5. Submit a pull request with clear description

### Code Standards

- Follow existing patterns and conventions
- Maintain consistent formatting
- Include appropriate error handling
- Document complex logic

### Questions?

If you have questions about contributing, please review:
- `.meta/module-creation-guide.md`
- `charter/standards/`
- `docs/guides/developer-onboarding.md`
