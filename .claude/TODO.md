# TODO

<!-- Captured by Claude on 2025-07-02 -->
<!-- All items below have been converted to GitHub issues -->
<!-- Projects created: #17 (Claude Code Enhancement Suite), #18 (Claude Code Commands & Roles) -->
<!-- Milestones created: Testing & Quality Framework, Cross-Platform Compatibility, Command Suite v1.0, Expert Roles System -->
<!-- Parent issues created: #1, #8, #9, #10, #11, #12, #13, #14, #15, #16, #17 -->
<!-- Total issues created: 85 (17 parent + 68 child issues) -->

## ✅ CAPTURED ITEMS

### Testing Framework (Issue #1)
- ~~Implement TDD Prompt Engineering workflow (Promptimize framework, Promptfoo, Textlint, Markdownlint, DeepEval, Yajsv);  Conversation Regressio Testing~~ → Issue #2
- ~~Add In Prompt testing for Rust https://github.com/budziq/rust-skeptic~~ → Issue #3
- ~~Implement regression testing process and add to testing workflow~~ → Issue #4

### OS Compatibility (Issue #9)
- ~~Add preference for `orb` > `docker`~~ → Issue #25
- ~~Add HostOS Conditionals~~ → Issue #26

### Dev Workflow (Issue #8)
- ~~Add to Dev Workflow~~
  - ~~Tagging~~ → Issue #18
  - ~~Changelog Updates~~ → Issue #19
  - ~~Version Bumping~~ → Issue #20
  - ~~Code Deduplication~~ → Issue #21
  - ~~Code Duplicate Identification~~ → Issue #22
  - ~~Link created projects to the repo, unless specified otherwise~~ → Issue #23

### Guides (Issues #1, #14, #15)
- ~~Add Guides~~
  - ~~Python Testing~~ → Issue #5
  - ~~Rust Testing~~ → Issue #6
  - ~~Golang Testing~~ → Issue #7
  - ~~Kubernetes~~ → Issue #65
  - ~~Talos~~ → Issue #66
  - ~~Bottlerocket Project~~ → Issue #67
  - ~~Nix~~ → Issue #68
  - ~~Nix Darwin~~ → Issue #69
  - ~~Home-manager~~ → Issue #70
  - ~~dotfiles~~ → Issue #71
  - ~~gh cli~~ → Issues #51-64
    - ~~gh project (specifically adding the project permissions)~~ → Issue #51
    - ~~gh attestation verify~~ → Issue #52
    - ~~gh auth refresh~~ → Issue #53
    - ~~gh gist~~ → Issue #54
    - ~~gh repo~~ → Issue #55
    - ~~gh issue~~ → Issue #56
    - ~~gh label~~ → Issue #57
    - ~~gh pr~~ → Issue #58
    - ~~gh release~~ → Issue #59
    - ~~gh run~~ → Issue #60
    - ~~gh search~~ → Issue #61
    - ~~gh secret~~ → Issue #62
    - ~~gh variable~~ → Issue #63
    - ~~gh workflow~~ → Issue #64

### Script Generation (Issue #8)
- ~~Add process/workflow for identifying a short task that should be scripted~~ → Issue #24

### Conditional Loading (Issue #9)
- ~~Add conditional `@~/workflow/*` references~~ → Issue #27
- ~~Add conditional `@~/templates/*` references~~ → Issue #28
- ~~Add conditional `@~/processes/*` references~~ → Issue #29
- ~~Add conditional `@~/commands/*` references~~ → Issue #30
- ~~Add conditional `@~/helpers/*` references~~ → Issue #31

### Planning Commands (Issue #10)
- ~~Add `/plan feature` command~~ → Issue #32
- ~~Add `/plan fix` command~~ → Issue #33
- ~~Add `/plan refactor` command~~ → Issue #34
- ~~Add `/plan-from-scratch` command~~ → Issue #35

### Assessment Commands (Issue #11)
- ~~Add `/assess codebase` command~~ → Issue #37
- ~~Add `/assess osint` command~~ → Issue #38
- ~~Add `/assess vulnerabilities` command~~ → Issue #39

### Threat Hunting Commands (Issue #12)
- ~~Add `/hunt init` command~~ → Issue #40
- ~~Add `/hunt explore` command~~ → Issue #41
- ~~Add `/hunt plan` command~~ → Issue #42
- ~~Add `/hunt discover` command~~ → Issue #43

### Activity Tracking (Issue #13)
- ~~Add `/jira war` command~~ → Issue #45
- ~~`/todo-2-issues` extensions~~ → Issues #46-50

### Hooks (Issue #16)
- ~~Add notification Hooks (Via Slack)~~ → Issue #72
- ~~Add logging Hooks (Log to `~/.claude/logs/`)~~ → Issue #73
- ~~Add Automatic formatting Hooks~~
  - ~~Prettier~~ → Issue #74
  - ~~gofmt~~ → Issue #75
  - ~~cargo fmt~~ → Issue #76
- ~~Add `op` PreToolUse events~~ → Issue #77

### Expert Roles (Issue #17)
- ~~CAD Design Expert~~ → Issue #78
- ~~KiCAD Design Expert~~ → Issue #79
- ~~3D Printer Expert~~ → Issue #80
- ~~Front End UI Design Expert~~ → Issue #81
- ~~Front End UX Design Expert~~ → Issue #82
- ~~Front End Engineer~~ → Issue #83
- ~~Political Scientist~~ → Issue #84
- ~~Political/Campaign roles~~ → Issue #85

## 📝 NEW TODO ITEMS
<!-- Add new TODO items below this line -->

- Add logic for creating issue templates in a repo
- Add intermediate templates for creating issues/projects/milestones in GitHub/GitLab/BitBucket
  - needs: title, description, labels, assignees (default @me), milestone, project
- Add logic for initializing a new project
  - .env: repoName, vaultAddr
- Add support for `op` cli in all
