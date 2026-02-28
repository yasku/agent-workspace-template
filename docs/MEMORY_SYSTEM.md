# MEMORY_SYSTEM — Arquitectura de Memoria de Dos Capas

El problema central de trabajar con agentes AI: **cada sesión arranca desde cero**.

Este sistema resuelve eso con dos capas de memoria complementarias.

---

## Arquitectura

```
┌─────────────────────────────────────────────────────────┐
│                   SESIÓN DE CLAUDE                      │
│                                                         │
│  ┌─────────────────────────────────────────────────┐    │
│  │  CAPA 1 — MEMORY.md (Auto-cargado)              │    │
│  │  ~/.claude/projects/.../memory/MEMORY.md        │    │
│  │                                                 │    │
│  │  → Cargado automáticamente al inicio            │    │
│  │  → Max ~200 líneas activas                      │    │
│  │  → Reglas permanentes, errores conocidos,       │    │
│  │    patrones críticos, quick reference           │    │
│  └─────────────────────────────────────────────────┘    │
│                          +                              │
│  ┌─────────────────────────────────────────────────┐    │
│  │  CAPA 2 — learning/ (Archivo profundo)          │    │
│  │  ./learning/                                    │    │
│  │                                                 │    │
│  │  → Leído bajo demanda (cuando es relevante)     │    │
│  │  → Sin límite de tamaño                         │    │
│  │  → Entradas atómicas por topic                  │    │
│  │  → patterns/, mistakes/, decisions/,            │    │
│  │    optimizations/, claude/                      │    │
│  └─────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
```

---

## Capa 1: MEMORY.md

### Ubicación

```
~/.claude/projects/[hash-del-proyecto]/memory/MEMORY.md
```

Claude Code carga este archivo automáticamente al inicio de cada sesión. No requiere acción del agente.

### Qué guardar en MEMORY.md

**SÍ guardar:**
- Reglas permanentes establecidas por el usuario ("siempre usar X", "nunca hacer Y")
- Errores conocidos de workers y sus fixes
- Patrones de arquitectura del proyecto
- Quick reference de comandos frecuentes
- Estado del proyecto (versión, proyectos activos)
- Preferencias del usuario

**NO guardar:**
- Detalles de implementación (van en learning/)
- Contexto de la sesión actual (es temporal)
- Información que puede cambiar frecuentemente (puede quedar desactualizada)
- Todo lo que ya está en AGENTS.md o CLAUDE.md (duplicación)

### Regla de concisión

MEMORY.md debe mantenerse bajo ~200 líneas activas. Líneas después de 200 pueden ser truncadas.

Si crece mucho:
1. Mover entradas detalladas a `learning/`
2. Conservar solo el resumen en MEMORY.md
3. Agregar referencia: "Ver learning/patterns/nombre.md para detalle"

### Template de MEMORY.md

Ver `docs/MEMORY_TEMPLATE.md`

---

## Capa 2: learning/

### Estructura

```
learning/
├── README.md          # Guía del sistema
├── TEMPLATE.md        # Template para nuevas entradas
│
├── patterns/          # Patrones reutilizables descubiertos
├── mistakes/          # Errores documentados y lecciones
├── decisions/         # Decisiones arquitectónicas importantes
├── optimizations/     # Optimizaciones de proceso y performance
│
└── claude/            # Learnings específicos de Claude
    ├── session-reviews/   # Reviews post-sesión
    ├── errors/            # Análisis de errores
    └── feedback/          # Feedback del usuario
```

### Cuándo crear una entrada

| Categoría | Crear cuando... |
|-----------|----------------|
| `patterns/` | Encontrás un patrón que funciona y es reutilizable |
| `mistakes/` | Cometés un error que no querés repetir |
| `decisions/` | El usuario establece una regla o toma una decisión importante |
| `optimizations/` | Encontrás una forma más eficiente de hacer algo |
| `claude/session-reviews/` | Al final de cada sesión significativa |
| `claude/errors/` | Cuando un error requiere análisis profundo |
| `claude/feedback/` | Cuando el usuario da feedback sobre tu trabajo |

### Formato de entrada

```markdown
---
date: YYYY-MM-DD
context: [descripción de la tarea donde ocurrió]
category: [pattern|mistake|decision|optimization]
tags: [tag1, tag2, tag3]
confidence: [Certain|Likely|Uncertain|Speculative]
---

## Observation
Qué pasó / qué se descubrió

## Analysis
Por qué ocurrió / por qué funciona

## Lesson
La regla o patrón a recordar

## Application
Cuándo aplicar esto en el futuro
```

### Nomenclatura de archivos

```
YYYY-MM-DD_descripcion-corta-en-kebab-case.md

Ejemplos:
2026-02-28_gemini-no-escribe-archivos.md
2026-02-28_plan-first-protocol.md
2026-02-28_bash-working-directory.md
```

---

## Ciclo de Actualización

### Durante la sesión

```
EVENTO                          → ACCIÓN DE MEMORIA
──────────────────────────────────────────────────────
Usuario establece nueva regla   → Agregar a MEMORY.md + learning/decisions/
Se descubre error de worker     → Agregar a MEMORY.md (conocidos) + learning/mistakes/
Se descubre patrón útil         → Agregar a learning/patterns/
Se optimiza un proceso          → Agregar a learning/optimizations/
```

### Al final de la sesión

```bash
# 1. Crear session review
cat > learning/claude/session-reviews/$(date +%Y-%m-%d)_nombre-sesion.md << 'EOF'
---
date: YYYY-MM-DD
context: [descripción de la sesión]
category: session-review
---

## Lo que se hizo
[Lista de tareas completadas]

## Lo que funcionó bien
[Patrones y decisiones exitosas]

## Lo que se puede mejorar
[Errores o ineficiencias]

## Nuevos learnings
[Lista de nuevas entradas en learning/]
EOF

# 2. Actualizar MEMORY.md si hay nueva info crítica
# 3. Commit de learning/ junto con el trabajo
```

---

## Pre-Task Review Protocol

Antes de empezar cualquier tarea, Claude debe revisar:

```
1. ¿Hay reglas en MEMORY.md que apliquen a esta tarea?
2. ¿Hay errores en learning/mistakes/ que debo evitar?
3. ¿Hay patrones en learning/patterns/ que pueda aplicar?
4. ¿Hay decisiones previas en learning/decisions/ relevantes?
```

Este proceso toma 2-3 minutos y previene errores repetidos.

---

## Ejemplo Real

En el proyecto ZeroClaw, después de 3 sesiones, `learning/` acumuló:

```
patterns/
  2026-02-28_trait-driven-plugin-architecture.md   # Patrón Rust universal
  2026-02-28_plan-first-orchestration.md           # Workflow del sistema

mistakes/
  2026-02-28_gemini-worker-output-not-written.md   # Gemini no escribe archivos
  2026-02-28_git-working-directory-not-persistent.md # Bash no persiste cd

decisions/
  2026-02-28_plan-first-rule.md                   # Regla permanente de YASKU

optimizations/
  2026-02-28_parallel-tool-execution.md           # Paralelizar reads independientes
  2026-02-28_token-efficient-codebase-exploration.md # Estrategia telescopio
```

El resultado: la cuarta sesión arrancó con todo ese conocimiento disponible, sin necesidad de redescubrir nada.
