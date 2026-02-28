#!/usr/bin/env bash
# init-project.sh — Inicializa un nuevo proyecto con el agent-workspace-template
# Usage: ./scripts/init-project.sh "nombre-del-proyecto" "OWNER_NAME"

set -euo pipefail

PROJECT_NAME="${1:-my-project}"
OWNER_NAME="${2:-OWNER}"
DATE=$(date +%Y-%m-%d)

echo "=== Agent Workspace Init ==="
echo "Project: $PROJECT_NAME"
echo "Owner:   $OWNER_NAME"
echo ""

# 1. Reemplazar placeholders en los archivos de configuración
echo "→ Configurando AGENTS.md..."
sed -i.bak "s/\[PROJECT_OWNER\]/$OWNER_NAME/g" AGENTS.md && rm AGENTS.md.bak

echo "→ Configurando CLAUDE.md..."
sed -i.bak "s/\[PROJECT_OWNER\]/$OWNER_NAME/g" CLAUDE.md && rm CLAUDE.md.bak
sed -i.bak "s/YYYY-MM-DD/$DATE/g" CLAUDE.md && rm CLAUDE.md.bak

echo "→ Configurando INTEGRATION.md..."
sed -i.bak "s/\[PROJECT_OWNER\]/$OWNER_NAME/g" INTEGRATION.md && rm INTEGRATION.md.bak

echo "→ Configurando CHANGELOG.md..."
sed -i.bak "s/\[Project Name\]/$PROJECT_NAME/g" CHANGELOG.md && rm CHANGELOG.md.bak
sed -i.bak "s/\[PROJECT_OWNER\]/$OWNER_NAME/g" CHANGELOG.md && rm CHANGELOG.md.bak
sed -i.bak "s/YYYY-MM-DD/$DATE/g" CHANGELOG.md && rm CHANGELOG.md.bak

echo "→ Configurando README.md..."
sed -i.bak "s/mi-proyecto/$PROJECT_NAME/g" README.md && rm README.md.bak

# 2. Crear MEMORY.md en el sistema de auto-memory de Claude
PROJECT_PATH=$(pwd)
MEMORY_DIR="$HOME/.claude/projects/$(echo "$PROJECT_PATH" | tr '/' '-')/memory"

echo "→ Creando MEMORY.md en $MEMORY_DIR..."
mkdir -p "$MEMORY_DIR"

cat > "$MEMORY_DIR/MEMORY.md" << MEMORY_EOF
# MEMORY.md — $PROJECT_NAME
*Auto-cargado por Claude Code al inicio de cada sesión*
*Mantener < 200 líneas activas*

---

## Workspace Overview

**Proyecto:** $PROJECT_NAME
**Owner:** $OWNER_NAME
**Fecha de inicio:** $DATE
**Repo:** [agregar URL cuando esté creado]

---

## Reglas Permanentes

- Plan-First Protocol: SIEMPRE generar PLAN.md antes de tareas no triviales
- Commit format: incluir Co-Authored-By: Claude <noreply@anthropic.com>
- [Agregar reglas específicas del proyecto]

---

## Workers Disponibles

| Worker | Comando | Estado |
|--------|---------|--------|
| Gemini CLI | \`gemini "..."\` | verificar con \`which gemini\` |
| gh CLI | \`gh ...\` | verificar con \`gh auth status\` |

**Gotchas conocidos:**
- Gemini CLI NO escribe archivos → capturar stdout, Write tool guarda
- Bash NO persiste working directory → usar \`git -C /ruta/absoluta\`
- gh CLI configura SSH por defecto → \`git remote set-url origin https://...\`

---

## Estado del Proyecto

**Sesiones completadas:** 0
**Última sesión:** $DATE — Inicialización del workspace
**Próximo paso:** [definir con $OWNER_NAME]

---

## Learning References

Ver \`learning/\` para detalles acumulados.
MEMORY_EOF

echo "   ✓ MEMORY.md creado en $MEMORY_DIR"

# 3. Verificar workers
echo ""
echo "=== Verificando Workers ==="

if which gemini &>/dev/null; then
    echo "✓ Gemini CLI: disponible"
else
    echo "✗ Gemini CLI: NO encontrado"
    echo "  Instalar: pip install google-generativeai"
fi

if which gh &>/dev/null; then
    echo "✓ gh CLI: disponible"
    if gh auth status &>/dev/null; then
        echo "✓ gh CLI: autenticado"
    else
        echo "✗ gh CLI: NO autenticado — ejecutar: gh auth login"
    fi
else
    echo "✗ gh CLI: NO encontrado"
    echo "  Instalar: brew install gh (macOS) / apt install gh (Ubuntu)"
fi

echo ""
echo "=== Setup Completo ==="
echo ""
echo "Próximos pasos:"
echo "1. Revisar y personalizar AGENTS.md y CLAUDE.md"
echo "2. Crear repo GitHub: gh repo create $OWNER_NAME/$PROJECT_NAME --private"
echo "3. Hacer el primer commit: git add . && git commit -m 'feat: initialize workspace'"
echo "4. Abrir una sesión de Claude Code y comenzar"
echo ""
echo "Documentación:"
echo "  docs/SYSTEM_OVERVIEW.md   — Cómo funciona el sistema"
echo "  docs/WORKERS_GUIDE.md     — Guía técnica de workers"
echo "  docs/MEMORY_SYSTEM.md     — Sistema de memoria"
echo "  docs/CONVERSATION_LOG.md  — Los agentes explican el sistema"
