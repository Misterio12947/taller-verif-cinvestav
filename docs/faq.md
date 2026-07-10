# Preguntas frecuentes (FAQ)

Preguntas que aparecen consistentemente en el aula y cómo responderlas. Léelas el día antes del curso para tenerlas frescas.

## Sobre la disciplina de verificación

### "¿Verificación es lo mismo que testing de software?"

Comparten filosofía (probar antes de liberar) pero tienen diferencias importantes:
- **Testing de software** puede iterar en producción — deployas un fix y se distribuye en horas.
- **Verificación de ASIC** es una sola oportunidad — el chip se fabrica una vez, un bug encontrado post-tape-out cuesta $5M-$50M USD.
- **Escala** es distinta — una app puede tener miles de líneas, un SoC tiene millones.
- **Metodología** es más estructurada — UVM impone patrones que en software se ven como sobreingeniería.

### "¿Por qué no puedo simplemente usar el testbench de FPGA?"

Puedes, para diseños simples. Pero:
- No escala más allá de unos cientos de estímulos
- No mide qué se probó (sin coverage)
- No detecta violaciones de protocolo automáticamente (sin assertions)
- Requiere que **imagines** todos los casos — los bugs interesantes son los que no imaginas

### "¿Cuánto tiempo se necesita para volverse verification engineer?"

En años típicamente:
- **6 meses** con este curso + Bootcamp: puedes seguir un TB UVM existente, escribir sequences y coverage
- **1-2 años** de experiencia: puedes construir un TB UVM desde cero para un bloque
- **3-5 años**: puedes liderar la verificación de un chip completo
- **5+ años**: eres senior — arquitectura de metodología, mentoreo, decisiones técnicas críticas

En México, con 2 años de experiencia sólida en UVM ganas más que un design engineer del mismo nivel.

## Sobre SystemVerilog

### "¿Por qué SystemVerilog y no Verilog puro?"

Verilog puro no tiene:
- Classes (no puedes hacer OO)
- Randomization (no puedes hacer constrained random)
- Assertions (no tienes SVA)
- Interfaces (no puedes empaquetar buses)
- Coverage (no tienes covergroups)

Verificación moderna **requiere** SystemVerilog. Verilog puro alcanza para RTL de diseño, no para verification.

### "¿Puedo usar VHDL en vez de SystemVerilog?"

En Europa y algunos sectores (aeroespacial, militar) VHDL sigue siendo común para RTL. Pero para verificación:
- VHDL no tiene equivalente directo a UVM
- El estándar de la industria comercial es SV+UVM
- Empresas grandes (Intel, AMD, NVIDIA, Qualcomm, Apple) usan SV+UVM

Si trabajas con VHDL en RTL, probablemente uses SV+UVM para verificarlo (co-simulación).

### "¿`logic` es lo mismo que `reg`?"

Casi. `logic` es la palabra clave moderna en SV que reemplaza a `reg`. Deja que el compilador decida si es red combinacional o secuencial según cómo la uses. Regla: **siempre usa `logic`** en código nuevo, `reg` es legacy.

## Sobre UVM

### "UVM parece muy complicado. ¿Es necesario?"

Para proyectos pequeños o educativos, no. Para cualquier ASIC comercial, sí:
- Es el estándar de la industria (IEEE 1800.2)
- Sin UVM el TB se vuelve inmantenible a partir de ~10,000 líneas
- La curva de aprendizaje es empinada pero **una vez** — el conocimiento aplica a todos los proyectos

El objetivo de este curso propedéutico es aplanar esa curva. Cuando lleguen a UVM formal en el Bootcamp, ya conocerán la arquitectura.

### "¿UVM es exclusivo de Synopsys?"

No. UVM es open source (Accellera) y funciona en:
- **VCS** (Synopsys)
- **Xcelium / Incisive** (Cadence)
- **Questa / ModelSim** (Siemens EDA)
- **Verilator** parcial (open source, no soporta todo)

Cada simulador trae su propia versión de la librería UVM preinstalada.

### "¿Cuánto código UVM voy a escribir en un proyecto real?"

Depende del bloque:
- Un bloque pequeño (ALU, FIFO): ~1,000-3,000 líneas de UVM
- Un bloque mediano (controlador de memoria): ~5,000-15,000 líneas
- Un SoC completo: 50,000-500,000 líneas

Pero mucho se **reutiliza** (agents, sequences base, scoreboards) — el trabajo verdadero es el reference model y las sequences específicas del bloque.

## Sobre herramientas Synopsys

### "¿Por qué Synopsys y no herramientas open source?"

Para aprendizaje personal, open source funciona (Verilator, Icarus, GTKWave). Para producción:
- No soportan UVM completo (Verilator solo parcial)
- No tienen debug integrado como Verdi
- No tienen sign-off tools como PrimeTime
- No están certificados con los PDKs comerciales

Un proyecto ASIC comercial **exige** herramientas comerciales. Synopsys, Cadence y Siemens EDA son las tres opciones.

### "¿Cuánto cuestan las licencias?"

Varían mucho por bundle y volumen, pero orden de magnitud:
- **VCS + Verdi**: $50k-$200k USD por seat por año
- **Design Compiler**: $100k+ USD por seat por año
- **PrimeTime**: $80k+ USD por seat por año

Un chip completo típicamente requiere docenas de seats. Total de tooling para un proyecto ASIC: **millones de USD**. Por eso las startups de semiconductores necesitan mucho capital inicial.

### "¿Puedo aprender en casa sin licencias?"

Sí, con limitaciones:
- **Verilator** es gratis y soporta simulación básica de SV
- **Icarus Verilog** es más viejo pero más portable
- **GTKWave** es un waveform viewer aceptable
- **PyUVM** (Python) permite algunos patrones UVM sin licencia SV

Para UVM completo, necesitas VCS/Xcelium/Questa. Muchas universidades tienen licencias académicas.

## Sobre el curso y el Bootcamp

### "¿Qué debo repasar antes del Bootcamp?"

Prioridad alta:
- El Lab 4 completo (ejecutarlo, entenderlo, modificarlo)
- El mapeo Lab 4 → UVM del Módulo 5
- El glosario UVM (uvm_env, uvm_agent, phases, factory, config_db)

Prioridad media:
- El uso de VCS y Verdi (flags, atajos, waveform navigation)
- Coverage con URG (correr el Lab 3 con `./run.sh cov` y explorar el reporte)

No hay que llegar dominando UVM — llegar dominando la **arquitectura conceptual** es lo importante.

### "¿Puedo llevarme el material?"

Sí. Todo está en el repositorio: slides, labs, guía del instructor, glosario, este FAQ. Uso académico libre. Compartir con otros estudiantes es bienvenido.

### "¿Habrá tarea entre este curso y el Bootcamp?"

Recomendada (no obligatoria):
1. Correr los 4 labs con seed distintas y confirmar que pasan
2. Inyectar un bug en `alu.sv` del Lab 4 y verificar que el scoreboard lo detecta
3. Leer las slides M4 y M5 completas
4. Repasar el glosario

Con esto llegarán al Bootcamp con contexto muy sólido.

## Sobre carrera

### "¿Qué buscan las empresas al contratar verification engineers?"

Skills técnicos:
- SystemVerilog + UVM (fundamental)
- Debug de waveforms
- Un lenguaje de scripting (Python o Perl)
- Familiaridad con simuladores comerciales

Skills blandos (igual de importantes):
- Comunicación escrita (los reportes de bugs son documentos)
- Persistencia (algunos bugs se debuggean por semanas)
- Colaboración (el TB es un producto compartido con el equipo de diseño)
- Curiosidad estructurada (los bugs interesantes se esconden)

### "¿Verification engineer es una carrera para toda la vida?"

Sí. Es una de las áreas más estables de la industria semiconductora:
- La complejidad de los chips sigue creciendo → más verificación necesaria
- La demanda supera a la oferta consistentemente
- El conocimiento es transferible entre empresas
- Los seniors son muy valorados (compensación creciente)

Muchos verification engineers senior evolucionan a:
- **Arquitecto de metodología** (define cómo verifica toda la empresa)
- **Manager técnico** (lidera equipos de 10-30 verification engineers)
- **Consultor** (freelance para múltiples proyectos)

### "¿Puedo trabajar remoto?"

Sí, cada vez más. Verificación es una de las áreas más "remote-friendly" de semiconductores porque:
- Todo el trabajo es en simulador (no hay lab físico)
- Los servers de simulación están en la nube o en datacenters remotos
- El debug se hace vía Verdi remoto

Empresas como Intel, AMD, NVIDIA tienen posiciones de verification 100% remote desde México hacia US/EU.
