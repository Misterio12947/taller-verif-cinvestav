# Conceptos clave del curso

Lista de términos que **todo estudiante debe poder definir** al terminar el curso. Estructurada por módulo de introducción.

## Módulo 1 — Motivación

- **Functional verification** — disciplina de asegurar que un diseño digital cumple su especificación funcional antes del tape-out
- **Tape-out** — momento en que se manda el diseño a fabricar
- **Respin** — segunda vuelta de fabricación por corrección de bugs (costo típico $5M-$50M USD)
- **Verification gap** — divergencia entre la complejidad exponencial de los chips y la capacidad lineal de escribir testbenches manuales
- **Directed testing** — estímulos escritos a mano, uno por uno
- **DUT** — Design Under Test, el módulo bajo verificación

## Módulo 2 — Anatomía del testbench

- **Testbench (TB)** — infraestructura de código que aplica estímulos al DUT y valida las respuestas
- **Reloj y reset** — señales de infraestructura temporal del TB
- **Estímulo** — entradas que el TB aplica al DUT
- **Observación** — proceso de leer las salidas del DUT
- **Checker** — código que compara observado contra esperado
- **Referencia (reference model)** — implementación independiente de la spec para saber qué es "correcto"
- **Reporte** — output final del TB con PASS/FAIL y métricas
- **Watchdog** — timeout para terminar simulaciones colgadas
- **Interface** — construct de SV que empaqueta señales de un bus
- **Clocking block** — región dentro de una interface que define timing determinista
- **Modport** — vista restringida de una interface (qué señales son input/output para cada usuario)

## Módulo 3 — Los cuatro pilares

### Constrained Random

- **Constrained random** — estímulos aleatorios controlados por reglas
- **`rand` field** — variable que se resortea en cada `randomize()`
- **`randc` field** — cíclico, agota todos los valores antes de repetir
- **Constraint** — regla declarativa que el solver debe satisfacer
- **`dist`** — distribución ponderada de valores
- **`randomize() with { ... }`** — constraints extras en el sitio de la llamada
- **Seed** — semilla del generador random, necesaria para reproducibilidad

### Coverage

- **Line coverage** — qué líneas del RTL se ejecutaron (automático)
- **Branch coverage** — qué ramas de `if`/`case` se tomaron (automático)
- **Toggle coverage** — qué señales cambiaron 0-1 y 1-0 (automático)
- **FSM coverage** — qué transiciones de estado ocurrieron (automático)
- **Functional coverage** — qué escenarios de la spec se probaron (manual)
- **Covergroup** — contenedor de coverpoints
- **Coverpoint** — variable cuya distribución medimos
- **Bins** — agrupamientos conceptuales de valores dentro de un coverpoint
- **Cross** — producto cartesiano entre coverpoints; el más potente
- **Coverage hole** — combinación no cubierta que necesita más estímulos
- **Coverage-driven verification** — metodología de iterar constraints hasta cerrar todos los holes

### Assertions

- **Assertion** — regla del protocolo que el simulador vigila automáticamente
- **SVA (SystemVerilog Assertions)** — subconjunto de SV para assertions temporales
- **Property** — regla temporal declarativa
- **`assert property`** — regla que **debe** cumplirse (si falla, error)
- **`cover property`** — escenario que **debemos ver** en algún momento (mide coverage)
- **`|->`** — implicación mismo ciclo (overlapping)
- **`|=>`** — implicación siguiente ciclo (non-overlapping)
- **`$past(x)`** — valor de x en el ciclo anterior
- **`$stable(x)`** — verdadero si x no cambió desde el ciclo pasado
- **`$rose` / `$fell`** — flanco de subida/bajada
- **`disable iff`** — deshabilitar la property durante una condición (típicamente reset)
- **`bind`** — instalar un módulo dentro de otro sin editar el RTL original

### Reference Model

- **Reference model / Golden model** — implementación independiente que dicta lo esperado
- **Predict()** — función del scoreboard que aplica el reference model
- **DPI (Direct Programming Interface)** — mecanismo para conectar SV con C/C++

## Módulo 4 — Arquitectura OO

- **Class** — construct de SV para programación orientada a objetos en el TB
- **Transaction** — objeto de datos que representa una unidad de comunicación en el TB
- **Generator** — clase que produce transacciones aleatorias
- **Driver** — clase que aplica transacciones al bus del DUT
- **Monitor** — clase pasiva que observa el bus y reconstruye transacciones
- **Scoreboard** — clase que compara observado vs. esperado
- **Environment** — clase que instancia y orquesta todo el testbench
- **Agent** — agrupamiento de driver+monitor+sequencer para un protocolo
- **Mailbox** — canal FIFO tipado y thread-safe entre clases
- **Virtual interface** — handle a una interface desde una clase OO
- **`fork/join_none`** — arrancar tareas paralelas sin esperar
- **`clone()`** — copia profunda de un objeto (patrón UVM)
- **Separación de responsabilidades** — cada clase hace una sola cosa

## Módulo 5 — UVM

- **UVM** — Universal Verification Methodology, librería de clases SV estandarizada (IEEE 1800.2)
- **`uvm_sequence_item`** — clase base para transacciones
- **`uvm_sequence`** — clase que define patrones de estímulos
- **`uvm_sequencer`** — clase que entrega sequences al driver
- **`uvm_driver #(T)`** — clase base para drivers, parametrizada por tipo de transacción
- **`uvm_monitor`** — clase base para monitores
- **`uvm_scoreboard`** — clase base para scoreboards
- **`uvm_env`** — clase base para environments
- **`uvm_test`** — clase base para tests (top de la jerarquía)
- **`uvm_agent`** — clase base para agents
- **Fase (phase)** — etapa automática del ciclo de vida de un componente UVM
- **`build_phase`** — instanciar hijos
- **`connect_phase`** — conectar puertos TLM
- **`run_phase`** — donde corre la simulación
- **`report_phase`** — imprimir reporte final
- **Factory** — mecanismo de UVM para reemplazar clases sin editar código
- **`type_override`** — decirle al factory que sustituya una clase por otra
- **`uvm_config_db`** — base de datos global tipada para pasar handles
- **TLM (Transaction-Level Modeling)** — sistema de comunicación entre componentes UVM
- **`uvm_analysis_port`** — puerto de broadcast 1-a-N
- **`uvm_analysis_imp`** — endpoint que recibe de un analysis_port
- **`seq_item_port` / `seq_item_export`** — canal sequencer-driver
- **`\`uvm_info`** / **`\`uvm_warning`** / **`\`uvm_error`** / **`\`uvm_fatal`** — reporting con verbosidad
- **`raise_objection` / `drop_objection`** — mecanismo para señalar "todavía no termino"

## Módulo 6 — Ecosistema Synopsys

- **VCS** — simulador de eventos discretos de Synopsys
- **Verdi** — waveform viewer + debugger de Synopsys
- **SpyGlass** — linter estático de RTL
- **VC Formal** — herramienta de verificación formal
- **Design Compiler (DC)** — sintetizador RTL → gates
- **IC Compiler II / Fusion Compiler** — herramienta de Place & Route
- **PrimeTime** — Static Timing Analysis para sign-off
- **URG** — Unified Report Generator, produce reportes HTML de coverage
- **GLS (Gate-Level Simulation)** — simulación con netlist post-síntesis
- **SDC** — Synopsys Design Constraints, archivo con constraints de timing/loading
- **Netlist** — descripción del diseño a nivel de compuertas específicas del PDK
- **PDK (Process Design Kit)** — librería de celdas del proceso de fabricación
- **Slack** — margen de timing (positivo = OK, negativo = viola timing)

## Metaconceptos que atraviesan el curso

- **Ciclo de verificación** — plan → build → run → analyze → close
- **Sign-off** — momento en que se declara que la verificación está completa
- **Regression** — corrida masiva del testbench con múltiples seeds
- **Nightly regression** — regression que corre cada noche automáticamente
- **CI/CD (Continuous Integration)** — automatización de regressions ante cada cambio
- **Bug hunt** — sesión dedicada a inyectar bugs y verificar que el TB los detecta
- **Coverage closure** — proceso de llegar a functional coverage 100%
