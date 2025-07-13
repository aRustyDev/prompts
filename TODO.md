# TODO/

## New directory Structure for `.claude/`/
```dir/
.claude/
├── INDEX.md
├── CLAUDE.md
├── README.md
├── CHANGELOG.md
├── CONTRIBUTING.md
├── MEMORY.md
├── .metrics/
├── .meta/
├── .config/
│    ├── project.yaml
│    ├── logging.yaml
│    ├── memory.yaml
│    └── code.yaml
├── .memory/
│    ├── shared.md
│    ├── short.md
│    ├── medium.md
│    └── long.md
├── .log/ : Records events/actions locally
├── .plan/ : Stores plans locally
├── commands/
│    ├── record/  : records some context as a Weekly Action Report item, unit of work, JIRA issues/task/comment, apple reminder, etc
│    ├── report/  : report errors, tuning requirements, bugs, feature requests, etc
│    ├── audit/   : broadly audits things like github workflows, pre-commit hooks, pre-commit configs, unit tests, mocks, test coverage, prompts, etc for general competency
│    ├── analyze/ : review things like cicd, tests, prompt, slash-commands for specifics like security, performance, scalability, maintainability, etc
│    ├── hunt/    : conduct hunting activities, init, research, analyze, queries, indicators, threat-modeling
│    ├── role/ : <scope>/<specialty>
│    │    ├── architect/
│    │    ├── manager/
│    │    ├── lead/
│    │    ├── junior/
│    │    └── senior/
│    ├── find
│    │    ├── project/
│    │    └── work/ : find good items to work on, then when selected, offer to /plan how to do it
│    ├── review/ : slash-command, prompt, code, process, report
│    ├── plan/ : plan how to do/build different things
│    │    ├── scripts/
│    │    ├── prompt/
│    │    ├── slash-command/
│    │    ├── microservices/
│    │    ├── cli/
│    │    ├── tui/
│    │    ├── mcp/ : server, client
│    │    ├── cicd/
│    │    │    ├── git-hooks/ : Direct git-hooks, pre-commit hooks from pre-commit project
│    │    │    ├── gitlab/
│    │    │    ├── tekton/
│    │    │    ├── drone/
│    │    │    ├── argo/
│    │    │    ├── jenkins/
│    │    │    └── github/
│    │    ├── tests/ : unit, benchmark, profiling, integration, end-to-end, mock
│    │    └── templates/
│    └── report/ : generates reports for things
├── utils/
│    ├── hooks/
│    ├── helpers/
│    ├── validators/
│    ├── tests/
│    └── scripts/
├── shared/
│    ├── schemas/
│    │    ├── events/
│    │    ├── objects/
│    │    ├── data-structures/
│    │    ├── social/
│    │    └── roles/
│    ├── specs/
│    │    ├── base/
│    │    └── custom/
│    ├── roles/
│    │    ├── base/
│    │    │    ├── cicd/
│    │    │    ├── prompting/
│    │    │    ├── offsec/
│    │    │    ├── forensics/
│    │    │    ├── threat-hunting/
│    │    │    ├── audit/
│    │    │    └── development/
│    │    └── custom/
│    ├── workflows/
│    │    ├── cicd/
│    │    ├── prompting/
│    │    ├── offsec/
│    │    ├── forensics/
│    │    ├── threat-hunting/
│    │    ├── audit/
│    │    └── development/
│    ├── processes/
│    │    ├── analysis/
│    │    ├── auditing/
│    │    ├── cicd
│    │    │    ├── complexity/
│    │    │    ├── core/
│    │    │    ├── governance/
│    │    │    ├── optimization/
│    │    │    ├── patterns/
│    │    │    └── platform/
│    │    ├── code-review/
│    │    ├── config/
│    │    ├── integrations/
│    │    ├── issue-tracking/
│    │    ├── meta/
│    │    ├── roles/
│    │    ├── security/
│    │    ├── testing/
│    │    ├── tooling/
│    │    ├── ui/
│    │    └── version-control/
│    │         ├── jj/
│    │         └── git/
│    ├── templates/
│    │    ├── outputs/
│    │    ├── reports/
│    │    ├── prompts/
│    │    ├── posts/
│    │    └── tests/
│    └── patterns/
│          ├── analysis/
│          ├── architecture/
│          ├── cicd
│          │    ├── blue-green/
│          │    ├── build-test-deploy/
│          │    ├── canary/
│          │    ├── feature-flags/
│          │    ├── gitops/
│          │    ├── microservices/
│          │    ├── monorepo/
│          │    ├── progressive-delivery/
│          │    └── rolling/
│          └── development/
├── charter/    : Guiding Principles & Organizational Standards/Morals
│    ├── index.md
│    ├── principles/
│    └── standards/
├── contracts/  : Agreements between Me and Claude
└── docs/
      ├── knowledge/
      ├── examples/
      ├── guides/
      │    ├── auditing/
      │    ├── cicd
      │    │    ├── best-practices/
      │    │    ├── migration/
      │    │    └── platforms
      │    │         ├── github/
      │    │         └── gitlab/
      │    ├── cloud
      │    │    ├── aws/
      │    │    ├── azure/
      │    │    ├── digitalocean/
      │    │    ├── gcp/
      │    │    └── linode/
      │    ├── iac/
      │    │    ├── ansible/
      │    │    ├── arm/
      │    │    ├── bicep/
      │    │    ├── cloudformation/
      │    │    ├── opentofu/
      │    │    ├── packer/
      │    │    ├── puppet/
      │    │    ├── salt/
      │    │    ├── terraform/
      │    │    ├── terragrunt/
      │    │    ├── vagrant/
      │    │    └── vault/
      │    ├── mcp-servers/
      │    ├── monitoring/
      │    │    ├── codecov/
      │    │    ├── gitguardian/
      │    │    ├── opentelemetry/
      │    │    ├── prometheus/
      │    │    └── sentry/
      │    ├── registries/
      │    │    ├── acr/
      │    │    ├── dockerhub/
      │    │    ├── ecr/
      │    │    ├── gcr/
      │    │    ├── harbor/
      │    │    └── quay/
      │    ├── security/
      │    │    ├── dast/
      │    │    ├── dependency-scanning/
      │    │    └── sast/
      │    └── tools/
      │          ├── build
      │          ├── cli-utilities/
      │          ├── containerization/
      │          ├── debugging/
      │          ├── infrastructure/
      │          ├── sanitization/
      │          ├── search/
      │          ├── testing/
      │          └── version-control/
      ├── references/
      └── patterns/
            ├── error-handling/
            ├── github-operations/
            ├── process-integration/
            ├── validation/
            └── git-operations/
```

## Review Agent Rules

- https://github.com/steipete/agent-rules
- https://github.com/e2b-dev/awesome-ai-agents
- https://awesomeagents.ai/
- https://medium.com/%40christianforce/coding-standards-for-ai-agents-cb5c80696f72
- https://www.augmentcode.com/blog/best-practices-for-using-ai-coding-agents
- https://www.aibase.com/repos/project/agent-rules
- https://getawesomesupport.com/documentation/smart-agent-assignment/smart-agent-assignment-concepts/
- https://cdn.openai.com/business-guides-and-resources/a-practical-guide-to-building-agents.pdf
- https://huggingface.co/docs/smolagents/en/tutorials/building_good_agents
- https://github.com/kyrolabs/awesome-agents
- https://www.aibase.com/repos/project/www.aibase.com/repos/project/awesome-agent-quickstart
- https://awesome.ecosyste.ms/lists/kaushikb11%252Fawesome-llm-agents
- https://github.com/ai-boost/awesome-prompts
- https://natnew.github.io/Awesome-Prompt-Engineering/Introduction.html
- https://docs.anthropic.com/en/resources/prompt-library/library
- https://www.godofprompt.ai/awesome-chatgpt-prompts%3Fsrsltid%3DAfmBOorKJjQazl-4X3xdfXgKQ9iklS2eJjr0Cpy_LYoF7xRssAQLXfqE
- https://www.awesomeprompts.cc/
- https://natnew.github.io/Awesome-Prompt-Engineering/Introduction.html
- https://huggingface.co/datasets/fka/awesome-chatgpt-prompts
- https://github.com/f/awesome-chatgpt-prompts
- https://github.com/mahseema/awesome-ai-tools
- https://amanpriyanshu.github.io/Awesome-AI-For-Security/
- https://huyenchip.com/2024/03/14/ai-oss.html
- https://araguaci.github.io/2024-05-30-ai-tools/
- https://www.aiawesome.com/
- https://medium.com/%40zeeshanijaz41/12-awesome-ai-tools-list-d64292d150f0
- https://github.com/hesreallyhim/awesome-claude-code
- https://github.com/langgptai/awesome-claude-prompts
- https://www.anthropic.com/engineering/claude-code-best-practices
- https://docs.anthropic.com/en/docs/about-claude/models/overview
- https://awesomeclaudeprompts.com/
- https://www.claudelog.com/addons/awesome-claude-code
- https://www.datacamp.com/blog/claude-4
- https://www.nextool.ai/tools/awesome-claude-prompts/
- https://github.com/madewithclaude/awesome-claude-artifacts
- https://medium.com/data-science-in-your-pocket/prompt-engineering-is-dead-debb01e9720e
- https://dev.to/awslee/the-prompt-engineer-is-dead-good-riddance-5bfp
- https://medium.com/%409shauryasingh/prompt-engineering-is-dead-0c5e416c8424
- https://ai.plainenglish.io/prompt-engineering-is-dead-this-new-skill-pays-more-works-better-9f9ff0d2f673
- https://www.brainlabsdigital.com/blog/is-ai-prompt-engineering-already-dead/
- https://simonwillison.net/2024/Mar/20/prompt-engineering/
- https://www.philschmid.de/agentic-pattern
- https://github.com/disler/infinite-agentic-loop

## Add in Refactoring patterns

- https://refactoring.guru/design-patterns/chain-of-responsibility


## Agent Memory Structuring architecture

- https://www.philschmid.de/gemini-with-memory
- https://medium.com/%40cauri/memory-in-multi-agent-systems-technical-implementations-770494c0eca7
- https://iianalytics.com/community/blog/the-anatomy-of-agentic-ai
- https://www.jit.io/resources/devsecops/its-not-magic-its-memory-how-to-architect-short-term-memory-for-agentic-ai
- https://medium.com/%40manavg/the-definitive-guide-to-designing-effective-agentic-ai-systems-4c7c559c3ab3
- https://www.dailydoseofds.com/ai-agents-crash-course-part-8-with-implementation/
- https://bdtechtalks.substack.com/p/how-to-create-an-optimal-memory-structure
- https://www.youtube.com/watch%3Fv%3DW2HVdB4Jbjs
- https://www.philschmid.de/langgraph-gemini-2-5-react-agent
- https://agenticengineer.com/principled-ai-coding?y=7LWl3EbcFTc


## Prompt Improving

- https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/prompt-improver
- https://docs.anthropic.com/en/docs/claude-code/common-workflows
- https://www.anthropic.com/engineering/claude-code-best-practices
- https://www.anthropic.com/learn/build-with-claude

## Spec development

- Intent Conflict Finder (~= Type Checks)
- Policy Examples (~= Unit Tests)
- Ambiguity Highlighters (~= Linters)

## Capture Concepts

- Chain of Thought
- Chain of Command
