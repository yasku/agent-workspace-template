# ROADMAP — agent-workspace-template

**Version:** 1.0.0
**Last Updated:** 2026-02-28
**Horizon:** 12 months
**Status:** Public, Active Development

---

## I. VISION

**In 12 months, agent-workspace-template is the standard starting point for any developer who wants to orchestrate multiple AI agents in a real software project — without frameworks, without vendor lock-in, without complexity overhead.**

The goal is not to become LangChain. The goal is to be the thing you reach for *before* you need LangChain.

### Strategic Positioning

| Competitor | Their Strength | Our Differentiation |
|---|---|---|
| LangChain / LangGraph | Rich ecosystem, Python-native | Zero code required, works with any stack |
| CrewAI | High automation, agent roles | More control, transparent, debuggable |
| AutoGen | Conversational multi-agent | File-based state, no runtime dependency |
| Cursor / Aider | Great UX, deep IDE integration | Orchestration layer, not an editor |
| Claude Code + CLAUDE.md | Native, fast | This IS the framework for that pattern |

**Our moat:** Simplicity is a feature. Markdown is infrastructure. No Python environment required.

---

## II. DESIGN PRINCIPLES (NON-NEGOTIABLE)

1. **Markdown-First** — State, memory, plans, and agent instructions live in `.md` files. Always.
2. **Zero Runtime Dependencies** — No Python packages, no npm installs, no Docker required for orchestration itself.
3. **Agent-Agnostic Core** — Swapping Claude for GPT-4 requires editing one file, not rewriting the system.
4. **Transparent State** — Full system state is inspectable by reading files. No hidden state.
5. **Convention Over Configuration** — Strong defaults. Users adapt by editing, not configuring.
6. **Composable, Not Monolithic** — Each component can be adopted independently.
7. **Human Always In Control** — No autonomous execution of destructive/irreversible actions.

---

## III. v1.1.0 — IMMEDIATE IMPROVEMENTS
**Timeline:** Weeks 1-4 | **Theme:** Polish, Friction Reduction, First Impressions

| Item | Effort | Priority | Impact |
|---|---|---|---|
| Init preflight checks with actionable errors | S | P0 | High |
| MEMORY.md auto-seeding with project info | S | P0 | High |
| Architecture diagram (Mermaid) | S | P0 | High |
| Worker setup guides (docs/workers/) | M | P1 | High |
| CONTRIBUTING.md | S | P1 | Medium |
| One-liner bootstrap (`curl \| bash`) | M | P1 | Medium |
| Interactive init mode (`--interactive`) | M | P2 | Medium |
| .gitignore hardening for API keys | XS | P2 | Medium |

---

## IV. v1.2.0 — NEW WORKERS
**Timeline:** Weeks 5-8 | **Theme:** Expand the Worker Ecosystem

### Custom Worker Template (highest leverage)

`workers/CUSTOM_WORKER_TEMPLATE.md` — copy and fill in the blanks. Defines:
- Worker identity and role
- Capability boundaries
- Invocation protocol
- Authorization levels
- Error reporting format

### New Workers

| Worker | Role | Key Use Cases |
|---|---|---|
| Docker (`workers/DOCKER.md`) | Container lifecycle | Build images, run test envs, inspect logs |
| Research (`workers/RESEARCH.md`) | External knowledge | Library changelogs, competitor research |
| Aider (`workers/AIDER.md`) | Autonomous code editing | Refactoring, implementing functions |
| Database (`workers/DATABASE.md`) | Schema and queries | Migrations, query explanation |

| Item | Effort | Priority | Impact |
|---|---|---|---|
| Custom Worker Template | M | P0 | Very High |
| Docker worker | M | P1 | High |
| Research worker | S | P1 | High |
| Aider worker | S | P2 | Medium |
| Database worker | M | P2 | Medium |

---

## V. v1.3.0 — MEMORY SYSTEM ENHANCEMENT
**Timeline:** Weeks 9-12 | **Theme:** Make Memory Useful, Not Just Present

### New structured schemas

- **Decision Log** — Context, options, decision, rationale, consequences, review date
- **Lesson Learned** — Source, discovery, application guidance, confidence level
- **Context Snapshot** — Point-in-time auto-generated project state

### New scripts

**`scripts/memory-sync.sh`** — Scans learning/, extracts key facts, proposes additions to MEMORY.md in a `.proposed` file. Human reviews and approves. Never auto-writes.

**`scripts/memory-health.sh`** — Diagnostic: last update, orphaned entries, duplicates, broken references, coverage score.

| Item | Effort | Priority | Impact |
|---|---|---|---|
| Memory schemas | M | P0 | Very High |
| MEMORY.md template upgrade | S | P0 | High |
| memory-sync.sh | L | P1 | High |
| memory-health.sh | M | P1 | High |

---

## VI. v2.0.0 — MULTI-PROJECT SUPPORT
**Timeline:** 6 months | **Theme:** One Workspace, Many Projects

### Workspace Architecture

```
workspace-root/
  WORKSPACE.md              ← Cross-project state
  agents/                   ← Shared agent configs
  learning/
    shared/                 ← Cross-project lessons
    project-a/
    project-b/
  projects/
    project-a/
      MEMORY.md
      .project.md           ← Stack, status, priority
    project-b/
```

### Key features
- **Shared Learning System** — Lessons tagged `applies-to: general` promoted to `learning/shared/`
- **Project Switching** — `scripts/project-switch.sh project-a` saves state, injects project memory
- **Cross-project context** — Agents can reference shared lessons from any project

| Item | Effort | Priority | Impact |
|---|---|---|---|
| Workspace directory structure | L | P0 | Very High |
| Shared learning system | L | P0 | Very High |
| WORKSPACE.md template | M | P1 | High |
| project-switch.sh | M | P1 | High |
| Migration guide v1.x → v2.0 | M | P1 | High |

---

## VII. EXPLICITLY DISCARDED

| Initiative | Why Not |
|---|---|
| Python/Node SDK or CLI | Violates zero-dependency principle. Creates versioning hell. |
| GUI / Web Dashboard | Massive cost for a terminal-native audience. |
| Cloud memory storage | Breaks local trust model. Introduces auth, privacy concerns, uptime. |
| Agent-to-agent direct comms | Requires a runtime coordinator — that's LangGraph. |
| Automatic plan execution | One bad autonomous action destroys trust. The checkpoint IS the product. |

---

## VIII. SUCCESS METRICS

| Metric | v1.1.0 | v1.3.0 | v2.0.0 |
|---|---|---|---|
| GitHub Stars | 500 | 1,500 | 5,000 |
| Forks | 100 | 400 | 1,500 |
| Contributors | 10 | 30 | 75 |
| Init success rate | >90% | >95% | >95% |
| Forks with >5 learning/ entries | >40% | >50% | >60% |

---

## IX. RELEASE TIMELINE

```
2026-02  v1.0.0  Initial release (current)
2026-03  v1.1.0  Polish & Friction Reduction
2026-04  v1.2.0  New Workers & Custom Worker Template
2026-05  v1.3.0  Memory System Enhancement
2026-08  v2.0.0  Multi-Project Workspace Support
2026-12  v2.x    Based on community feedback
```

---

## X. OPEN QUESTIONS FOR YASKU

1. Community platform: GitHub Discussions vs Discord?
2. Worker contributions: community-contributed or maintainer-gated?
3. Naming: should "workers" become "agents" or "tools"?
4. License: MIT still correct for v2.0.0 workspace features?

---

*Next review: v1.1.0 release | Authority: YASKU*
