# Guía del instructor

Documento operativo del curso. Timing minuto a minuto, cues de energía, backup plans y sugerencias de manejo del aula. Léelo el día antes del curso.

## Filosofía pedagógica del curso

El curso está construido sobre tres principios:

**1. Frustración productiva antes de solución.** Cada módulo introduce una técnica *después* de que el estudiante haya sentido la carencia. El Lab 1 termina frustrando al estudiante con TB directed; solo entonces M3 presenta constrained random como respuesta.

**2. Construir antes de nombrar.** El Lab 4 construye la arquitectura UVM completa antes de mencionar la palabra UVM. En M5 el estudiante descubre que "esto que hice es UVM".

**3. Densidad calibrada.** Cada slide tiene contenido pero espacio para respirar. Las analogías anclan lo abstracto en lo concreto. Los callouts marcan qué es crítico y qué es opcional.

Si en algún momento sientes que estás "avanzando por avanzar", detente y pregunta al aula. El curso está diseñado para conversación, no para monólogo.

## Timing global

| Bloque | Tiempo | Acumulado |
|--------|--------|-----------|
| M0 Kick-off y quiz diagnóstico | 15 min | 0:15 |
| M1 ¿Por qué existe Verification? | 45 min | 1:00 |
| M2 Anatomía de un testbench + Lab 1 | 60 min | 2:00 |
| M3 Los 4 pilares + Labs 2 y 3 | 75 min | 3:15 |
| **Break** | 15 min | 3:30 |
| M4 UVM a mano + Lab 4 | 90 min | 5:00 |
| M5 Ahora sí: ¿qué es UVM? | 60 min | 6:00 |
| M6 Flujo ASIC + Synopsys | 30 min | 6:30 |
| M7 Cierre y quiz final | 15 min | 6:45 |

**El curso está diseñado para 6:45.** Si tu ventana es solo de 6:00, ver la sección "Qué recortar bajo presión de tiempo" más abajo.

## Timing por módulo — cues detallados

### M0 — Kick-off (15 min)

- 0-2 min: presentación del instructor y bienvenida
- 2-3 min: framing — "este curso NO es UVM, es prepararse mentalmente para UVM"
- 3-5 min: agenda visible (proyectar slide 3)
- 5-13 min: quiz diagnóstico. Que respondan por escrito, no en voz alta
- 13-15 min: discutir pregunta 8 ("¿cuántas combinaciones si hay 32 entradas?") en voz alta

**Cue de energía:** llegan nerviosos. Bajar el nivel de tensión con humor. La pregunta 8 debe hacerlos reír (o incomodar) — es el gancho emocional.

### M1 — ¿Por qué existe Verification? (45 min)

- 0-10 min: costo del bug + Verification Gap
- 10-25 min: pie chart del 70% + FPGA vs ASIC (esta tabla genera preguntas, dejar tiempo)
- 25-40 min: por qué el TB manual no basta + bugs difíciles
- 40-45 min: resumen y transición

**Backup plan si preguntan mucho:** el pie chart es muy discutido. Si excede tiempo, recortar el detalle de "bugs difíciles" y saltar al resumen.

### M2 — Anatomía del testbench + Lab 1 (60 min)

- 0-25 min: slides M2 hasta interface (25 min continuos, ritmo alto)
- 25-27 min: transición y planteo del Lab 1
- 27-47 min: **Lab 1 en vivo** — el estudiante en su laptop/server, 20 min efectivos
- 47-55 min: post-lab, discutir las 4 frustraciones
- 55-60 min: resumen y transición a M3

**Cue durante el lab:** pasear por el aula. Los que ya terminaron probablemente hicieron copy-paste. Preguntarles: "explícame por qué usaste `negedge` aquí". Si no saben, tuvieron culto cargo.

### M3 — Los 4 pilares + Labs 2 y 3 (75 min)

Aquí el timing es apretado. Cuidar los tiempos:

- 0-3 min: panorama del módulo (slide con tabla frustración→pilar)
- 3-20 min: **Pilar 1 Constrained Random** — motivación, sintaxis, seed
- 20-40 min: **Lab 2 en vivo** — 20 min efectivos
- 40-55 min: **Pilar 2 Coverage** + **Pilar 3 Assertions**
- 55-70 min: **Lab 3 en vivo** — 15 min efectivos (más apretado que Lab 2)
- 70-73 min: **Pilar 4 Reference Model**
- 73-75 min: resumen + break

**Cue crítico:** el Lab 3 tiene 25 min asignados en el material pero en aula solo tienen 15 min efectivos. Guiarles el proceso — no dejar que se atoren.

### Break (15 min)

**Este break es sagrado. NO lo recortes.** El cerebro necesita procesar M3 antes de M4. Si acortas el break, M4 no aterriza.

Aprovecha para:
- Charlar 1-a-1 con los que se ven perdidos
- Revisar rápidamente el resultado del Lab 3 en algún estudiante
- Preparar el aula (proyector, USB de labs, etc.)

### M4 — UVM a mano + Lab 4 (90 min) — MÓDULO ESTRELLA

- 0-10 min: motivación y arquitectura (slides M4 hasta el DUT del lab)
- 10-45 min: **recorrido pieza por pieza** — 5 min por pieza en promedio. Transaction, Generator, Driver, Interface, Monitor, Scoreboard, Env, Agent
- 45-85 min: **Lab 4 en vivo** — 40 min completos, el lab más grande
- 85-90 min: **el aha-moment** — `wc -l *.sv`, revelación "esto es UVM"

**Cue crítico del módulo:** en el post-lab, hacer preguntas socráticas de responsabilidades:
- "¿Dónde vive la aleatoriedad?"
- "¿Si el DUT gana un pin nuevo, qué archivo tocas?"
- "¿Por qué el scoreboard tiene el reference model?"

Estas preguntas provocan el aha. Sin ellas, el módulo entrega la información pero no el insight.

**Si el aula está exhausta después del Lab 4** (típico), hacer una pausa de 2 min antes de M5.

### M5 — Ahora sí ¿qué es UVM? (60 min)

- 0-10 min: historia + qué agrega UVM
- 10-40 min: mapeo pieza por pieza (5 min por pieza)
- 40-55 min: jerarquía + fases + factory + config_db + TLM + reporting
- 55-60 min: test UVM completo + resumen

**Cue de energía:** este módulo es **denso pero rápido**. El estudiante ya construyó la arquitectura en M4, aquí solo pone nombres. No sobrecargar con detalles del framework — eso es el Bootcamp.

### M6 — Flujo ASIC + Synopsys (30 min)

- 0-3 min: flujo ASIC completo (diagrama grande)
- 3-27 min: 3 min por herramienta (VCS, Verdi, SpyGlass, VC Formal, DC, ICC2, PT)
- 27-30 min: ecosistema completo + resumen

**Backup plan:** si va corto de tiempo, agrupar SpyGlass + VC Formal en una sola slide (2 min combinados) y saltar detalles de DC/ICC2/PT.

### M7 — Cierre (15 min)

- 0-10 min: quiz final (respuestas escritas)
- 10-13 min: discutir preguntas más falladas + mapa conceptual
- 13-15 min: preview del Bootcamp + cierre

## Qué recortar bajo presión de tiempo

Si tu ventana real es menos de 6:45:

**Recorte moderado (para 6:00):**
- Quitar M6 completo (30 min) → hacerlo asincrónico como pre-work del Bootcamp

**Recorte agresivo (para 5:00):**
- M0 15 → 10 min (sin quiz escrito, solo pregunta oral)
- M1 45 → 30 min (quitar tabla FPGA vs ASIC y "bugs difíciles")
- M3 75 → 60 min (recortar 15 min del Lab 3)
- M6 completo fuera

**NUNCA recortes:**
- El break de M3
- El Lab 4
- El aha-moment de M4
- El mapeo pieza-por-pieza de M5

Sin estos, el curso pierde su valor central.

## Backup plans para preguntas difíciles

**"¿Y qué pasa con Verilator / open source?"**
- Existe, se usa para pre-silicon en algunos proyectos
- No soporta UVM completo
- En industria semiconductora seria, Synopsys/Cadence/Mentor son estándar

**"¿UVM se puede usar sin licencia comercial?"**
- La librería UVM es open source (Accellera)
- Pero requiere un simulador SV comercial (VCS/Xcelium/Questa) para correr

**"¿Cuál lenguaje va a reemplazar a SystemVerilog?"**
- Nada a corto plazo. Chisel/PyMTL son para diseño, no verificación
- cocotb (Python) crece pero no reemplaza UVM en flujos ASIC serios
- SystemVerilog + UVM es la apuesta segura para 10+ años

**"¿Cuánto gana un verification engineer?"**
- En México, entry-level: 20-40k MXN/mes
- Senior con UVM sólido: 60-120k MXN/mes
- En US/EU, entry: 90-130k USD/año
- Senior: 150-250k USD/año

## Al final del curso

- Recolectar retroalimentación (formulario Google Forms rápido)
- Anunciar el Bootcamp con día y hora
- Compartir el link al repositorio para que revisen el material asincrónicamente
- Compartir el `docs/glosario.md` como referencia

**Si el aula queda motivada, el curso fue un éxito.** Los detalles se aprenden con la práctica.
