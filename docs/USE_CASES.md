# Agent Workspace Template — Real Use Cases

**Version:** 1.0.0
**System:** agent-workspace-template
**Battle-tested on:** ZeroClaw (Rust runtime, 33 modules)
**Date:** 2026-02-28

---

## Overview

10 concrete, real-world use cases for the `agent-workspace-template` system.

**Core Workers:**
- **Claude** — Lead Orchestrator: planning, reasoning, final synthesis
- **Gemini CLI** — Heavy Worker: large-scale code analysis, bulk processing
- **gh CLI** — GitHub Operator: PR management, issue tracking, repository actions

---

## Use Case 1: Onboarding to a New Codebase (100k+ Lines of Legacy Code)

### User Profile
Senior engineer joining a new company. Codebase is 3-7 years old, partially documented, written by developers who have since left.

### Problem Before
Reading code file by file is exhausting. After a week you still have a fragmented mental model and constant fear of breaking things you don't understand.

### How the System Solves It

**Step 1 — Generate the plan**
```
Claude: "I need to onboard to this codebase. Generate an analysis plan before touching anything."
```

**Step 2 — Gemini CLI bulk structural analysis**
```bash
gemini -p "Analyze the entire repository structure. Identify:
1. Entry points (main files, CLI entrypoints, server bootstraps)
2. Core domain modules vs infrastructure modules
3. High-coupling zones (files imported by 10+ other files)
4. Dead code candidates
5. Architectural patterns used
Output structured report with file paths and confidence levels." \
--all_files > memory/gemini/codebase-structure.md
```

**Step 3 — Claude synthesizes the mental model**
```
Claude: "Based on Gemini's report, create:
- System map (ASCII diagram of main components)
- Domain glossary from code
- Danger zones: high complexity + low test coverage
- Recommended reading order for onboarding"
```

**Step 4 — gh CLI pulls recent activity**
```bash
gh pr list --state merged --limit 50 --json title,body,files | \
  claude "Summarize the last 50 PRs. What areas are actively changing?"
```

### Workers Involved
- **Gemini CLI**: Full codebase scan, coupling detection
- **Claude**: Synthesis, mental model, prioritization
- **gh CLI**: PR history, change frequency

### Time Estimate
| Task | Without System | With System |
|------|---------------|-------------|
| Understand architecture | 3-5 days | 2-3 hours |
| Build mental model | 1 week | 4 hours |
| Identify danger zones | Weeks | Same session |
| **Total onboarding** | **2-3 weeks** | **1-2 days** |

---

## Use Case 2: Architecture Analysis Before a Major Refactoring

### User Profile
Tech lead. Backend grew organically for 4 years and needs refactoring before scaling.

### How the System Solves It

```bash
gemini -p "Full dependency analysis:
1. Module dependency graph
2. Circular dependency detection
3. Coupling metrics (afferent/efferent)
4. Layer violations
Flag: CRITICAL / HIGH / MEDIUM / LOW" \
--all_files > memory/gemini/dependency-analysis.md
```

```
Claude: "Propose 3 refactoring strategies:
- Strategy A: Minimal risk, incremental
- Strategy B: Moderate risk, significant improvement
- Strategy C: High risk, complete restructuring
For each: approach, risks, effort, migration order."
```

### Time Estimate
| Task | Without System | With System |
|------|---------------|-------------|
| Dependency analysis | 1-2 weeks | 1-2 hours |
| Strategy definition | 1 week | 3-4 hours |
| Risk matrix | 3-5 days | 1 hour |
| **Total** | **3-4 weeks** | **1-2 days** |

---

## Use Case 3: Bulk Technical Documentation Generation

### User Profile
Indie developer with a successful open-source library. Contributors requesting docs. No time to write manually.

### How the System Solves It

```bash
gemini -p "For every public function, class, and module:
1. Extract signature and return type
2. Infer purpose from implementation
3. Identify usage patterns from callers
4. Find existing comments/docstrings
5. Detect edge cases handled
Output structured JSON per symbol." \
--all_files > memory/gemini/doc-signals.json
```

```bash
claude "Using doc-signals.json, generate complete API documentation.
Include: overview, all public functions with params/returns/examples,
common usage patterns, and gotchas. Flag gaps requiring human review."
```

### Time Estimate
| Task | Without System | With System |
|------|---------------|-------------|
| Document 100 public functions | 2-3 weeks | 3-4 hours |
| Generate examples | 1 week | 1 hour (from tests) |
| Review and edit | 3-5 days | 1 day (gaps only) |
| **Total** | **4-5 weeks** | **1-2 days** |

---

## Use Case 4: Automated Code Review of a Large PR

### User Profile
Engineering manager. A critical PR has 80 files changed, 4000 lines of diff. Available reviewers are junior.

### How the System Solves It

```bash
gh pr diff 342 > /tmp/pr-342.diff

gemini -p "$(cat /tmp/pr-342.diff)
Perform thorough code review:
1. Logic errors and off-by-one bugs
2. Security vulnerabilities
3. Performance regressions
4. Breaking API changes
5. Missing error handling
6. Race conditions
Rate: BLOCKER / MAJOR / MINOR / SUGGESTION"

claude "Format Gemini's findings as GitHub PR review comments.
For each: file, line, explanation, fix suggestion, severity." | \
gh pr review 342 --comment --body-file -
```

### Time Estimate
| Task | Without System | With System |
|------|---------------|-------------|
| Review 80-file PR | 2-3 days (senior) | 45 minutes |
| Identify blockers | ~20% miss rate | Comprehensive |
| Post comments | 1-2 hours | Automated |
| **Total** | **2-3 days** | **1-2 hours** |

---

## Use Case 5: Library Migration (REST to gRPC)

### User Profile
Staff engineer. 40 internal services, 200+ REST endpoints to migrate to gRPC.

### How the System Solves It

```bash
gemini -p "Catalog every REST endpoint:
- HTTP method, path, parameters
- Request/response schema (inferred from handlers)
- Authentication requirements
- Internal vs external classification
Output as JSON array." \
--all_files > memory/gemini/rest-surface.json
```

```
Claude: "Using rest-surface.json, generate .proto files:
- One proto file per service domain
- Map REST patterns correctly
- Preserve all field types
- Add comments mapping each RPC to original REST endpoint
- Flag breaking changes for external endpoints"
```

### Time Estimate
| Task | Without System | With System |
|------|---------------|-------------|
| Catalog 200 endpoints | 2-3 weeks | 2-3 hours |
| Generate proto files | 3-4 weeks | 4-6 hours |
| Compatibility analysis | 1-2 weeks | 2-3 hours |
| **Total planning** | **6-9 weeks** | **1-2 days** |

---

## Use Case 6: Security Audit of a Codebase

### User Profile
CTO preparing for SOC 2 certification. External pentest = $30k-$80k. Needs internal pre-audit first.

### How the System Solves It

```bash
gemini -p "Security audit. Check for:
- SQL/command/SSRF injection
- Hardcoded credentials, weak hashing
- Missing auth/authz checks
- PII in logs, unencrypted sensitive data
- Race conditions

For each finding: file, line, CWE ID, severity (Critical/High/Medium/Low)" \
--all_files > memory/gemini/security-findings.md
```

```
Claude: "Generate professional audit report:
1. Executive Summary
2. Critical Findings (fix before external audit)
3. High Findings (fix within 30 days)
4. Medium/Low + Recommendations
5. SOC 2 compliance gaps
6. Remediation roadmap with effort estimates
For each Critical/High: concrete code fix example."
```

### Time Estimate
| Task | Without System | With System |
|------|---------------|-------------|
| Manual security review | 2-4 weeks | 3-4 hours |
| Report writing | 1 week | 2 hours |
| Issue creation | 1 day | Automated |
| **Total** | **3-5 weeks** | **1 day** |

---

## Use Case 7: Unit Test Generation for Untested Code

### User Profile
Engineering team. CI requires 80% coverage. Legacy service has 12%. Launch in 3 weeks.

### How the System Solves It

```bash
gemini -p "Analyze for test generation:
1. All functions with 0 test coverage
2. For each: input/output types, side effects, error conditions, complexity
3. Rank by: complexity × business_criticality
4. Identify dependencies needing mocking
Output JSON: {function, file, complexity, dependencies_to_mock}" \
--all_files > memory/gemini/test-targets.json
```

```
Claude: "For the top 20 highest-priority functions, generate complete test files.
- Use project's existing test framework
- Follow existing naming conventions
- Generate: happy path, error cases, edge cases (null/empty/boundary)
- Mock all external dependencies identified"
```

### Time Estimate
| Task | Without System | With System |
|------|---------------|-------------|
| Identify test gaps | 2-3 days | 1-2 hours |
| Write 200 unit tests | 3-4 weeks | 6-8 hours |
| Review and fix | 1 week | 1 day |
| **Total** | **4-5 weeks** | **2 days** |

---

## Use Case 8: Technology Research and Decision Making

### User Profile
Startup CTO deciding which message queue to adopt (Kafka vs RabbitMQ vs NATS vs Pulsar).

### How the System Solves It

```bash
gemini -p "Extract actual message queue requirements from this codebase:
1. Current message patterns (pub/sub, fan-out, request-reply)
2. Volume indicators (batch sizes, event frequency)
3. Ordering requirements
4. Durability requirements
5. Consumer patterns
Provide code evidence for each finding." \
--all_files > memory/gemini/mq-requirements.md
```

```
Claude: "Based on ACTUAL requirements, compare Kafka vs RabbitMQ vs NATS vs Pulsar.
Weighted by our requirements:
1. Throughput at our scale
2. Operational complexity (3-person DevOps team)
3. Ecosystem maturity (Node.js + Rust)
4. Cost at scale
Generate: comparison matrix + ADR (Architecture Decision Record)."
```

### Time Estimate
| Task | Without System | With System |
|------|---------------|-------------|
| Requirements gathering | 1-2 weeks (meetings) | 2-3 hours |
| Research all options | 1 week | 2 hours |
| Write decision doc | 2-3 days | 1 hour |
| **Total** | **2-3 weeks** | **1 day** |

---

## Use Case 9: Complete New Project Setup from Scratch

### User Profile
Indie developer starting a new SaaS (Rust + React + PostgreSQL). Spends first week on boilerplate.

### How the System Solves It

```
Claude: "I'm starting a new SaaS project:
- Backend: Rust (Axum), Frontend: React + TypeScript (Vite)
- Database: PostgreSQL, Deployment: fly.io, Team: solo

Generate with exact file contents ready to write:
1. Complete directory structure
2. All config files (Cargo.toml, package.json, tsconfig, .env.example)
3. Docker + docker-compose for local dev
4. GitHub Actions CI/CD pipeline
5. Pre-commit hooks (formatting, linting, tests)
6. Database migration setup (sqlx)"
```

```bash
gh repo create my-saas-project --private
gh repo clone my-saas-project
# Claude generates setup.sh with all file creation
bash setup.sh && git add . && git commit -m "feat: initialize project"
```

### Time Estimate
| Task | Without System | With System |
|------|---------------|-------------|
| Project setup and config | 1-2 weeks | 3-4 hours |
| CI/CD configuration | 2-3 days | 1 hour |
| First working commit | End of week 2 | End of day 1 |
| **Total** | **2 weeks** | **4-5 hours** |

---

## Use Case 10: Post-Mortem Analysis of a Production Bug

### User Profile
Engineering team after 4 hours of downtime on a Saturday. CEO wants post-mortem by Monday.

### How the System Solves It

```bash
gh issue view 891 --comments > /tmp/incident-891.md
gh run list --workflow=deploy.yml --limit 20 --json status,createdAt,headCommit > /tmp/deploys.json
gh pr list --state merged --search "merged:>2026-02-21" --json number,title,mergedAt,files > /tmp/prs.json
```

```bash
gemini -p "Production incident: NullPointerException in PaymentProcessor.processRefund()
Bug introduced in last deploy.

Analyze:
1. PaymentProcessor class and all dependencies
2. What changed in recent commits
3. Why the null check was missed
4. Other code paths with similar assumptions
5. What tests should have caught this
Provide: root cause chain (5 Whys), contributing factors, blast radius." \
--all_files > memory/gemini/incident-analysis.md
```

```
Claude: "Write a blameless post-mortem (Google SRE format):
1. Incident Summary
2. Timeline (from issue comments + deploy logs)
3. Root Cause Analysis (5 Whys)
4. Contributing Factors
5. Impact Assessment
6. Action Items (specific, assigned, with deadlines)
7. Lessons Learned
Tone: blameless, analytical, focused on systems not people."
```

### Time Estimate
| Task | Without System | With System |
|------|---------------|-------------|
| Root cause analysis | 4-8 hours (uncertain) | 1-2 hours (thorough) |
| Post-mortem writing | 3-4 hours | 45 minutes |
| Action items + issues | 1 hour | Automated |
| **Total** | **1-2 days** | **3-4 hours** |

---

## Summary

| # | Use Case | Primary Worker | Time Saved |
|---|----------|---------------|------------|
| 1 | Legacy Codebase Onboarding | Gemini | 2-3 weeks → 1-2 days |
| 2 | Pre-Refactoring Architecture | Gemini + Claude | 3-4 weeks → 1-2 days |
| 3 | Bulk Documentation | Gemini + Claude | 4-5 weeks → 1-2 days |
| 4 | Large PR Review | Gemini + gh CLI | 2-3 days → 1-2 hours |
| 5 | Framework Migration | Gemini + Claude | 6-9 weeks → 1-2 days |
| 6 | Security Audit | Gemini + Claude | 3-5 weeks → 1 day |
| 7 | Test Generation | Gemini + Claude | 4-5 weeks → 2 days |
| 8 | Tech Decision Research | Gemini + Claude | 2-3 weeks → 1 day |
| 9 | New Project Setup | Claude + gh CLI | 2 weeks → 4-5 hours |
| 10 | Production Post-Mortem | All three | 1-2 days → 3-4 hours |

---

## The Plan-First Protocol (in Every Use Case)

```
1. UNDERSTAND  — What is the actual problem?
2. SCOPE       — What is in / out of scope?
3. PLAN        — Which workers? What order? What dependencies?
4. EXECUTE     — Run the plan, verify each step
5. SYNTHESIZE  — Claude resolves conflicts and gaps
6. DELIVER     — Output committed, issues created, humans informed
```

---

*Generated for agent-workspace-template | Battle-tested on ZeroClaw | 2026-02-28*
