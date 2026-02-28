# agent-workspace-template

**Sistema operacional multi-agente para proyectos de software**

Un framework battle-tested para trabajar con múltiples agentes AI (Claude, Gemini CLI, gh CLI) de forma coordinada, con memoria persistente, planificación estructurada y aprendizaje continuo.

---

## ¿Qué es esto?

Este template implementa un sistema donde:

- **Claude** actúa como **Lead Orchestrator** — análisis, síntesis, decisiones, coordinación
- **Gemini CLI** actúa como **Heavy Worker** — análisis masivo de código, generación de contenido, tareas token-intensivas
- **gh CLI** actúa como **GitHub Operator** — repos, PRs, issues, releases

Todo gobernado por una constitución operacional (`AGENTS.md`) y un sistema de memoria de dos capas que persiste el conocimiento entre sesiones.

```
                    ┌─────────────┐
                    │    YASKU    │  ← Autoridad máxima
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐
                    │   AGENTS.md │  ← Constitución (todos los agentes)
                    └──────┬──────┘
                           │
           ┌───────────────┼───────────────┐
           │               │               │
    ┌──────▼──────┐ ┌──────▼──────┐ ┌──────▼──────┐
    │   Claude    │ │ Gemini CLI  │ │   gh CLI    │
    │ Orchestrator│ │   Worker    │ │  Operator   │
    └─────────────┘ └─────────────┘ └─────────────┘
           │
    ┌──────▼──────────────────────────────┐
    │           MEMORIA (2 capas)         │
    │  Capa 1: MEMORY.md (auto-load)      │
    │  Capa 2: learning/ (estructurado)   │
    └─────────────────────────────────────┘
```

---

## Inicio Rápido

### 1. Clonar el template

```bash
git clone https://github.com/yasku/agent-workspace-template.git mi-proyecto
cd mi-proyecto
rm -rf .git
git init
```

### 2. Ejecutar el script de inicialización

```bash
chmod +x scripts/init-project.sh
./scripts/init-project.sh "nombre-de-tu-proyecto"
```

### 3. Configurar tu agente AI

Abrir `CLAUDE.md` y `AGENTS.md` — ajustar las referencias al nombre de tu proyecto.

### 4. Crear el MEMORY.md para Claude

```bash
mkdir -p ~/.claude/projects/$(pwd | tr '/' '-')/memory/
cp docs/MEMORY_TEMPLATE.md ~/.claude/projects/$(pwd | tr '/' '-')/memory/MEMORY.md
```

### 5. Verificar workers

```bash
which gemini && echo "Gemini CLI: OK" || echo "Gemini CLI: MISSING — instalar con: pip install gemini-cli"
which gh && echo "gh CLI: OK" || echo "gh CLI: MISSING — instalar con: brew install gh"
gh auth status
```

---

## Estructura del Workspace

```
mi-proyecto/
├── AGENTS.md              # Constitución operacional — aplica a TODOS los agentes
├── CLAUDE.md              # Protocolo específico para Claude
├── INTEGRATION.md         # Cómo AGENTS.md, CLAUDE.md y learning/ se integran
├── PLAN_TEMPLATE.md       # Template para planes de sesión
├── CHANGELOG.md           # Registro de cambios operacionales
├── README.md              # Este archivo
│
├── learning/              # Sistema de memoria colectiva
│   ├── README.md          # Guía del sistema
│   ├── TEMPLATE.md        # Template para nuevas entradas
│   ├── patterns/          # Patrones reutilizables
│   ├── mistakes/          # Errores documentados
│   ├── decisions/         # Decisiones arquitectónicas
│   ├── optimizations/     # Optimizaciones de proceso
│   └── claude/
│       ├── session-reviews/
│       ├── errors/
│       └── feedback/
│
├── scripts/
│   └── init-project.sh    # Setup inicial del proyecto
│
└── docs/
    ├── SYSTEM_OVERVIEW.md     # Cómo funciona el sistema
    ├── WORKERS_GUIDE.md       # Guía de workers con gotchas
    ├── MEMORY_SYSTEM.md       # Arquitectura de memoria
    ├── MEMORY_TEMPLATE.md     # Template para MEMORY.md de Claude
    └── CONVERSATION_LOG.md    # Los agentes explican el sistema
```

---

## Protocolo de Sesión

### Al inicio de cada sesión:
1. Leer `AGENTS.md` — refresh de reglas core
2. Leer `CLAUDE.md` — refresh de protocolo Claude
3. Revisar `learning/` relevante — recuperar lecciones
4. Entender la tarea — clarificar con el usuario si hay dudas
5. **Generar PLAN.md** antes de cualquier tarea no trivial

### Durante la sesión:
- Seguir la regla de las tres preguntas (`AGENTS.md §2.2`)
- Actualizar PLAN.md + CHANGELOG después de cada fase
- Delegar a workers cuando sea eficiente
- Documentar learnings en tiempo real

### Al final de la sesión:
- Verificar completitud
- Documentar en `learning/claude/session-reviews/`
- Commit y push

---

## Documentación

| Doc | Propósito |
|-----|-----------|
| `docs/SYSTEM_OVERVIEW.md` | Visión completa del sistema |
| `docs/WORKERS_GUIDE.md` | Cómo usar Gemini CLI y gh CLI |
| `docs/MEMORY_SYSTEM.md` | Arquitectura de memoria de dos capas |
| `docs/CONVERSATION_LOG.md` | Los agentes explican el sistema en su propio lenguaje |

---

## Créditos

Sistema diseñado y battle-tested en el proyecto ZeroClaw (Rust AI agent runtime).
Desarrollado por YASKU con Claude como Lead Orchestrator.
