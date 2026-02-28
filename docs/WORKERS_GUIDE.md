# WORKERS_GUIDE — Guía Técnica de Workers

Guía práctica y honesta sobre cómo usar cada worker — incluyendo los gotchas aprendidos en producción.

---

## Worker 1: Gemini CLI

### Instalación y verificación

```bash
# Verificar disponibilidad
which gemini || echo "MISSING"

# Instalar (si no está)
pip install google-generativeai
# o según la distribución disponible

# Test rápido
gemini "Di hola"
```

### Patrones de uso probados

**Patrón 1 — Análisis de archivo único:**
```bash
OUTPUT=$(gemini "
TASK: Analiza este archivo Rust e identifica:
1. Traits públicos definidos
2. Dependencias externas
3. Patrones de diseño usados

OUTPUT: Lista estructurada en Markdown.

---
$(cat src/main.rs)
")
echo "$OUTPUT"
```

**Patrón 2 — Análisis de múltiples archivos:**
```bash
OUTPUT=$(gemini "
TASK: Compara la arquitectura de estos dos módulos.
Identifica diferencias de diseño y sugiere cuál es más extensible.

--- MÓDULO A ---
$(cat src/providers/mod.rs)

--- MÓDULO B ---
$(cat src/channels/mod.rs)
")
```

**Patrón 3 — Code review:**
```bash
OUTPUT=$(gemini "
TASK: Actúa como un senior engineer haciendo code review.
Evalúa: calidad, seguridad, mantenibilidad, y documentación.
Puntúa de 1-10 y lista los 3 cambios más importantes.

---
$(cat src/agent/agent.rs)
")
```

**Patrón 4 — Generación de documentación:**
```bash
OUTPUT=$(gemini "
TASK: Genera documentación técnica en Markdown para este módulo.
Incluir: propósito, API pública, ejemplos de uso, consideraciones de seguridad.

---
$(cat src/security/sandbox.rs)
")

# Guardar con Claude (Gemini no escribe archivos)
echo "$OUTPUT" > /tmp/sandbox-docs.md
```

**Patrón 5 — Análisis de directorio completo:**
```bash
# Pasar lista de archivos + contenidos
FILES_CONTENT=""
for f in src/**/*.rs; do
    FILES_CONTENT+="--- FILE: $f ---\n$(cat $f)\n\n"
done

OUTPUT=$(gemini "TASK: Resume la arquitectura general.
$FILES_CONTENT")
```

### Gotchas críticos

| Gotcha | Descripción | Fix |
|--------|-------------|-----|
| **No escribe archivos** | Gemini responde por stdout, no escribe al disco | Siempre capturar con `$()` y guardar con Write tool |
| **Context window** | Tiene límites — demasiado contenido trunca el análisis | Dividir en chunks si el input supera ~50k tokens |
| **Output no determinístico** | Dos llamadas con el mismo prompt pueden dar resultados diferentes | Siempre validar antes de guardar |
| **Markdown inconsistente** | A veces genera headers incorrectos o tablas malformadas | Revisar y corregir antes de commitear |
| **Sin acceso al filesystem** | No puede leer archivos por su cuenta | Claude debe pasarle el contenido en el prompt |

### Template de delegación (Claude → Gemini)

```bash
# Claude invoca así:
TASK_CONTEXT="[Descripción de la tarea]"
FILE_CONTENT=$(cat ruta/al/archivo)

OUTPUT=$(gemini "
TASK: $TASK_CONTEXT

CONSTRAINTS:
- Output en Markdown
- Máximo 500 líneas
- Incluir ejemplos de código donde sea relevante

---
$FILE_CONTENT
")

# Claude valida:
if [ -z "$OUTPUT" ]; then
    echo "ERROR: Gemini returned empty output"
    exit 1
fi

# Claude guarda:
echo "$OUTPUT" > ruta/de/salida.md
echo "OK: $(wc -l < ruta/de/salida.md) lines written"
```

---

## Worker 2: gh CLI

### Instalación y verificación

```bash
# Verificar disponibilidad
which gh || echo "MISSING"

# Instalar
brew install gh          # macOS
apt install gh           # Ubuntu/Debian

# Autenticar
gh auth login
gh auth status           # Verificar
```

### Operaciones de repositorio

```bash
# Crear repo
gh repo create usuario/nombre --private --description "descripción"
gh repo create usuario/nombre --public

# Ver repo
gh repo view usuario/nombre
gh repo view --web        # Abrir en browser

# Clonar
gh repo clone usuario/nombre

# Listar repos
gh repo list usuario
```

### Operaciones de branches y commits

```bash
# Ver branches remotos
gh api repos/usuario/nombre/branches

# Crear branch via API
gh api repos/usuario/nombre/git/refs \
  --method POST \
  -f ref="refs/heads/nueva-branch" \
  -f sha="$(git rev-parse HEAD)"
```

### Pull Requests

```bash
# Crear PR
gh pr create \
  --title "feat: nueva funcionalidad" \
  --body "## Descripción\n- cambio 1\n- cambio 2" \
  --base main \
  --head feature-branch

# Listar PRs
gh pr list
gh pr list --state merged

# Ver PR
gh pr view 123
gh pr view 123 --web

# Mergear PR
gh pr merge 123 --squash
gh pr merge 123 --merge
```

### Issues

```bash
# Crear issue
gh issue create \
  --title "Bug: descripción" \
  --body "## Pasos para reproducir\n1. ...\n2. ..."

# Listar issues
gh issue list
gh issue list --label bug

# Cerrar issue
gh issue close 123
```

### CI/CD y Actions

```bash
# Ver runs de CI
gh run list
gh run view 123
gh run watch 123         # Watch en tiempo real

# Re-run fallido
gh run rerun 123
```

### Gotchas críticos

| Gotcha | Descripción | Fix |
|--------|-------------|-----|
| **SSH por defecto** | `gh repo create` configura remote con SSH | `git remote set-url origin https://github.com/u/r.git` |
| **Auth expira** | El token de gh CLI puede expirar | `gh auth refresh` |
| **Permisos de org** | En repos de organización puede requerir permisos adicionales | Verificar con `gh auth status` |
| **Rate limits** | API de GitHub tiene rate limits | Agregar `--jq` para filtrar y reducir llamadas |

---

## Worker 3: Bash Tool (Claude interno)

No es un worker externo — es la herramienta de shell de Claude. Tiene una particularidad crítica.

### Gotcha: Working directory no persiste

```bash
# MAL — esto NO funciona
cd /ruta/al/proyecto
# [nueva llamada Bash]
git status  # ← ERROR: está en directorio incorrecto
```

```bash
# BIEN — usar -C o rutas absolutas
git -C /ruta/absoluta/al/proyecto status
git -C /ruta/absoluta/al/proyecto add .
git -C /ruta/absoluta/al/proyecto commit -m "mensaje"
```

```bash
# O combinar en una sola llamada Bash
cd /ruta/absoluta && git add . && git commit -m "mensaje" && git push
```

---

## Flujo de Validación de Worker Output

Antes de usar cualquier output de un worker, Claude debe validar:

```bash
# 1. Verificar que el output no está vacío
[ -z "$OUTPUT" ] && echo "ERROR: empty output" && exit 1

# 2. Verificar tamaño razonable
LINES=$(echo "$OUTPUT" | wc -l)
[ "$LINES" -lt 5 ] && echo "WARNING: output muy corto ($LINES lines)"

# 3. Verificar formato si es Markdown
echo "$OUTPUT" | grep -q "^#" || echo "WARNING: no Markdown headers found"

# 4. Guardar y verificar
echo "$OUTPUT" > /ruta/de/salida.md
[ -s "/ruta/de/salida.md" ] && echo "OK: archivo guardado" || echo "ERROR: archivo vacío"
```
