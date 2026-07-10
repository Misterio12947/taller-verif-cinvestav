# Glosario A-Z

Definiciones concisas de todos los términos técnicos del curso. Referencia rápida durante el aula o para el estudiante después.

## A

- **Agent** — Componente UVM que agrupa driver, monitor y sequencer para un protocolo específico.
- **Analysis port** — Puerto TLM de broadcast (1-a-N) en UVM. El monitor lo usa para publicar transacciones a scoreboard, coverage y logger.
- **Assertion** — Regla del protocolo escrita en un lenguaje que el simulador vigila automáticamente en cada ciclo.

## B

- **Bind** — Construct de SystemVerilog que instala un módulo (típicamente un checker con assertions) dentro de otro módulo sin editar su código fuente.
- **Bins** — Agrupamientos conceptuales de valores dentro de un coverpoint.
- **Build phase** — Fase inicial de un componente UVM donde se instancian los componentes hijos.

## C

- **Checker** — Código que compara lo observado del DUT contra lo esperado y reporta pass/fail.
- **CI/CD** — Continuous Integration / Continuous Deployment. En verificación, regressions automáticas ante cada commit.
- **Clocking block** — Construct de SV dentro de una interface que define timing determinista para muestreo y estímulo.
- **Code coverage** — Métrica automática que mide qué partes del RTL se ejecutaron (line, branch, toggle, FSM, condition).
- **config_db** — Base de datos global tipada de UVM para pasar handles entre componentes sin variables globales.
- **Constraint** — Regla declarativa que restringe qué valores puede tomar un `rand` field.
- **Constrained random** — Estímulos aleatorios controlados por reglas. Contrasta con directed testing.
- **Coverage closure** — Proceso de iterar constraints y tests hasta cerrar todos los "holes" del functional coverage.
- **Coverage hole** — Combinación de coverage no cubierta aún; señala que faltan estímulos.
- **Coverage-driven verification** — Metodología donde el progreso se mide por functional coverage, no por número de tests.
- **Coverpoint** — Variable cuya distribución de valores se mide dentro de un covergroup.
- **Covergroup** — Contenedor de coverpoints que define qué medir y cuándo samplear.
- **Cover property** — Escenario temporal que el TB **quiere ver ocurrir**; contrasta con `assert property`.
- **Cross** — Producto cartesiano entre dos coverpoints. Mide combinaciones de valores, no valores individuales.

## D

- **Directed testing** — Estímulos escritos a mano, uno por uno. Contrasta con constrained random.
- **DPI (Direct Programming Interface)** — Mecanismo de SV para llamar C/C++ desde código SV y viceversa.
- **Driver** — Clase (o `uvm_driver`) que toma transacciones abstractas y las aplica al bus físico del DUT.
- **DUT (Design Under Test)** — El módulo bajo verificación.

## E

- **Environment (env)** — Clase que orquesta la construcción y ejecución de todo el testbench.
- **Extract phase** — Fase UVM entre `run_phase` y `check_phase` donde se extrae información de los componentes.

## F

- **Factory** — Mecanismo de UVM para reemplazar clases sin editar código. Habilita polimorfismo configurable desde afuera.
- **fork/join_none** — Construct de SV para arrancar tareas paralelas sin bloquear al padre.
- **Formal verification** — Verificación matemática de propiedades sin correr estímulos. Demuestra correctud para todos los inputs posibles.
- **FSDB** — Formato de waveform de Verdi (Fast Signal Database), más compacto que VCD.
- **Functional coverage** — Métrica manual (con `covergroup`) que mide qué escenarios de la spec se probaron.

## G

- **Generator** — Clase (o `uvm_sequence`) que produce transacciones para el driver.
- **GLS (Gate-Level Simulation)** — Simulación con la netlist post-síntesis en vez del RTL.
- **Golden model** — Sinónimo de reference model.

## I

- **Interface** — Construct de SV que empaqueta señales de un bus y sus modports.

## L

- **Latch** — Elemento de memoria asíncrono. Típicamente inferido por accidente cuando un `if` en `always @(*)` no tiene `else`. Casi siempre es un bug.
- **Lint** — Análisis estático del RTL para detectar problemas sin simular.

## M

- **Mailbox** — Canal FIFO tipado y thread-safe entre clases SV. Se usa en TB OO puros antes de UVM.
- **Modport** — Vista restringida de una interface (qué señales son input/output para cada usuario).
- **Monitor** — Clase (o `uvm_monitor`) que observa pasivamente el bus del DUT y reconstruye transacciones.

## N

- **Netlist** — Descripción del diseño a nivel de compuertas específicas del PDK, resultado de la síntesis.

## O

- **OO (Object-Oriented)** — Paradigma de programación con clases, objetos y herencia. En verificación se usa desde SV para modelar componentes.

## P

- **PDK (Process Design Kit)** — Librería de celdas del proceso de fabricación (por ejemplo GF180MCU, TSMC 28nm).
- **PnR (Place & Route)** — Etapa de implementación física: ubicar celdas y rutear conexiones.
- **PrimeTime** — Herramienta Synopsys de Static Timing Analysis para sign-off.
- **Property** — Regla temporal declarativa en SVA.

## Q

- **Quality of Results (QoR)** — Métricas del diseño físico: área, potencia, timing. No aplica directamente a verificación funcional.

## R

- **`rand`** — Modificador SV que hace que un field se resortee en cada `randomize()`.
- **`randc`** — Variante cíclica: agota todos los valores posibles antes de repetir.
- **`randomize()`** — Método que dispara el solver para asignar valores a los `rand` fields respetando las constraints.
- **Reference model** — Implementación independiente de la especificación funcional, usada por el scoreboard para dictar qué se espera del DUT.
- **Regression** — Corrida masiva del testbench con múltiples seeds o tests.
- **Report phase** — Fase final de un componente UVM donde se imprime el reporte de resultados.
- **Respin** — Segunda vuelta de fabricación por corrección de bugs. Costo típico $5M-$50M USD.
- **Run phase** — Fase UVM donde ocurre la simulación real.

## S

- **Scoreboard** — Clase (o `uvm_scoreboard`) que compara lo observado por el monitor contra el reference model.
- **SDC (Synopsys Design Constraints)** — Archivo con constraints de timing, loading y clocks para síntesis y STA.
- **Seed** — Semilla del generador random. Necesaria para reproducibilidad.
- **`seq_item_port`** — Puerto TLM del driver por donde recibe transacciones del sequencer.
- **Sequence** — Clase UVM que define patrones de generación de transacciones.
- **Sequencer** — Componente UVM que entrega transacciones (de la sequence) al driver.
- **Sign-off** — Momento formal en que se declara que una etapa está completa (verification sign-off, timing sign-off, etc.).
- **Slack** — Margen de timing. Positivo = OK, negativo = viola timing.
- **SoC** — System on Chip. Chip que integra CPU, memoria, periféricos, etc.
- **SpyGlass** — Linter estático de RTL de Synopsys.
- **STA (Static Timing Analysis)** — Verificación de timing sin simular, analizando todos los paths.
- **SVA (SystemVerilog Assertions)** — Subconjunto de SV para assertions temporales.
- **SystemVerilog (SV)** — Extensión de Verilog con constructs para OO, randomization, coverage, assertions.

## T

- **Tape-out** — Momento en que se manda el diseño a fabricar.
- **Testbench (TB)** — Infraestructura de código que aplica estímulos al DUT y valida las respuestas.
- **TLM (Transaction-Level Modeling)** — Sistema de comunicación de UVM entre componentes vía puertos tipados.
- **Toggle coverage** — Métrica automática de qué señales cambiaron 0→1 y 1→0.
- **Transaction** — Objeto que representa una unidad de comunicación en el TB (por ejemplo, una operación de ALU).
- **Type override** — Instrucción al factory de UVM para sustituir una clase por otra.

## U

- **URG (Unified Report Generator)** — Herramienta de Synopsys que genera reportes HTML de coverage.
- **UVM (Universal Verification Methodology)** — Librería de clases SV estandarizada (IEEE 1800.2) para construir testbenches profesionales.
- **`uvm_config_db`** — Ver `config_db`.
- **`uvm_env`** — Clase base para environments UVM.
- **`uvm_driver #(T)`** — Clase base parametrizada para drivers UVM.
- **`uvm_monitor`** — Clase base para monitores UVM.
- **`uvm_scoreboard`** — Clase base para scoreboards UVM.
- **`uvm_sequence_item`** — Clase base para transacciones UVM.
- **`uvm_sequence`** — Clase base para sequences.
- **`uvm_sequencer`** — Componente UVM que gestiona la entrega de transacciones al driver.
- **`uvm_test`** — Clase base para el top de un TB UVM.

## V

- **VCS** — Simulador de Synopsys para Verilog / SystemVerilog / UVM.
- **VC Formal** — Herramienta Synopsys de verificación formal.
- **VCD (Value Change Dump)** — Formato estándar de waveforms, portable pero pesado.
- **Verdi** — Waveform viewer + debugger de Synopsys.
- **Verification Gap** — Divergencia entre complejidad exponencial de chips y capacidad lineal de escribir TBs manuales.
- **Virtual interface** — Handle desde una clase OO a una `interface` de SV, permite acceder al DUT desde clases.

## W

- **Watchdog** — Timeout en el TB para terminar simulaciones colgadas.
- **Waveform** — Representación visual de señales en función del tiempo.
- **WNS (Worst Negative Slack)** — Peor slack negativo del diseño. Métrica de timing crítica.
