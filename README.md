# agent-workspace-template

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue?style=for-the-badge)
![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)
![Battle Tested](https://img.shields.io/badge/battle--tested-ZeroClaw-orange?style=for-the-badge)
![Agents](https://img.shields.io/badge/agents-3%20coordinated-purple?style=for-the-badge)
![Token Reduction](https://img.shields.io/badge/token%20reduction-80%25-red?style=for-the-badge)

**A production-grade multi-agent operating system for software projects.**

*Stop juggling AI tools. Start orchestrating them.*

[Quick Start](#quick-start) · [Architecture](#architecture) · [Memory System](#the-memory-system) · [Use Cases](#use-cases)

</div>

---

## What Is This?

Most developers use AI tools in isolation — one Claude tab, one terminal with Gemini, manually copying context between sessions. Every day you start from scratch.

**agent-workspace-template** gives your AI agents a shared brain, a constitution, and a job description. Three specialized agents — a lead orchestrator, a heavy worker, and a GitHub operator — coordinate under a single operational framework with persistent memory that survives every session restart.

> **Result:** 80% fewer tokens, 75% available context, 5x faster session start, near-zero repeated mistakes.

---

## The System at a Glance

```
┌─────────────────────────────────────────────────────────────────┐
│                     YOUR TASK / INTENT                          │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
          ┌─────────────────────────────────┐
          │         CLAUDE (Lead)           │
          │      ┌─────────────────┐        │
          │      │  AGENTS.md      │        │
          │      │  CLAUDE.md      │  ◄──── │── Constitutional Layer
          │      │  Session Memory │        │
          │      └─────────────────┘        │
          │   Analyze · Plan · Decide       │
          └────────┬──────────┬─────────────┘
                   │          │
         ┌─────────┘          └──────────┐
         ▼                               ▼
┌─────────────────┐           ┌──────────────────────┐
│  GEMINI CLI     │           │      gh CLI           │
│  (Heavy Worker) │           │  (GitHub Operator)    │
│                 │           │                       │
│ • Bulk analysis │           │ • Repo management     │
│ • 33+ modules   │           │ • PRs & reviews       │
│ • Code gen      │           │ • Issues & milestones │
│ • Token-heavy   │           │ • Releases            │
│   workloads     │           │ • Actions / CI        │
└────────┬────────┘           └──────────┬────────────┘
         │                               │
         └───────────────┬───────────────┘
                         ▼
          ┌──────────────────────────────┐
          │       MEMORY LAYER           │
          │                              │
          │  [Session]   +  [Long-Term]  │
          │  fast recall    persisted    │
          └──────────────────────────────┘
```

---

## Before vs. After

| Situation | Without This System | With This System |
|-----------|---------------------|------------------|
| Session startup | 15 min re-explaining context | 3 min — memory auto-loaded |
| Analyzing 33 Rust modules | ~200k tokens | ~40k tokens (80% less) |
| Available context window | ~30% left | ~75% available |
| Repeated mistakes | Frequent — no memory | Rare — errors documented |
| Agent coordination | Manual copy-paste | Structured delegation |
| GitHub operations | Context-switching, forgetting flags | Single operator, documented conventions |
| Task handoff | Lost in chat history | Committed to memory layer |

---

## Quick Start

> Five steps. Under two minutes.

**Step 1 — Clone the template**

```bash
gh repo clone yasku/agent-workspace-template my-project
cd my-project && rm -rf .git && git init
```

**Step 2 — Initialize**

```bash
chmod +x scripts/init-project.sh
./scripts/init-project.sh "my-project" "YOUR_NAME"
```

**Step 3 — Verify workers**

```bash
which gemini && echo "✓ Gemini CLI" || echo "✗ Missing: pip install google-generativeai"
which gh && gh auth status && echo "✓ gh CLI" || echo "✗ Missing: brew install gh && gh auth login"
```

**Step 4 — Personalize the constitution**

Open `AGENTS.md` and `CLAUDE.md` — replace `[PROJECT_OWNER]` with your name and add project-specific rules.

**Step 5 — Start your first session**

Open Claude Code and send:
```
Read AGENTS.md and CLAUDE.md. Check MEMORY.md.
Confirm you understand the system. My first task is: [your task]
```

You're running a coordinated multi-agent workspace.

---

## Architecture

### The Three Agents

**Claude — Lead Orchestrator**
Analysis, synthesis, decisions, coordination. The only agent that writes to the filesystem. Governs the session.

**Gemini CLI — Heavy Worker**
Token-intensive tasks: bulk code analysis (1M context window), large-scale content generation, code reviews across dozens of files. Called by Claude when the task would exhaust Claude's context.

**gh CLI — GitHub Operator**
All GitHub interactions. Repos, PRs, issues, releases, CI/CD. Single operator with documented conventions — no more forgotten flags.

### The Constitutional Layer

```
LAYER 1 — Anthropic Constitutional AI (Claude's training)
     ↓
LAYER 2 — AGENTS.md (universal rules for all agents)
     ↓
LAYER 3 — CLAUDE.md (Claude-specific protocol)
     ↓
LAYER 4 — User explicit instructions (highest runtime authority)
```

`AGENTS.md` is the contract. Every agent reads it. Every session starts with it.

---

## The Memory System

Two layers. Different speeds. Different lifetimes.

```
LAYER 1 — MEMORY.md (Hot cache, auto-loaded)        LAYER 2 — learning/ (Cold archive)
~/.claude/projects/[hash]/memory/MEMORY.md          ./learning/

┌─────────────────────────────────┐                 ┌────────────────────────────────┐
│ • Permanent rules               │                 │ • patterns/ — reusable patterns│
│ • Known worker errors & fixes   │                 │ • mistakes/ — errors & lessons │
│ • Architecture quick reference  │                 │ • decisions/ — ADRs            │
│ • Frequent commands             │                 │ • optimizations/ — perf wins   │
│ • Project state                 │                 │ • claude/session-reviews/      │
│                                 │                 │                                │
│ Max ~200 lines                  │                 │ Unlimited, atomic entries      │
│ Auto-loaded every session       │                 │ Read on demand                 │
└─────────────────────────────────┘                 └────────────────────────────────┘
         Fast recall                                          Deep knowledge
```

At session end, Claude promotes valuable discoveries from the session into `learning/`. Nothing important is lost.

---

## Use Cases

This system works best when:

- **Your codebase is large** — tens of files — and you need Gemini's 1M token window without burning Claude's context
- **You iterate fast** — daily sessions, frequent pivots — and cannot afford 15 min of re-orientation each time
- **You use GitHub heavily** — PRs, issues, releases — and want a single operator that knows your conventions
- **You want AI that learns** — errors documented, patterns captured — so your agent gets smarter about your project over time
- **You're building something non-trivial** — multiple modules, multiple concerns — and need continuity between sessions

---

## Repository Structure

```
agent-workspace-template/
│
├── AGENTS.md              # Universal agent constitution — READ THIS FIRST
├── CLAUDE.md              # Claude-specific operational protocol
├── INTEGRATION.md         # How everything connects
├── PLAN_TEMPLATE.md       # Session plan template (Plan-First Protocol)
├── CHANGELOG.md           # Operational changelog
│
├── learning/              # Two-layer memory system
│   ├── patterns/          # Reusable patterns discovered
│   ├── mistakes/          # Errors documented with root cause
│   ├── decisions/         # Architectural decisions with rationale
│   ├── optimizations/     # Process improvements
│   └── claude/            # Claude-specific learning
│       ├── session-reviews/
│       ├── errors/
│       └── feedback/
│
├── docs/
│   ├── SYSTEM_OVERVIEW.md     # Full system architecture
│   ├── WORKERS_GUIDE.md       # Gemini + gh CLI guide with real gotchas
│   ├── MEMORY_SYSTEM.md       # Memory architecture deep-dive
│   ├── MEMORY_TEMPLATE.md     # Starter for your MEMORY.md
│   └── CONVERSATION_LOG.md    # The agents explain the system themselves
│
└── scripts/
    └── init-project.sh        # Automated project initialization
```

---

## Real-World Numbers

Measured in production on ZeroClaw — a complex multi-module Rust AI runtime.

| Metric | Before | After | Delta |
|--------|--------|-------|-------|
| Tokens to analyze 33 Rust modules | ~200,000 | ~40,000 | **-80%** |
| Session startup time | 15 min | 3 min | **-80%** |
| Available context at mid-session | ~30% | ~75% | **+150%** |
| Repeated errors across sessions | Frequent | Rare | **≈ zero** |

---

## Contributing

**Good contributions:**
- Better delegation patterns between Claude and Gemini
- New memory schemas that capture more useful signal
- Scripts that automate session lifecycle
- New agent integrations (Codex CLI, Aider, etc.)
- Real metrics from your production usage

**Not a good fit:**
- Project-specific content
- Changes that break the constitutional layer model

---

## Credits

Built and battle-tested in **ZeroClaw** — a Rust AI agent runtime.
Developed with **Claude (Anthropic)** as Lead Orchestrator.

The system is opinionated by design. It reflects real lessons from real sessions: what breaks when agents have no memory, what happens when there's no constitution, what it costs to re-orient an AI every single day.

---

<div align="center">

**If this saved you time or tokens, give it a star.**

*Then go build something with it.*

</div>
