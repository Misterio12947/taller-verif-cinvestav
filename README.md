# Curso Propedéutico de Functional Verification

**CINVESTAV Zacatenco — Departamento de Ingeniería Eléctrica**
**Duración:** 6 horas · **Modalidad:** presencial + laboratorios en `syn-sr`
**Instructor:** Ing. Cesar Otamendi

Curso propedéutico previo al Bootcamp de una semana con herramientas Synopsys. El objetivo es que el estudiante llegue al Bootcamp con la **filosofía**, el **vocabulario** y la **intuición arquitectural** de la Functional Verification moderna — sin haber tocado todavía UVM formalmente.

## Arco del curso

```
  M0 Diagnóstico  →  M1 ¿Por qué verificar?  →  M2 Anatomía de un TB
                          ↓
  M3 Los 4 pilares  →  Break  →  M4 UVM a mano (sin UVM)
                          ↓
  M5 Ahora sí: UVM  →  M6 Flujo ASIC + Synopsys  →  M7 Cierre
```

El *aha-moment* central ocurre al final del **Módulo 4**: el estudiante habrá construido a mano — con classes de SystemVerilog puras — todas las piezas que UVM organiza (transaction, driver, monitor, scoreboard, environment, agent). En el **Módulo 5** verá que UVM es un mapeo 1:1 de lo que ya construyó.

---

## Arranque rápido

Requisitos: **Docker** (recomendado) o **Node 18+** local. Los laboratorios además requieren el toolchain Synopsys VCS instalado en `syn-sr`.

### Opción A — Docker (recomendado para el aula)

```bash
./setup.sh docker
# Abrir http://localhost:3030
```

### Opción B — Local con npm

```bash
./setup.sh local        # npm install (una sola vez)
./setup.sh dev          # arranca http://localhost:3030 en modo dev
```

### Otros modos

```bash
./setup.sh build        # build estático en dist/ (para desplegar)
./setup.sh pdf          # exporta a curso.pdf
```

**Verificación:** el proyecto compila limpio con Slidev 0.49+ y Node 22.

---

## Estructura del proyecto

```
verif-propedeutico-cinvestav/
├── slides.md              # Todas las slides del curso (M0 → M7)
├── setup.sh               # Arranque rápido (docker | local | dev | build | pdf)
├── package.json           # Deps Slidev
├── Dockerfile             # Slidev en Node 20 + Chromium (para export PDF)
├── .gitignore
├── styles/
│   └── index.css          # Paleta CINVESTAV + callouts semánticos
├── components/            # Componentes Vue reutilizables (auto-loaded por Slidev)
│   ├── Analogy.vue
│   ├── ProTip.vue
│   ├── QuestionBox.vue
│   └── Gotcha.vue
├── labs/                  # Laboratorios incrementales (mismo DUT evoluciona)
│   ├── lab1_tb_directed/          # M2 · 20 min · testbench directed clásico
│   ├── lab2_random_constraints/   # M3 · 20 min · constrained random
│   ├── lab3_coverage_assertions/  # M3 · 25 min · covergroup + SVA + URG
│   └── lab4_uvm_a_mano/           # M4 · 40 min · TB OO estilo UVM (por llenar)
├── docs/                  # Material del instructor (por llenar en M7)
├── examples/              # Snippets SV que aparecen en slides (opcional)
├── images/                # Diagramas exportados si hacen falta
└── assets/                # Íconos, logos
```

---

## Cómo correr los laboratorios

Los labs asumen el toolchain Synopsys instalado en `syn-sr` (VCS V-2023.12-SP5-x). Cada lab tiene su propio `run.sh` con modos consistentes:

```bash
cd labs/lab1_tb_directed
./run.sh              # compila + corre la solución con VCS
./run.sh starter      # corre el TB inicial con TODOs
./run.sh verdi        # abre Verdi con las ondas
./run.sh clean        # limpia artefactos
```

Los labs 2 y 3 añaden modos adicionales:

```bash
cd labs/lab2_random_constraints
./run.sh seed 42      # reproducibilidad con seed específica

cd labs/lab3_coverage_assertions
./run.sh cov          # simula + genera reporte de coverage URG
./run.sh urg          # abre el dashboard HTML en el navegador
```

---

## Material del instructor

Cada slide del `slides.md` trae notas del instructor en comentarios HTML (`<!-- ... -->`) con timing, cues, qué preguntar al aula y qué recortar si el tiempo aprieta. En modo presenter (`slidev` con `--presenter` o tecla `P`) las notas se ven aparte.

Adicionalmente en `docs/` (pendientes de completarse en M7):

- `guia_instructor.md` — timing minuto a minuto, cues de energía, backup plans
- `quiz_diagnostico.md` — se aplica en M0
- `quiz_final.md` — se aplica en M7 + answer key
- `conceptos_clave.md` — vocabulario a martillar durante el curso
- `mapa_conceptual.md` — mapa Mermaid para colgar en el aula
- `glosario.md` — A-Z de términos
- `faq.md` — preguntas frecuentes y cómo responderlas

---

## Convenciones tipográficas

- **Español en prosa**, términos técnicos en **inglés** (`driver`, `scoreboard`, `covergroup`).
- Nombres de herramientas Synopsys con su capitalización oficial: **VCS**, **Verdi**, **Design Compiler**, **PrimeTime**, **VC Formal**, **SpyGlass**, **IC Compiler II**, **Fusion Compiler**.
- Los bloques de código usan ` ```verilog ` como identificador de lenguaje (compatible con el bundle web de Shiki). Todo el SystemVerilog se resalta correctamente.

---

## Notas técnicas para el mantenedor

- **Slidev auto-carga** `styles/index.css` y `components/*.vue` — no hace falta declararlos en el frontmatter.
- **Mermaid** funciona nativamente en Slidev; los diagramas usan `{scale: 0.75}` para caber bien en 16:9.
- **Callouts CSS** se pueden usar de dos formas: (a) el componente Vue (`<Analogy>...</Analogy>`) o (b) directamente el div (`<div class="analogy">...</div>`). Ambos renderizan idéntico.
- **Exportar a PDF** requiere Playwright/Chromium (ya viene en el Docker).

## Licencia

Material educativo interno CINVESTAV. Uso libre para docencia académica.
