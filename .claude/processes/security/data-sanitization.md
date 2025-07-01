---
module: DataSanitization
scope: persistent
triggers: ["sanitize", "clean data", "remove sensitive", "redact", "before posting"]
conflicts: []
dependencies: []
priority: critical
---

# Data Sanitization Process

## Purpose
Remove or mask sensitive information before posting to any public or semi-public location, preventing accidental exposure of credentials, personal information, or system details that could compromise security or privacy.

## Trigger
Execute before:
- Posting any content to issue trackers
- Creating pull request descriptions
- Committing code or messages
- Sharing debug output
- Posting error messages
- Any external communication

## Prerequisites
- Content to be sanitized
- Understanding of sensitivity context
- Access to sanitization tools

## Steps

### Step 1: Content Type Assessment
```
1.1 Identify content format:
    - Plain text → Use text sanitization tools
    - JSON data → Use structure-aware tools
    - Log files → Use log-specific patterns
    - Code snippets → Use syntax-aware tools
    - Error traces → Preserve structure while sanitizing

1.2 Determine sensitivity level:
    - Public posting (GitHub, forums) → Maximum sanitization
    - Internal team → Moderate sanitization
    - Local only → Minimal sanitization

1.3 Assess complexity:
    - Simple patterns → Basic regex tools
    - Nested structures → Advanced parsing
    - Mixed content → Multiple passes
```

### Step 2: Tool Selection
```
2.1 Select primary tool based on content:

    For simple text patterns:
    - sed for basic replacements
    - grep for pattern detection

    For complex patterns:
    - awk for structured text
    - perl for advanced regex

    For structured data:
    - jq for JSON
    - yq for YAML
    - xmlstarlet for XML

    For fallback:
    - python for any complexity

2.2 Verify tool availability:
    Check: command -v ${tool_name}
    If unavailable, use next preference

2.3 Prepare tool commands:
    Based on ${sanitization_patterns} configuration
```

### Step 3: Pattern Detection
```
3.1 Scan for Personal Identifiable Information (PII):

    Email addresses:
    - Pattern: [\w\.-]+@[\w\.-]+\.\w+
    - Replace with: <email>

    Names in paths:
    - /home/username/ → /home/<username>/
    - /Users/johndoe/ → /Users/<username>/
    - C:\Users\Alice\ → C:\Users\<username>\

    Phone numbers:
    - Pattern: [\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4}
    - Replace with: <phone>

    Social Security Numbers:
    - Pattern: \b\d{3}-\d{2}-\d{4}\b
    - Replace with: <ssn-REDACTED>

3.2 Scan for System Information:

    IP addresses:
    - Pattern: \b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b
    - Replace with: <ip-address>
    - Exception: Keep 127.0.0.1 and 0.0.0.0

    Hostnames:
    - Pattern: [a-zA-Z0-9\-]+\.(local|internal|corp)
    - Replace with: <hostname>

    MAC addresses:
    - Pattern: ([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})
    - Replace with: <mac-address>

    Ports (when sensitive):
    - Pattern: :(?!80|443|22|3000|8080)\d{2,5}
    - Replace with: :<port>

3.3 Scan for Credentials:

    API keys:
    - Pattern: (api[_-]?key|apikey|api_token)[\s:="']+([A-Za-z0-9\-_]{20,})
    - Replace with: $1=<api-key-REDACTED>

    Passwords:
    - Pattern: (password|passwd|pwd)[\s:="']+([^\s"']+)
    - Replace with: $1=<password>

    Tokens:
    - Pattern: (bearer|token|auth)[\s:="']+([A-Za-z0-9\-_\.]{20,})
    - Replace with: $1 <token-REDACTED>

    SSH keys:
    - Pattern: -----BEGIN ([A-Z ]+) KEY-----[\s\S]+?-----END \1 KEY-----
    - Replace with: <ssh-key-REDACTED>

    Database URLs:
    - Pattern: (postgres|mysql|mongodb)://[^:]+:[^@]+@[^/]+/\w+
    - Replace with: $1://<user>:<password>@<host>/<database>

3.4 Scan for Identifiers:

    UUIDs:
    - Pattern: [0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}
    - Replace with: <uuid>

    GUIDs:
    - Pattern: \{[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\}
    - Replace with: <guid>

    Session IDs:
    - Pattern: (session[_-]?id|sid)[\s:="']+([A-Za-z0-9]{16,})
    - Replace with: $1=<session-id>
```

### Step 4: Multi-pass Sanitization
```
4.1 First pass - Critical credentials:
    Priority: Remove immediately dangerous items
    - API keys and tokens
    - Passwords and secrets
    - Private keys
    - Database credentials

4.2 Second pass - Personal information:
    Priority: Protect privacy
    - Email addresses
    - Names and usernames
    - Phone numbers
    - Personal identifiers

4.3 Third pass - System details:
    Priority: Prevent reconnaissance
    - Internal hostnames
    - IP addresses
    - File paths with usernames
    - Infrastructure details

4.4 Final pass - Context-specific:
    Priority: Project-specific patterns
    - Custom ID formats
    - Internal project names
    - Client information
    - Proprietary data patterns
```

### Step 5: Implementation Examples
```
5.1 Using sed (simple patterns):
    # Sanitize email addresses
    echo "$content" | sed -E 's/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/<email>/g'

    # Sanitize IP addresses
    echo "$content" | sed -E 's/\b([0-9]{1,3}\.){3}[0-9]{1,3}\b/<ip-address>/g'

5.2 Using awk (multi-line patterns):
    # Sanitize multi-line SSH keys
    awk '
    /-----BEGIN .* KEY-----/ { in_key=1; print "<ssh-key-REDACTED>"; next }
    /-----END .* KEY-----/ { in_key=0; next }
    !in_key { print }
    ' file.txt

5.3 Using Python (complex logic):
    python3 -c "
    import re
    import sys

    content = sys.stdin.read()

    # Define patterns with named groups for clarity
    patterns = [
        # API keys with context
        (r'(api[_-]?key|token)[\"\'\\s:=]+([A-Za-z0-9\\-_]{20,})', r'\\1=<api-key-REDACTED>'),
        # Email addresses
        (r'[\\w\\.-]+@[\\w\\.-]+\\.\\w+', '<email>'),
        # File paths with usernames
        (r'/home/[^/]+/', '/home/<username>/'),
        # UUIDs
        (r'[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}', '<uuid>')
    ]

    # Apply all patterns
    for pattern, replacement in patterns:
        content = re.sub(pattern, replacement, content, flags=re.IGNORECASE)

    print(content)
    "

5.4 Using jq (JSON data):
    # Sanitize JSON while preserving structure
    jq 'walk(
        if type == "object" then
            with_entries(
                if .key | test("password|secret|token"; "i") then
                    .value = "<redacted>"
                else . end
            )
        elif type == "string" then
            gsub("[\\w.-]+@[\\w.-]+\\.[\\w]+"; "<email>") |
            gsub("Bearer [A-Za-z0-9\\-_.]+"; "Bearer <token-REDACTED>")
        else . end
    )' data.json
```

### Step 6: Validation
```
6.1 Quick scan for missed patterns:
    - Re-run detection without replacement
    - Flag any matches found
    - Manually review if needed

6.2 Check for partial exposures:
    - Key prefixes (sk_live_xxx → <api-key>)
    - Encoded credentials (base64, hex)
    - URLs with embedded auth

6.3 Context preservation check:
    - Error messages still meaningful?
    - Stack traces still useful?
    - Relationships preserved?

6.4 Over-sanitization check:
    - Public information not redacted
    - Error types preserved
    - Line numbers intact
```

### Step 7: Final Formatting
```
7.1 Add sanitization notice:
    Prepend to sanitized content:
    "Note: This output has been sanitized to remove sensitive information.
     Patterns like <email>, <ip-address>, and <api-key-REDACTED>
     replace actual values."

7.2 Preserve debugging value:
    - Keep error types and codes
    - Maintain stack trace structure
    - Preserve timestamp formats
    - Keep relative relationships

7.3 Document what was sanitized:
    If significant sanitization:
    "Sanitized: 3 email addresses, 2 API keys, 1 database URL"
```

## Common Sanitization Scenarios

### Error Message Sanitization
```
Original:
Failed to connect to database at postgresql://admin:SuperSecret123@192.168.1.100:5432/production
User john.smith@company.com does not have permission

Sanitized:
Failed to connect to database at postgresql://<user>:<password>@<ip-address>:5432/<database>
User <email> does not have permission
```

### Stack Trace Sanitization
```
Original:
Traceback (most recent call last):
  File "/home/johndoe/projects/secret-project/main.py", line 42, in process
    api_key = "sk_live_abcd1234efgh5678ijkl"

Sanitized:
Traceback (most recent call last):
  File "/home/<username>/projects/<project>/main.py", line 42, in process
    api_key = "<api-key-REDACTED>"
```

### Configuration File Sanitization
```
Original:
{
  "database_url": "postgres://dbuser:mypassword@db.internal.company.com/app",
  "api_key": "ak_prod_1234567890abcdef",
  "admin_email": "admin@company.com"
}

Sanitized:
{
  "database_url": "postgres://<user>:<password>@<hostname>/<database>",
  "api_key": "<api-key-REDACTED>",
  "admin_email": "<email>"
}
```

## Tool Fallback Chain

When primary tools unavailable:

1. **No sed?** → Use awk or perl
2. **No jq?** → Use python -m json.tool + sed
3. **No specialized tools?** → Fall back to Python
4. **No scripting?** → Provide manual instructions

## Integration Points

- **Called by**: All processes before external posting
- **Especially critical for**: IssueUpdate, CommitWork, SubmitWork
- **Configuration from**: sanitization_patterns in manifest
- **Reports to**: Security audit logs

## Best Practices

### Do's
- ✅ Sanitize before posting, not after
- ✅ Err on the side of over-sanitization
- ✅ Preserve error context while removing details
- ✅ Test sanitization patterns regularly
- ✅ Keep local unsanitized copies for debugging

### Don'ts
- ❌ Post first, sanitize later
- ❌ Trust automatic sanitization blindly
- ❌ Remove so much context errors become useless
- ❌ Forget about encoded sensitive data
- ❌ Sanitize local-only debugging sessions

## Security Considerations

Remember that sanitization is part of defense in depth. Even with sanitization:
- Never commit actual credentials to repositories
- Use environment variables for secrets
- Rotate any accidentally exposed credentials
- Review sanitized output before posting
- Consider the audience and adjust accordingly

The goal is to share useful information for debugging and collaboration while preventing any security or privacy breaches. When in doubt, redact it out!
