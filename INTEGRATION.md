# INTEGRATION.md — Cómo Todo se Conecta

## El Sistema en Una Línea

```
AGENTS.md (reglas) + CLAUDE.md (protocolo) + learning/ (memoria) = agente que mejora con el tiempo
```

## Jerarquía de Autoridad

```
[PROJECT_OWNER] (override absoluto)
    │
    ▼
AGENTS.md (constitución — aplica a todos)
    │
    ├── CLAUDE.md (protocolo Claude-específico)
    │
    └── learning/ (memoria colectiva — editable por agentes)
```

## Flujo de Información

```
Nueva sesión
    │
    ▼
Claude lee AGENTS.md + CLAUDE.md    ← reglas y protocolo
    │
    ▼
MEMORY.md se carga automáticamente  ← estado y contexto reciente
    │
    ▼
Claude revisa learning/ relevante   ← conocimiento profundo
    │
    ▼
Claude genera PLAN.md               ← plan antes de actuar
    │
    ▼
Ejecución con workers               ← trabajo real
    │
    ▼
Claude documenta en learning/       ← captura del conocimiento
    │
    ▼
Claude actualiza MEMORY.md          ← actualiza caché caliente
    │
    ▼
Commit + push                       ← persiste todo
```

## Qué Modifica Quién

| Archivo | Quién puede modificar |
|---------|----------------------|
| `AGENTS.md` | Solo [PROJECT_OWNER] |
| `CLAUDE.md` | Solo [PROJECT_OWNER] |
| `INTEGRATION.md` | Solo [PROJECT_OWNER] |
| `MEMORY.md` | Claude (auto-memory system) |
| `learning/*` | Claude (documentando learnings) |
| `PLAN.md` | Claude (actualizando durante sesión) |
| `CHANGELOG.md` | Claude (al finalizar fases) |

## El Loop de Mejora Continua

```
SESIÓN 1: Claude comete un error
    → Documenta en learning/mistakes/
    → Agrega a MEMORY.md (errores conocidos)

SESIÓN 2: Claude lee MEMORY.md al inicio
    → Ve el error documentado
    → Evita repetirlo

SESIÓN 3: Claude ve el patrón de evitar ese error
    → Ya es automático
    → El sistema mejoró sin intervención humana
```

Este loop es la razón por la que el sistema se vuelve más eficiente con el tiempo.
