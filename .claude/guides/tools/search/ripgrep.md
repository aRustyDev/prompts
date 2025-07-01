---
module: RipgrepGuide
scope: temporary
triggers: ["rg", "ripgrep", "fast search", "search code", "grep replacement"]
conflicts: []
dependencies: []
priority: low
---

# Ripgrep (rg) Usage Guide

## Purpose
Quick reference for using ripgrep, a fast recursive search tool that respects gitignore and provides powerful pattern matching capabilities.

## Basic Usage

### Simple Search
```bash
# Search for pattern in current directory
rg "pattern"

# Search for exact word
rg -w "word"

# Case-insensitive search
rg -i "pattern"

# Search specific file types
rg -t python "import"
rg -t js "console.log"
```

## Common Patterns

### Finding Function Definitions
```bash
# Python functions
rg "^def \w+\(" -t py

# JavaScript functions
rg "(function|const|let|var)\s+\w+\s*=" -t js

# Go functions
rg "^func\s+\w+" -t go
```

### Searching with Context
```bash
# Show 3 lines before and after match
rg -C 3 "error"

# Show only lines before
rg -B 2 "error"

# Show only lines after
rg -A 2 "error"
```

### Excluding Patterns
```bash
# Exclude directories
rg "TODO" -g '!vendor/' -g '!node_modules/'

# Exclude file patterns
rg "secret" -g '!*.test.js' -g '!*_test.go'

# Invert match (show lines NOT containing pattern)
rg -v "debug"
```

## Advanced Features

### Using Regular Expressions
```bash
# Email addresses
rg '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'

# IP addresses
rg '\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b'

# TODO/FIXME with author
rg 'TODO|FIXME' -A 1 | rg '@\w+'
```

### File Type Management
```bash
# List all known file types
rg --type-list

# Define custom type
rg --type-add 'web:*.{html,css,js}' -t web "class="

# Search multiple types
rg -t rust -t toml "version"
```

### Performance Optimization
```bash
# Use multiple threads (default: number of CPU cores)
rg -j 4 "pattern"

# Disable regex for literal speed
rg -F "exact.string"

# Search binary files
rg -a "pattern"
```

### Output Formatting
```bash
# Show only filenames
rg -l "pattern"

# Show only count
rg -c "pattern"

# No filename headers
rg --no-heading "pattern"

# JSON output
rg --json "pattern"
```

## Integration Examples

### Finding Unused Functions
```bash
# Find function definitions
rg "^def (\w+)\(" -r '$1' -o | sort -u > defined.txt

# Find function calls
rg "\b(\w+)\(" -r '$1' -o | sort -u > called.txt

# Compare
comm -23 defined.txt called.txt
```

### Security Audit Patterns
```bash
# Hardcoded passwords
rg -i "password\s*=\s*[\"'][^\"']+[\"']"

# API keys
rg "api[_-]?key\s*[:=]\s*[\"'][0-9a-zA-Z]{20,}[\"']"

# SQL injection risks
rg "query.*\+.*request\." -t python
```

### Refactoring Helpers
```bash
# Find all imports of a module
rg "from mymodule import|import mymodule"

# Find class instantiations
rg "new\s+ClassName\b|\bClassName\("

# Find deprecated function usage
rg "deprecated_function\("
```

## Troubleshooting

### Pattern Not Matching
- Check regex escaping: `rg "\.txt$"` not `rg ".txt$"`
- Use `-F` for literal strings with special chars
- Test regex at regex101.com first

### Too Many Results
- Use `-t` to limit file types
- Add `-g` patterns to exclude directories
- Use `-w` for whole word matching

### Performance Issues
- Exclude large directories: `-g '!*.log'`
- Limit search depth: `--max-depth 3`
- Use literal search when possible: `-F`

## Comparison with grep
| Feature | grep | ripgrep |
|---------|------|---------|
| Speed | Slower | Much faster |
| Gitignore | No | Yes |
| Unicode | Limited | Full |
| Recursive | -r flag | Default |
| Binary files | Warning | Skips |

## Quick Command Reference
```bash
rg [OPTIONS] PATTERN [PATH ...]

Common OPTIONS:
  -i    Case insensitive
  -w    Word boundaries
  -v    Invert match
  -F    Fixed strings (literal)
  -l    Files with matches
  -c    Count matches
  -t    File type
  -g    Glob patterns
  -A/B/C Context lines
  -j    Thread count
```

Remember: ripgrep is optimized for searching code repositories. It automatically skips binary files and respects .gitignore, making it ideal for development workflows.
