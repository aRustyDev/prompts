# TODO

- Implement TDD Prompt Engineering workflow (Promptimize framework, Promptfoo, Textlint, Markdownlint, DeepEval, Yajsv);  Conversation Regressio Testing
- Add In Prompt testing for Rust https://github.com/budziq/rust-skeptic
- Implement regression testing process and add to testing workflow
- Add preference for `orb` > `docker`
- Add HostOS Conditionals
- Add to Dev Workflow
  - Tagging
  - Changelog Updates
  - Version Bumping
  - Code Deduplication
  - Code Duplicate Identification
- Add Guides
  - Python Testing
  - Rust Testing
  - Golang Testing
  - Kubernetes
  - Talos
  - Bottlerocket Project
  - Nix
  - Nix Darwin
  - Home-manager
  - dotfiles
  - gh cli
    - gh project (specifically adding the project permissions)
    - gh attestation verify
    - gh auth refresh
    - gh gist
    - gh repo
    - gh issue
    - gh label
    - gh pr
    - gh release
    - gh run
    - gh search
    - gh secret
    - gh variable
    - gh workflow
- Add process/workflow for identifying a short task that should be scripted (ie convert "known string: x hrs" to "known string: 'xh'" in a group of template based files) and then creating a short script for that task.
- Add conditional `@~/workflow/*` references, to minimize memory load w/ not neccessary
- Add conditional `@~/templates/*` references, to minimize memory load w/ not neccessary
- Add conditional `@~/processes/*` references, to minimize memory load w/ not neccessary
- Add conditional `@~/commands/*` references, to minimize memory load w/ not neccessary
- Add conditional `@~/helpers/*` references, to minimize memory load w/ not neccessary
- Add `/plan feature` command; interactively query for refactor details, and clarify until plan is ready, then add plan to issue tracker as project/milestone
- Add `/plan fix` command; interactively query for fix details, then assess and requery/clarify until plan is ready, then add plan to issue tracker as project/milestone
- Add `/plan refactor` command; interactively query for refactor details, then assess and requery/clarify until plan is ready, then add plan to issue tracker as project/milestone
- Add `/assess codebase` command; assess code base
- Add `/assess osint` command; assess osint for org after querying for basic details
- Add `/assess vulnerabilities` command; assess vulnerability landscape for org after querying for basic details
- Add `/hunt init` command; iteratively configure threat hunt plan
- Add `/hunt explore` command; Use configured data to begin preparatory hunt exploration and analysis (ie develop threat intel)
- Add `/hunt plan` command; Iteratively develop plan to hunt based on exploration and clarification.
- Add `/hunt discover` command; Begin using plan to hunt
- Add `/jira war` command; record WAR in jira format
  - Task(On Opening): Title, Expected Hours, Description of expected work
  - Logged Work[n]: Date started, Time Spent, Work Description, related challenges discovered, related solutions implemented, description of related Research and exploration, code changs involved
  - Task(On Closing): Title, Total Changes, Description of Impact, Lessons Learned Overall
  - Format
```markdown
NOTE: times (estimated, actual, or total) should be formatted as 3w 4d 12h, and should be enclosed in quotes
# Week MM-DD-2025

## Implement Testing: <Descriptive Subtitle Here>
### Task: On Opening
Expected Time to complete: "x+y h"
Description of expected work here

Expected Work:
- foo (x hrs)
- bar (y hrs)

---

### Logged work: foo
Date started: MM-DD-2025
Actual Time Spent: z hrs
Work Description after the fact, include unplanned work involved in completing this

#### Challenges
Description of challenges related to this item of logged work

#### Solutions
Description of Solutions to the challenges in this item of logged work

#### Research & Exploration
Description of Research and Exploration conducted in relation to this logged work.

#### Code Changes Involved
Lines of code Added/Removed
High level description of code changes, minimal code examples
Files changed: x
- path/to/file1
- path/to/file2

---

### Task: On Closing
High level description of total changes
Description of impact of work in this task on the project as a whole.
Total time spent: x hrs
Reason for time discrepency: foo bar blah blah

#### Lessons Learned
Description of lessons learned this week from challenges and their solutions.
```

## Roles

### CAD Design Expert 
- AutoDesk
- Fusion
- AutoCAD

### KiCAD Design Expert 
- KiCAD
- FreePCB
- Altium
- LTSpice
- EasyEDA

### 3D Printer Expert 
- Thermal Expansion Consideration on Print Plan

### Front End UI Design Expert

### Front End UX Design Expert

### Front End Engineer

### Political Scientist

### Political Strategist

### Campaign Manager

### Campaign Strategist

### Director of communications
