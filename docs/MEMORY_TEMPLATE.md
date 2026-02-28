# MEMORY.md — [Nombre del Proyecto]
*Auto-cargado por Claude Code al inicio de cada sesión*
*Mantener < 200 líneas activas*

---

## Workspace Overview

**Proyecto:** [nombre]
**Repo:** [url]
**Stack:** [tecnologías principales]
**Versión actual:** [version]

---

## Reglas Permanentes

- [Regla 1 establecida por el usuario]
- [Regla 2]
- Plan-First Protocol: SIEMPRE generar PLAN.md antes de tareas no triviales
- Commit format: incluir `Co-Authored-By: Claude <noreply@anthropic.com>`

---

## Workers Disponibles

| Worker | Comando | Estado |
|--------|---------|--------|
| Gemini CLI | `gemini "..."` | [verificar con `which gemini`] |
| gh CLI | `gh ...` | [verificar con `gh auth status`] |

**Gotchas conocidos:**
- Gemini CLI NO escribe archivos → capturar stdout, Write tool guarda
- Bash NO persiste working directory → usar `git -C /ruta/absoluta`
- gh CLI configura SSH por defecto → `git remote set-url origin https://...`

---

## Arquitectura del Proyecto

*[Llenar con arquitectura específica del proyecto]*

```
[diagrama ASCII o descripción]
```

**Patrones clave:**
- [Patrón 1]
- [Patrón 2]

---

## Errores Conocidos

| Error | Contexto | Fix |
|-------|---------|-----|
| [descripción] | [cuándo ocurre] | [cómo resolverlo] |

---

## Quick Reference

```bash
# Comandos frecuentes del proyecto
[comando 1]
[comando 2]
```

---

## Estado del Proyecto

**Sesiones completadas:** [N]
**Última sesión:** [fecha] — [qué se hizo]
**Próximo paso:** [qué sigue]

---

## Learning References

Ver `learning/` para detalles:
- `learning/patterns/` — [N] entradas
- `learning/mistakes/` — [N] entradas
- `learning/decisions/` — [N] entradas
