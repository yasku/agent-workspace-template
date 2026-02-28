# SYSTEM_OVERVIEW — Multi-Agent Workspace

## ¿Por qué un sistema multi-agente?

Trabajar con un solo agente AI tiene límites claros:
- **Contexto finito** — leer 50 archivos consume tokens rápidamente
- **Un solo punto de falla** — si el agente se pierde, pierde todo
- **Sin memoria** — cada sesión arranca desde cero
- **Sin especialización** — un agente hace todo, ninguno hace nada bien

Este sistema resuelve los cuatro problemas con tres componentes:

```
PROBLEMA              → SOLUCIÓN
─────────────────────────────────────────────────
Contexto finito       → Workers aislados (Gemini absorbe lo pesado)
Un solo punto de falla → Orquestador (Claude) mantiene el estado
Sin memoria           → Sistema de dos capas (MEMORY.md + learning/)
Sin especialización   → Workers especializados por dominio
```

---

## Los Tres Roles

### Claude — Lead Orchestrator

**Responsabilidades:**
- Entender el intent del usuario
- Generar el PLAN.md antes de actuar
- Decidir qué delegar y a quién
- Validar outputs de workers
- Mantener el contexto global de la sesión
- Escribir al filesystem (los workers no escriben)
- Documentar learnings
- Hacer commits

**Cuándo Claude hace el trabajo él mismo:**
- Análisis que requiere síntesis y razonamiento
- Decisiones arquitectónicas
- Código crítico que requiere contexto completo
- Comunicación con el usuario

**Cuándo Claude delega:**
- Análisis de código masivo (> 10 archivos) → Gemini
- Operaciones de texto/generación de contenido repetitivo → Gemini
- Cualquier operación de GitHub → gh CLI

---

### Gemini CLI — Heavy Worker

**Responsabilidades:**
- Analizar grandes volúmenes de código
- Generar documentación técnica extensa
- Code reviews automatizados
- Análisis comparativos entre múltiples archivos

**Cómo invocarlo:**
```bash
# Análisis de código
OUTPUT=$(gemini "TASK: Analiza la arquitectura de src/.
CONTEXT: [pegar contexto relevante]
OUTPUT FORMAT: Markdown estructurado
---
$(cat src/lib.rs)")
echo "$OUTPUT"

# Con archivos grandes
OUTPUT=$(gemini --file src/main.rs "¿Cuáles son los entry points principales?")

# Redirigir output
gemini "TASK: Genera documentación para este módulo" > /tmp/output.md
```

**Gotcha crítico:** Gemini NO escribe archivos automáticamente.
→ Siempre capturar con `$()` o `>`, y usar Write tool de Claude para guardar.

**Cuándo NO usar Gemini:**
- Decisiones que requieren contexto de la sesión
- Código que modifica el proyecto
- Cuando el análisis es < 3 archivos (Claude lo maneja solo)

---

### gh CLI — GitHub Operator

**Responsabilidades:**
- Crear y gestionar repositorios
- PRs, issues, releases
- Ver estado de CI/CD
- Gestionar branches remotos

**Comandos frecuentes:**
```bash
# Repos
gh repo create usuario/nombre --private
gh repo view usuario/nombre

# PRs
gh pr list
gh pr create --title "título" --body "descripción"
gh pr merge 123

# Issues
gh issue list
gh issue create --title "título" --body "descripción"

# Auth
gh auth status
gh auth login
```

**Gotcha crítico:** gh CLI configura SSH por defecto al crear repos.
→ Si no hay SSH key configurada: `git remote set-url origin https://github.com/usuario/repo.git`

---

## El Flujo Típico de una Sesión

```
1. YASKU da una tarea
        ↓
2. Claude lee AGENTS.md + CLAUDE.md + learning/ relevante
        ↓
3. Claude genera PLAN.md (OBLIGATORIO para tareas no triviales)
        ↓
4. Claude ejecuta Fase 1
   ├── Si requiere análisis masivo → delega a Gemini CLI
   ├── Si requiere GitHub → usa gh CLI
   └── Si es análisis/síntesis/código → Claude lo hace
        ↓
5. Claude valida outputs de workers
        ↓
6. Claude escribe resultados al filesystem
        ↓
7. Claude actualiza PLAN.md + CHANGELOG
        ↓
8. Claude documenta learnings en learning/
        ↓
9. Claude hace commit + push
        ↓
10. Repetir desde paso 4 para siguiente fase
```

---

## El Plan-First Protocol

**Regla permanente: Antes de cualquier tarea no trivial → generar PLAN.md**

¿Por qué es crítico?

1. **Fuerza claridad** — el agente debe entender el objetivo antes de actuar
2. **Previene scope creep** — los límites están definidos antes de empezar
3. **Permite coordinación** — YASKU puede aprobar/modificar el plan antes de la ejecución
4. **Facilita recovery** — si la sesión se interrumpe, el plan documenta dónde se estaba

**Template:** Ver `PLAN_TEMPLATE.md`

---

## El Sistema de Memoria

El conocimiento generado en cada sesión NO debe perderse. El sistema usa dos capas:

**Capa 1 — MEMORY.md (auto-cargado):**
- Cargado automáticamente al inicio de cada sesión de Claude
- Máximo ~200 líneas — solo lo más crítico y frecuente
- Reglas permanentes, errores conocidos, patrones clave

**Capa 2 — learning/ (archivo profundo):**
- Entradas atómicas por topic
- Categorizadas: patterns, mistakes, decisions, optimizations
- Sin límite de tamaño — detalle completo

**Ver:** `docs/MEMORY_SYSTEM.md` para la arquitectura completa.

---

## Métricas del Sistema (observadas en producción)

| Métrica | Sin sistema | Con sistema |
|---------|-------------|-------------|
| Tokens para analizar 33 módulos Rust | ~200k | ~40k |
| Tiempo de setup de sesión | 15 min | 3 min |
| Errores repetidos entre sesiones | Frecuentes | Raros |
| Contexto disponible para trabajo real | ~30% | ~75% |

Fuente: proyecto ZeroClaw, sesiones 2026-02-28.
