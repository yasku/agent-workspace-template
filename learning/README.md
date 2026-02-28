# learning/ — Sistema de Memoria Colectiva

Este directorio es la memoria de largo plazo del sistema multi-agente.

## Estructura

```
learning/
├── patterns/          # Patrones reutilizables descubiertos
├── mistakes/          # Errores documentados y lecciones
├── decisions/         # Decisiones importantes con su rationale
├── optimizations/     # Optimizaciones de proceso y performance
└── claude/
    ├── session-reviews/   # Reviews post-sesión
    ├── errors/            # Análisis de errores específicos de Claude
    └── feedback/          # Feedback del PROJECT_OWNER
```

## Cuándo crear una entrada

- **patterns/**: cuando un patrón funciona y es reutilizable en otros contextos
- **mistakes/**: cuando se comete un error que no debe repetirse
- **decisions/**: cuando el PROJECT_OWNER establece una regla o se toma una decisión importante
- **optimizations/**: cuando se encuentra una forma más eficiente de hacer algo
- **session-reviews/**: al final de cada sesión significativa
- **errors/**: cuando un error requiere análisis profundo
- **feedback/**: cuando el PROJECT_OWNER da feedback sobre el trabajo del agente

## Template

Ver `TEMPLATE.md` para el formato estándar de entradas.

## Naming convention

```
YYYY-MM-DD_descripcion-corta-en-kebab-case.md
```
