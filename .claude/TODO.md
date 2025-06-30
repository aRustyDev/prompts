# TODO

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
# Week MM-DD-2025 

## Implement Testing: <Descriptive Subtitle Here> 
### Task: On Opening
Expected Time to complete: x hrs
Description of expected work here 

Itemized description of expected work here 
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
Files changed 
High level description of code changes, minimal code examples 

---

### Task: On Closing 
High level description of total changes 
Description of impact of work in this task on the project as a whole. 
Total time spent: x hrs
Reason for time discrepency: foo bar blah blah

#### Lessons Learned 
Description of lessons learned this week from challenges and their solutions.
```
