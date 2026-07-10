# Laboratorio 4 — UVM a mano, sin UVM

**Duración estimada:** 40 minutos
**Ubicación en el curso:** Módulo 4 (el más importante del curso)

## Objetivo

Construir un testbench orientado a objetos completo — con las siete piezas de un ambiente UVM — **usando solo clases puras de SystemVerilog**. Al terminar, el estudiante entenderá:

1. Que cada pieza tiene una **responsabilidad única y clara**
2. Que la **comunicación** entre piezas usa mailboxes (canales tipados)
3. Que el **puente al DUT** es un `virtual interface`
4. Que la **orquestación** vive en un `environment` con `fork/join_none`
5. Y sobre todo: que **UVM es exactamente esta arquitectura con nombres formales**. Este lab es el aha-moment del curso.

## Archivos

| Archivo | Rol | Equivalente UVM |
|---------|-----|-----------------|
| `alu.sv` | DUT: ALU 4-bit combinacional con ADD/SUB/AND/OR | — |
| `alu_if.sv` | Interface con clocking block y modports | `interface` |
| `transaction.sv` | Objeto que representa una operación de ALU | `uvm_sequence_item` |
| `generator.sv` | Fábrica de transacciones aleatorias | `uvm_sequence` + `uvm_sequencer` |
| `driver.sv` | Consume transactions y las aplica al bus | `uvm_driver` |
| `monitor.sv` | Observa el bus y reconstruye transactions | `uvm_monitor` |
| `scoreboard.sv` | Compara observado vs. reference model | `uvm_scoreboard` |
| `env.sv` | Orquestador que construye y arranca todo | `uvm_env` |
| `tb_top.sv` | Módulo top (solución completa) | `uvm_test` top |
| `tb_top_starter.sv` | Módulo top con TODOs (para completar) | — |

## Cómo correr

```bash
cd labs/lab4_uvm_a_mano

./run.sh              # Solución con 200 transacciones aleatorias
./run.sh starter      # Su implementación (después de completar TODOs)
./run.sh N 1000       # Solución con 1000 transacciones
./run.sh seed 42      # Solución con seed distinta
./run.sh verdi        # Waveforms
./run.sh clean
```

Salida esperada de una corrida exitosa:

```
[TB] Reset liberado en t=25
[GEN] Terminó de generar 200 transacciones.

=====================================================
[SB] Transacciones comparadas: 200
[SB] PASS: 200
[SB] FAIL: 0
[SB] RESULTADO: PASS
=====================================================
```

## El DUT: ALU 4-bit

```
op = 00 -> ADD   (result = a + b, carry = carry-out)
op = 01 -> SUB   (result = a - b)
op = 10 -> AND   (result = a & b)
op = 11 -> OR    (result = a | b)

zero = 1 si result == 0
```

Es combinacional, pero lo muestreamos síncrono con `clocking block` para tener race-free sampling — el mismo patrón que se usa con DUTs reales.

## La arquitectura

```
    +-----------+      mailbox (gen2drv)      +--------+
    | Generator |----------------------------->| Driver |
    +-----------+                              +--------+
          |                                        |
          | mailbox (gen2sb)                       | virtual interface
          |                                        v
          v                                    +---------+
    +--------------+     mailbox (mon2sb)     |   DUT   |
    |  Scoreboard  |<--------------------------|  (ALU)  |
    +--------------+           +---------+     +---------+
          ^                    | Monitor |<---------+
          |                    +---------+  virtual interface
          |
   Reference Model
   (dentro del SB)
```

**Flujo de una transacción individual:**

1. **Generator** crea una `transaction` con `randomize()`, la copia y la manda a **dos** mailboxes: uno hacia el driver, otro hacia el scoreboard (como referencia).
2. **Driver** toma la transaction, extrae `a/b/op` y los pone en el bus del DUT vía `virtual interface`.
3. **DUT** produce `result/zero/carry` combinacionalmente.
4. **Monitor** samplea el bus completo (inputs + outputs) y arma una transaction observada. La manda al scoreboard.
5. **Scoreboard** recibe la esperada (del generator) y la observada (del monitor). Llama `predict()` para calcular la referencia y compara. Cuenta PASS/FAIL.

## Instrucciones paso a paso

Los seis archivos de clases (`transaction.sv` → `env.sv`) ya están completos. Su tarea es solo el módulo top:

**TODO #1 — Instanciar el DUT**

En `tb_top_starter.sv`, después de la instancia del `alu_if`, agregar:

```verilog
alu dut (
    .clk    (clk),
    .rst_n  (rst_n),
    .a      (vif.a),
    .b      (vif.b),
    .op     (vif.op),
    .result (vif.result),
    .zero   (vif.zero),
    .carry  (vif.carry)
);
```

**TODO #2 — Construir y arrancar el environment**

Dentro del `initial begin`, después del reset y del `$value$plusargs`:

```verilog
env = new(vif, num_trans);
env.build();
env.run();
```

Correr con `./run.sh starter`. Deberían ver 200 PASS.

## Explorando el aha-moment

Estas son las preguntas que responder **con el código en la mano**, no de memoria:

1. **¿Cuántas líneas tiene cada clase?** Corran `wc -l *.sv`. Ninguna pasa de ~80 líneas. Cada una hace **una sola cosa**. Comparar con el TB monolítico del Lab 3 (~200 líneas todo revuelto).

2. **¿Dónde vive la aleatoriedad?** Solo en `generator.sv`. El driver, monitor y scoreboard no saben nada de random. Si mañana queremos estímulos directed, solo cambiamos el generator.

3. **¿Dónde vive el reference model?** Solo en `scoreboard.sv`, dentro de `predict()`. El resto del TB no sabe cómo debe comportarse el DUT — solo el scoreboard tiene esa autoridad.

4. **¿Dónde vive el conocimiento del bus del DUT?** Solo en `driver.sv` y `monitor.sv`. Si el DUT cambia sus pines mañana, solo esas dos clases se modifican. Transaction, generator, scoreboard son inmunes.

5. **¿Qué pasa si necesitamos un segundo tipo de transacción?** Extenderíamos `alu_transaction` con `class error_transaction extends alu_transaction`. El generator podría producir mezcla.

Esta es la **razón de ser** de una arquitectura OO en verificación: **cambio local, impacto local**.

## Mapeo directo a UVM

| Este lab | UVM |
|----------|-----|
| `class alu_transaction` | `class alu_transaction extends uvm_sequence_item` |
| `class alu_generator` con `mailbox` | `class alu_sequence extends uvm_sequence` |
| `class alu_driver` con `virtual interface` | `class alu_driver extends uvm_driver #(alu_transaction)` |
| `class alu_monitor` con `mailbox #(T)` de salida | `class alu_monitor extends uvm_monitor` con `uvm_analysis_port` |
| `class alu_scoreboard` con `predict()` | `class alu_scoreboard extends uvm_scoreboard` |
| `class alu_env` con `build()` y `run()` | `class alu_env extends uvm_env` con `build_phase()` y `run_phase()` |
| `initial begin ... env.new() ... env.run(); end` | `class alu_test extends uvm_test` + `run_test()` |
| `mailbox #(T)` | `uvm_analysis_port` / `uvm_tlm_analysis_fifo` |
| `virtual interface` | `virtual interface` (sí, es idéntico) |
| `fork/join_none` en el env | Fases automáticas del `uvm_env` |

**El 90% de UVM son estas mismas piezas, con nombres estandarizados y algunas conveniencias adicionales:**

- `uvm_factory` para reemplazar clases sin editar código
- `uvm_config_db` para pasar handles sin variables globales
- Sistema de fases automático (`build → connect → run → check → report`)
- `uvm_report_server` para logs estructurados
- `uvm_reg` para modelar registros del DUT

Todo eso lo verán en el Bootcamp. Pero la **arquitectura conceptual** ya la construyeron aquí.

## Errores comunes

1. **`virtual alu_if vif;` sin asignar antes de `env.build()`.** El env necesita el vif para pasarlo al driver/monitor. Si es null → crash con "null pointer" al llamar `vif.cb_tb`.

2. **`fork/join` en lugar de `fork/join_none`.** `join` bloquea hasta que TODAS las tareas terminen — pero driver/monitor/scoreboard son `forever`, nunca terminan. Solo el generator termina. Se necesita `join_none` + `wait` explícito.

3. **Olvidar `t.clone()` al mandar al scoreboard.** Si mandan la misma referencia al driver y al scoreboard, el driver puede modificarla antes de que el scoreboard la lea → race condition. Siempre clonar.

4. **Sampling del monitor sin `clocking block`.** Muestrear con `@(posedge clk); t.result = vif.result;` funciona a veces y falla otras. Con `clocking block` es determinista.

5. **`+incdir+..` faltante en la compilación.** Los `\`include` en `tb_top.sv` buscan en el mismo directorio. Si compilan desde `work_lab4/`, VCS necesita `+incdir+..` para encontrar los archivos. El `run.sh` ya lo trae.

6. **Constraint que hace el espacio vacío.** Si agregan `constraint c { a > 15; }` en `alu_transaction`, no existe `a` de 4 bits > 15 → `randomize()` regresa 0. Siempre chequear el retorno.

## Preguntas de reflexión

1. Corran con `./run.sh N 10000`. ¿Cuánto tarda? ¿Se rompen alguna transacción? ¿Cómo compara con el Lab 3?

2. Modifiquen `transaction.sv` para que `op` sea 90% ADD y 10% otras operaciones. ¿Qué cambia? ¿Cuál otra parte del TB se ve afectada?

3. Introduzcan un **bug intencional** en `alu.sv` (ej: cambien `a + b` por `a - b` en la operación ADD). Corran. ¿El scoreboard lo detecta?

4. Introduzcan un **bug intencional** en `scoreboard.sv` (ej: cambien la operación AND por OR en `predict()`). Corran. ¿Los "fallos" reportados en realidad son bugs del DUT o del reference?

5. Piensen: si mañana el DUT gana un pin nuevo (por ejemplo un `overflow`), ¿cuántos archivos tienen que tocar? Responderán "3": `alu.sv` (obvio), `alu_if.sv` (agregar la señal), `monitor.sv` (muestrearla). Ni transaction ni generator ni scoreboard cambian por diseño. **Eso es encapsulación.**

## Cierre — el aha-moment

Cuando terminen el lab y sus 200 transacciones pasen, **cuenten sus líneas de código**:

```bash
wc -l *.sv
```

Verán algo como:
- `transaction.sv`: 55 líneas
- `generator.sv`: 35 líneas
- `driver.sv`: 40 líneas
- `monitor.sv`: 35 líneas
- `scoreboard.sv`: 80 líneas
- `env.sv`: 55 líneas
- `tb_top.sv`: 60 líneas
- **Total: ~360 líneas**

Con 360 líneas construyeron un mini-framework de verificación completo. UVM tiene ~200,000 líneas — pero organizadas exactamente igual. Lo que agrega UVM es infraestructura industrial (factory, config_db, fases, reporte, RAL), no arquitectura conceptual.

**Bienvenidos a Functional Verification profesional.**
